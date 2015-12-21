Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50504 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbbLUM06 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Dec 2015 07:26:58 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] au8522: Avoid memory leak in case of errors
Date: Mon, 21 Dec 2015 10:26:29 -0200
Message-Id: <e14d568af71dd44f5b34bb710936354a88bafbbd.1450700786.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by kmemleak:

	unreferenced object 0xffff880321e1da40 (size 32):
	  comm "modprobe", pid 3309, jiffies 4295019569 (age 2359.636s)
	  hex dump (first 32 bytes):
	    47 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  G...............
	    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
	  backtrace:
	    [<ffffffff82278c8e>] kmemleak_alloc+0x4e/0xb0
	    [<ffffffff8153c08c>] kmem_cache_alloc_trace+0x1ec/0x280
	    [<ffffffffa13a896a>] au8522_probe+0x19a/0xa30 [au8522_decoder]
	    [<ffffffff81de0032>] i2c_device_probe+0x2b2/0x490
	    [<ffffffff81ca7004>] driver_probe_device+0x454/0xd90
	    [<ffffffff81ca7c1b>] __device_attach_driver+0x17b/0x230
	    [<ffffffff81ca15da>] bus_for_each_drv+0x11a/0x1b0
	    [<ffffffff81ca6a4d>] __device_attach+0x1cd/0x2c0
	    [<ffffffff81ca7d43>] device_initial_probe+0x13/0x20
	    [<ffffffff81ca451f>] bus_probe_device+0x1af/0x250
	    [<ffffffff81c9e0f3>] device_add+0x943/0x13b0
	    [<ffffffff81c9eb7a>] device_register+0x1a/0x20
	    [<ffffffff81de8626>] i2c_new_device+0x5d6/0x8f0
	    [<ffffffffa0d88ea4>] v4l2_i2c_new_subdev_board+0x1e4/0x250 [v4l2_common]
	    [<ffffffffa0d88fe7>] v4l2_i2c_new_subdev+0xd7/0x110 [v4l2_common]
	    [<ffffffffa13b2f76>] au0828_card_analog_fe_setup+0x2e6/0x3f0 [au0828]

Checking where the error happens:
	(gdb) list *au8522_probe+0x19a
	0x99a is in au8522_probe (drivers/media/dvb-frontends/au8522_decoder.c:761).
	756			printk(KERN_INFO "au8522_decoder attach existing instance.\n");
	757			break;
	758		}
	759
	760		demod_config = kzalloc(sizeof(struct au8522_config), GFP_KERNEL);
	761		if (demod_config == NULL) {
	762			if (instance == 1)
	763				kfree(state);
	764			return -ENOMEM;
	765		}

Shows that the error pathc is not being handled properly. The issue here is
that it should have been calling hybrid_tuner_release_state() function, by
calling au8522_release_state().

Yet, it is easier to just reorder the allocation, with makes the error path
simpler.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/dvb-frontends/au8522_decoder.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb-frontends/au8522_decoder.c b/drivers/media/dvb-frontends/au8522_decoder.c
index 28d7dc2fee34..88fddbbf8491 100644
--- a/drivers/media/dvb-frontends/au8522_decoder.c
+++ b/drivers/media/dvb-frontends/au8522_decoder.c
@@ -738,11 +738,16 @@ static int au8522_probe(struct i2c_client *client,
 		return -EIO;
 	}
 
+	demod_config = kzalloc(sizeof(struct au8522_config), GFP_KERNEL);
+	if (!demod_config)
+		return -ENOMEM;
+
 	/* allocate memory for the internal state */
 	instance = au8522_get_state(&state, client->adapter, client->addr);
 	switch (instance) {
 	case 0:
 		printk(KERN_ERR "au8522_decoder allocation failed\n");
+		kfree(demod_config);
 		return -EIO;
 	case 1:
 		/* new demod instance */
@@ -754,12 +759,6 @@ static int au8522_probe(struct i2c_client *client,
 		break;
 	}
 
-	demod_config = kzalloc(sizeof(struct au8522_config), GFP_KERNEL);
-	if (demod_config == NULL) {
-		if (instance == 1)
-			kfree(state);
-		return -ENOMEM;
-	}
 	demod_config->demod_address = 0x8e >> 1;
 
 	state->config = demod_config;
-- 
2.5.0

