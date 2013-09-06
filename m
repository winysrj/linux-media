Return-path: <linux-media-owner@vger.kernel.org>
Received: from outbound-queue-2.mail.thdo.gradwell.net ([212.11.70.35]:40626
	"EHLO outbound-queue-2.mail.thdo.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751140Ab3IFJV3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Sep 2013 05:21:29 -0400
Received: from outbound-edge-2.mail.thdo.gradwell.net (bonnie.gradwell.net [212.11.70.2])
	by outbound-queue-2.mail.thdo.gradwell.net (Postfix) with ESMTP id CDEE65536F
	for <linux-media@vger.kernel.org>; Fri,  6 Sep 2013 10:16:07 +0100 (BST)
Message-ID: <ef0d52a3858465f4c4cc366a308ef458.squirrel@webmail.gradwell.com>
Date: Fri, 6 Sep 2013 10:16:04 +0100
Subject: Oops with AVerTV DVB-T Volar (mt2060)
From: "Dave Cunningham" <ml@upsilon.org.uk>
To: linux-media@vger.kernel.org
Reply-To: ml@upsilon.org.uk
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In the last few days I've installed a old AVerTV DVB-T Volar USB stick
into my mythtv backend.

The system is running debian squeeze with the 3.2 debian backport kernel.
The motherboard in the sytem uses an AMD 760G/SB710 chipset. The USB stick
is plugged into a mains powered (usb2) hub (NEC chipset).

EIT active scan is enabled in MythTv (0.24) & the tuner/signal timeouts
are set to 1000ms/3000ms in mythbackend

Since installing the stick I've started getting I2C read from the mt2060,
shortly afterwards I get an oops (see below).

I've googled a bit and I've come across similar reports from some years
ago in regards to Hauppage Nova-T sticks. Whether they are the same or not
I'm unsure, but the feedback to these issues appears to have been that a
fix was committed (presumably long before kernel 3.2)

Any suggestions here?

A bit of background, I've just picked up this dib7000 stick after a couple
of years of getting I2C errors from a pair of AF9015 sticks. I've finally
gotten sick of the issues and am trying to get a more stable system.

The powered hub is connected to the system as it seemed that the AF9015
sticks seemed more stable when plugged into this hub, rather than the
motherboard root hubs.

Also installed in the system are 2 atheros ar9280 cards (pci-e), an
RTL8139 based adsl router(pci) and a Hauppauge WinTV-HVR-4000(pci). I've
never had any problems with any of these pci/pci-e cards, only the dvb-t
usb sticks.

FYI, I'm suspicious that the USB on the amd 760/710 usb is buggy
(suspicions arise from some googling I did around this some years ago).
I'm considering changing the motherboard for one based on an AMD 970/SB950
chipset. Is this likely to be wise or just throwing more money away?



Sep  5 20:13:47 beta kernel: [118265.068117] mt2060 I2C write failed (len=2)
Sep  5 20:13:52 beta kernel: [118270.080113] mt2060 I2C write failed (len=6)
Sep  5 20:13:57 beta kernel: [118275.092086] mt2060 I2C read failed
Sep  5 20:14:02 beta kernel: [118280.112092] mt2060 I2C read failed
Sep  5 20:14:07 beta kernel: [118285.132114] mt2060 I2C read failed
Sep  5 20:14:12 beta kernel: [118290.152113] mt2060 I2C read failed
Sep  5 20:14:17 beta kernel: [118295.172076] mt2060 I2C read failed
Sep  5 20:14:22 beta kernel: [118300.192128] mt2060 I2C read failed
Sep  5 20:14:27 beta kernel: [118305.212088] mt2060 I2C read failed
Sep  5 20:14:32 beta kernel: [118310.232110] mt2060 I2C read failed
Sep  5 20:14:38 beta kernel: [118315.252090] mt2060 I2C read failed
Sep  5 20:14:43 beta kernel: [118320.272110] mt2060 I2C read failed
Sep  5 20:16:43 beta kernel: [118440.932153] mythbackend     D
ffff880037790ea0     0 15174      1 0x00000000
Sep  5 20:16:43 beta kernel: [118440.932166]  ffff880037790ea0
0000000000000086 ffff88007af66240 ffffffff8160d020
Sep  5 20:16:43 beta kernel: [118440.932178]  0000000000013740
ffff880037449fd8 ffff880037449fd8 0000000000013740
Sep  5 20:16:43 beta kernel: [118440.932188]  ffff880037790ea0
0000000000013740 0000000000013740 ffff880037448010
Sep  5 20:16:43 beta kernel: [118440.932197] Call Trace:
Sep  5 20:16:43 beta kernel: [118440.932212]  [<ffffffff8110f5b6>] ?
complete_walk+0x87/0xd4
Sep  5 20:16:43 beta kernel: [118440.932272]  [<ffffffff81369130>] ?
__mutex_lock_common+0x10c/0x172
Sep  5 20:16:43 beta kernel: [118440.932300]  [<ffffffff8136925c>] ?
mutex_lock+0x1a/0x2c
Sep  5 20:16:43 beta kernel: [118440.932323]  [<ffffffffa048b1fd>] ?
dvb_usercopy+0xb6/0x14a [dvb_core]
Sep  5 20:16:43 beta kernel: [118440.932346]  [<ffffffffa0493306>] ?
dvb_frontend_ioctl_legacy+0x981/0x981 [dvb_core]
Sep  5 20:16:43 beta kernel: [118440.932357]  [<ffffffff8110a77a>] ?
cp_new_stat+0xe6/0xfa
Sep  5 20:16:43 beta kernel: [118440.932377]  [<ffffffffa048b2b8>] ?
dvb_generic_ioctl+0x27/0x2c [dvb_core]
Sep  5 20:16:43 beta kernel: [118440.932386]  [<ffffffff8111499f>] ?
do_vfs_ioctl+0x464/0x4b1
Sep  5 20:16:43 beta kernel: [118440.932395]  [<ffffffff8110a906>] ?
sys_newstat+0x24/0x2d
Sep  5 20:16:43 beta kernel: [118440.932403]  [<ffffffff81114a37>] ?
sys_ioctl+0x4b/0x70
Sep  5 20:16:43 beta kernel: [118440.932411]  [<ffffffff8136f2d2>] ?
system_call_fastpath+0x16/0x1b

...reboot...


Sep  6 00:24:01 beta kernel: [11206.193885] usb 1-5: USB disconnect,
device number 2
Sep  6 00:24:01 beta kernel: [11206.193887] usb 1-5.7: USB disconnect,
device number 3
Sep  6 00:24:01 beta kernel: [11206.194055] mt2060 I2C write failed
Sep  6 00:27:16 beta kernel: [11400.928123] khubd           D
ffff880037b6d550     0   149      2 0x00000000
Sep  6 00:27:16 beta kernel: [11400.928135]  ffff880037b6d550
0000000000000046 0000000000000001 ffff880079e39510
Sep  6 00:27:16 beta kernel: [11400.928147]  0000000000013740
ffff880037b6ffd8 ffff880037b6ffd8 0000000000013740
Sep  6 00:27:16 beta kernel: [11400.928156]  ffff880037b6d550
0000000000013740 0000000000013740 ffff880037b6e010
Sep  6 00:27:16 beta kernel: [11400.928165] Call Trace:
Sep  6 00:27:16 beta kernel: [11400.928244]  [<ffffffffa03d289c>] ?
dvb_unregister_frontend+0xab/0xea [dvb_core]
Sep  6 00:27:16 beta kernel: [11400.928257]  [<ffffffff81063c8d>] ?
wake_up_bit+0x20/0x20
Sep  6 00:27:16 beta kernel: [11400.928278]  [<ffffffffa03c2d74>] ?
dvb_usb_adapter_frontend_exit+0x30/0x54 [dvb_usb]
Sep  6 00:27:16 beta kernel: [11400.928297]  [<ffffffffa03c234d>] ?
dvb_usb_exit+0x32/0x98 [dvb_usb]
Sep  6 00:27:16 beta kernel: [11400.928320]  [<ffffffffa03c23f5>] ?
dvb_usb_device_exit+0x42/0x56 [dvb_usb]
Sep  6 00:27:16 beta kernel: [11400.928369]  [<ffffffffa004359f>] ?
usb_unbind_interface+0x5b/0x124 [usbcore]
Sep  6 00:27:16 beta kernel: [11400.928395]  [<ffffffff81268e7c>] ?
__device_release_driver+0x7f/0xca
Sep  6 00:27:16 beta kernel: [11400.928404]  [<ffffffff81268f7b>] ?
device_release_driver+0x1d/0x28
Sep  6 00:27:16 beta kernel: [11400.928413]  [<ffffffff81268536>] ?
bus_remove_device+0xee/0x103
Sep  6 00:27:16 beta kernel: [11400.928421]  [<ffffffff81266704>] ?
device_del+0x11a/0x182
Sep  6 00:27:16 beta kernel: [11400.928453]  [<ffffffffa0040cf3>] ?
usb_disable_device+0x6b/0x175 [usbcore]
Sep  6 00:27:16 beta kernel: [11400.928483]  [<ffffffffa003c25a>] ?
usb_disconnect+0x7d/0x10b [usbcore]
Sep  6 00:27:16 beta kernel: [11400.928513]  [<ffffffffa003c248>] ?
usb_disconnect+0x6b/0x10b [usbcore]
Sep  6 00:27:16 beta kernel: [11400.928542]  [<ffffffffa003cae7>] ?
hub_thread+0x5d3/0xf81 [usbcore]
Sep  6 00:27:16 beta kernel: [11400.928552]  [<ffffffff81063c8d>] ?
wake_up_bit+0x20/0x20
Sep  6 00:27:16 beta kernel: [11400.928581]  [<ffffffffa003c514>] ?
hub_disconnect+0xdf/0xdf [usbcore]
Sep  6 00:27:16 beta kernel: [11400.928611]  [<ffffffffa003c514>] ?
hub_disconnect+0xdf/0xdf [usbcore]
Sep  6 00:27:16 beta kernel: [11400.928619]  [<ffffffff81063841>] ?
kthread+0x7a/0x82
Sep  6 00:27:16 beta kernel: [11400.928628]  [<ffffffff81371434>] ?
kernel_thread_helper+0x4/0x10
Sep  6 00:27:16 beta kernel: [11400.928637]  [<ffffffff810637c7>] ?
kthread_worker_fn+0x147/0x147
Sep  6 00:27:16 beta kernel: [11400.928645]  [<ffffffff81371430>] ?
gs_change+0x13/0x13


