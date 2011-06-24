Return-path: <mchehab@pedra>
Received: from mrqout2a.tiscali.it ([195.130.225.14]:37832 "EHLO
	mrqout2.tiscali.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751134Ab1FXJJU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2011 05:09:20 -0400
Date: Fri, 24 Jun 2011 11:09:13 +0200
Message-ID: <4DF7665C00004E03@mta-nl-1.mail.tiscali.sys>
From: cedric.dewijs@telfort.nl
Subject: dib0700 hangs when usb receiver is unplugged while watching TV
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi All,

I have the PCTV nanostick solo. This works perfectly, but when I pull out
the stick while i'm watching TV, the driver crashes. When I replug the stick,
there's no reaction in dmesg.

To reproduce:
1)plugin the stick
1a)scan channels with scan, see also
https://wiki.archlinux.org/index.php/Digitenne#Configure_Sasc-ng
2)use tzap, cat and mplayer to watch TV
3)unplug the stick
4)watch the fireworks in /var/log/everything.log (dmesg)
See below for details.

I run the following kernel:
Linux cedric 2.6.39-ARCH #1 SMP PREEMPT Mon Jun 6 22:37:55 CEST 2011 x86_64
Intel(R) Core(TM)2 Duo CPU T5670 @ 1.80GHz GenuineIntel GNU/Linux

Best regards,
Cedric


1)plugin the stick. This yields the following messages in dmesg:
[75262.399219] usb 2-4: new high speed USB device number 4 using ehci_hcd
[75263.442900] IR NEC protocol handler initialized
[75263.585643] dib0700: loaded with support for 20 different device-types
[75263.586003] dvb-usb: found a 'Pinnacle PCTV 73e SE' in cold state, will
try to load a firmware
[75263.600941] IR RC5(x) protocol handler initialized
[75263.626257] dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.20.fw'
[75263.626871] IR RC6 protocol handler initialized
[75263.825852] IR JVC protocol handler initialized
[75263.830658] IR Sony protocol handler initialized
[75263.841488] dib0700: firmware started successfully.
[75264.121550] lirc_dev: IR Remote Control driver registered, major 250
[75264.123092] IR LIRC bridge handler initialized
[75264.342633] dvb-usb: found a 'Pinnacle PCTV 73e SE' in warm state.
[75264.342716] dvb-usb: will pass the complete MPEG2 transport stream to
the software demuxer.
[75264.342896] DVB: registering new adapter (Pinnacle PCTV 73e SE)
[75264.545372] DVB: registering adapter 0 frontend 0 (DiBcom 7000PC)...
[75264.746115] DiB0070: successfully identified
[75264.945842] Registered IR keymap rc-dib0700-rc5
[75264.946120] input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:1d.7/usb2/2-4/rc/rc0/input16
[75264.946234] rc0: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:1d.7/usb2/2-4/rc/rc0
[75264.946443] dvb-usb: schedule remote query interval to 50 msecs.
[75264.946447] dvb-usb: Pinnacle PCTV 73e SE successfully initialized and
connected.
[75264.946856] usbcore: registered new interface driver dvb_usb_dib0700
2) Use tzap, cat and mplayer to watch Nederland 1:
$ tzap -a 0 -r 'Nederland 1'
$ cat /dev/dvb/adapter0/dvr0 > test.ts
$ mplayer test.ts
3) Pull out the stick. This yields the following messages in dmesg:
[77043.886483] usb 2-4: USB disconnect, device number 4
Now the kernel does no longer respond when I replug the stick.
After 2 minutes, the following messages show up in dmesg:
[77280.502349] INFO: task khubd:361 blocked for more than 120 seconds.
[77280.502354] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
this message.
[77280.502359] khubd D 00000001015f4e25 0 361 2 0x00000000
[77280.502367] ffff880075bffbb0 0000000000000046 00000001015f4e25 000000008ff4ed27
[77280.502375] ffff880075bffac0 ffff880070bbff00 ffff880075bfffd8 ffff88007af5dbd0
[77280.502382] ffff880075bfffd8 ffff880075bfffd8 ffff880037f6dbd0 ffff88007af5dbd0
[77280.502390] Call Trace:
[77280.502403] [<ffffffff810559e0>] ? try_to_wake_up+0x380/0x380
[77280.502410] [<ffffffff813e56dd>] ? wait_for_completion+0x1d/0x20
[77280.502425] [<ffffffffa027cdd5>] dvb_unregister_frontend+0xc5/0x110 [dvb_core]
[77280.502432] [<ffffffff8107e050>] ? abort_exclusive_wait+0xb0/0xb0
[77280.502440] [<ffffffffa0188592>] dvb_usb_adapter_frontend_exit+0x22/0x40
[dvb_usb]
[77280.502446] [<ffffffffa01874ac>] dvb_usb_exit+0x4c/0xd0 [dvb_usb]
[77280.502453] [<ffffffffa0187582>] dvb_usb_device_exit+0x52/0x70 [dvb_usb]
[77280.502474] [<ffffffffa02ead12>] usb_unbind_interface+0x52/0x180 [usbcore]
[77280.502483] [<ffffffff812e0515>] __device_release_driver+0x75/0xe0
[77280.502493] [<ffffffff812e05ac>] device_release_driver+0x2c/0x40
[77280.502497] [<ffffffff812e0058>] bus_remove_device+0x78/0xb0
[77280.502501] [<ffffffff812dd91a>] device_del+0x13a/0x1d0
[77280.502508] [<ffffffffa02e8ae4>] usb_disable_device+0x74/0x130 [usbcore]
[77280.502515] [<ffffffffa02e117c>] usb_disconnect+0x8c/0x120 [usbcore]
[77280.502522] [<ffffffffa02e2f4c>] hub_thread+0x9fc/0x1220 [usbcore]
[77280.502526] [<ffffffff8107e050>] ? abort_exclusive_wait+0xb0/0xb0
[77280.502532] [<ffffffffa02e2550>] ? usb_remote_wakeup+0x40/0x40 [usbcore]
[77280.502536] [<ffffffff8107d6fc>] kthread+0x8c/0xa0
[77280.502540] [<ffffffff813eac64>] kernel_thread_helper+0x4/0x10
[77280.502544] [<ffffffff8107d670>] ? kthread_worker_fn+0x190/0x190
[77280.502547] [<ffffffff813eac60>] ? gs_change+0x13/0x13
[77400.502398] INFO: task khubd:361 blocked for more than 120 seconds.
[77400.502403] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
this message.
[77400.502407] khubd D 00000001015f4e25 0 361 2 0x00000000
[77400.502416] ffff880075bffbb0 0000000000000046 00000001015f4e25 000000008ff4ed27
[77400.502424] ffff880075bffac0 ffff880070bbff00 ffff880075bfffd8 ffff88007af5dbd0
[77400.502431] ffff880075bfffd8 ffff880075bfffd8 ffff880037f6dbd0 ffff88007af5dbd0
[77400.502438] Call Trace:
[77400.502450] [<ffffffff810559e0>] ? try_to_wake_up+0x380/0x380
[77400.502458] [<ffffffff813e56dd>] ? wait_for_completion+0x1d/0x20
[77400.502473] [<ffffffffa027cdd5>] dvb_unregister_frontend+0xc5/0x110 [dvb_core]
[77400.502480] [<ffffffff8107e050>] ? abort_exclusive_wait+0xb0/0xb0
[77400.502488] [<ffffffffa0188592>] dvb_usb_adapter_frontend_exit+0x22/0x40
[dvb_usb]
[77400.502494] [<ffffffffa01874ac>] dvb_usb_exit+0x4c/0xd0 [dvb_usb]
[77400.502501] [<ffffffffa0187582>] dvb_usb_device_exit+0x52/0x70 [dvb_usb]
[77400.502522] [<ffffffffa02ead12>] usb_unbind_interface+0x52/0x180 [usbcore]
[77400.502531] [<ffffffff812e0515>] __device_release_driver+0x75/0xe0
[77400.502537] [<ffffffff812e05ac>] device_release_driver+0x2c/0x40
[77400.502542] [<ffffffff812e0058>] bus_remove_device+0x78/0xb0
[77400.502554] [<ffffffff812dd91a>] device_del+0x13a/0x1d0
[77400.502561] [<ffffffffa02e8ae4>] usb_disable_device+0x74/0x130 [usbcore]
[77400.502568] [<ffffffffa02e117c>] usb_disconnect+0x8c/0x120 [usbcore]
[77400.502575] [<ffffffffa02e2f4c>] hub_thread+0x9fc/0x1220 [usbcore]
[77400.502579] [<ffffffff8107e050>] ? abort_exclusive_wait+0xb0/0xb0
[77400.502586] [<ffffffffa02e2550>] ? usb_remote_wakeup+0x40/0x40 [usbcore]
[77400.502589] [<ffffffff8107d6fc>] kthread+0x8c/0xa0
[77400.502593] [<ffffffff813eac64>] kernel_thread_helper+0x4/0x10
[77400.502597] [<ffffffff8107d670>] ? kthread_worker_fn+0x190/0x190
[77400.502601] [<ffffffff813eac60>] ? gs_change+0x13/0x13
[77520.502380] INFO: task khubd:361 blocked for more than 120 seconds.
[77520.502385] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
this message.
[77520.502389] khubd D 00000001015f4e25 0 361 2 0x00000000
[77520.502398] ffff880075bffbb0 0000000000000046 00000001015f4e25 000000008ff4ed27
[77520.502406] ffff880075bffac0 ffff880070bbff00 ffff880075bfffd8 ffff88007af5dbd0
[77520.502413] ffff880075bfffd8 ffff880075bfffd8 ffff880037f6dbd0 ffff88007af5dbd0
[77520.502420] Call Trace:
[77520.502433] [<ffffffff810559e0>] ? try_to_wake_up+0x380/0x380
[77520.502440] [<ffffffff813e56dd>] ? wait_for_completion+0x1d/0x20
[77520.502455] [<ffffffffa027cdd5>] dvb_unregister_frontend+0xc5/0x110 [dvb_core]
[77520.502462] [<ffffffff8107e050>] ? abort_exclusive_wait+0xb0/0xb0
[77520.502470] [<ffffffffa0188592>] dvb_usb_adapter_frontend_exit+0x22/0x40
[dvb_usb]
[77520.502477] [<ffffffffa01874ac>] dvb_usb_exit+0x4c/0xd0 [dvb_usb]
[77520.502484] [<ffffffffa0187582>] dvb_usb_device_exit+0x52/0x70 [dvb_usb]
[77520.502505] [<ffffffffa02ead12>] usb_unbind_interface+0x52/0x180 [usbcore]
[77520.502514] [<ffffffff812e0515>] __device_release_driver+0x75/0xe0
[77520.502520] [<ffffffff812e05ac>] device_release_driver+0x2c/0x40
[77520.502525] [<ffffffff812e0058>] bus_remove_device+0x78/0xb0
[77520.502531] [<ffffffff812dd91a>] device_del+0x13a/0x1d0
[77520.502545] [<ffffffffa02e8ae4>] usb_disable_device+0x74/0x130 [usbcore]
[77520.502552] [<ffffffffa02e117c>] usb_disconnect+0x8c/0x120 [usbcore]
[77520.502558] [<ffffffffa02e2f4c>] hub_thread+0x9fc/0x1220 [usbcore]
[77520.502563] [<ffffffff8107e050>] ? abort_exclusive_wait+0xb0/0xb0
[77520.502569] [<ffffffffa02e2550>] ? usb_remote_wakeup+0x40/0x40 [usbcore]
[77520.502573] [<ffffffff8107d6fc>] kthread+0x8c/0xa0
[77520.502577] [<ffffffff813eac64>] kernel_thread_helper+0x4/0x10
[77520.502581] [<ffffffff8107d670>] ? kthread_worker_fn+0x190/0x190
[77520.502584] [<ffffffff813eac60>] ? gs_change+0x13/0x13
[77640.502274] INFO: task khubd:361 blocked for more than 120 seconds.
[77640.502279] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
this message.
[77640.502284] khubd D 00000001015f4e25 0 361 2 0x00000000
[77640.502293] ffff880075bffbb0 0000000000000046 00000001015f4e25 000000008ff4ed27
[77640.502301] ffff880075bffac0 ffff880070bbff00 ffff880075bfffd8 ffff88007af5dbd0
[77640.502308] ffff880075bfffd8 ffff880075bfffd8 ffff880037f6dbd0 ffff88007af5dbd0
[77640.502316] Call Trace:
[77640.502329] [<ffffffff810559e0>] ? try_to_wake_up+0x380/0x380
[77640.502336] [<ffffffff813e56dd>] ? wait_for_completion+0x1d/0x20
[77640.502351] [<ffffffffa027cdd5>] dvb_unregister_frontend+0xc5/0x110 [dvb_core]
[77640.502358] [<ffffffff8107e050>] ? abort_exclusive_wait+0xb0/0xb0
[77640.502366] [<ffffffffa0188592>] dvb_usb_adapter_frontend_exit+0x22/0x40
[dvb_usb]
[77640.502372] [<ffffffffa01874ac>] dvb_usb_exit+0x4c/0xd0 [dvb_usb]
[77640.502379] [<ffffffffa0187582>] dvb_usb_device_exit+0x52/0x70 [dvb_usb]
[77640.502401] [<ffffffffa02ead12>] usb_unbind_interface+0x52/0x180 [usbcore]
[77640.502409] [<ffffffff812e0515>] __device_release_driver+0x75/0xe0
[77640.502415] [<ffffffff812e05ac>] device_release_driver+0x2c/0x40
[77640.502421] [<ffffffff812e0058>] bus_remove_device+0x78/0xb0
[77640.502431] [<ffffffff812dd91a>] device_del+0x13a/0x1d0
[77640.502437] [<ffffffffa02e8ae4>] usb_disable_device+0x74/0x130 [usbcore]
[77640.502443] [<ffffffffa02e117c>] usb_disconnect+0x8c/0x120 [usbcore]
[77640.502450] [<ffffffffa02e2f4c>] hub_thread+0x9fc/0x1220 [usbcore]
[77640.502454] [<ffffffff8107e050>] ? abort_exclusive_wait+0xb0/0xb0
[77640.502460] [<ffffffffa02e2550>] ? usb_remote_wakeup+0x40/0x40 [usbcore]
[77640.502463] [<ffffffff8107d6fc>] kthread+0x8c/0xa0
[77640.502466] [<ffffffff813eac64>] kernel_thread_helper+0x4/0x10
[77640.502470] [<ffffffff8107d670>] ? kthread_worker_fn+0x190/0x190
[77640.502473] [<ffffffff813eac60>] ? gs_change+0x13/0x13
[77760.502279] INFO: task khubd:361 blocked for more than 120 seconds.
[77760.502285] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
this message.
[77760.502289] khubd D 00000001015f4e25 0 361 2 0x00000000
[77760.502297] ffff880075bffbb0 0000000000000046 00000001015f4e25 000000008ff4ed27
[77760.502306] ffff880075bffac0 ffff880070bbff00 ffff880075bfffd8 ffff88007af5dbd0
[77760.502313] ffff880075bfffd8 ffff880075bfffd8 ffff880037f6dbd0 ffff88007af5dbd0
[77760.502320] Call Trace:
[77760.502333] [<ffffffff810559e0>] ? try_to_wake_up+0x380/0x380
[77760.502341] [<ffffffff813e56dd>] ? wait_for_completion+0x1d/0x20
[77760.502355] [<ffffffffa027cdd5>] dvb_unregister_frontend+0xc5/0x110 [dvb_core]
[77760.502362] [<ffffffff8107e050>] ? abort_exclusive_wait+0xb0/0xb0
[77760.502370] [<ffffffffa0188592>] dvb_usb_adapter_frontend_exit+0x22/0x40
[dvb_usb]
[77760.502377] [<ffffffffa01874ac>] dvb_usb_exit+0x4c/0xd0 [dvb_usb]
[77760.502384] [<ffffffffa0187582>] dvb_usb_device_exit+0x52/0x70 [dvb_usb]
[77760.502405] [<ffffffffa02ead12>] usb_unbind_interface+0x52/0x180 [usbcore]
[77760.502414] [<ffffffff812e0515>] __device_release_driver+0x75/0xe0
[77760.502419] [<ffffffff812e05ac>] device_release_driver+0x2c/0x40
[77760.502425] [<ffffffff812e0058>] bus_remove_device+0x78/0xb0
[77760.502430] [<ffffffff812dd91a>] device_del+0x13a/0x1d0
[77760.502441] [<ffffffffa02e8ae4>] usb_disable_device+0x74/0x130 [usbcore]
[77760.502451] [<ffffffffa02e117c>] usb_disconnect+0x8c/0x120 [usbcore]
[77760.502462] [<ffffffffa02e2f4c>] hub_thread+0x9fc/0x1220 [usbcore]
[77760.502468] [<ffffffff8107e050>] ? abort_exclusive_wait+0xb0/0xb0
[77760.502478] [<ffffffffa02e2550>] ? usb_remote_wakeup+0x40/0x40 [usbcore]
[77760.502483] [<ffffffff8107d6fc>] kthread+0x8c/0xa0
[77760.502489] [<ffffffff813eac64>] kernel_thread_helper+0x4/0x10
[77760.502495] [<ffffffff8107d670>] ? kthread_worker_fn+0x190/0x190
[77760.502500] [<ffffffff813eac60>] ? gs_change+0x13/0x13
[77880.502265] INFO: task khubd:361 blocked for more than 120 seconds.
[77880.502270] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
this message.
[77880.502275] khubd D 00000001015f4e25 0 361 2 0x00000000
[77880.502283] ffff880075bffbb0 0000000000000046 00000001015f4e25 000000008ff4ed27
[77880.502292] ffff880075bffac0 ffff880070bbff00 ffff880075bfffd8 ffff88007af5dbd0
[77880.502299] ffff880075bfffd8 ffff880075bfffd8 ffff880037f6dbd0 ffff88007af5dbd0
[77880.502306] Call Trace:
[77880.502318] [<ffffffff810559e0>] ? try_to_wake_up+0x380/0x380
[77880.502326] [<ffffffff813e56dd>] ? wait_for_completion+0x1d/0x20
[77880.502340] [<ffffffffa027cdd5>] dvb_unregister_frontend+0xc5/0x110 [dvb_core]
[77880.502348] [<ffffffff8107e050>] ? abort_exclusive_wait+0xb0/0xb0
[77880.502355] [<ffffffffa0188592>] dvb_usb_adapter_frontend_exit+0x22/0x40
[dvb_usb]
[77880.502362] [<ffffffffa01874ac>] dvb_usb_exit+0x4c/0xd0 [dvb_usb]
[77880.502369] [<ffffffffa0187582>] dvb_usb_device_exit+0x52/0x70 [dvb_usb]
[77880.502390] [<ffffffffa02ead12>] usb_unbind_interface+0x52/0x180 [usbcore]
[77880.502399] [<ffffffff812e0515>] __device_release_driver+0x75/0xe0
[77880.502405] [<ffffffff812e05ac>] device_release_driver+0x2c/0x40
[77880.502410] [<ffffffff812e0058>] bus_remove_device+0x78/0xb0
[77880.502416] [<ffffffff812dd91a>] device_del+0x13a/0x1d0
[77880.502427] [<ffffffffa02e8ae4>] usb_disable_device+0x74/0x130 [usbcore]
[77880.502437] [<ffffffffa02e117c>] usb_disconnect+0x8c/0x120 [usbcore]
[77880.502447] [<ffffffffa02e2f4c>] hub_thread+0x9fc/0x1220 [usbcore]
[77880.502454] [<ffffffff8107e050>] ? abort_exclusive_wait+0xb0/0xb0
[77880.502464] [<ffffffffa02e2550>] ? usb_remote_wakeup+0x40/0x40 [usbcore]
[77880.502469] [<ffffffff8107d6fc>] kthread+0x8c/0xa0
[77880.502475] [<ffffffff813eac64>] kernel_thread_helper+0x4/0x10
[77880.502481] [<ffffffff8107d670>] ? kthread_worker_fn+0x190/0x190
[77880.502486] [<ffffffff813eac60>] ? gs_change+0x13/0x13


       



