Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:50813 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281AbbESWLo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2015 18:11:44 -0400
Subject: [PATCH 3/4] rc-core: remove the LIRC "protocol"
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Date: Wed, 20 May 2015 00:03:22 +0200
Message-ID: <20150519220322.3467.51293.stgit@zeus.muc.hardeman.nu>
In-Reply-To: <20150519220101.3467.16288.stgit@zeus.muc.hardeman.nu>
References: <20150519220101.3467.16288.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The LIRC protocol was always a bad fit and if we're ever going to expose
protocol numbers in a user-space API, it'd be better to get rid of the
LIRC "protocol" first.

The sysfs API is kept backwards compatible by always listing the lirc
protocol as present and enabled.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/ir-lirc-codec.c   |    5 +----
 drivers/media/rc/keymaps/rc-lirc.c |    2 +-
 drivers/media/rc/rc-main.c         |   14 +++++++++----
 include/media/rc-map.h             |   38 +++++++++++++++++-------------------
 4 files changed, 29 insertions(+), 30 deletions(-)

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index 98893a8..a32659f 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -35,9 +35,6 @@ static int ir_lirc_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	struct lirc_codec *lirc = &dev->raw->lirc;
 	int sample;
 
-	if (!(dev->enabled_protocols & RC_BIT_LIRC))
-		return 0;
-
 	if (!dev->raw->lirc.drv || !dev->raw->lirc.drv->rbuf)
 		return -EINVAL;
 
@@ -424,7 +421,7 @@ static int ir_lirc_unregister(struct rc_dev *dev)
 }
 
 static struct ir_raw_handler lirc_handler = {
-	.protocols	= RC_BIT_LIRC,
+	.protocols	= 0,
 	.decode		= ir_lirc_decode,
 	.raw_register	= ir_lirc_register,
 	.raw_unregister	= ir_lirc_unregister,
diff --git a/drivers/media/rc/keymaps/rc-lirc.c b/drivers/media/rc/keymaps/rc-lirc.c
index fbf08fa..e172f5d 100644
--- a/drivers/media/rc/keymaps/rc-lirc.c
+++ b/drivers/media/rc/keymaps/rc-lirc.c
@@ -20,7 +20,7 @@ static struct rc_map_list lirc_map = {
 	.map = {
 		.scan    = lirc,
 		.size    = ARRAY_SIZE(lirc),
-		.rc_type = RC_TYPE_LIRC,
+		.rc_type = RC_TYPE_OTHER,
 		.name    = RC_MAP_LIRC,
 	}
 };
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 20914ed..c808165 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -800,7 +800,6 @@ static struct {
 	{ RC_BIT_SANYO,		"sanyo"		},
 	{ RC_BIT_SHARP,		"sharp"		},
 	{ RC_BIT_MCE_KBD,	"mce_kbd"	},
-	{ RC_BIT_LIRC,		"lirc"		},
 	{ RC_BIT_XMP,		"xmp"		},
 };
 
@@ -885,6 +884,9 @@ static ssize_t show_protocols(struct device *device,
 			allowed &= ~proto_names[i].type;
 	}
 
+	if (dev->driver_type == RC_DRIVER_IR_RAW)
+		tmp += sprintf(tmp, "[lirc] ");
+
 	if (tmp != buf)
 		tmp--;
 	*tmp = '\n';
@@ -936,8 +938,12 @@ static int parse_protocol_change(u64 *protocols, const char *buf)
 		}
 
 		if (i == ARRAY_SIZE(proto_names)) {
-			IR_dprintk(1, "Unknown protocol: '%s'\n", tmp);
-			return -EINVAL;
+			if (!strcasecmp(tmp, "lirc"))
+				mask = 0;
+			else {
+				IR_dprintk(1, "Unknown protocol: '%s'\n", tmp);
+				return -EINVAL;
+			}
 		}
 
 		count++;
@@ -1425,8 +1431,6 @@ int rc_register_device(struct rc_dev *dev)
 
 	if (dev->change_protocol) {
 		u64 rc_type = (1ll << rc_map->rc_type);
-		if (dev->driver_type == RC_DRIVER_IR_RAW)
-			rc_type |= RC_BIT_LIRC;
 		rc = dev->change_protocol(dev, &rc_type);
 		if (rc < 0)
 			goto out_raw;
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index e7a1514..9133363 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -14,30 +14,28 @@
 enum rc_type {
 	RC_TYPE_UNKNOWN		= 0,	/* Protocol not known */
 	RC_TYPE_OTHER		= 1,	/* Protocol known but proprietary */
-	RC_TYPE_LIRC		= 2,	/* Pass raw IR to lirc userspace */
-	RC_TYPE_RC5		= 3,	/* Philips RC5 protocol */
-	RC_TYPE_RC5X		= 4,	/* Philips RC5x protocol */
-	RC_TYPE_RC5_SZ		= 5,	/* StreamZap variant of RC5 */
-	RC_TYPE_JVC		= 6,	/* JVC protocol */
-	RC_TYPE_SONY12		= 7,	/* Sony 12 bit protocol */
-	RC_TYPE_SONY15		= 8,	/* Sony 15 bit protocol */
-	RC_TYPE_SONY20		= 9,	/* Sony 20 bit protocol */
-	RC_TYPE_NEC		= 10,	/* NEC protocol */
-	RC_TYPE_SANYO		= 11,	/* Sanyo protocol */
-	RC_TYPE_MCE_KBD		= 12,	/* RC6-ish MCE keyboard/mouse */
-	RC_TYPE_RC6_0		= 13,	/* Philips RC6-0-16 protocol */
-	RC_TYPE_RC6_6A_20	= 14,	/* Philips RC6-6A-20 protocol */
-	RC_TYPE_RC6_6A_24	= 15,	/* Philips RC6-6A-24 protocol */
-	RC_TYPE_RC6_6A_32	= 16,	/* Philips RC6-6A-32 protocol */
-	RC_TYPE_RC6_MCE		= 17,	/* MCE (Philips RC6-6A-32 subtype) protocol */
-	RC_TYPE_SHARP		= 18,	/* Sharp protocol */
-	RC_TYPE_XMP		= 19,	/* XMP protocol */
+	RC_TYPE_RC5		= 2,	/* Philips RC5 protocol */
+	RC_TYPE_RC5X		= 3,	/* Philips RC5x protocol */
+	RC_TYPE_RC5_SZ		= 4,	/* StreamZap variant of RC5 */
+	RC_TYPE_JVC		= 5,	/* JVC protocol */
+	RC_TYPE_SONY12		= 6,	/* Sony 12 bit protocol */
+	RC_TYPE_SONY15		= 7,	/* Sony 15 bit protocol */
+	RC_TYPE_SONY20		= 8,	/* Sony 20 bit protocol */
+	RC_TYPE_NEC		= 9,	/* NEC protocol */
+	RC_TYPE_SANYO		= 10,	/* Sanyo protocol */
+	RC_TYPE_MCE_KBD		= 11,	/* RC6-ish MCE keyboard/mouse */
+	RC_TYPE_RC6_0		= 12,	/* Philips RC6-0-16 protocol */
+	RC_TYPE_RC6_6A_20	= 13,	/* Philips RC6-6A-20 protocol */
+	RC_TYPE_RC6_6A_24	= 14,	/* Philips RC6-6A-24 protocol */
+	RC_TYPE_RC6_6A_32	= 15,	/* Philips RC6-6A-32 protocol */
+	RC_TYPE_RC6_MCE		= 16,	/* MCE (Philips RC6-6A-32 subtype) protocol */
+	RC_TYPE_SHARP		= 17,	/* Sharp protocol */
+	RC_TYPE_XMP		= 18,	/* XMP protocol */
 };
 
 #define RC_BIT_NONE		0
 #define RC_BIT_UNKNOWN		(1 << RC_TYPE_UNKNOWN)
 #define RC_BIT_OTHER		(1 << RC_TYPE_OTHER)
-#define RC_BIT_LIRC		(1 << RC_TYPE_LIRC)
 #define RC_BIT_RC5		(1 << RC_TYPE_RC5)
 #define RC_BIT_RC5X		(1 << RC_TYPE_RC5X)
 #define RC_BIT_RC5_SZ		(1 << RC_TYPE_RC5_SZ)
@@ -56,7 +54,7 @@ enum rc_type {
 #define RC_BIT_SHARP		(1 << RC_TYPE_SHARP)
 #define RC_BIT_XMP		(1 << RC_TYPE_XMP)
 
-#define RC_BIT_ALL	(RC_BIT_UNKNOWN | RC_BIT_OTHER | RC_BIT_LIRC | \
+#define RC_BIT_ALL	(RC_BIT_UNKNOWN | RC_BIT_OTHER | \
 			 RC_BIT_RC5 | RC_BIT_RC5X | RC_BIT_RC5_SZ | \
 			 RC_BIT_JVC | \
 			 RC_BIT_SONY12 | RC_BIT_SONY15 | RC_BIT_SONY20 | \

