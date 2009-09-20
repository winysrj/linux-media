Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36334 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237AbZITOEJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Sep 2009 10:04:09 -0400
Message-ID: <4AB6364B.20700@iki.fi>
Date: Sun, 20 Sep 2009 17:03:55 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Thomas Steinreiter <thomas.steinreiter@gmx.at>
Subject: DVB USB resume from suspend crash
Content-Type: multipart/mixed;
 boundary="------------040006010107060400080300"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040006010107060400080300
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello
I have got bug report where DVB USB device crash when resume from 
suspend. I did some tests and googled a little and this seems to be 
rather widely known issue. Looks like firmware loader misses firmware 
and crash somewhere. Any idea how to fix that? Contact firmware loader 
devels?

I did simplest possible driver to test this issue:
http://linuxtv.org/hg/~anttip/suspend/

Antti
-- 
http://palosaari.fi/

--------------040006010107060400080300
Content-Type: text/plain;
 name="suspend_fails.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="suspend_fails.txt"

Sep 20 05:27:16 crope-laptop kernel: [105512.869057] usb 5-2: new high speed USB device using ehci_hcd and address 3
Sep 20 05:27:16 crope-laptop kernel: [105513.006555] usb 5-2: configuration #1 chosen from 1 choice
Sep 20 05:27:16 crope-laptop kernel: [105513.307621] check for cold ace 13a1
Sep 20 05:27:16 crope-laptop kernel: [105513.307629] dvb-usb: found a 'suspend test device' in cold state, will try to load a firmware
Sep 20 05:27:16 crope-laptop kernel: [105513.307639] usb 5-2: firmware: requesting rt2561.bin
Sep 20 05:27:16 crope-laptop kernel: [105513.503801] dvb-usb: downloading firmware from file 'rt2561.bin'
Sep 20 05:27:16 crope-laptop kernel: [105513.503824] dvb-usb: found a 'suspend test device' in warm state.
Sep 20 05:27:16 crope-laptop kernel: [105513.503841] power control: 1
Sep 20 05:27:16 crope-laptop kernel: [105513.503847] power control: 0
Sep 20 05:27:16 crope-laptop kernel: [105513.503852] dvb-usb: suspend test device successfully initialized and connected.
Sep 20 05:27:16 crope-laptop kernel: [105513.503914] usbcore: registered new interface driver dvb_usb_suspend
Sep 20 05:27:25 crope-laptop kernel: [105522.362120] usb 5-2: USB disconnect, address 3
Sep 20 05:27:25 crope-laptop kernel: [105522.362629] state before exiting everything: 0
Sep 20 05:27:25 crope-laptop kernel: [105522.362637] state should be zero now: 0
Sep 20 05:27:25 crope-laptop kernel: [105522.362645] dvb-usb: suspend test device successfully deinitialized and disconnected.
Sep 20 05:27:28 crope-laptop kernel: [105524.684101] usb 5-2: new high speed USB device using ehci_hcd and address 4
Sep 20 05:27:28 crope-laptop kernel: [105524.818403] usb 5-2: configuration #1 chosen from 1 choice
Sep 20 05:27:28 crope-laptop kernel: [105524.819062] check for cold ace 13a1
Sep 20 05:27:28 crope-laptop kernel: [105524.819070] dvb-usb: found a 'suspend test device' in cold state, will try to load a firmware
Sep 20 05:27:28 crope-laptop kernel: [105524.819081] usb 5-2: firmware: requesting rt2561.bin
Sep 20 05:27:28 crope-laptop kernel: [105524.877760] dvb-usb: downloading firmware from file 'rt2561.bin'
Sep 20 05:27:28 crope-laptop kernel: [105524.877785] dvb-usb: found a 'suspend test device' in warm state.
Sep 20 05:27:28 crope-laptop kernel: [105524.877802] power control: 1
Sep 20 05:27:28 crope-laptop kernel: [105524.877807] power control: 0
Sep 20 05:27:28 crope-laptop kernel: [105524.877811] dvb-usb: suspend test device successfully initialized and connected.
Sep 20 05:27:39 crope-laptop system: CPU Mode: "Super High Performance"
[...]
Sep 20 05:28:55 crope-laptop kernel: [105540.080879] PM: Syncing filesystems ... done.
Sep 20 05:28:55 crope-laptop kernel: [105540.088976] Freezing user space processes ... (elapsed 0.00 seconds) done.
Sep 20 05:28:55 crope-laptop kernel: [105540.090445] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
Sep 20 05:28:55 crope-laptop kernel: [105540.097128] Suspending console(s) (use no_console_suspend to debug)
Sep 20 05:28:55 crope-laptop kernel: [105540.097377] state before exiting everything: 0
Sep 20 05:28:55 crope-laptop kernel: [105540.097381] state should be zero now: 0
Sep 20 05:28:55 crope-laptop kernel: [105540.097388] dvb-usb: suspend test device successfully deinitialized and disconnected.
[...]
Sep 20 05:28:55 crope-laptop kernel: [105544.180396] check for cold ace 13a1
Sep 20 05:28:55 crope-laptop kernel: [105544.180401] dvb-usb: found a 'suspend test device' in cold state, will try to load a firmware
Sep 20 05:28:55 crope-laptop kernel: [105544.180407] usb 5-2: firmware: requesting rt2561.bin
Sep 20 05:28:55 crope-laptop kernel: [105604.180177] dvb_usb_suspend: probe of 5-2:1.0 failed with error -2
Sep 20 05:28:55 crope-laptop kernel: [105604.180510] PM: resume devices took 62.388 seconds
Sep 20 05:28:55 crope-laptop kernel: [105604.180520] ------------[ cut here ]------------
Sep 20 05:28:55 crope-laptop kernel: [105604.180525] WARNING: at /home/adamm/git/array/ubuntu-jaunty/kernel/power/main.c:176 suspend_test_finish+0x54/0x5e()
Sep 20 05:28:55 crope-laptop kernel: [105604.180530] Hardware name: 1000H
Sep 20 05:28:55 crope-laptop kernel: [105604.180533] Component: resume devices
Sep 20 05:28:55 crope-laptop kernel: [105604.180536] Modules linked in: dvb_usb_suspend dvb_usb dvb_core i915 drm i2c_algo_bit binfmt_misc ppdev bridge stp llc bnep dm_crypt lp parport asus_eee i2c_i801 snd_hda_codec_realtek snd_hda_intel snd_hda_codec joydev snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device iTCO_wdt iTCO_vendor_support serio_raw snd psmouse pcspkr intel_agp rt2860sta(C) soundcore snd_page_alloc agpgart video output eeepc_laptop ehci_hcd uhci_hcd atl1e fuse
Sep 20 05:28:55 crope-laptop kernel: [105604.180602] Pid: 8717, comm: pm-suspend Tainted: G         C 2.6.29-1-netbook #0array1
Sep 20 05:28:55 crope-laptop kernel: [105604.180607] Call Trace:
Sep 20 05:28:55 crope-laptop firmware.sh[8994]: udev firmware loader misses sysfs directory
Sep 20 05:28:55 crope-laptop kernel: [105604.180616]  [<c012a165>] warn_slowpath+0x71/0xa8
Sep 20 05:28:55 crope-laptop kernel: [105604.180625]  [<c0117190>] ? default_spin_lock_flags+0x8/0xc
Sep 20 05:28:55 crope-laptop kernel: [105604.180631]  [<c013e0f0>] ? up+0x2b/0x2f
Sep 20 05:28:55 crope-laptop kernel: [105604.180637]  [<c012a636>] ? try_acquire_console_sem+0x27/0x46
Sep 20 05:28:55 crope-laptop kernel: [105604.180645]  [<c0416300>] ? mutex_lock+0xe/0x1e
Sep 20 05:28:55 crope-laptop kernel: [105604.180651]  [<c0117190>] ? default_spin_lock_flags+0x8/0xc
Sep 20 05:28:55 crope-laptop kernel: [105604.180657]  [<c04155a5>] ? printk+0xf/0x12
Sep 20 05:28:55 crope-laptop kernel: [105604.180663]  [<c014c9fe>] suspend_test_finish+0x54/0x5e
Sep 20 05:28:55 crope-laptop kernel: [105604.180670]  [<c014caf7>] suspend_devices_and_enter+0xef/0x118
Sep 20 05:28:55 crope-laptop kernel: [105604.180676]  [<c014cc86>] enter_state+0x89/0xe4
Sep 20 05:28:55 crope-laptop kernel: [105604.180682]  [<c014cd6f>] state_store+0x8e/0xa2
Sep 20 05:28:55 crope-laptop kernel: [105604.180688]  [<c014cce1>] ? state_store+0x0/0xa2
Sep 20 05:28:55 crope-laptop kernel: [105604.180695]  [<c025b27d>] kobj_attr_store+0x1a/0x22
Sep 20 05:28:55 crope-laptop kernel: [105604.180702]  [<c01d1f1f>] sysfs_write_file+0xb0/0xdb
Sep 20 05:28:55 crope-laptop kernel: [105604.180709]  [<c01d1e6f>] ? sysfs_write_file+0x0/0xdb
Sep 20 05:28:55 crope-laptop kernel: [105604.180716]  [<c019445a>] vfs_write+0x84/0xdf
Sep 20 05:28:55 crope-laptop kernel: [105604.180722]  [<c019454e>] sys_write+0x3b/0x60
Sep 20 05:28:55 crope-laptop kernel: [105604.180729]  [<c0102f6b>] sysenter_do_call+0x12/0x2f
Sep 20 05:28:55 crope-laptop kernel: [105604.180734] ---[ end trace 22e6fd31cdb1c5cf ]---
Sep 20 05:28:55 crope-laptop kernel: [105604.180875] Restarting tasks ... done.


--------------040006010107060400080300--
