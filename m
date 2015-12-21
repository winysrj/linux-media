Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45369 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbbLURDz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Dec 2015 12:03:55 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>
Subject: [PATCH] [media] ir-lirc-codec.c: don't leak lirc->drv-rbuf
Date: Mon, 21 Dec 2015 15:03:28 -0200
Message-Id: <c77adf214ba619ad959f37fa429aa3f1045fe0cf.1450717405.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by kmemleak:

	unreferenced object 0xffff8802adae0ba0 (size 192):
	  comm "modprobe", pid 3024, jiffies 4296503588 (age 324.368s)
	  hex dump (first 32 bytes):
	    00 00 00 00 ad 4e ad de ff ff ff ff 00 00 00 00  .....N..........
	    ff ff ff ff ff ff ff ff c0 48 25 a0 ff ff ff ff  .........H%.....
	  backtrace:
	    [<ffffffff82278c8e>] kmemleak_alloc+0x4e/0xb0
	    [<ffffffff8153c08c>] kmem_cache_alloc_trace+0x1ec/0x280
	    [<ffffffffa0250f0d>] ir_lirc_register+0x8d/0x7a0 [ir_lirc_codec]
	    [<ffffffffa07372b8>] ir_raw_event_register+0x318/0x4b0 [rc_core]
	    [<ffffffffa07351ed>] rc_register_device+0xf2d/0x1450 [rc_core]
	    [<ffffffffa13c5451>] au0828_rc_register+0x7d1/0xa10 [au0828]
	    [<ffffffffa13b0dc2>] au0828_usb_probe+0x6c2/0xcf0 [au0828]
	    [<ffffffff81d7619d>] usb_probe_interface+0x45d/0x940
	    [<ffffffff81ca7004>] driver_probe_device+0x454/0xd90
	    [<ffffffff81ca7a61>] __driver_attach+0x121/0x160
	    [<ffffffff81ca141f>] bus_for_each_dev+0x11f/0x1a0
	    [<ffffffff81ca5d4d>] driver_attach+0x3d/0x50
	    [<ffffffff81ca5039>] bus_add_driver+0x4c9/0x770
	    [<ffffffff81ca944c>] driver_register+0x18c/0x3b0
	    [<ffffffff81d71e58>] usb_register_driver+0x1f8/0x440
	    [<ffffffffa13680b7>] 0xffffffffa13680b7

	0xf3d is in ir_lirc_register (drivers/media/rc/ir-lirc-codec.c:348).
	343		drv = kzalloc(sizeof(struct lirc_driver), GFP_KERNEL);
	344		if (!drv)
	345			return rc;
	346
	347		rbuf = kzalloc(sizeof(struct lirc_buffer), GFP_KERNEL);
	348		if (!rbuf)
	349			goto rbuf_alloc_failed;
	350
	351		rc = lirc_buffer_init(rbuf, sizeof(int), LIRCBUF_SIZE);
	352		if (rc)

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/rc/ir-lirc-codec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index a32659fcd266..5effc65d2947 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -415,6 +415,7 @@ static int ir_lirc_unregister(struct rc_dev *dev)
 
 	lirc_unregister_driver(lirc->drv->minor);
 	lirc_buffer_free(lirc->drv->rbuf);
+	kfree(lirc->drv->rbuf);
 	kfree(lirc->drv);
 
 	return 0;
-- 
2.5.0

