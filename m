Return-path: <linux-media-owner@vger.kernel.org>
Received: from ven69-h01-31-33-9-98.dsl.sta.abo.bbox.fr ([31.33.9.98]:46596
	"EHLO laptop-kevin.kbaradon.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755375Ab3DVUpY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Apr 2013 16:45:24 -0400
From: Kevin Baradon <kevin.baradon@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Kevin Baradon <kevin.baradon@gmail.com>
Subject: [PATCH 3/4] media/rc/imon.c: do not try to register 2nd intf if 1st intf failed
Date: Mon, 22 Apr 2013 22:09:45 +0200
Message-Id: <1366661386-6720-4-git-send-email-kevin.baradon@gmail.com>
In-Reply-To: <1366661386-6720-1-git-send-email-kevin.baradon@gmail.com>
References: <1366661386-6720-1-git-send-email-kevin.baradon@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This bug could be triggered if 1st interface configuration fails:

Apr  8 18:20:30 homeserver kernel: usb 5-1: new low-speed USB device number 2 using ohci_hcd
Apr  8 18:20:30 homeserver kernel: input: iMON Panel, Knob and Mouse(15c2:0036) as /devices/pci0000:00/0000:00:13.0/usb5/5-1/5-1:1.0/input/input2
Apr  8 18:20:30 homeserver kernel: Registered IR keymap rc-imon-pad
Apr  8 18:20:30 homeserver kernel: input: iMON Remote (15c2:0036) as /devices/pci0000:00/0000:00:13.0/usb5/5-1/5-1:1.0/rc/rc0/input3
Apr  8 18:20:30 homeserver kernel: rc0: iMON Remote (15c2:0036) as /devices/pci0000:00/0000:00:13.0/usb5/5-1/5-1:1.0/rc/rc0
Apr  8 18:20:30 homeserver kernel: imon:send_packet: packet tx failed (-32)
Apr  8 18:20:30 homeserver kernel: imon 5-1:1.0: remote input dev register failed
Apr  8 18:20:30 homeserver kernel: imon 5-1:1.0: imon_init_intf0: rc device setup failed
Apr  8 18:20:30 homeserver kernel: imon 5-1:1.0: unable to initialize intf0, err 0
Apr  8 18:20:30 homeserver kernel: imon:imon_probe: failed to initialize context!
Apr  8 18:20:30 homeserver kernel: imon 5-1:1.0: unable to register, err -19
Apr  8 18:20:30 homeserver kernel: BUG: unable to handle kernel NULL pointer dereference at 00000014
Apr  8 18:20:30 homeserver kernel: IP: [<c05c4e4c>] mutex_lock+0xc/0x30
Apr  8 18:20:30 homeserver kernel: *pde = 00000000
Apr  8 18:20:30 homeserver kernel: Oops: 0002 [#1] PREEMPT SMP
Apr  8 18:20:30 homeserver kernel: Modules linked in:
Apr  8 18:20:30 homeserver kernel: Pid: 367, comm: khubd Not tainted 3.8.3-htpc-00002-g79b1403 #23 Unknow Unknow/RS780-SB700
Apr  8 18:20:30 homeserver kernel: EIP: 0060:[<c05c4e4c>] EFLAGS: 00010296 CPU: 1
Apr  8 18:20:30 homeserver kernel: EIP is at mutex_lock+0xc/0x30
Apr  8 18:20:30 homeserver kernel: EAX: 00000014 EBX: 00000014 ECX: 00000000 EDX: f590e480
Apr  8 18:20:30 homeserver kernel: ESI: f5deac00 EDI: f590e480 EBP: f5f3ee00 ESP: f6577c28
Apr  8 18:20:30 homeserver kernel: DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Apr  8 18:20:30 homeserver kernel: CR0: 8005003b CR2: 00000014 CR3: 0081b000 CR4: 000007d0
Apr  8 18:20:30 homeserver kernel: DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
Apr  8 18:20:30 homeserver kernel: DR6: ffff0ff0 DR7: 00000400
Apr  8 18:20:30 homeserver kernel: Process khubd (pid: 367, ti=f6576000 task=f649ea00 task.ti=f6576000)
Apr  8 18:20:30 homeserver kernel: Stack:
Apr  8 18:20:30 homeserver kernel: 00000000 f5deac00 c0448de4 f59714c0 f5deac64 c03b8ad2 f6577c90 00000004
Apr  8 18:20:30 homeserver kernel: f649ea00 c0205142 f6779820 a1ff7f08 f5deac00 00000001 f5f3ee1c 00000014
Apr  8 18:20:30 homeserver kernel: 00000004 00000202 15c20036 c07a03e8 fffee0ca f6795c00 f5f3ee1c f5deac00
Apr  8 18:20:30 homeserver kernel: Call Trace:
Apr  8 18:20:30 homeserver kernel: [<c0448de4>] ? imon_probe+0x494/0xde0
Apr  8 18:20:30 homeserver kernel: [<c03b8ad2>] ? rpm_resume+0xb2/0x4f0
Apr  8 18:20:30 homeserver kernel: [<c0205142>] ? sysfs_addrm_finish+0x12/0x90
Apr  8 18:20:30 homeserver kernel: [<c04170e9>] ? usb_probe_interface+0x169/0x240
Apr  8 18:20:30 homeserver kernel: [<c03b0ca0>] ? __driver_attach+0x80/0x80
Apr  8 18:20:30 homeserver kernel: [<c03b0ca0>] ? __driver_attach+0x80/0x80
Apr  8 18:20:30 homeserver kernel: [<c03b0a94>] ? driver_probe_device+0x54/0x1e0
Apr  8 18:20:30 homeserver kernel: [<c0416abe>] ? usb_device_match+0x4e/0x80
Apr  8 18:20:30 homeserver kernel: [<c03af314>] ? bus_for_each_drv+0x34/0x70
Apr  8 18:20:30 homeserver kernel: [<c03b0a0b>] ? device_attach+0x7b/0x90
Apr  8 18:20:30 homeserver kernel: [<c03b0ca0>] ? __driver_attach+0x80/0x80
Apr  8 18:20:30 homeserver kernel: [<c03b00ff>] ? bus_probe_device+0x5f/0x80
Apr  8 18:20:30 homeserver kernel: [<c03aeab7>] ? device_add+0x567/0x610
Apr  8 18:20:30 homeserver kernel: [<c041a7bc>] ? usb_create_ep_devs+0x7c/0xd0
Apr  8 18:20:30 homeserver kernel: [<c0413837>] ? create_intf_ep_devs+0x47/0x70
Apr  8 18:20:30 homeserver kernel: [<c04156c4>] ? usb_set_configuration+0x454/0x750
Apr  8 18:20:30 homeserver kernel: [<c03b0ca0>] ? __driver_attach+0x80/0x80
Apr  8 18:20:30 homeserver kernel: [<c041de8a>] ? generic_probe+0x2a/0x80
Apr  8 18:20:30 homeserver kernel: [<c03b0ca0>] ? __driver_attach+0x80/0x80
Apr  8 18:20:30 homeserver kernel: [<c0205aff>] ? sysfs_create_link+0xf/0x20
Apr  8 18:20:30 homeserver kernel: [<c04171db>] ? usb_probe_device+0x1b/0x40
Apr  8 18:20:30 homeserver kernel: [<c03b0a94>] ? driver_probe_device+0x54/0x1e0
Apr  8 18:20:30 homeserver kernel: [<c03af314>] ? bus_for_each_drv+0x34/0x70
Apr  8 18:20:30 homeserver kernel: [<c03b0a0b>] ? device_attach+0x7b/0x90
Apr  8 18:20:30 homeserver kernel: [<c03b0ca0>] ? __driver_attach+0x80/0x80
Apr  8 18:20:30 homeserver kernel: [<c03b00ff>] ? bus_probe_device+0x5f/0x80
Apr  8 18:20:30 homeserver kernel: [<c03aeab7>] ? device_add+0x567/0x610
Apr  8 18:20:30 homeserver kernel: [<c040e6df>] ? usb_new_device+0x12f/0x1e0
Apr  8 18:20:30 homeserver kernel: [<c040f4d8>] ? hub_thread+0x458/0x1230
Apr  8 18:20:30 homeserver kernel: [<c015554f>] ? dequeue_task_fair+0x9f/0xc0
Apr  8 18:20:30 homeserver kernel: [<c0131312>] ? release_task+0x1d2/0x330
Apr  8 18:20:30 homeserver kernel: [<c01477b0>] ? abort_exclusive_wait+0x90/0x90
Apr  8 18:20:30 homeserver kernel: [<c040f080>] ? usb_remote_wakeup+0x40/0x40
Apr  8 18:20:30 homeserver kernel: [<c0146ed2>] ? kthread+0x92/0xa0
Apr  8 18:20:30 homeserver kernel: [<c05c7877>] ? ret_from_kernel_thread+0x1b/0x28
Apr  8 18:20:30 homeserver kernel: [<c0146e40>] ? kthread_freezable_should_stop+0x50/0x50
Apr  8 18:20:30 homeserver kernel: Code: 89 04 24 89 f0 e8 05 ff ff ff 8b 5c 24 24 8b 74 24 28 8b 7c 24 2c 8b 6c 24 30 83 c4 34 c3 00 83 ec 08 89 1c 24 89 74 24 04 89 c3 <f0> ff 08 79 05 e8 ca 03 00 00 64 a1 70 d6 80 c0 8b 74 24 04 89
Apr  8 18:20:30 homeserver kernel: EIP: [<c05c4e4c>] mutex_lock+0xc/0x30 SS:ESP 0068:f6577c28
Apr  8 18:20:30 homeserver kernel: CR2: 0000000000000014
Apr  8 18:20:30 homeserver kernel: ---[ end trace df134132c967205c ]---

Signed-off-by: Kevin Baradon <kevin.baradon@gmail.com>
---
 drivers/media/rc/imon.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index 624fd33..3af7bb6 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -2324,7 +2324,14 @@ static int imon_probe(struct usb_interface *interface,
 		}
 
 	} else {
-	/* this is the secondary interface on the device */
+		/* this is the secondary interface on the device */
+
+		/* fail early if first intf failed to register */
+		if (!first_if_ctx) {
+			ret = -ENODEV;
+			goto fail;
+		}
+
 		ictx = imon_init_intf1(interface, first_if_ctx);
 		if (!ictx) {
 			pr_err("failed to attach to context!\n");
-- 
1.7.10.4

