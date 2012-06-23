Return-path: <linux-media-owner@vger.kernel.org>
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:1779 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751471Ab2FWJCk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Jun 2012 05:02:40 -0400
Date: Sat, 23 Jun 2012 11:02:30 +0200
Message-ID: <4FC4F1B40000A99C@mta-nl-3.mail.tiscali.sys>
From: cedric.dewijs@telfort.nl
Subject: PROBLEM: Unplugging USB DVB-t receiver while watching TV makes that USB port ignore all new devices.
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[1.] One line summary of the problem:
Unplugging USB DVB-t receiver while watching TV makes that USB port ignore
all new devices.

[2.] Full description of the problem/report:
a)plugin DVB-t receiver, and watch /var/log/everything.log
Jun 23 10:43:57 localhost kernel: [ 1534.633272] usb 2-4: new high-speed
USB device number 5 using ehci_hcd
Jun 23 10:43:57 localhost kernel: [ 1534.758578] dvb-usb: found a 'Pinnacle
PCTV 73e SE' in cold state, will try to load a firmware
Jun 23 10:43:57 localhost kernel: [ 1534.760716] dvb-usb: downloading firmware
from file 'dvb-usb-dib0700-1.20.fw'
Jun 23 10:43:57 localhost kernel: [ 1534.963365] dib0700: firmware started
successfully.
Jun 23 10:43:58 localhost kernel: [ 1535.466771] dvb-usb: found a 'Pinnacle
PCTV 73e SE' in warm state.
Jun 23 10:43:58 localhost kernel: [ 1535.466856] dvb-usb: will pass the complete
MPEG2 transport stream to the software demuxer.
Jun 23 10:43:58 localhost kernel: [ 1535.467009] DVB: registering new adapter
(Pinnacle PCTV 73e SE)
Jun 23 10:43:58 localhost kernel: [ 1535.676006] DVB: registering adapter
0 frontend 0 (DiBcom 7000PC)...
Jun 23 10:43:58 localhost kernel: [ 1535.880380] DiB0070: successfully identified
Jun 23 10:43:58 localhost kernel: [ 1535.880397] Registered IR keymap rc-dib0700-rc5
Jun 23 10:43:58 localhost kernel: [ 1535.880613] input: IR-receiver inside
an USB DVB receiver as /devices/pci0000:00/0000:00:1d.7/usb2/2-4/rc/rc2/input19
Jun 23 10:43:58 localhost kernel: [ 1535.880766] rc2: IR-receiver inside
an USB DVB receiver as /devices/pci0000:00/0000:00:1d.7/usb2/2-4/rc/rc2
Jun 23 10:43:58 localhost kernel: [ 1535.880873] dvb-usb: schedule remote
query interval to 50 msecs.
Jun 23 10:43:58 localhost kernel: [ 1535.880877] dvb-usb: Pinnacle PCTV 73e
SE successfully initialized and connected.
Jun 23 10:43:58 localhost mtp-probe: checking bus 2, device 5: "/sys/devices/pci0000:00/0000:00:1d.7/usb2/2-4"
Jun 23 10:43:58 localhost mtp-probe: bus: 2, device: 5 was not an MTP device
B) watch TV with tzap and mplayer:
$ tzap -r 'Nederland 1'
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
reading channels from file '/home/cedric/.tzap/channels.conf'
tuning to 618000000 Hz
video pid 0x1b63, audio pid 0x1b64
status 1f | signal 6172 | snr 0092 | ber 001fffff | unc 00000012 | FE_HAS_LOCK
status 1f | signal 5d6b | snr 009d | ber 00000000 | unc 00000000 | FE_HAS_LOCK
$ mplayer /dev/dvb/adapter0/dvr0 
MPlayer SVN-r34799-4.6.3 (C) 2000-2012 MPlayer Team
183 audio & 398 video codecs
mplayer: could not connect to socket
mplayer: No such file or directory
Failed to open LIRC support. You will not be able to use your remote control.

Playing /dev/dvb/adapter0/dvr0.
libavformat version 54.2.100 (internal)
TS file format detected.
C)unplug the DVB-T receiver. Now mplayer hangs, and tzap reports something
else:
status 1f | signal 0000 | snr 7f53 | ber 00000040 | unc 74cfb5d4 | FE_HAS_LOCK
status 1f | signal 0000 | snr 7f53 | ber 00000040 | unc 74cfb5d4 | FE_HAS_LOCK
status 1f | signal 0000 | snr 7f53 | ber 00000040 | unc 74cfb5d4 | FE_HAS_LOCK

Plugging in another USB device into the USB port where the DVB-t receiver
used to be yields no response in /var/log/everything.log
After a few minutes the following messages appear in everything.log:
Jun 23 10:48:23 localhost kernel: [ 1800.423208] INFO: task khubd:73 blocked
for more than 120 seconds.
Jun 23 10:48:23 localhost kernel: [ 1800.423214] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
Jun 23 10:48:23 localhost kernel: [ 1800.423219] khubd           D 0000000000000000
    0    73      2 0x00000000
Jun 23 10:48:23 localhost kernel: [ 1800.423227]  ffff880037f0bb80 0000000000000046
ffff88007b142800 ffff880037f0bfd8
Jun 23 10:48:23 localhost kernel: [ 1800.423236]  ffff880037f0bfd8 ffff880037f0bfd8
ffff88007b433800 ffff88007b142800
Jun 23 10:48:23 localhost kernel: [ 1800.423243]  ffff880037f0bb30 ffffffff8145d61d
ffff880060c845f0 0000000000000002
Jun 23 10:48:23 localhost kernel: [ 1800.423251] Call Trace:
Jun 23 10:48:23 localhost kernel: [ 1800.423263]  [<ffffffff8145d61d>] ?
wait_for_common+0x12d/0x160
Jun 23 10:48:23 localhost kernel: [ 1800.423271]  [<ffffffff81080ab0>] ?
try_to_wake_up+0x2f0/0x2f0
Jun 23 10:48:23 localhost kernel: [ 1800.423276]  [<ffffffff8145d66d>] ?
wait_for_completion+0x1d/0x20
Jun 23 10:48:23 localhost kernel: [ 1800.423282]  [<ffffffff8145e2df>] schedule+0x3f/0x60
Jun 23 10:48:23 localhost kernel: [ 1800.423298]  [<ffffffffa152ca55>] dvb_unregister_frontend+0xc5/0x110
[dvb_core]
Jun 23 10:48:23 localhost kernel: [ 1800.423306]  [<ffffffff81072550>] ?
abort_exclusive_wait+0xb0/0xb0
Jun 23 10:48:23 localhost kernel: [ 1800.423314]  [<ffffffffa1545b16>] dvb_usb_adapter_frontend_exit+0x46/0x80
[dvb_usb]
Jun 23 10:48:23 localhost kernel: [ 1800.423321]  [<ffffffffa15444d3>] dvb_usb_exit+0x53/0xd0
[dvb_usb]
Jun 23 10:48:23 localhost kernel: [ 1800.423329]  [<ffffffffa15445a1>] dvb_usb_device_exit+0x51/0x70
[dvb_usb]
Jun 23 10:48:23 localhost kernel: [ 1800.423358]  [<ffffffffa00111e0>] usb_unbind_interface+0x50/0x180
[usbcore]
Jun 23 10:48:23 localhost kernel: [ 1800.423369]  [<ffffffff8130ad6c>] __device_release_driver+0x7c/0xe0
Jun 23 10:48:23 localhost kernel: [ 1800.423374]  [<ffffffff8130adfc>] device_release_driver+0x2c/0x40
Jun 23 10:48:23 localhost kernel: [ 1800.423380]  [<ffffffff8130a891>] bus_remove_device+0xe1/0x120
Jun 23 10:48:23 localhost kernel: [ 1800.423386]  [<ffffffff813083ea>] device_del+0x12a/0x1b0
Jun 23 10:48:23 localhost kernel: [ 1800.423399]  [<ffffffffa000ef8f>] usb_disable_device+0xaf/0x1f0
[usbcore]
Jun 23 10:48:23 localhost kernel: [ 1800.423412]  [<ffffffffa0007427>] usb_disconnect+0x87/0x120
[usbcore]
Jun 23 10:48:23 localhost kernel: [ 1800.423425]  [<ffffffffa0008ddb>] hub_thread+0x54b/0x12a0
[usbcore]
Jun 23 10:48:23 localhost kernel: [ 1800.423432]  [<ffffffff81072550>] ?
abort_exclusive_wait+0xb0/0xb0
Jun 23 10:48:23 localhost kernel: [ 1800.423445]  [<ffffffffa0008890>] ?
usb_remote_wakeup+0x40/0x40 [usbcore]
Jun 23 10:48:23 localhost kernel: [ 1800.423455]  [<ffffffff81071bd3>] kthread+0x93/0xa0
Jun 23 10:48:23 localhost kernel: [ 1800.423459]  [<ffffffff81461424>] kernel_thread_helper+0x4/0x10
Jun 23 10:48:23 localhost kernel: [ 1800.423462]  [<ffffffff81071b40>] ?
kthread_freezable_should_stop+0x70/0x70
Jun 23 10:48:23 localhost kernel: [ 1800.423466]  [<ffffffff81461420>] ?
gs_change+0x13/0x13
Jun 23 10:50:23 localhost kernel: [ 1920.423202] INFO: task khubd:73 blocked
for more than 120 seconds.
Jun 23 10:50:23 localhost kernel: [ 1920.423208] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
Jun 23 10:50:23 localhost kernel: [ 1920.423213] khubd           D 0000000000000000
    0    73      2 0x00000000
Jun 23 10:50:23 localhost kernel: [ 1920.423221]  ffff880037f0bb80 0000000000000046
ffff88007b142800 ffff880037f0bfd8
Jun 23 10:50:23 localhost kernel: [ 1920.423230]  ffff880037f0bfd8 ffff880037f0bfd8
ffff88007b433800 ffff88007b142800
Jun 23 10:50:23 localhost kernel: [ 1920.423238]  ffff880037f0bb30 ffffffff8145d61d
ffff880060c845f0 0000000000000002
Jun 23 10:50:23 localhost kernel: [ 1920.423245] Call Trace:
Jun 23 10:50:23 localhost kernel: [ 1920.423257]  [<ffffffff8145d61d>] ?
wait_for_common+0x12d/0x160
Jun 23 10:50:23 localhost kernel: [ 1920.423265]  [<ffffffff81080ab0>] ?
try_to_wake_up+0x2f0/0x2f0
Jun 23 10:50:23 localhost kernel: [ 1920.423271]  [<ffffffff8145d66d>] ?
wait_for_completion+0x1d/0x20
Jun 23 10:50:23 localhost kernel: [ 1920.423277]  [<ffffffff8145e2df>] schedule+0x3f/0x60
Jun 23 10:50:23 localhost kernel: [ 1920.423292]  [<ffffffffa152ca55>] dvb_unregister_frontend+0xc5/0x110
[dvb_core]
Jun 23 10:50:23 localhost kernel: [ 1920.423300]  [<ffffffff81072550>] ?
abort_exclusive_wait+0xb0/0xb0
Jun 23 10:50:23 localhost kernel: [ 1920.423308]  [<ffffffffa1545b16>] dvb_usb_adapter_frontend_exit+0x46/0x80
[dvb_usb]
Jun 23 10:50:23 localhost kernel: [ 1920.423316]  [<ffffffffa15444d3>] dvb_usb_exit+0x53/0xd0
[dvb_usb]
Jun 23 10:50:23 localhost kernel: [ 1920.423324]  [<ffffffffa15445a1>] dvb_usb_device_exit+0x51/0x70
[dvb_usb]
Jun 23 10:50:23 localhost kernel: [ 1920.423353]  [<ffffffffa00111e0>] usb_unbind_interface+0x50/0x180
[usbcore]
Jun 23 10:50:23 localhost kernel: [ 1920.423364]  [<ffffffff8130ad6c>] __device_release_driver+0x7c/0xe0
Jun 23 10:50:23 localhost kernel: [ 1920.423370]  [<ffffffff8130adfc>] device_release_driver+0x2c/0x40
Jun 23 10:50:23 localhost kernel: [ 1920.423376]  [<ffffffff8130a891>] bus_remove_device+0xe1/0x120
Jun 23 10:50:23 localhost kernel: [ 1920.423382]  [<ffffffff813083ea>] device_del+0x12a/0x1b0
Jun 23 10:50:23 localhost kernel: [ 1920.423396]  [<ffffffffa000ef8f>] usb_disable_device+0xaf/0x1f0
[usbcore]
Jun 23 10:50:23 localhost kernel: [ 1920.423409]  [<ffffffffa0007427>] usb_disconnect+0x87/0x120
[usbcore]
Jun 23 10:50:23 localhost kernel: [ 1920.423422]  [<ffffffffa0008ddb>] hub_thread+0x54b/0x12a0
[usbcore]
Jun 23 10:50:23 localhost kernel: [ 1920.423429]  [<ffffffff81072550>] ?
abort_exclusive_wait+0xb0/0xb0
Jun 23 10:50:23 localhost kernel: [ 1920.423444]  [<ffffffffa0008890>] ?
usb_remote_wakeup+0x40/0x40 [usbcore]
Jun 23 10:50:23 localhost kernel: [ 1920.423448]  [<ffffffff81071bd3>] kthread+0x93/0xa0
Jun 23 10:50:23 localhost kernel: [ 1920.423451]  [<ffffffff81461424>] kernel_thread_helper+0x4/0x10
Jun 23 10:50:23 localhost kernel: [ 1920.423455]  [<ffffffff81071b40>] ?
kthread_freezable_should_stop+0x70/0x70
Jun 23 10:50:23 localhost kernel: [ 1920.423459]  [<ffffffff81461420>] ?
gs_change+0x13/0x13
Jun 23 10:52:23 localhost kernel: [ 2040.423186] INFO: task khubd:73 blocked
for more than 120 seconds.
Jun 23 10:52:23 localhost kernel: [ 2040.423192] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
Jun 23 10:52:23 localhost kernel: [ 2040.423198] khubd           D 0000000000000000
    0    73      2 0x00000000
Jun 23 10:52:23 localhost kernel: [ 2040.423206]  ffff880037f0bb80 0000000000000046
ffff88007b142800 ffff880037f0bfd8
Jun 23 10:52:23 localhost kernel: [ 2040.423214]  ffff880037f0bfd8 ffff880037f0bfd8
ffff88007b433800 ffff88007b142800
Jun 23 10:52:23 localhost kernel: [ 2040.423222]  ffff880037f0bb30 ffffffff8145d61d
ffff880060c845f0 0000000000000002
Jun 23 10:52:23 localhost kernel: [ 2040.423230] Call Trace:
Jun 23 10:52:23 localhost kernel: [ 2040.423241]  [<ffffffff8145d61d>] ?
wait_for_common+0x12d/0x160
Jun 23 10:52:23 localhost kernel: [ 2040.423249]  [<ffffffff81080ab0>] ?
try_to_wake_up+0x2f0/0x2f0
Jun 23 10:52:23 localhost kernel: [ 2040.423255]  [<ffffffff8145d66d>] ?
wait_for_completion+0x1d/0x20
Jun 23 10:52:23 localhost kernel: [ 2040.423261]  [<ffffffff8145e2df>] schedule+0x3f/0x60
Jun 23 10:52:23 localhost kernel: [ 2040.423277]  [<ffffffffa152ca55>] dvb_unregister_frontend+0xc5/0x110
[dvb_core]
Jun 23 10:52:23 localhost kernel: [ 2040.423285]  [<ffffffff81072550>] ?
abort_exclusive_wait+0xb0/0xb0
Jun 23 10:52:23 localhost kernel: [ 2040.423293]  [<ffffffffa1545b16>] dvb_usb_adapter_frontend_exit+0x46/0x80
[dvb_usb]
Jun 23 10:52:23 localhost kernel: [ 2040.423301]  [<ffffffffa15444d3>] dvb_usb_exit+0x53/0xd0
[dvb_usb]
Jun 23 10:52:23 localhost kernel: [ 2040.423308]  [<ffffffffa15445a1>] dvb_usb_device_exit+0x51/0x70
[dvb_usb]
Jun 23 10:52:23 localhost kernel: [ 2040.423338]  [<ffffffffa00111e0>] usb_unbind_interface+0x50/0x180
[usbcore]
Jun 23 10:52:23 localhost kernel: [ 2040.423348]  [<ffffffff8130ad6c>] __device_release_driver+0x7c/0xe0
Jun 23 10:52:23 localhost kernel: [ 2040.423354]  [<ffffffff8130adfc>] device_release_driver+0x2c/0x40
Jun 23 10:52:23 localhost kernel: [ 2040.423360]  [<ffffffff8130a891>] bus_remove_device+0xe1/0x120
Jun 23 10:52:23 localhost kernel: [ 2040.423366]  [<ffffffff813083ea>] device_del+0x12a/0x1b0
Jun 23 10:52:23 localhost kernel: [ 2040.423379]  [<ffffffffa000ef8f>] usb_disable_device+0xaf/0x1f0
[usbcore]
Jun 23 10:52:23 localhost kernel: [ 2040.423392]  [<ffffffffa0007427>] usb_disconnect+0x87/0x120
[usbcore]
Jun 23 10:52:23 localhost kernel: [ 2040.423405]  [<ffffffffa0008ddb>] hub_thread+0x54b/0x12a0
[usbcore]
Jun 23 10:52:23 localhost kernel: [ 2040.423412]  [<ffffffff81072550>] ?
abort_exclusive_wait+0xb0/0xb0
Jun 23 10:52:23 localhost kernel: [ 2040.423429]  [<ffffffffa0008890>] ?
usb_remote_wakeup+0x40/0x40 [usbcore]
Jun 23 10:52:23 localhost kernel: [ 2040.423433]  [<ffffffff81071bd3>] kthread+0x93/0xa0
Jun 23 10:52:23 localhost kernel: [ 2040.423437]  [<ffffffff81461424>] kernel_thread_helper+0x4/0x10
Jun 23 10:52:23 localhost kernel: [ 2040.423441]  [<ffffffff81071b40>] ?
kthread_freezable_should_stop+0x70/0x70
Jun 23 10:52:23 localhost kernel: [ 2040.423444]  [<ffffffff81461420>] ?
gs_change+0x13/0x13
Jun 23 10:54:23 localhost kernel: [ 2160.423201] INFO: task khubd:73 blocked
for more than 120 seconds.
Jun 23 10:54:23 localhost kernel: [ 2160.423207] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
Jun 23 10:54:23 localhost kernel: [ 2160.423212] khubd           D 0000000000000000
    0    73      2 0x00000000
Jun 23 10:54:23 localhost kernel: [ 2160.423221]  ffff880037f0bb80 0000000000000046
ffff88007b142800 ffff880037f0bfd8
Jun 23 10:54:23 localhost kernel: [ 2160.423230]  ffff880037f0bfd8 ffff880037f0bfd8
ffff88007b433800 ffff88007b142800
Jun 23 10:54:23 localhost kernel: [ 2160.423237]  ffff880037f0bb30 ffffffff8145d61d
ffff880060c845f0 0000000000000002
Jun 23 10:54:23 localhost kernel: [ 2160.423245] Call Trace:
Jun 23 10:54:23 localhost kernel: [ 2160.423257]  [<ffffffff8145d61d>] ?
wait_for_common+0x12d/0x160
Jun 23 10:54:23 localhost kernel: [ 2160.423265]  [<ffffffff81080ab0>] ?
try_to_wake_up+0x2f0/0x2f0
Jun 23 10:54:23 localhost kernel: [ 2160.423271]  [<ffffffff8145d66d>] ?
wait_for_completion+0x1d/0x20
Jun 23 10:54:23 localhost kernel: [ 2160.423276]  [<ffffffff8145e2df>] schedule+0x3f/0x60
Jun 23 10:54:23 localhost kernel: [ 2160.423292]  [<ffffffffa152ca55>] dvb_unregister_frontend+0xc5/0x110
[dvb_core]
Jun 23 10:54:23 localhost kernel: [ 2160.423300]  [<ffffffff81072550>] ?
abort_exclusive_wait+0xb0/0xb0
Jun 23 10:54:23 localhost kernel: [ 2160.423308]  [<ffffffffa1545b16>] dvb_usb_adapter_frontend_exit+0x46/0x80
[dvb_usb]
Jun 23 10:54:23 localhost kernel: [ 2160.423315]  [<ffffffffa15444d3>] dvb_usb_exit+0x53/0xd0
[dvb_usb]
Jun 23 10:54:23 localhost kernel: [ 2160.423323]  [<ffffffffa15445a1>] dvb_usb_device_exit+0x51/0x70
[dvb_usb]
Jun 23 10:54:23 localhost kernel: [ 2160.423353]  [<ffffffffa00111e0>] usb_unbind_interface+0x50/0x180
[usbcore]
Jun 23 10:54:23 localhost kernel: [ 2160.423363]  [<ffffffff8130ad6c>] __device_release_driver+0x7c/0xe0
Jun 23 10:54:23 localhost kernel: [ 2160.423369]  [<ffffffff8130adfc>] device_release_driver+0x2c/0x40
Jun 23 10:54:23 localhost kernel: [ 2160.423374]  [<ffffffff8130a891>] bus_remove_device+0xe1/0x120
Jun 23 10:54:23 localhost kernel: [ 2160.423380]  [<ffffffff813083ea>] device_del+0x12a/0x1b0
Jun 23 10:54:23 localhost kernel: [ 2160.423394]  [<ffffffffa000ef8f>] usb_disable_device+0xaf/0x1f0
[usbcore]
Jun 23 10:54:23 localhost kernel: [ 2160.423407]  [<ffffffffa0007427>] usb_disconnect+0x87/0x120
[usbcore]
Jun 23 10:54:23 localhost kernel: [ 2160.423422]  [<ffffffffa0008ddb>] hub_thread+0x54b/0x12a0
[usbcore]
Jun 23 10:54:23 localhost kernel: [ 2160.423426]  [<ffffffff81072550>] ?
abort_exclusive_wait+0xb0/0xb0
Jun 23 10:54:23 localhost kernel: [ 2160.423434]  [<ffffffffa0008890>] ?
usb_remote_wakeup+0x40/0x40 [usbcore]
Jun 23 10:54:23 localhost kernel: [ 2160.423437]  [<ffffffff81071bd3>] kthread+0x93/0xa0
Jun 23 10:54:23 localhost kernel: [ 2160.423441]  [<ffffffff81461424>] kernel_thread_helper+0x4/0x10
Jun 23 10:54:23 localhost kernel: [ 2160.423445]  [<ffffffff81071b40>] ?
kthread_freezable_should_stop+0x70/0x70
Jun 23 10:54:23 localhost kernel: [ 2160.423448]  [<ffffffff81461420>] ?
gs_change+0x13/0x13

D) kill both mplayer and tzap. Directly afterwards, the USB port responds
to plugging in of a USB device:
Jun 23 10:56:22 localhost kernel: [ 2279.106209] dvb-usb: error while stopping
stream.
Jun 23 10:56:26 localhost kernel: [ 2283.075887] dvb-usb: Pinnacle PCTV 73e
SE successfully deinitialized and disconnected.
Jun 23 10:56:43 localhost kernel: [ 2300.323170] usb 6-2: new low-speed USB
device number 3 using uhci_hcd
Jun 23 10:56:43 localhost kernel: [ 2300.508901] input: Logitech USB Receiver
as /devices/pci0000:00/0000:00:1d.1/usb6/6-2/6-2:1.0/input/input20
Jun 23 10:56:43 localhost kernel: [ 2300.509039] generic-usb 0003:03F0:0B0C.0009:
input,hidraw6: USB HID v1.10 Keyboard [Logitech USB Receiver] on usb-0000:00:1d.1-2/input0
Jun 23 10:56:43 localhost kernel: [ 2300.546310] input: Logitech USB Receiver
as /devices/pci0000:00/0000:00:1d.1/usb6/6-2/6-2:1.1/input/input21
Jun 23 10:56:43 localhost kernel: [ 2300.546816] generic-usb 0003:03F0:0B0C.000A:
input,hiddev0,hidraw7: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:1d.1-2/input1
Jun 23 10:56:43 localhost logger: loading HP Device 006 003
Jun 23 10:56:43 localhost mtp-probe: checking bus 6, device 3: "/sys/devices/pci0000:00/0000:00:1d.1/usb6/6-2"
Jun 23 10:56:43 localhost mtp-probe: bus: 6, device: 3 was not an MTP device
Jun 23 10:56:44 localhost acpid: input device has been disconnected, fd 8
Jun 23 10:56:44 localhost kernel: [ 2301.846533] usb 6-2: USB disconnect,
device number 3
Jun 23 10:56:44 localhost acpid: input device has been disconnected, fd 21
Jun 23 10:56:45 localhost python2: io/hpmud/musb.c 2118: invalid busnum:devnum
006:003
Jun 23 10:56:45 localhost hp-config_usb_printer: hp-config_usb_printer[2123]:
error: This is not a valid device


[3.] Keywords (i.e., modules, networking, kernel):
DVB, USB

[4.] Kernel information
[4.1.] Kernel version (from /proc/version):
# cat /proc/version 
Linux version 3.3.7-1-ARCH (tobias@T-POWA-LX) (gcc version 4.7.0 20120505
(prerelease) (GCC) ) #1 SMP PREEMPT Tue May 22 00:26:26 CEST 2012
[4.2.] Kernel .config file: attached
[5.] Most recent kernel version which did not have the bug:
Unknown.
[6.] Output of Oops.. message (if applicable) with symbolic information resolved.
This is not an oops
[7.] A small shell script or example program which triggers the problem (if
possible)
See the steps in section 2
[8.] Environment
[8.1.] Software (add the output of the ver_linux script here)
$ sh scripts/ver_linux 
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.
 
Linux cedric 3.3.7-1-ARCH #1 SMP PREEMPT Tue May 22 00:26:26 CEST 2012 x86_64
GNU/Linux
 
Gnu C                  4.7.0
Gnu make               3.82
binutils               2.22.0.20120323
util-linux             2.21.2
mount                  debug
module-init-tools      8
e2fsprogs              1.42.3
jfsutils               1.1.15
reiserfsprogs          3.6.21
xfsprogs               3.1.8
pcmciautils            018
PPP                    2.4.5
Linux C Library        2.15
Dynamic linker (ldd)   2.15
Linux C++ Library      6.0.17
Procps                 3.3.3
Net-tools              1.60
Kbd                    1.15.3
Sh-utils               8.17
wireless-tools         29
Modules Loaded         nls_cp437 vfat fat fuse aes_x86_64 cryptd aes_generic
rc_dib0700_rc5 ir_lirc_codec lirc_dev ir_mce_kbd_decoder ir_sanyo_decoder
ir_sony_decoder ir_jvc_decoder ir_rc6_decoder ir_rc5_decoder ir_nec_decoder
dvb_usb_dib0700 dib3000mc dib8000 dib0070 dib7000m dib7000p dibx000_common
dib0090 dvb_usb dvb_core rc_core joydev btusb bluetooth nvidia r8169 snd_hda_codec_realtek
snd_hda_intel snd_hda_codec intel_agp snd_hwdep snd_pcm intel_gtt snd_page_alloc
firewire_ohci snd_timer snd firewire_core mmc_block soundcore serio_raw psmouse
pcspkr dell_wmi dell_laptop sdhci_pci sparse_keymap i2c_i801 iTCO_wdt i2c_core
sdhci mii iTCO_vendor_support crc_itu_t dcdbas evdev wmi processor button
battery video ac arc4 b43 ssb pcmcia bcma mmc_core mac80211 cfg80211 rfkill
pcmcia_core vboxdrv ext4 crc16 jbd2 mbcache hid_logitech_dj usbhid hid sr_mod
cdrom sd_mod pata_acpi ata_generic ata_piix ahci libahci uhci_hcd libata
scsi_mod ehci_hcd usbcore usb_common

[8.2.] Processor information (from /proc/cpuinfo):
$ cat /proc/cpuinfo 
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Core(TM)2 Duo CPU     T5670  @ 1.80GHz
stepping	: 13
microcode	: 0xa1
cpu MHz		: 1795.508
cache size	: 2048 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat
pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc
arch_perfmon pebs bts rep_good nopl aperfmperf pni dtes64 monitor ds_cpl
est tm2 ssse3 cx16 xtpr pdcm lahf_lm ida dts
bogomips	: 3592.64
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Core(TM)2 Duo CPU     T5670  @ 1.80GHz
stepping	: 13
microcode	: 0xa1
cpu MHz		: 1795.508
cache size	: 2048 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
apicid		: 1
initial apicid	: 1
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat
pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc
arch_perfmon pebs bts rep_good nopl aperfmperf pni dtes64 monitor ds_cpl
est tm2 ssse3 cx16 xtpr pdcm lahf_lm ida dts
bogomips	: 3592.64
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:
[8.3.] Module information (from /proc/modules):
$ cat /proc/modules 
nls_cp437 5953 1 - Live 0xffffffffa005b000
vfat 10183 1 - Live 0xffffffffa0055000
fat 49739 1 vfat, Live 0xffffffffa0042000
fuse 68162 2 - Live 0xffffffffa0029000
aes_x86_64 7508 2 - Live 0xffffffffa15f6000
cryptd 8383 0 - Live 0xffffffffa15ef000
aes_generic 26138 1 aes_x86_64, Live 0xffffffffa15e0000
rc_dib0700_rc5 2300 0 - Live 0xffffffffa15dc000
ir_lirc_codec 4027 0 - Live 0xffffffffa15d8000
lirc_dev 9359 1 ir_lirc_codec, Live 0xffffffffa15d1000
ir_mce_kbd_decoder 3254 0 - Live 0xffffffffa15cd000
ir_sanyo_decoder 1677 0 - Live 0xffffffffa15c9000
ir_sony_decoder 1579 0 - Live 0xffffffffa15c5000
ir_jvc_decoder 1673 0 - Live 0xffffffffa15c1000
ir_rc6_decoder 2153 0 - Live 0xffffffffa15bd000
ir_rc5_decoder 1609 0 - Live 0xffffffffa15b9000
ir_nec_decoder 1705 0 - Live 0xffffffffa15b5000
dvb_usb_dib0700 134133 0 - Live 0xffffffffa158d000
dib3000mc 13077 1 dvb_usb_dib0700, Live 0xffffffffa1585000
dib8000 41012 1 dvb_usb_dib0700, Live 0xffffffffa1575000
dib0070 8050 2 dvb_usb_dib0700, Live 0xffffffffa1570000
dib7000m 15390 1 dvb_usb_dib0700, Live 0xffffffffa1568000
dib7000p 27940 2 dvb_usb_dib0700, Live 0xffffffffa155d000
dibx000_common 7048 5 dvb_usb_dib0700,dib3000mc,dib8000,dib7000m,dib7000p,
Live 0xffffffffa1558000
dib0090 24877 1 dvb_usb_dib0700, Live 0xffffffffa154d000
dvb_usb 17288 1 dvb_usb_dib0700, Live 0xffffffffa1544000
dvb_core 95963 3 dib8000,dib7000p,dvb_usb, Live 0xffffffffa1523000
rc_core 13280 12 rc_dib0700_rc5,ir_lirc_codec,ir_mce_kbd_decoder,ir_sanyo_decoder,ir_sony_decoder,ir_jvc_decoder,ir_rc6_decoder,ir_rc5_decoder,ir_nec_decoder,dvb_usb_dib0700,dvb_usb,
Live 0xffffffffa151a000
joydev 9991 0 - Live 0xffffffffa1514000
btusb 11675 0 - Live 0xffffffffa1506000
bluetooth 171342 1 btusb, Live 0xffffffffa149c000
nvidia 12283579 33 - Live 0xffffffffa0837000 (PO)
r8169 48740 0 - Live 0xffffffffa0825000
snd_hda_codec_realtek 114123 1 - Live 0xffffffffa0801000
snd_hda_intel 24021 1 - Live 0xffffffffa07f5000
snd_hda_codec 92713 2 snd_hda_codec_realtek,snd_hda_intel, Live 0xffffffffa07d0000
intel_agp 10872 0 - Live 0xffffffffa07c9000
snd_hwdep 6556 1 snd_hda_codec, Live 0xffffffffa07c3000
snd_pcm 74812 2 snd_hda_intel,snd_hda_codec, Live 0xffffffffa07a6000
intel_gtt 14007 1 intel_agp, Live 0xffffffffa079e000
snd_page_alloc 7217 2 snd_hda_intel,snd_pcm, Live 0xffffffffa0798000
firewire_ohci 31554 0 - Live 0xffffffffa078c000
snd_timer 19222 1 snd_pcm, Live 0xffffffffa0782000
snd 59656 8 snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_timer,
Live 0xffffffffa0769000
firewire_core 51466 1 firewire_ohci, Live 0xffffffffa0755000
mmc_block 19219 2 - Live 0xffffffffa074c000
soundcore 6082 1 snd, Live 0xffffffffa0746000
serio_raw 4653 0 - Live 0xffffffffa0741000
psmouse 69539 0 - Live 0xffffffffa0728000
pcspkr 1835 0 - Live 0xffffffffa0724000
dell_wmi 1517 0 - Live 0xffffffffa0720000
dell_laptop 10600 0 - Live 0xffffffffa0719000
sdhci_pci 10535 0 - Live 0xffffffffa0712000
sparse_keymap 3056 1 dell_wmi, Live 0xffffffffa070e000
i2c_i801 8116 0 - Live 0xffffffffa0708000
iTCO_wdt 12877 0 - Live 0xffffffffa06ff000
i2c_core 20593 11 dvb_usb_dib0700,dib3000mc,dib8000,dib0070,dib7000m,dib7000p,dibx000_common,dib0090,dvb_usb,nvidia,i2c_i801,
Live 0xffffffffa06e7000
sdhci 23662 1 sdhci_pci, Live 0xffffffffa06dd000
mii 4091 1 r8169, Live 0xffffffffa06d9000
iTCO_vendor_support 1929 1 iTCO_wdt, Live 0xffffffffa06d5000
crc_itu_t 1363 1 firewire_core, Live 0xffffffffa06d1000
dcdbas 5552 1 dell_laptop, Live 0xffffffffa06cb000
evdev 9402 25 - Live 0xffffffffa06c4000
wmi 8475 1 dell_wmi, Live 0xffffffffa06bd000
processor 26144 2 - Live 0xffffffffa06a3000
button 4502 0 - Live 0xffffffffa0683000
battery 6485 0 - Live 0xffffffffa067e000
video 11243 0 - Live 0xffffffffa0672000
ac 2376 0 - Live 0xffffffffa067a000
arc4 1410 2 - Live 0xffffffffa066e000
b43 347913 0 - Live 0xffffffffa060c000
ssb 48216 1 b43, Live 0xffffffffa05f9000
pcmcia 36073 2 b43,ssb, Live 0xffffffffa05ea000
bcma 21810 1 b43, Live 0xffffffffa05df000
mmc_core 82735 5 mmc_block,sdhci_pci,sdhci,b43,ssb, Live 0xffffffffa05bf000
mac80211 391455 1 b43, Live 0xffffffffa0542000
cfg80211 176857 2 b43,mac80211, Live 0xffffffffa0508000
rfkill 15604 3 bluetooth,dell_laptop,cfg80211, Live 0xffffffffa04ff000
pcmcia_core 12189 1 pcmcia, Live 0xffffffffa04f7000
vboxdrv 1792230 0 - Live 0xffffffffa0323000 (O)
ext4 424467 2 - Live 0xffffffffa02a0000
crc16 1359 2 bluetooth,ext4, Live 0xffffffffa029c000
jbd2 71704 1 ext4, Live 0xffffffffa0280000
mbcache 5977 1 ext4, Live 0xffffffffa027a000
hid_logitech_dj 10181 0 - Live 0xffffffffa026c000
usbhid 36142 1 hid_logitech_dj, Live 0xffffffffa0250000
hid 84549 2 hid_logitech_dj,usbhid, Live 0xffffffffa0235000
sr_mod 14823 0 - Live 0xffffffffa022d000
cdrom 35744 1 sr_mod, Live 0xffffffffa021f000
sd_mod 28059 4 - Live 0xffffffffa0213000
pata_acpi 3408 0 - Live 0xffffffffa020f000
ata_generic 3295 0 - Live 0xffffffffa020b000
ata_piix 22136 0 - Live 0xffffffffa0200000
ahci 20261 3 - Live 0xffffffffa01e2000
libahci 19999 1 ahci, Live 0xffffffffa01d8000
uhci_hcd 23404 0 - Live 0xffffffffa01ba000
libata 167083 5 pata_acpi,ata_generic,ata_piix,ahci,libahci, Live 0xffffffffa017b000
scsi_mod 133422 3 sr_mod,sd_mod,libata, Live 0xffffffffa0135000
ehci_hcd 44104 0 - Live 0xffffffffa00a3000
usbcore 146847 7 dvb_usb_dib0700,dvb_usb,btusb,usbhid,uhci_hcd,ehci_hcd,
Live 0xffffffffa0004000
usb_common 954 1 usbcore, Live 0xffffffffa0000000

[8.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
$ cat /proc/ioports 
0000-0cf7 : PCI Bus 0000:00
  0000-001f : dma1
  0020-0021 : pic1
  0040-0043 : timer0
  0050-0053 : timer1
  0060-0060 : keyboard
  0062-0062 : EC data
  0064-0064 : keyboard
  0066-0066 : EC cmd
  0070-0077 : rtc0
  0080-008f : dma page reg
  00a0-00a1 : pic2
  00c0-00df : dma2
  00f0-00ff : fpu
  0170-0177 : 0000:00:1f.1
    0170-0177 : ata_piix
  01f0-01f7 : 0000:00:1f.1
    01f0-01f7 : ata_piix
  0376-0376 : 0000:00:1f.1
    0376-0376 : ata_piix
  03c0-03df : vga+
  03f6-03f6 : 0000:00:1f.1
    03f6-03f6 : ata_piix
  0680-069f : pnp 00:06
  0800-080f : pnp 00:06
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
  1000-107f : 0000:00:1f.0
    1000-107f : pnp 00:06
      1000-1003 : ACPI PM1a_EVT_BLK
      1004-1005 : ACPI PM1a_CNT_BLK
      1008-100b : ACPI PM_TMR
      1010-1015 : ACPI CPU throttle
      1020-1020 : ACPI PM2_CNT_BLK
      1028-102f : ACPI GPE0_BLK
      1030-1033 : iTCO_wdt
      1060-107f : iTCO_wdt
  1180-11bf : 0000:00:1f.0
    1180-11bf : pnp 00:06
  1800-181f : 0000:00:1a.0
    1800-181f : uhci_hcd
  1820-183f : 0000:00:1a.1
    1820-183f : uhci_hcd
  1840-185f : 0000:00:1d.0
    1840-185f : uhci_hcd
  1860-187f : 0000:00:1d.1
    1860-187f : uhci_hcd
  1880-189f : 0000:00:1d.2
    1880-189f : uhci_hcd
  18a0-18af : 0000:00:1f.1
    18a0-18af : ata_piix
  18c8-18cb : 0000:00:1f.2
    18c8-18cb : ahci
  18cc-18cf : 0000:00:1f.2
    18cc-18cf : ahci
  18d0-18d7 : 0000:00:1f.2
    18d0-18d7 : ahci
  18d8-18df : 0000:00:1f.2
    18d8-18df : ahci
  18e0-18ff : 0000:00:1f.2
    18e0-18ff : ahci
  1c00-1c1f : 0000:00:1f.3
  2000-2fff : PCI Bus 0000:01
    2000-207f : 0000:01:00.0
  3000-3fff : PCI Bus 0000:02
  4000-4fff : PCI Bus 0000:03
  5000-5fff : PCI Bus 0000:06
  6000-6fff : PCI Bus 0000:07
    6000-60ff : 0000:07:00.0
      6000-60ff : r8169
  fe00-fe00 : pnp 00:06
  ff00-ff7f : pnp 00:06

$ cat /proc/iomem 
00000000-0000ffff : reserved
00010000-0009f7ff : System RAM
0009f800-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
000c0000-000ccdff : Video ROM
000cd000-000cdfff : Adapter ROM
000ce000-000cffff : reserved
000d0000-000d3fff : PCI Bus 0000:00
000d4000-000d7fff : PCI Bus 0000:00
000d8000-000dbfff : PCI Bus 0000:00
000dc000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-7fecffff : System RAM
  01000000-01463f3d : Kernel code
  01463f3e-0189dbff : Kernel data
  0195b000-01a99fff : Kernel bss
7fed0000-7fee2fff : ACPI Non-volatile Storage
7fee3000-7fffffff : reserved
80000000-dfffffff : PCI Bus 0000:00
  80100000-801000ff : 0000:00:1f.3
  80200000-806fffff : PCI Bus 0000:07
  c0000000-c3ffffff : PCI Bus 0000:02
  c8000000-caffffff : PCI Bus 0000:01
    c8000000-c9ffffff : 0000:01:00.0
    ca000000-caffffff : 0000:01:00.0
      ca000000-caffffff : nvidia
  cc000000-cdffffff : PCI Bus 0000:02
  d0000000-dfffffff : PCI Bus 0000:01
    d0000000-dfffffff : 0000:01:00.0
e0000000-efffffff : PCI MMCONFIG 0000 [bus 00-ff]
  e0000000-efffffff : reserved
    e0000000-efffffff : pnp 00:01
f0000000-febfffff : PCI Bus 0000:00
  f0000000-f3ffffff : PCI Bus 0000:03
  f4000000-f7ffffff : PCI Bus 0000:06
    f4000000-f4003fff : 0000:06:00.0
      f4000000-f4003fff : 0000:06:00.0
  f8000000-f80fffff : PCI Bus 0000:08
    f8000000-f8000fff : 0000:08:05.0
      f8000000-f8000fff : firewire_ohci
    f8001000-f8001fff : 0000:08:05.3
    f8002000-f80027ff : 0000:08:05.0
    f8002800-f80028ff : 0000:08:05.2
      f8002800-f80028ff : mmc0
  f8300000-f8303fff : 0000:00:1b.0
    f8300000-f8303fff : ICH HD audio
  f8304000-f83047ff : 0000:00:1f.2
    f8304000-f83047ff : ahci
  f8304800-f8304bff : 0000:00:1a.7
    f8304800-f8304bff : ehci_hcd
  f8304c00-f8304fff : 0000:00:1d.7
    f8304c00-f8304fff : ehci_hcd
  f8400000-f84fffff : PCI Bus 0000:07
    f8400000-f840ffff : 0000:07:00.0
      f8400000-f840ffff : r8169
    f8410000-f8410fff : 0000:07:00.0
      f8410000-f8410fff : r8169
    f8420000-f842ffff : 0000:07:00.0
  fa000000-fbffffff : PCI Bus 0000:03
  fc000000-fdffffff : PCI Bus 0000:06
    fc000000-fc0fffff : 0000:06:00.0
      fc000000-fc0fffff : 0000:06:00.0
fec00000-fec0ffff : reserved
  fec00000-fec003ff : IOAPIC 0
fed00000-fed003ff : HPET 0
  fed00000-fed003ff : reserved
    fed00000-fed003ff : pnp 00:04
fed14000-fed19fff : reserved
  fed14000-fed17fff : pnp 00:01
  fed18000-fed18fff : pnp 00:01
  fed19000-fed19fff : pnp 00:01
fed1c000-fed8ffff : reserved
  fed1c000-fed1ffff : pnp 00:01
  fed20000-fed3ffff : pnp 00:01
  fed40000-fed44fff : pnp 00:01
  fed45000-fed8ffff : pnp 00:01
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : reserved
ff000000-ffffffff : reserved

[8.5.] PCI information ('lspci -vvv' as root)
# lspci -vvv
00:00.0 Host bridge: Intel Corporation Mobile PM965/GM965/GL960 Memory Controller
Hub (rev 0c)
	Subsystem: Dell Device 0275
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information: Len=0a <?>

00:01.0 PCI bridge: Intel Corporation Mobile PM965/GM965/GL960 PCI Express
Root Port (rev 0c) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: c8000000-caffffff
	Prefetchable memory behind bridge: 00000000d0000000-00000000dfffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [88] Subsystem: Dell Device 0275
	Capabilities: [80] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0300c  Data: 4169
	Capabilities: [a0] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0 <256ns,
L1 <4us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- BWMgmt-
ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise-
			Slot #1, PowerLimit 75.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Off, PwrInd On, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed+ WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
	Capabilities: [140 v1] Root Complex Link
		Desc:	PortNumber=02 ComponentID=01 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=01 AssocRCRB- LinkType=MemMapped
LinkValid+
			Addr:	00000000fed19000
	Kernel driver in use: pcieport

00:1a.0 USB controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller
#4 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Dell Device 0275
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 4: I/O ports at 1800 [size=32]
	Kernel driver in use: uhci_hcd

00:1a.1 USB controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller
#5 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Dell Device 0275
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 21
	Region 4: I/O ports at 1820 [size=32]
	Kernel driver in use: uhci_hcd

00:1a.7 USB controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI
Controller #2 (rev 03) (prog-if 20 [EHCI])
	Subsystem: Dell Device 0275
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at f8304800 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Kernel driver in use: ehci_hcd

00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio Controller
(rev 03)
	Subsystem: Dell Device 0275
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 46
	Region 0: Memory at f8300000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0300c  Data: 41a1
	Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 <64ns,
L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- BWMgmt-
ABWMgmt-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
		VC1:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=1 ArbSelect=Fixed TC/VC=80
			Status:	NegoPending- InProgress-
	Capabilities: [130 v1] Root Complex Link
		Desc:	PortNumber=0f ComponentID=02 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=02 AssocRCRB- LinkType=MemMapped
LinkValid+
			Addr:	00000000fed1c000
	Kernel driver in use: snd_hda_intel

00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port
1 (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 00003000-00003fff
	Memory behind bridge: c0000000-c3ffffff
	Prefetchable memory behind bridge: 00000000cc000000-00000000cdffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us,
L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt-
ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #2, PowerLimit 6.500W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0300c  Data: 4171
	Capabilities: [90] Subsystem: Dell Device 0275
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed+ WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
	Capabilities: [180 v1] Root Complex Link
		Desc:	PortNumber=01 ComponentID=02 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=02 AssocRCRB- LinkType=MemMapped
LinkValid+
			Addr:	00000000fed1c001
	Kernel driver in use: pcieport

00:1c.1 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port
2 (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 00004000-00004fff
	Memory behind bridge: f0000000-f3ffffff
	Prefetchable memory behind bridge: 00000000fa000000-00000000fbffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us,
L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt-
ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #3, PowerLimit 6.500W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0300c  Data: 4179
	Capabilities: [90] Subsystem: Dell Device 0275
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed+ WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
	Capabilities: [180 v1] Root Complex Link
		Desc:	PortNumber=02 ComponentID=02 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=02 AssocRCRB- LinkType=MemMapped
LinkValid+
			Addr:	00000000fed1c001
	Kernel driver in use: pcieport

00:1c.3 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port
4 (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=06, subordinate=06, sec-latency=0
	I/O behind bridge: 00005000-00005fff
	Memory behind bridge: f4000000-f7ffffff
	Prefetchable memory behind bridge: 00000000fc000000-00000000fdffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #4, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <256ns,
L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt-
ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #5, PowerLimit 6.500W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0300c  Data: 4181
	Capabilities: [90] Subsystem: Dell Device 0275
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed+ WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
	Capabilities: [180 v1] Root Complex Link
		Desc:	PortNumber=04 ComponentID=02 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=02 AssocRCRB- LinkType=MemMapped
LinkValid+
			Addr:	00000000fed1c001
	Kernel driver in use: pcieport

00:1c.4 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port
5 (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=07, subordinate=07, sec-latency=0
	I/O behind bridge: 00006000-00006fff
	Memory behind bridge: 80200000-806fffff
	Prefetchable memory behind bridge: 00000000f8400000-00000000f84fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #5, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <256ns,
L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM L0s Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt-
ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #2, PowerLimit 6.500W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0300c  Data: 4189
	Capabilities: [90] Subsystem: Dell Device 0275
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed+ WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
	Capabilities: [180 v1] Root Complex Link
		Desc:	PortNumber=05 ComponentID=02 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=02 AssocRCRB- LinkType=MemMapped
LinkValid+
			Addr:	00000000fed1c001
	Kernel driver in use: pcieport

00:1d.0 USB controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller
#1 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Dell Device 0275
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 23
	Region 4: I/O ports at 1840 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.1 USB controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller
#2 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Dell Device 0275
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 19
	Region 4: I/O ports at 1860 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.2 USB controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller
#3 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Dell Device 0275
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 18
	Region 4: I/O ports at 1880 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.7 USB controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI
Controller #1 (rev 03) (prog-if 20 [EHCI])
	Subsystem: Dell Device 0275
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at f8304c00 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev f3) (prog-if
01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=08, subordinate=08, sec-latency=32
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: f8000000-f80fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort+ <SERR- <PERR+
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Subsystem: Dell Device 0275

00:1f.0 ISA bridge: Intel Corporation 82801HM (ICH8M) LPC Interface Controller
(rev 03)
	Subsystem: Dell Device 0275
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information: Len=0c <?>

00:1f.1 IDE interface: Intel Corporation 82801HM/HEM (ICH8M/ICH8M-E) IDE
Controller (rev 03) (prog-if 8a [Master SecP PriP])
	Subsystem: Dell Device 0275
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 18
	Region 0: I/O ports at 01f0 [size=8]
	Region 1: I/O ports at 03f4 [size=1]
	Region 2: I/O ports at 0170 [size=8]
	Region 3: I/O ports at 0374 [size=1]
	Region 4: I/O ports at 18a0 [size=16]
	Kernel driver in use: ata_piix

00:1f.2 SATA controller: Intel Corporation 82801HM/HEM (ICH8M/ICH8M-E) SATA
Controller [AHCI mode] (rev 03) (prog-if 01 [AHCI 1.0])
	Subsystem: Dell Device 0275
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 45
	Region 0: I/O ports at 18d8 [size=8]
	Region 1: I/O ports at 18cc [size=4]
	Region 2: I/O ports at 18d0 [size=8]
	Region 3: I/O ports at 18c8 [size=4]
	Region 4: I/O ports at 18e0 [size=32]
	Region 5: Memory at f8304000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [80] MSI: Enable+ Count=1/4 Maskable- 64bit-
		Address: fee0300c  Data: 4191
	Capabilities: [70] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=00000004
	Kernel driver in use: ahci

00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller (rev
03)
	Subsystem: Dell Device 0275
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at 80100000 (32-bit, non-prefetchable) [size=256]
	Region 4: I/O ports at 1c00 [size=32]

01:00.0 VGA compatible controller: NVIDIA Corporation G86 [GeForce 8600M
GS] (rev a1) (prog-if 00 [VGA controller])
	Subsystem: Dell Device 0275
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at ca000000 (32-bit, non-prefetchable) [size=16M]
	Region 1: Memory at d0000000 (64-bit, prefetchable) [size=256M]
	Region 3: Memory at c8000000 (64-bit, non-prefetchable) [size=32M]
	Region 5: I/O ports at 2000 [size=128]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [68] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [78] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <4us
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0 <512ns,
L1 <4us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 128 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- BWMgmt-
ABWMgmt-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
	Capabilities: [128 v1] Power Budgeting <?>
	Capabilities: [600 v1] Vendor Specific Information: ID=0001 Rev=1 Len=024
<?>
	Kernel driver in use: nvidia

06:00.0 Network controller: Broadcom Corporation BCM4321 802.11a/b/g/n (rev
03)
	Subsystem: Dell Wireless 1500 Draft 802.11n WLAN Mini-card
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at f4000000 (64-bit, non-prefetchable) [size=16K]
	Region 2: Memory at fc000000 (64-bit, prefetchable) [size=1M]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=2 PME-
	Capabilities: [58] Vendor Specific Information: Len=78 <?>
	Capabilities: [e8] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [d0] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr+ UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM unknown, Latency L0 <4us,
L1 <64us
			ClockPM- Surprise+ LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt-
ABWMgmt-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP-
ECRC- UnsupReq+ ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP-
ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+
ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 14, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [13c v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
	Capabilities: [160 v1] Device Serial Number c9-97-4d-ff-ff-95-00-23
	Capabilities: [16c v1] Power Budgeting <?>
	Kernel driver in use: b43-pci-bridge

07:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B
PCI Express Gigabit Ethernet controller (rev 02)
	Subsystem: Dell Device 0275
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR+ <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 47
	Region 0: I/O ports at 6000 [size=256]
	Region 2: Memory at f8410000 (64-bit, prefetchable) [size=4K]
	Region 4: Memory at f8400000 (64-bit, prefetchable) [size=64K]
	[virtual] Expansion ROM at f8420000 [disabled] [size=64K]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable+ Count=1/2 Maskable- 64bit+
		Address: 00000000fee0300c  Data: 41a9
	Capabilities: [70] Express (v1) Endpoint, MSI 01
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <512ns, L1 <8us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 4096 bytes
		DevSta:	CorrErr+ UncorrErr+ FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns,
L1 <64us
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM L0s Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt-
ABWMgmt-
	Capabilities: [b0] MSI-X: Enable- Count=2 Masked-
		Vector table: BAR=4 offset=00000000
		PBA: BAR=4 offset=00000800
	Capabilities: [d0] Vital Product Data
		Unknown small resource type 00, will not decode more.
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP-
ECRC- UnsupReq+ ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP-
ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+
ECRC- UnsupReq- ACSViol-
		CESta:	RxErr+ BadTLP- BadDLLP- Rollover- Timeout+ NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 14, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [140 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
	Capabilities: [160 v1] Device Serial Number 00-00-00-00-00-00-00-00
	Kernel driver in use: r8169

08:05.0 FireWire (IEEE 1394): O2 Micro, Inc. Firewire (IEEE 1394) (rev 02)
(prog-if 10 [OHCI])
	Subsystem: Dell Device 0275
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx+
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 22
	Region 0: Memory at f8000000 (32-bit, non-prefetchable) [size=4K]
	Region 1: Memory at f8002000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME+
	Kernel driver in use: firewire_ohci

08:05.2 SD Host controller: O2 Micro, Inc. Integrated MMC/SD Controller (rev
02) (prog-if 01)
	Subsystem: Dell Device 0275
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 22
	Region 0: Memory at f8002800 (32-bit, non-prefetchable) [size=256]
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: sdhci-pci

08:05.3 Mass storage controller: O2 Micro, Inc. Integrated MS/xD Controller
(rev 01)
	Subsystem: Dell Device 0275
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at f8001000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

[8.6.] SCSI information (from /proc/scsi/scsi)
# cat /proc/scsi/scsi 
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: WDC WD2500BJKT-7 Rev: 11.0
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi3 Channel: 00 Id: 00 Lun: 00
  Vendor: Optiarc  Model: DVD+-RW AD-7640A Rev: JD06
  Type:   CD-ROM                           ANSI  SCSI revision: 05

[8.7.] Other information that might be relevant to the problem
       (please look in /proc and include all information that you
       think to be relevant):
# lsusb -v

Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0        64
  idVendor           0x1d6b Linux Foundation
  idProduct          0x0002 2.0 root hub
  bcdDevice            3.03
  iManufacturer           3 Linux 3.3.7-1-ARCH ehci_hcd
  iProduct                2 EHCI Host Controller
  iSerial                 1 0000:00:1a.7
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0004  1x 4 bytes
        bInterval              12
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             4
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
  bPwrOn2PwrGood       10 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0100 power
   Port 3: 0000.0100 power
   Port 4: 0000.0100 power
Device Status:     0x0001
  Self Powered

Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0        64
  idVendor           0x1d6b Linux Foundation
  idProduct          0x0002 2.0 root hub
  bcdDevice            3.03
  iManufacturer           3 Linux 3.3.7-1-ARCH ehci_hcd
  iProduct                2 EHCI Host Controller
  iSerial                 1 0000:00:1d.7
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0004  1x 4 bytes
        bInterval              12
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             6
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
  bPwrOn2PwrGood       10 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0100 power
   Port 3: 0000.0100 power
   Port 4: 0000.0503 highspeed power enable connect
   Port 5: 0000.0100 power
   Port 6: 0000.0100 power
Device Status:     0x0001
  Self Powered

Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0        64
  idVendor           0x1d6b Linux Foundation
  idProduct          0x0001 1.1 root hub
  bcdDevice            3.03
  iManufacturer           3 Linux 3.3.7-1-ARCH uhci_hcd
  iProduct                2 UHCI Host Controller
  iSerial                 1 0000:00:1a.0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0002  1x 2 bytes
        bInterval             255
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             2
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
  bPwrOn2PwrGood        1 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0103 power enable connect
   Port 2: 0000.0100 power
Device Status:     0x0001
  Self Powered

Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0        64
  idVendor           0x1d6b Linux Foundation
  idProduct          0x0001 1.1 root hub
  bcdDevice            3.03
  iManufacturer           3 Linux 3.3.7-1-ARCH uhci_hcd
  iProduct                2 UHCI Host Controller
  iSerial                 1 0000:00:1a.1
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0002  1x 2 bytes
        bInterval             255
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             2
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
  bPwrOn2PwrGood        1 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0103 power enable connect
   Port 2: 0000.0103 power enable connect
Device Status:     0x0001
  Self Powered

Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0        64
  idVendor           0x1d6b Linux Foundation
  idProduct          0x0001 1.1 root hub
  bcdDevice            3.03
  iManufacturer           3 Linux 3.3.7-1-ARCH uhci_hcd
  iProduct                2 UHCI Host Controller
  iSerial                 1 0000:00:1d.0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0002  1x 2 bytes
        bInterval             255
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             2
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
  bPwrOn2PwrGood        1 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0100 power
Device Status:     0x0001
  Self Powered

Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0        64
  idVendor           0x1d6b Linux Foundation
  idProduct          0x0001 1.1 root hub
  bcdDevice            3.03
  iManufacturer           3 Linux 3.3.7-1-ARCH uhci_hcd
  iProduct                2 UHCI Host Controller
  iSerial                 1 0000:00:1d.1
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0002  1x 2 bytes
        bInterval             255
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             2
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
  bPwrOn2PwrGood        1 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0103 power enable connect
   Port 2: 0000.0100 power
Device Status:     0x0001
  Self Powered

Bus 007 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0        64
  idVendor           0x1d6b Linux Foundation
  idProduct          0x0001 1.1 root hub
  bcdDevice            3.03
  iManufacturer           3 Linux 3.3.7-1-ARCH uhci_hcd
  iProduct                2 UHCI Host Controller
  iSerial                 1 0000:00:1d.2
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0002  1x 2 bytes
        bInterval             255
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             2
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
  bPwrOn2PwrGood        1 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0100 power
Device Status:     0x0001
  Self Powered

Bus 002 Device 003: ID 2013:0245 PCTV Systems PCTV 73ESE
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x2013 PCTV Systems
  idProduct          0x0245 PCTV 73ESE
  bcdDevice            1.00
  iManufacturer           1 PCTV Systems
  iProduct                2 PCTV 73e SE
  iSerial                 3 0000000M05E19JN
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           46
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           4
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0 
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)

Bus 003 Device 002: ID 046d:c042 Logitech, Inc. G3 Laser Mouse
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0         8
  idVendor           0x046d Logitech, Inc.
  idProduct          0xc042 G3 Laser Mouse
  bcdDevice           49.01
  iManufacturer           1 Logitech
  iProduct                2 USB Gaming Mouse
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           59
    bNumInterfaces          2
    bConfigurationValue     1
    iConfiguration          4 U49.1 B0010
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower               98mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Device
      bInterfaceSubClass      1 Boot Interface Subclass
      bInterfaceProtocol      2 Mouse
      iInterface              0 
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               1.11
          bCountryCode            0 Not supported
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength      94
         Report Descriptors: 
           ** UNAVAILABLE **
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x000a  1x 10 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Device
      bInterfaceSubClass      0 No Subclass
      bInterfaceProtocol      0 None
      iInterface              0 
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               1.11
          bCountryCode            0 Not supported
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength      54
         Report Descriptors: 
           ** UNAVAILABLE **
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0014  1x 20 bytes
        bInterval              10
Device Status:     0x0000
  (Bus Powered)

Bus 004 Device 002: ID 413c:1002 Dell Computer Corp. Keyboard Hub
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0         8
  idVendor           0x413c Dell Computer Corp.
  idProduct          0x1002 Keyboard Hub
  bcdDevice            2.00
  iManufacturer           1 Dell
  iProduct                2 Dell USB Keyboard Hub
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          2 Dell USB Keyboard Hub
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower               90mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              2 Dell USB Keyboard Hub
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0001  1x 1 bytes
        bInterval             255
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             3
  wHubCharacteristic 0x000d
    Per-port power switching
    Compound device
    Per-port overcurrent protection
  bPwrOn2PwrGood       50 * 2 milli seconds
  bHubContrCurrent     90 milli Ampere
  DeviceRemovable    0x02
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0103 power enable connect
   Port 2: 0000.0100 power
   Port 3: 0000.0100 power
Device Status:     0x0000
  (Bus Powered)

Bus 004 Device 003: ID 046d:c52b Logitech, Inc. Unifying Receiver
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0         8
  idVendor           0x046d Logitech, Inc.
  idProduct          0xc52b Unifying Receiver
  bcdDevice           12.01
  iManufacturer           1 Logitech
  iProduct                2 USB Receiver
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           84
    bNumInterfaces          3
    bConfigurationValue     1
    iConfiguration          4 RQR12.01_B0019
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower               98mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Device
      bInterfaceSubClass      1 Boot Interface Subclass
      bInterfaceProtocol      1 Keyboard
      iInterface              0 
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               1.11
          bCountryCode            0 Not supported
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength      59
         Report Descriptors: 
           ** UNAVAILABLE **
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0008  1x 8 bytes
        bInterval               8
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Device
      bInterfaceSubClass      1 Boot Interface Subclass
      bInterfaceProtocol      2 Mouse
      iInterface              0 
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               1.11
          bCountryCode            0 Not supported
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength     148
         Report Descriptors: 
           ** UNAVAILABLE **
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0008  1x 8 bytes
        bInterval               2
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Device
      bInterfaceSubClass      0 No Subclass
      bInterfaceProtocol      0 None
      iInterface              0 
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               1.11
          bCountryCode            0 Not supported
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength      98
         Report Descriptors: 
           ** UNAVAILABLE **
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0020  1x 32 bytes
        bInterval               2
Device Status:     0x0000
  (Bus Powered)

Bus 006 Device 002: ID 0a12:0001 Cambridge Silicon Radio, Ltd Bluetooth Dongle
(HCI mode)
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass          224 Wireless
  bDeviceSubClass         1 Radio Frequency
  bDeviceProtocol         1 Bluetooth
  bMaxPacketSize0        64
  idVendor           0x0a12 Cambridge Silicon Radio, Ltd
  idProduct          0x0001 Bluetooth Dongle (HCI mode)
  bcdDevice           48.39
  iManufacturer           0 
  iProduct                2 BT2.0
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength          177
    bNumInterfaces          2
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xc0
      Self Powered
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           3
      bInterfaceClass       224 Wireless
      bInterfaceSubClass      1 Radio Frequency
      bInterfaceProtocol      1 Bluetooth
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0010  1x 16 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       224 Wireless
      bInterfaceSubClass      1 Radio Frequency
      bInterfaceProtocol      1 Bluetooth
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0000  1x 0 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0000  1x 0 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       1
      bNumEndpoints           2
      bInterfaceClass       224 Wireless
      bInterfaceSubClass      1 Radio Frequency
      bInterfaceProtocol      1 Bluetooth
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0009  1x 9 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0009  1x 9 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       2
      bNumEndpoints           2
      bInterfaceClass       224 Wireless
      bInterfaceSubClass      1 Radio Frequency
      bInterfaceProtocol      1 Bluetooth
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0011  1x 17 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0011  1x 17 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       3
      bNumEndpoints           2
      bInterfaceClass       224 Wireless
      bInterfaceSubClass      1 Radio Frequency
      bInterfaceProtocol      1 Bluetooth
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0019  1x 25 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0019  1x 25 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       4
      bNumEndpoints           2
      bInterfaceClass       224 Wireless
      bInterfaceSubClass      1 Radio Frequency
      bInterfaceProtocol      1 Bluetooth
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0021  1x 33 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0021  1x 33 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       5
      bNumEndpoints           2
      bInterfaceClass       224 Wireless
      bInterfaceSubClass      1 Radio Frequency
      bInterfaceProtocol      1 Bluetooth
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0031  1x 49 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0031  1x 49 bytes
        bInterval               1
Device Status:     0x0001
  Self Powered

Bus 004 Device 004: ID 413c:2002 Dell Computer Corp. SK-8125 Keyboard
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0         8
  idVendor           0x413c Dell Computer Corp.
  idProduct          0x2002 SK-8125 Keyboard
  bcdDevice            2.00
  iManufacturer           1 Dell
  iProduct                2 Dell USB Keyboard Hub
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           59
    bNumInterfaces          2
    bConfigurationValue     1
    iConfiguration          2 Dell USB Keyboard Hub
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Device
      bInterfaceSubClass      1 Boot Interface Subclass
      bInterfaceProtocol      1 Keyboard
      iInterface              2 Dell USB Keyboard Hub
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               1.10
          bCountryCode            0 Not supported
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength      65
         Report Descriptors: 
           ** UNAVAILABLE **
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0008  1x 8 bytes
        bInterval              24
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Device
      bInterfaceSubClass      0 No Subclass
      bInterfaceProtocol      0 None
      iInterface              2 Dell USB Keyboard Hub
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               1.10
          bCountryCode            0 Not supported
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength     153
         Report Descriptors: 
           ** UNAVAILABLE **
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0004  1x 4 bytes
        bInterval              48
Device Status:     0x0000
  (Bus Powered)

[X.] Other notes, patches, fixes, workarounds:

       



