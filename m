Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2U9SrCJ032675
	for <video4linux-list@redhat.com>; Sun, 30 Mar 2008 05:28:53 -0400
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.174])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2U9SgtK007719
	for <video4linux-list@redhat.com>; Sun, 30 Mar 2008 05:28:42 -0400
Received: by wf-out-1314.google.com with SMTP id 28so1822380wfc.6
	for <video4linux-list@redhat.com>; Sun, 30 Mar 2008 02:28:42 -0700 (PDT)
Message-ID: <1dea8a6d0803300228j6b905cbamfe22c5e74db30700@mail.gmail.com>
Date: Sun, 30 Mar 2008 17:28:41 +0800
From: "Ben Caldwell" <benny.caldwell@gmail.com>
To: V4L <video4linux-list@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: hang with dvico dual digital 4, kernel 2.6.24.3-50
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

I'm getting a system hang after updating to the latest v4l source last week.
My machine was running Fedora 8, kernel 2.6.24.3-34 and I'm using the v4l
drivers for a dvico dual digital 4 tuner card.
Yesterday I upgraded to kernel 2.6.24.3-50 and updated to the latest v4l
sources again.  The system still hangs whenever it tries to access the tuner
card.

I've pasted two traces from /var/log/messages below if anyone can make any
sense of them.

On reboot after installing the newly compiled modules I get the following
trace:

*Mar 29 13:23:31 lounge kernel: Call Trace:
Mar 29 13:23:31 lounge kernel:  [<ffffffff88ae0b7c>]
:dvb_usb_cxusb:cxusb_dvico_xc3028_tuner_attach+0x6a/0xb7
Mar 29 13:23:31 lounge kernel:  [<ffffffff88ae114f>]
:dvb_usb_cxusb:dvico_bluebird_xc2028_callback+0x0/0x91
Mar 29 13:23:31 lounge kernel:  [<ffffffff88ad4e91>]
:dvb_usb:dvb_usb_adapter_frontend_init+0xd4/0xf5
Mar 29 13:23:31 lounge kernel:  [<ffffffff88ad48da>]
:dvb_usb:dvb_usb_device_init+0x464/0x576
Mar 29 13:23:31 lounge kernel:  [<ffffffff88ae00e3>]
:dvb_usb_cxusb:cxusb_probe+0xb1/0xf8
Mar 29 13:23:31 lounge kernel:  [<ffffffff811b91b7>]
usb_probe_interface+0xdd/0x125
Mar 29 13:23:31 lounge kernel:  [<ffffffff8119f6f6>]
driver_probe_device+0xff/0x17c
Mar 29 13:23:31 lounge kernel:  [<ffffffff8119f8bb>]
__driver_attach+0x90/0xcc
Mar 29 13:23:31 lounge kernel:  [<ffffffff8119f82b>]
__driver_attach+0x0/0xcc
Mar 29 13:23:31 lounge kernel:  [<ffffffff8119f82b>]
__driver_attach+0x0/0xcc
Mar 29 13:23:31 lounge kernel:  [<ffffffff8119ea86>]
bus_for_each_dev+0x43/0x6e
Mar 29 13:23:31 lounge kernel:  [<ffffffff8119ee06>]
bus_add_driver+0x77/0x1be
Mar 29 13:23:31 lounge kernel:  [<ffffffff811b8d44>]
usb_register_driver+0x7e/0xe1
Mar 29 13:23:31 lounge kernel:  [<ffffffff880c901b>]
:dvb_usb_cxusb:cxusb_module_init+0x1b/0x35
Mar 29 13:23:31 lounge kernel:  [<ffffffff81057a6c>]
sys_init_module+0x15da/0x171a
Mar 29 13:23:31 lounge kernel:  [<ffffffff8100be8e>] system_call+0x7e/0x83
Mar 29 13:23:31 lounge kernel:
Mar 29 13:23:31 lounge kernel:
Mar 29 13:23:31 lounge kernel: Code: 8b 90 a8 02 00 00 48 8b 73 28 31 c0 0f
b6 c9 49 c7 c0 1b 4e
Mar 29 13:23:31 lounge kernel: RIP  [<ffffffff88b528f0>]
:tuner_xc2028:xc2028_attach+0x197/0x1e1
Mar 29 13:23:31 lounge kernel:  RSP <ffff81003dcefc08>
Mar 29 13:23:31 lounge kernel: ---[ end trace 37c91073ba808476 ]---*

The system is still running at this point, but then when I start the mythtv
backend which accesses the tuner card the system hangs and I get this trace:

*Call Trace:
 [<ffffffff8126896c>] __mutex_lock_slowpath+0x1d/0x9b
 [<ffffffff81268851>] mutex_lock+0x2b/0x2f
 [<ffffffff88a951b2>] :dvb_usb_cxusb:cxusb_ctrl_msg+0x88/0x96
 [<ffffffff88b52f0d>] :tuner_xc2028:generic_set_freq+0x8d/0x156a
 [<ffffffff880db126>] :i2c_core:i2c_transfer+0x47/0x53
 [<ffffffff88ae842c>] :zl10353:zl10353_single_write+0x4d/0x75
 [<ffffffff88ae8a0f>] :zl10353:zl10353_set_parameters+0x3b9/0x45c
 [<ffffffff8103f3c0>] try_to_del_timer_sync+0x51/0x5a
 [<ffffffff88a0f84d>] :dvb_core:dvb_frontend_swzigzag_autotune+0x189/0x1b1
 [<ffffffff88a100db>] :dvb_core:dvb_frontend_swzigzag+0x1b8/0x21c
 [<ffffffff810492a4>] finish_wait+0x32/0x5d
 [<ffffffff88a10f22>] :dvb_core:dvb_frontend_thread+0x28f/0x351
 [<ffffffff81049221>] autoremove_wake_function+0x0/0x2e
 [<ffffffff88a10c93>] :dvb_core:dvb_frontend_thread+0x0/0x351
 [<ffffffff810490f2>] kthread+0x47/0x75
 [<ffffffff8100cca8>] child_rip+0xa/0x12
 [<ffffffff8101ced7>] lapic_next_event+0x0/0xa
 [<ffffffff810490ab>] kthread+0x0/0x75
 [<ffffffff8100cc9e>] child_rip+0x0/0x12*

Does anyone have any suggestions for what to try next?

- Ben  Caldwell
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
