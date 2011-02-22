Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:26141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696Ab1BVCSt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Feb 2011 21:18:49 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1M2In9u028789
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 21 Feb 2011 21:18:49 -0500
Received: from pedra (vpn-224-79.phx2.redhat.com [10.3.224.79])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p1M2HksU012926
	for <linux-media@vger.kernel.org>; Mon, 21 Feb 2011 21:18:48 -0500
Date: Mon, 21 Feb 2011 23:17:38 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/4] [media] tvp5150: device detection should be done only
 once
Message-ID: <20110221231738.5c9d06f2@pedra>
In-Reply-To: <cover.1298340861.git.mchehab@redhat.com>
References: <cover.1298340861.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Having the device detection happening at reset is bad, as every time,
it will produce a message like:
	tvp5150 2-005c: tvp5150am1 detected.

This only polutes the log and for an accidental kernel hacker, it looks
like a real problem. So, move those printk's to happen during device
probe.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/tvp5150.c b/drivers/media/video/tvp5150.c
index 959d690..e927d25 100644
--- a/drivers/media/video/tvp5150.c
+++ b/drivers/media/video/tvp5150.c
@@ -737,27 +737,6 @@ static int tvp5150_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
 static int tvp5150_reset(struct v4l2_subdev *sd, u32 val)
 {
 	struct tvp5150 *decoder = to_tvp5150(sd);
-	u8 msb_id, lsb_id, msb_rom, lsb_rom;
-
-	msb_id = tvp5150_read(sd, TVP5150_MSB_DEV_ID);
-	lsb_id = tvp5150_read(sd, TVP5150_LSB_DEV_ID);
-	msb_rom = tvp5150_read(sd, TVP5150_ROM_MAJOR_VER);
-	lsb_rom = tvp5150_read(sd, TVP5150_ROM_MINOR_VER);
-
-	if (msb_rom == 4 && lsb_rom == 0) { /* Is TVP5150AM1 */
-		v4l2_info(sd, "tvp%02x%02xam1 detected.\n", msb_id, lsb_id);
-
-		/* ITU-T BT.656.4 timing */
-		tvp5150_write(sd, TVP5150_REV_SELECT, 0);
-	} else {
-		if (msb_rom == 3 || lsb_rom == 0x21) { /* Is TVP5150A */
-			v4l2_info(sd, "tvp%02x%02xa detected.\n", msb_id, lsb_id);
-		} else {
-			v4l2_info(sd, "*** unknown tvp%02x%02x chip detected.\n",
-					msb_id, lsb_id);
-			v4l2_info(sd, "*** Rom ver is %d.%d\n", msb_rom, lsb_rom);
-		}
-	}
 
 	/* Initializes TVP5150 to its default values */
 	tvp5150_write_inittab(sd, tvp5150_init_default);
@@ -977,6 +956,7 @@ static int tvp5150_probe(struct i2c_client *c,
 {
 	struct tvp5150 *core;
 	struct v4l2_subdev *sd;
+	u8 msb_id, lsb_id, msb_rom, lsb_rom;
 
 	/* Check if the adapter supports the needed features */
 	if (!i2c_check_functionality(c->adapter,
@@ -992,6 +972,26 @@ static int tvp5150_probe(struct i2c_client *c,
 	v4l_info(c, "chip found @ 0x%02x (%s)\n",
 		 c->addr << 1, c->adapter->name);
 
+	msb_id = tvp5150_read(sd, TVP5150_MSB_DEV_ID);
+	lsb_id = tvp5150_read(sd, TVP5150_LSB_DEV_ID);
+	msb_rom = tvp5150_read(sd, TVP5150_ROM_MAJOR_VER);
+	lsb_rom = tvp5150_read(sd, TVP5150_ROM_MINOR_VER);
+
+	if (msb_rom == 4 && lsb_rom == 0) { /* Is TVP5150AM1 */
+		v4l2_info(sd, "tvp%02x%02xam1 detected.\n", msb_id, lsb_id);
+
+		/* ITU-T BT.656.4 timing */
+		tvp5150_write(sd, TVP5150_REV_SELECT, 0);
+	} else {
+		if (msb_rom == 3 || lsb_rom == 0x21) { /* Is TVP5150A */
+			v4l2_info(sd, "tvp%02x%02xa detected.\n", msb_id, lsb_id);
+		} else {
+			v4l2_info(sd, "*** unknown tvp%02x%02x chip detected.\n",
+					msb_id, lsb_id);
+			v4l2_info(sd, "*** Rom ver is %d.%d\n", msb_rom, lsb_rom);
+		}
+	}
+
 	core->norm = V4L2_STD_ALL;	/* Default is autodetect */
 	core->input = TVP5150_COMPOSITE1;
 	core->enable = 1;
-- 
1.7.1


