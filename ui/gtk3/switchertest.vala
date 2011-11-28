/* vim:set et sts=4 sw=4:
 *
 * ibus - The Input Bus
 *
 * Copyright(c) 2011 Peng Huang <shawn.p.huang@gmail.com>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or(at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this program; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA  02111-1307  USA
 */

using Gdk;
using Gtk;
using IBus;

void handler(Gdk.Event event) {
    var keyevent = event.key;
    var window = keyevent.window;
    var display = window.get_display();
    var device = display.get_device_manager().get_client_pointer();
    uint state = 0;
    
    device.get_state(window, null, out state);

    if ((state & Gdk.ModifierType.CONTROL_MASK) == 0) {
        debug ("Control is Up state=%08x event.state=%08x", state, keyevent.state);
    } else {
        debug ("Control is Down");
    }
}

public void main(string[] argv) {
    Gtk.init(ref argv);
    IBus.init();
    var bus = new IBus.Bus();
    string[] names = { "xkb:us:eng", "pinyin", "anthy" };
    var engines = bus.get_engines_by_names(names);
    Switcher switcher = new Switcher();

    switcher.update_engines(engines);

    switcher.delete_event.connect((e) => {
        Gtk.main_quit();
        return true;
    });

    switcher.show_all();


    KeybindingManager.get_instance().bind("<Ctrl><Alt>M", handler);

    Gtk.main();
}
