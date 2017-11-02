Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:47112 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933364AbdKBOi3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Nov 2017 10:38:29 -0400
Received: by mail-wm0-f65.google.com with SMTP id r196so11590903wmf.2
        for <linux-media@vger.kernel.org>; Thu, 02 Nov 2017 07:38:29 -0700 (PDT)
From: Andrey Konovalov <andreyknvl@google.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Piotr Oleszczyk <piotr.oleszczyk@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sean Young <sean@mess.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        Andrey Konovalov <andreyknvl@google.com>
Subject: [PATCH] media: dib0700: fix invalid dvb_detach argument
Date: Thu,  2 Nov 2017 15:38:21 +0100
Message-Id: <7d99503f8ba3308371c4da948b53c3ac0e53586d.1509633491.git.andreyknvl@google.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

dvb_detach(arg) calls symbol_put_addr(arg), where arg should be a pointer
to a function. Right now a pointer to state->dib7000p_ops is passed to
dvb_detach(), which causes a BUG() in symbol_put_addr() as discovered by
syzkaller. Pass state->dib7000p_ops.set_wbd_ref instead.

------------[ cut here ]------------
kernel BUG at kernel/module.c:1081!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
Modules linked in:
CPU: 1 PID: 1151 Comm: kworker/1:1 Tainted: G        W
4.14.0-rc1-42251-gebb2c2437d80 #224
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
Workqueue: usb_hub_wq hub_event
task: ffff88006a336300 task.stack: ffff88006a7c8000
RIP: 0010:symbol_put_addr+0x54/0x60 kernel/module.c:1083
RSP: 0018:ffff88006a7ce210 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff880062a8d190 RCX: 0000000000000000
RDX: dffffc0000000020 RSI: ffffffff85876d60 RDI: ffff880062a8d190
RBP: ffff88006a7ce218 R08: 1ffff1000d4f9c12 R09: 1ffff1000d4f9ae4
R10: 1ffff1000d4f9bed R11: 0000000000000000 R12: ffff880062a8d180
R13: 00000000ffffffed R14: ffff880062a8d190 R15: ffff88006947c000
FS:  0000000000000000(0000) GS:ffff88006c900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f6416532000 CR3: 00000000632f5000 CR4: 00000000000006e0
Call Trace:
 stk7070p_frontend_attach+0x515/0x610
drivers/media/usb/dvb-usb/dib0700_devices.c:1013
 dvb_usb_adapter_frontend_init+0x32b/0x660
drivers/media/usb/dvb-usb/dvb-usb-dvb.c:286
 dvb_usb_adapter_init drivers/media/usb/dvb-usb/dvb-usb-init.c:86
 dvb_usb_init drivers/media/usb/dvb-usb/dvb-usb-init.c:162
 dvb_usb_device_init+0xf70/0x17f0 drivers/media/usb/dvb-usb/dvb-usb-init.c:277
 dib0700_probe+0x171/0x5a0 drivers/media/usb/dvb-usb/dib0700_core.c:886
 usb_probe_interface+0x35d/0x8e0 drivers/usb/core/driver.c:361
 really_probe drivers/base/dd.c:413
 driver_probe_device+0x610/0xa00 drivers/base/dd.c:557
 __device_attach_driver+0x230/0x290 drivers/base/dd.c:653
 bus_for_each_drv+0x161/0x210 drivers/base/bus.c:463
 __device_attach+0x26e/0x3d0 drivers/base/dd.c:710
 device_initial_probe+0x1f/0x30 drivers/base/dd.c:757
 bus_probe_device+0x1eb/0x290 drivers/base/bus.c:523
 device_add+0xd0b/0x1660 drivers/base/core.c:1835
 usb_set_configuration+0x104e/0x1870 drivers/usb/core/message.c:1932
 generic_probe+0x73/0xe0 drivers/usb/core/generic.c:174
 usb_probe_device+0xaf/0xe0 drivers/usb/core/driver.c:266
 really_probe drivers/base/dd.c:413
 driver_probe_device+0x610/0xa00 drivers/base/dd.c:557
 __device_attach_driver+0x230/0x290 drivers/base/dd.c:653
 bus_for_each_drv+0x161/0x210 drivers/base/bus.c:463
 __device_attach+0x26e/0x3d0 drivers/base/dd.c:710
 device_initial_probe+0x1f/0x30 drivers/base/dd.c:757
 bus_probe_device+0x1eb/0x290 drivers/base/bus.c:523
 device_add+0xd0b/0x1660 drivers/base/core.c:1835
 usb_new_device+0x7b8/0x1020 drivers/usb/core/hub.c:2457
 hub_port_connect drivers/usb/core/hub.c:4903
 hub_port_connect_change drivers/usb/core/hub.c:5009
 port_event drivers/usb/core/hub.c:5115
 hub_event+0x194d/0x3740 drivers/usb/core/hub.c:5195
 process_one_work+0xc7f/0x1db0 kernel/workqueue.c:2119
 worker_thread+0x221/0x1850 kernel/workqueue.c:2253
 kthread+0x3a1/0x470 kernel/kthread.c:231
 ret_from_fork+0x2a/0x40 arch/x86/entry/entry_64.S:431
Code: ff ff 48 85 c0 74 24 48 89 c7 e8 48 ea ff ff bf 01 00 00 00 e8
de 20 e3 ff 65 8b 05 b7 2f c2 7e 85 c0 75 c9 e8 f9 0b c1 ff eb c2 <0f>
0b 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 b8 00 00
RIP: symbol_put_addr+0x54/0x60 RSP: ffff88006a7ce210
---[ end trace b75b357739e7e116 ]---

Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
---
 drivers/media/usb/dvb-usb/dib0700_devices.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/dib0700_devices.c b/drivers/media/usb/dvb-usb/dib0700_devices.c
index 6020170fe99a..92098c1b78e5 100644
--- a/drivers/media/usb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/usb/dvb-usb/dib0700_devices.c
@@ -291,7 +291,7 @@ static int stk7700P2_frontend_attach(struct dvb_usb_adapter *adap)
 					     stk7700d_dib7000p_mt2266_config)
 		    != 0) {
 			err("%s: state->dib7000p_ops.i2c_enumeration failed.  Cannot continue\n", __func__);
-			dvb_detach(&state->dib7000p_ops);
+			dvb_detach(state->dib7000p_ops.set_wbd_ref);
 			return -ENODEV;
 		}
 	}
@@ -325,7 +325,7 @@ static int stk7700d_frontend_attach(struct dvb_usb_adapter *adap)
 					     stk7700d_dib7000p_mt2266_config)
 		    != 0) {
 			err("%s: state->dib7000p_ops.i2c_enumeration failed.  Cannot continue\n", __func__);
-			dvb_detach(&state->dib7000p_ops);
+			dvb_detach(state->dib7000p_ops.set_wbd_ref);
 			return -ENODEV;
 		}
 	}
@@ -478,7 +478,7 @@ static int stk7700ph_frontend_attach(struct dvb_usb_adapter *adap)
 				     &stk7700ph_dib7700_xc3028_config) != 0) {
 		err("%s: state->dib7000p_ops.i2c_enumeration failed.  Cannot continue\n",
 		    __func__);
-		dvb_detach(&state->dib7000p_ops);
+		dvb_detach(state->dib7000p_ops.set_wbd_ref);
 		return -ENODEV;
 	}
 
@@ -1010,7 +1010,7 @@ static int stk7070p_frontend_attach(struct dvb_usb_adapter *adap)
 				     &dib7070p_dib7000p_config) != 0) {
 		err("%s: state->dib7000p_ops.i2c_enumeration failed.  Cannot continue\n",
 		    __func__);
-		dvb_detach(&state->dib7000p_ops);
+		dvb_detach(state->dib7000p_ops.set_wbd_ref);
 		return -ENODEV;
 	}
 
@@ -1068,7 +1068,7 @@ static int stk7770p_frontend_attach(struct dvb_usb_adapter *adap)
 				     &dib7770p_dib7000p_config) != 0) {
 		err("%s: state->dib7000p_ops.i2c_enumeration failed.  Cannot continue\n",
 		    __func__);
-		dvb_detach(&state->dib7000p_ops);
+		dvb_detach(state->dib7000p_ops.set_wbd_ref);
 		return -ENODEV;
 	}
 
@@ -3056,7 +3056,7 @@ static int nim7090_frontend_attach(struct dvb_usb_adapter *adap)
 
 	if (state->dib7000p_ops.i2c_enumeration(&adap->dev->i2c_adap, 1, 0x10, &nim7090_dib7000p_config) != 0) {
 		err("%s: state->dib7000p_ops.i2c_enumeration failed.  Cannot continue\n", __func__);
-		dvb_detach(&state->dib7000p_ops);
+		dvb_detach(state->dib7000p_ops.set_wbd_ref);
 		return -ENODEV;
 	}
 	adap->fe_adap[0].fe = state->dib7000p_ops.init(&adap->dev->i2c_adap, 0x80, &nim7090_dib7000p_config);
@@ -3109,7 +3109,7 @@ static int tfe7090pvr_frontend0_attach(struct dvb_usb_adapter *adap)
 	/* initialize IC 0 */
 	if (state->dib7000p_ops.i2c_enumeration(&adap->dev->i2c_adap, 1, 0x20, &tfe7090pvr_dib7000p_config[0]) != 0) {
 		err("%s: state->dib7000p_ops.i2c_enumeration failed.  Cannot continue\n", __func__);
-		dvb_detach(&state->dib7000p_ops);
+		dvb_detach(state->dib7000p_ops.set_wbd_ref);
 		return -ENODEV;
 	}
 
@@ -3139,7 +3139,7 @@ static int tfe7090pvr_frontend1_attach(struct dvb_usb_adapter *adap)
 	i2c = state->dib7000p_ops.get_i2c_master(adap->dev->adapter[0].fe_adap[0].fe, DIBX000_I2C_INTERFACE_GPIO_6_7, 1);
 	if (state->dib7000p_ops.i2c_enumeration(i2c, 1, 0x10, &tfe7090pvr_dib7000p_config[1]) != 0) {
 		err("%s: state->dib7000p_ops.i2c_enumeration failed.  Cannot continue\n", __func__);
-		dvb_detach(&state->dib7000p_ops);
+		dvb_detach(state->dib7000p_ops.set_wbd_ref);
 		return -ENODEV;
 	}
 
@@ -3214,7 +3214,7 @@ static int tfe7790p_frontend_attach(struct dvb_usb_adapter *adap)
 				1, 0x10, &tfe7790p_dib7000p_config) != 0) {
 		err("%s: state->dib7000p_ops.i2c_enumeration failed.  Cannot continue\n",
 				__func__);
-		dvb_detach(&state->dib7000p_ops);
+		dvb_detach(state->dib7000p_ops.set_wbd_ref);
 		return -ENODEV;
 	}
 	adap->fe_adap[0].fe = state->dib7000p_ops.init(&adap->dev->i2c_adap,
@@ -3309,7 +3309,7 @@ static int stk7070pd_frontend_attach0(struct dvb_usb_adapter *adap)
 				     stk7070pd_dib7000p_config) != 0) {
 		err("%s: state->dib7000p_ops.i2c_enumeration failed.  Cannot continue\n",
 		    __func__);
-		dvb_detach(&state->dib7000p_ops);
+		dvb_detach(state->dib7000p_ops.set_wbd_ref);
 		return -ENODEV;
 	}
 
@@ -3384,7 +3384,7 @@ static int novatd_frontend_attach(struct dvb_usb_adapter *adap)
 					     stk7070pd_dib7000p_config) != 0) {
 			err("%s: state->dib7000p_ops.i2c_enumeration failed.  Cannot continue\n",
 			    __func__);
-			dvb_detach(&state->dib7000p_ops);
+			dvb_detach(state->dib7000p_ops.set_wbd_ref);
 			return -ENODEV;
 		}
 	}
@@ -3620,7 +3620,7 @@ static int pctv340e_frontend_attach(struct dvb_usb_adapter *adap)
 
 	if (state->dib7000p_ops.dib7000pc_detection(&adap->dev->i2c_adap) == 0) {
 		/* Demodulator not found for some reason? */
-		dvb_detach(&state->dib7000p_ops);
+		dvb_detach(state->dib7000p_ops.set_wbd_ref);
 		return -ENODEV;
 	}
 
-- 
2.15.0.403.gc27cc4dac6-goog
