Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:42003 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756884Ab0KQTMH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Nov 2010 14:12:07 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oAHJC7hY029571
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 17 Nov 2010 14:12:07 -0500
Received: from pedra (vpn-230-120.phx2.redhat.com [10.3.230.120])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id oAHJC5xI007699
	for <linux-media@vger.kernel.org>; Wed, 17 Nov 2010 14:12:06 -0500
Date: Wed, 17 Nov 2010 17:08:28 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 05/10] [media] cx231xx: Properly name rc_map name
Message-ID: <20101117170828.203a06e3@pedra>
In-Reply-To: <cover.1290020731.git.mchehab@redhat.com>
References: <cover.1290020731.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

rc_map is confusing, as it may be understood as another thing. Properly
rename the field to indicate its usage.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/cx231xx/cx231xx-cards.c b/drivers/media/video/cx231xx/cx231xx-cards.c
index ac4bf2c..bfa3251 100644
--- a/drivers/media/video/cx231xx/cx231xx-cards.c
+++ b/drivers/media/video/cx231xx/cx231xx-cards.c
@@ -412,7 +412,7 @@ struct cx231xx_board cx231xx_boards[] = {
 		.tuner_i2c_master = 2,
 		.demod_i2c_master = 1,
 		.ir_i2c_master = 2,
-		.rc_map = RC_MAP_PIXELVIEW_NEW,
+		.rc_map_name = RC_MAP_PIXELVIEW_NEW,
 		.has_dvb = 1,
 		.demod_addr = 0x10,
 		.norm = V4L2_STD_PAL_M,
diff --git a/drivers/media/video/cx231xx/cx231xx-input.c b/drivers/media/video/cx231xx/cx231xx-input.c
index 65d951e..1d043ed 100644
--- a/drivers/media/video/cx231xx/cx231xx-input.c
+++ b/drivers/media/video/cx231xx/cx231xx-input.c
@@ -57,7 +57,7 @@ int cx231xx_ir_init(struct cx231xx *dev)
 	dev_dbg(&dev->udev->dev, "%s\n", __func__);
 
 	/* Only initialize if a rc keycode map is defined */
-	if (!cx231xx_boards[dev->model].rc_map)
+	if (!cx231xx_boards[dev->model].rc_map_name)
 		return -ENODEV;
 
 	request_module("ir-kbd-i2c");
@@ -80,7 +80,7 @@ int cx231xx_ir_init(struct cx231xx *dev)
 	 * an i2c device.
 	 */
 	dev->init_data.get_key = get_key_isdbt;
-	dev->init_data.ir_codes = cx231xx_boards[dev->model].rc_map;
+	dev->init_data.ir_codes = cx231xx_boards[dev->model].rc_map_name;
 	/* The i2c micro-controller only outputs the cmd part of NEC protocol */
 	dev->init_data.rc_dev->scanmask = 0xff;
 	dev->init_data.rc_dev->driver_name = "cx231xx";
diff --git a/drivers/media/video/cx231xx/cx231xx.h b/drivers/media/video/cx231xx/cx231xx.h
index 87a20ae..709cb87 100644
--- a/drivers/media/video/cx231xx/cx231xx.h
+++ b/drivers/media/video/cx231xx/cx231xx.h
@@ -349,7 +349,7 @@ struct cx231xx_board {
 	u8 ir_i2c_master;
 
 	/* for devices with I2C chips for IR */
-	char *rc_map;
+	char *rc_map_name;
 
 	unsigned int max_range_640_480:1;
 	unsigned int has_dvb:1;
-- 
1.7.1


