Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64927 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756825Ab3DZMta (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Apr 2013 08:49:30 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: =?UTF-8?q?Jon=20Arne=20J=C3=B8rgensen?= <jonarne@jonarne.no>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/2] saa7115: add detection code for gm7113c
Date: Fri, 26 Apr 2013 09:49:17 -0300
Message-Id: <1366980557-23077-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1366980557-23077-1-git-send-email-mchehab@redhat.com>
References: <1366980557-23077-1-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds a code that (auto)detects gm7113c clones. The auto-detection
here is not perfect, as, on contrary to what it would be expected
by looking into its datasheets some devices would return, instead:

	saa7115 0-0025: chip 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 @ 0x4a is unknown

(found on a device labeled as GM7113C 1145 by Ezequiel Garcia)

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/i2c/saa7115.c     | 36 ++++++++++++++++++++++++++++++++++++
 include/media/v4l2-chip-ident.h |  2 ++
 2 files changed, 38 insertions(+)

diff --git a/drivers/media/i2c/saa7115.c b/drivers/media/i2c/saa7115.c
index 2bc8b72..24672a7 100644
--- a/drivers/media/i2c/saa7115.c
+++ b/drivers/media/i2c/saa7115.c
@@ -1640,6 +1640,36 @@ static int saa711x_detect_chip(struct i2c_client *client,
 		}
 	}
 
+	/* Check if it is a gm1113c */
+	if (!memcmp(name, "0000", 4)) {
+		chip_id = 0;
+		for (i = 0; i < 4; i++) {
+			chip_id = chip_id << 1;
+			chip_id |= (chip_ver[i] & 0x80) ? 1 : 0;
+		}
+
+		/*
+		 * Note: From the datasheet, only versions 1 and 2
+		 * exists. However, tests on a device labeled as:
+		 *	"GM7113C 1145" returned "10" on all 16 chip
+		 *	version (reg 0x00) reads. So, we need to also
+		 *	accept at least verion 0. For now, let's just
+		 *	assume that a device that returns "0000" for
+		 *	the lower nibble is a gm1113c.
+		 */
+
+		snprintf(name, size, "gm1113c");
+
+		if (!autodetect && strcmp(name, id->name))
+			return -EINVAL;
+
+		v4l_dbg(1, debug, client,
+			"It seems to be a %s chip (%*ph) @ 0x%x.\n",
+			name, 16, chip_ver, client->addr << 1);
+
+		return V4L2_IDENT_GM7113C;
+	}
+
 	/* Chip was not discovered. Return its ID and don't bind */
 	v4l_dbg(1, debug, client, "chip %*ph @ 0x%x is unknown.\n",
 		16, chip_ver, client->addr << 1);
@@ -1669,6 +1699,11 @@ static int saa711x_probe(struct i2c_client *client,
 	if (ident < 0)
 		return ident;
 
+	if (ident == V4L2_IDENT_GM7113C) {
+		v4l_warn(client, "%s not yet supported\n", name);
+		return -ENODEV;
+	}
+
 	strlcpy(client->name, name, sizeof(client->name));
 
 	state = kzalloc(sizeof(struct saa711x_state), GFP_KERNEL);
@@ -1756,6 +1791,7 @@ static const struct i2c_device_id saa711x_id[] = {
 	{ "saa7114", 0 },
 	{ "saa7115", 0 },
 	{ "saa7118", 0 },
+	{ "gm7113c", 0 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, saa711x_id);
diff --git a/include/media/v4l2-chip-ident.h b/include/media/v4l2-chip-ident.h
index c259b36..543f89c 100644
--- a/include/media/v4l2-chip-ident.h
+++ b/include/media/v4l2-chip-ident.h
@@ -52,6 +52,8 @@ enum {
 	V4L2_IDENT_SAA7115 = 105,
 	V4L2_IDENT_SAA7118 = 108,
 
+	V4L2_IDENT_GM7113C = 140,
+
 	/* module saa7127: reserved range 150-199 */
 	V4L2_IDENT_SAA7127 = 157,
 	V4L2_IDENT_SAA7129 = 159,
-- 
1.8.1.4

