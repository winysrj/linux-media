Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50235 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755267Ab3L1MQa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Dec 2013 07:16:30 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v3 05/24] em28xx: initialize analog I2C devices at the right place
Date: Sat, 28 Dec 2013 10:15:57 -0200
Message-Id: <1388232976-20061-6-git-send-email-mchehab@redhat.com>
In-Reply-To: <1388232976-20061-1-git-send-email-mchehab@redhat.com>
References: <1388232976-20061-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mauro Carvalho Chehab <m.chehab@samsung.com>

In order to initialize the analog tuner, v4l2 should be registere
first, or otherwise we get an oops:

[   51.783537] BUG: unable to handle kernel NULL pointer dereference at        )
[   51.784479] IP: [<ffffffff81319fbb>] __list_add+0x1b/0xc0
[   51.784479] PGD 0
[   51.784479] Oops: 0000 [#1] SMP
[   51.784479] Modules linked in: tvp5150 em28xx(+) tveeprom v4l2_common videode
[   51.784479] CPU: 0 PID: 946 Comm: systemd-udevd Not tainted 3.13.0-rc1+ #38
[   51.784479] Hardware name: PCCHIPS P17G/P17G, BIOS 080012  05/14/2008
[   51.784479] task: ffff880027482080 ti: ffff88003c9b6000 task.ti: ffff88003c90
[   51.784479] RIP: 0010:[<ffffffff81319fbb>]  [<ffffffff81319fbb>] __list_add+0
[   51.784479] RSP: 0018:ffff88003c9b7a10  EFLAGS: 00010246
[   51.784479] RAX: 0000000000000000 RBX: ffff880036d12428 RCX: 0000000000000000
[   51.784479] RDX: ffff880036ce6040 RSI: 0000000000000000 RDI: ffff880036d12428
[   51.784479] RBP: ffff88003c9b7a28 R08: 0000000000000000 R09: 0000000000000001
[   51.784479] R10: 0000000000000001 R11: 0000000000000000 R12: ffff880036ce6040
[   51.784479] R13: 0000000000000000 R14: ffff880036ce62c0 R15: ffffffffa045c176
[   51.784479] FS:  00007fba89124880(0000) GS:ffff88003f400000(0000) knlGS:00000
[   51.784479] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   51.784479] CR2: 0000000000000000 CR3: 000000003bccf000 CR4: 00000000000007f0
[   51.784479] Stack:
[   51.784479]  ffff880036d12428 ffff880036ce6038 0000000000000000 ffff88003c9b0
[   51.784479]  ffffffffa0425bbc ffff880028246800 ffff880036d12428 ffff880036ce8
[   51.784479]  ffff88003c9b7a80 ffffffffa044d733 ffff88003c9b7a90 ffff880036ce8
[   51.784479] Call Trace:
[   51.784479]  [<ffffffffa0425bbc>] v4l2_device_register_subdev+0xdc/0x120 [vi]
[   51.784479]  [<ffffffffa044d733>] v4l2_i2c_new_subdev_board+0xa3/0x100 [v4l2]
[   51.784479]  [<ffffffffa044d7fa>] v4l2_i2c_new_subdev+0x6a/0x90 [v4l2_common]
[   51.784479]  [<ffffffffa0455dcb>] em28xx_usb_probe+0xd3b/0x10a0 [em28xx]
[   51.784479]  [<ffffffff81478f74>] usb_probe_interface+0x1c4/0x2f0
[   51.784479]  [<ffffffff81400127>] driver_probe_device+0x87/0x390
[   51.784479]  [<ffffffff81400503>] __driver_attach+0x93/0xa0
[   51.784479]  [<ffffffff81400470>] ? __device_attach+0x40/0x40
[   51.784479]  [<ffffffff813fe153>] bus_for_each_dev+0x63/0xa0
[   51.784479]  [<ffffffff813ffb7e>] driver_attach+0x1e/0x20
[   51.784479]  [<ffffffff813ff760>] bus_add_driver+0x180/0x250
[   51.784479]  [<ffffffff81400b34>] driver_register+0x64/0xf0
[   51.784479]  [<ffffffff81477751>] usb_register_driver+0x81/0x160
[   51.784479]  [<ffffffffa0467000>] ? 0xffffffffa0466fff
[   51.784479]  [<ffffffffa046701e>] em28xx_usb_driver_init+0x1e/0x1000 [em28xx]
[   51.784479]  [<ffffffff8100214a>] do_one_initcall+0xfa/0x1b0
[   51.784479]  [<ffffffff81053793>] ? set_memory_nx+0x43/0x50
[   51.784479]  [<ffffffff810d9926>] load_module+0x1bc6/0x24b0
[   51.784479]  [<ffffffff810d5940>] ? store_uevent+0x40/0x40
[   51.784479]  [<ffffffff810da386>] SyS_finit_module+0x86/0xb0
[   51.784479]  [<ffffffff81666529>] system_call_fastpath+0x16/0x1b
[   51.784479] Code: ff ff 5b 41 5c 41 5d 41 5e 41 5f 5d c3 0f 1f 00 55 48 89 e
[   51.784479] RIP  [<ffffffff81319fbb>] __list_add+0x1b/0xc0
[   51.784479]  RSP <ffff88003c9b7a10>
[   51.784479] CR2: 0000000000000000
[   52.218397] ---[ end trace 0bd601544e51b8a3 ]---

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 64 ------------------------------
 drivers/media/usb/em28xx/em28xx-video.c | 70 ++++++++++++++++++++++++++++++++-
 2 files changed, 69 insertions(+), 65 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 53dc82409bc2..4fccbed539f9 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2362,24 +2362,6 @@ static struct em28xx_hash_table em28xx_i2c_hash[] = {
 };
 /* NOTE: introduce a separate hash table for devices with 16 bit eeproms */
 
-/* I2C possible address to saa7115, tvp5150, msp3400, tvaudio */
-static unsigned short saa711x_addrs[] = {
-	0x4a >> 1, 0x48 >> 1,   /* SAA7111, SAA7111A and SAA7113 */
-	0x42 >> 1, 0x40 >> 1,   /* SAA7114, SAA7115 and SAA7118 */
-	I2C_CLIENT_END };
-
-static unsigned short tvp5150_addrs[] = {
-	0xb8 >> 1,
-	0xba >> 1,
-	I2C_CLIENT_END
-};
-
-static unsigned short msp3400_addrs[] = {
-	0x80 >> 1,
-	0x88 >> 1,
-	I2C_CLIENT_END
-};
-
 int em28xx_tuner_callback(void *ptr, int component, int command, int arg)
 {
 	struct em28xx_i2c_bus *i2c_bus = ptr;
@@ -2784,54 +2766,8 @@ static void em28xx_card_setup(struct em28xx *dev)
 	/* Allow override tuner type by a module parameter */
 	if (tuner >= 0)
 		dev->tuner_type = tuner;
-
-	/* request some modules */
-	if (dev->board.has_msp34xx)
-		v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap[dev->def_i2c_bus],
-			"msp3400", 0, msp3400_addrs);
-
-	if (dev->board.decoder == EM28XX_SAA711X)
-		v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap[dev->def_i2c_bus],
-			"saa7115_auto", 0, saa711x_addrs);
-
-	if (dev->board.decoder == EM28XX_TVP5150)
-		v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap[dev->def_i2c_bus],
-			"tvp5150", 0, tvp5150_addrs);
-
-	if (dev->board.adecoder == EM28XX_TVAUDIO)
-		v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap[dev->def_i2c_bus],
-			"tvaudio", dev->board.tvaudio_addr, NULL);
-
-	if (dev->board.tuner_type != TUNER_ABSENT) {
-		int has_demod = (dev->tda9887_conf & TDA9887_PRESENT);
-
-		if (dev->board.radio.type)
-			v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap[dev->def_i2c_bus],
-				"tuner", dev->board.radio_addr, NULL);
-
-		if (has_demod)
-			v4l2_i2c_new_subdev(&dev->v4l2_dev,
-				&dev->i2c_adap[dev->def_i2c_bus], "tuner",
-				0, v4l2_i2c_tuner_addrs(ADDRS_DEMOD));
-		if (dev->tuner_addr == 0) {
-			enum v4l2_i2c_tuner_type type =
-				has_demod ? ADDRS_TV_WITH_DEMOD : ADDRS_TV;
-			struct v4l2_subdev *sd;
-
-			sd = v4l2_i2c_new_subdev(&dev->v4l2_dev,
-				&dev->i2c_adap[dev->def_i2c_bus], "tuner",
-				0, v4l2_i2c_tuner_addrs(type));
-
-			if (sd)
-				dev->tuner_addr = v4l2_i2c_subdev_addr(sd);
-		} else {
-			v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap[dev->def_i2c_bus],
-				"tuner", dev->tuner_addr, NULL);
-		}
-	}
 }
 
-
 static void request_module_async(struct work_struct *work)
 {
 	struct em28xx *dev = container_of(work,
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index b0b1a3d4534b..3baf22464c0d 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -2053,6 +2053,25 @@ static struct video_device em28xx_radio_template = {
 	.ioctl_ops 	      = &radio_ioctl_ops,
 };
 
+
+/* I2C possible address to saa7115, tvp5150, msp3400, tvaudio */
+static unsigned short saa711x_addrs[] = {
+	0x4a >> 1, 0x48 >> 1,   /* SAA7111, SAA7111A and SAA7113 */
+	0x42 >> 1, 0x40 >> 1,   /* SAA7114, SAA7115 and SAA7118 */
+	I2C_CLIENT_END };
+
+static unsigned short tvp5150_addrs[] = {
+	0xb8 >> 1,
+	0xba >> 1,
+	I2C_CLIENT_END
+};
+
+static unsigned short msp3400_addrs[] = {
+	0x80 >> 1,
+	0x88 >> 1,
+	I2C_CLIENT_END
+};
+
 /******************************** usb interface ******************************/
 
 static struct video_device *em28xx_vdev_init(struct em28xx *dev,
@@ -2220,7 +2239,56 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 	dev->vinctl  = EM28XX_VINCTRL_INTERLACED |
 		       EM28XX_VINCTRL_CCIR656_ENABLE;
 
-        /* Initialize tuner and camera */
+
+
+	/* request some modules */
+
+	if (dev->board.has_msp34xx)
+		v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap[dev->def_i2c_bus],
+			"msp3400", 0, msp3400_addrs);
+
+	if (dev->board.decoder == EM28XX_SAA711X)
+		v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap[dev->def_i2c_bus],
+			"saa7115_auto", 0, saa711x_addrs);
+
+	if (dev->board.decoder == EM28XX_TVP5150)
+		v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap[dev->def_i2c_bus],
+			"tvp5150", 0, tvp5150_addrs);
+
+	if (dev->board.adecoder == EM28XX_TVAUDIO)
+		v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap[dev->def_i2c_bus],
+			"tvaudio", dev->board.tvaudio_addr, NULL);
+
+	/* Initialize tuner and camera */
+
+	if (dev->board.tuner_type != TUNER_ABSENT) {
+		int has_demod = (dev->tda9887_conf & TDA9887_PRESENT);
+
+		if (dev->board.radio.type)
+			v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap[dev->def_i2c_bus],
+				"tuner", dev->board.radio_addr, NULL);
+
+		if (has_demod)
+			v4l2_i2c_new_subdev(&dev->v4l2_dev,
+				&dev->i2c_adap[dev->def_i2c_bus], "tuner",
+				0, v4l2_i2c_tuner_addrs(ADDRS_DEMOD));
+		if (dev->tuner_addr == 0) {
+			enum v4l2_i2c_tuner_type type =
+				has_demod ? ADDRS_TV_WITH_DEMOD : ADDRS_TV;
+			struct v4l2_subdev *sd;
+
+			sd = v4l2_i2c_new_subdev(&dev->v4l2_dev,
+				&dev->i2c_adap[dev->def_i2c_bus], "tuner",
+				0, v4l2_i2c_tuner_addrs(type));
+
+			if (sd)
+				dev->tuner_addr = v4l2_i2c_subdev_addr(sd);
+		} else {
+			v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap[dev->def_i2c_bus],
+				"tuner", dev->tuner_addr, NULL);
+		}
+	}
+
 	em28xx_tuner_setup(dev);
 	em28xx_init_camera(dev);
 
-- 
1.8.3.1

