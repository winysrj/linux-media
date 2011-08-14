Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm30-vm2.bullet.mail.ne1.yahoo.com ([98.138.91.130]:34742 "HELO
	nm30-vm2.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751156Ab1HNXUv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Aug 2011 19:20:51 -0400
Message-ID: <1313364050.41593.YahooMailClassic@web121710.mail.ne1.yahoo.com>
Date: Sun, 14 Aug 2011 16:20:50 -0700 (PDT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: PCTV 290e - assorted problems
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I've been experimenting with my new PCTV 290e DVB-T2 device this weekend, and have a couple of observations. For example, the device sometimes has trouble initialising itself:

usb 4-2: new high speed USB device number 4 using ehci_hcd
em28xx: New device PCTV Systems PCTV 290e @ 480 Mbps (2013:024f, interface 0, class 0)
em28xx #0: chip ID is em28174
em28xx #0: Identified as PCTV nanoStick T2 290e (card=78)
Registered IR keymap rc-pinnacle-pctv-hd
input: em28xx IR (em28xx #0) as /devices/pci0000:00/0000:00:1d.7/usb4/4-2/rc/rc1/input10
rc1: em28xx IR (em28xx #0) as /devices/pci0000:00/0000:00:1d.7/usb4/4-2/rc/rc1
em28xx #0: v4l2 driver version 0.1.2
em28xx #0: V4L2 video device registered as video1
INFO: task khubd:1100 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
khubd           D 0000000000000000     0  1100      2 0x00000000
 ffff8801a694e930 0000000000000046 ffff8801a691ffd8 ffffffff8162b020
 0000000000010280 ffff8801a691ffd8 0000000000004000 0000000000010280
 ffff8801a691ffd8 ffff8801a694e930 0000000000010280 ffff8801a691e000
Call Trace:
 [<ffffffff8128580e>] ? apic_timer_interrupt+0xe/0x20
 [<ffffffff8113ffff>] ? memscan+0x3/0x18
 [<ffffffff8128354e>] ? __mutex_lock_slowpath+0x15c/0x295
 [<ffffffff81283690>] ? mutex_lock+0x9/0x18
 [<ffffffffa06af671>] ? dvb_init+0x99/0xcc8 [em28xx_dvb]
 [<ffffffffa067d459>] ? em28xx_init_extension+0x35/0x53 [em28xx]
 [<ffffffffa067b938>] ? em28xx_usb_probe+0x827/0x8df [em28xx]
 [<ffffffffa013f5bc>] ? usb_probe_interface+0xfc/0x16f [usbcore]
 [<ffffffff811c2eec>] ? driver_probe_device+0xa8/0x138
 [<ffffffff811c2feb>] ? __driver_attach+0x6f/0x6f
 [<ffffffff811c1f19>] ? bus_for_each_drv+0x47/0x7b
 [<ffffffff811c2d8d>] ? device_attach+0x6f/0x8f
 [<ffffffff811c2714>] ? bus_probe_device+0x22/0x40
 [<ffffffff811c0f80>] ? device_add+0x3bf/0x531
 [<ffffffff811bfffa>] ? dev_set_name+0x3f/0x44
 [<ffffffff8102956d>] ? sub_preempt_count+0x83/0x94
 [<ffffffffa013e1b1>] ? usb_set_configuration+0x536/0x58f [usbcore]
 [<ffffffff8110cd99>] ? sysfs_do_create_link+0x14c/0x1a1
 [<ffffffffa01450c5>] ? generic_probe+0x48/0x77 [usbcore]
 [<ffffffff811c2eec>] ? driver_probe_device+0xa8/0x138
 [<ffffffff811c2feb>] ? __driver_attach+0x6f/0x6f
 [<ffffffff811c1f19>] ? bus_for_each_drv+0x47/0x7b
 [<ffffffff811c2d8d>] ? device_attach+0x6f/0x8f
 [<ffffffff811c2714>] ? bus_probe_device+0x22/0x40
 [<ffffffff811c0f80>] ? device_add+0x3bf/0x531
 [<ffffffff810b3818>] ? kfree+0x13/0xa2
 [<ffffffffa013811b>] ? usb_new_device+0x9d/0x111 [usbcore]
 [<ffffffffa01391cd>] ? hub_thread+0xa03/0xe89 [usbcore]
 [<ffffffff81046361>] ? wake_up_bit+0x23/0x23
 [<ffffffffa01387ca>] ? usb_remote_wakeup+0x2f/0x2f [usbcore]
 [<ffffffffa01387ca>] ? usb_remote_wakeup+0x2f/0x2f [usbcore]
 [<ffffffff81045f73>] ? kthread+0x7a/0x82
 [<ffffffff81285c54>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff81045ef9>] ? kthread_worker_fn+0x149/0x149
 [<ffffffff81285c50>] ? gs_change+0xb/0xb
INFO: task usb_id:13895 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
usb_id          D 0000000000000004     0 13895  13887 0x00000080
 ffff880195e5ef60 0000000000000082 ffff880196064e60 ffff88018e8156a0
 0000000000010280 ffff88018b2c5fd8 0000000000004000 0000000000010280
 ffff88018b2c5fd8 ffff880195e5ef60 0000000000010280 ffff88018b2c4000
Call Trace:
 [<ffffffff81088f59>] ? __alloc_pages_nodemask+0x130/0x72a
 [<ffffffff810294d8>] ? get_parent_ip+0x9/0x1b
 [<ffffffff8128354e>] ? __mutex_lock_slowpath+0x15c/0x295
 [<ffffffff81283690>] ? mutex_lock+0x9/0x18
 [<ffffffffa01416a8>] ? show_manufacturer+0x1a/0x45 [usbcore]
 [<ffffffff811c001d>] ? dev_attr_show+0x1e/0x46
 [<ffffffff810895e1>] ? __get_free_pages+0x12/0x52
 [<ffffffff8110b3b6>] ? sysfs_read_file+0xa8/0x12e
 [<ffffffff8102956d>] ? sub_preempt_count+0x83/0x94
 [<ffffffff810bb922>] ? vfs_read+0xac/0x126
 [<ffffffff810bb9e1>] ? sys_read+0x45/0x6e
 [<ffffffff81284e7b>] ? system_call_fastpath+0x16/0x1b

A more successful hotplug looks like this:

usb 4-3.1: new high speed USB device number 3 using ehci_hcd
IR NEC protocol handler initialized
IR RC5(x) protocol handler initialized
lirc_dev: IR Remote Control driver registered, major 250 
IR LIRC bridge handler initialized
em28xx: New device PCTV Systems PCTV 290e @ 480 Mbps (2013:024f, interface 0, class 0)
em28xx #0: chip ID is em28174
em28xx #0: Identified as PCTV nanoStick T2 290e (card=78)
Registered IR keymap rc-pinnacle-pctv-hd
input: em28xx IR (em28xx #0) as /devices/pci0000:00/0000:00:1d.7/usb4/4-3/4-3.1/rc/rc0/input7
rc0: em28xx IR (em28xx #0) as /devices/pci0000:00/0000:00:1d.7/usb4/4-3/4-3.1/rc/rc0
em28xx #0: v4l2 driver version 0.1.2
em28xx #0: V4L2 video device registered as video1
usbcore: registered new interface driver em28xx
em28xx driver loaded
tda18271 7-0060: creating new instance
TDA18271HD/C2 detected @ 7-0060
tda18271 7-0060: attaching existing instance
DVB: registering new adapter (em28xx #0)
DVB: registering adapter 0 frontend 0 (Sony CXD2820R (DVB-T/T2))...
DVB: registering adapter 0 frontend 1 (Sony CXD2820R (DVB-C))...
em28xx #0: Successfully loaded em28xx-dvb
Em28xx: Initialized (Em28xx dvb Extension) extension
tda18271: performing RF tracking filter calibration
tda18271: RF tracking filter calibration complete

Tuning the adapter into the HD MUX is also proving to be more difficult that I anticipated. Successful attempts are so rare that I am now forced to assume that I was merely lucky.

The following parameters *should* be enough, but clearly aren't in practice:

T 554000000 8MHz 2/3 AUTO QAM256 AUTO AUTO AUTO

Cheers,
Chris

