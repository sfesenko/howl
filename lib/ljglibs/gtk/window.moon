-- Copyright 2014-2015 The Howl Developers
-- License: MIT (see LICENSE.md at the top-level directory of the distribution)

ffi = require 'ffi'
jit = require 'jit'
require 'ljglibs.cdefs.gtk'
glib = require 'ljglibs.glib'
core = require 'ljglibs.core'
gobject = require 'ljglibs.gobject'
require 'ljglibs.gtk.bin'

C = ffi.C
catch_error = glib.catch_error
{:ref_ptr} = gobject

jit.off true, true

core.define 'GtkWindow < GtkBin', {
  constants: {
    prefix: 'GTK_WINDOW_'

    -- GtkWindowType
    'TOPLEVEL',
    'POPUP'
  }

  properties: {
    accept_focus: 'gboolean'
    application: 'GtkApplication*'
    decorated: 'gboolean'
    default_height: 'gint'
    default_width: 'gint'
    deletable: 'gboolean'
    destroy_with_parent: 'gboolean'
    focus_on_map: 'gboolean'
    focus_visible: 'gboolean'
    gravity: 'GdkGravity'
    has_resize_grip: 'gboolean'
    has_toplevel_focus: 'gboolean'
    icon: 'GdkPixbuf*'
    icon_name: 'gchar*'
    is_active: 'gboolean'
    mnemonics_visible: 'gboolean'
    modal: 'gboolean'
    opacity: 'gdouble'
    resizable: 'gboolean'
    resize_grip_visible: 'gboolean'
    role: 'gchar*'
    screen: 'GdkScreen*'
    skip_pager_hint: 'gboolean'
    skip_taskbar_hint: 'gboolean'
    startup_id: 'gchar*'
    title: 'gchar*'
    transient_for: 'GtkWindow*'
    type: 'GtkWindowType'
    type_hint: 'GdkWindowTypeHint'
    urgency_hint: 'gboolean'
    window_position: 'GtkWindowPosition'
    hide_titlebar_when_maximized: 'gboolean'

    -- added properties
    window_type: => C.gtk_window_get_window_type @

    focus:
      get: => ref_ptr C.gtk_window_get_focus @
      set: (focus) => C.gtk_window_set_focus @, focus
  }

  new: (type = C.GTK_WINDOW_TOPLEVEL) -> ref_ptr C.gtk_window_new type

  set_default_size: (width, height) => C.gtk_window_set_default_size @, width, height
  resize: (width, height) => C.gtk_window_resize @, width, height
  move: (x, y) => C.gtk_window_move @, x, y
  fullscreen: => C.gtk_window_fullscreen @
  unfullscreen: => C.gtk_window_unfullscreen @
  maximize: => C.gtk_window_maximize @
  unmaximize: => C.gtk_window_unmaximize @

  get_size: =>
    sizes = ffi.new 'gint [2]'
    C.gtk_window_get_size @, sizes, sizes + 1
    sizes[0], sizes[1]

  set_default_icon_from_file: (filename) ->
    catch_error(C.gtk_window_set_default_icon_from_file, filename) != 0

  set_title: (title) => C.gtk_window_set_title(@, title)

}, (spec, type) -> spec.new type
