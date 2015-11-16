Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:33504 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbbKPTyE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Nov 2015 14:54:04 -0500
Received: by wmec201 with SMTP id c201so194732820wme.0
        for <linux-media@vger.kernel.org>; Mon, 16 Nov 2015 11:54:02 -0800 (PST)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 2/8] media: rc: preparation for on-demand decoder module
 loading
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org,
	=?UTF-8?Q?David_H=c3=a4rdeman?= <david@hardeman.nu>
Message-ID: <564A33E8.3020301@gmail.com>
Date: Mon, 16 Nov 2015 20:52:08 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Prepare on-demand decoder module loading by adding a module_name member
to struct proto_names and introducing the related load function.

After this patch of the series the decoder modules are still loaded
unconditionally.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/rc-main.c | 72 +++++++++++++++++++++++++++++++++++++---------
 1 file changed, 59 insertions(+), 13 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index c47ed33..cede8bc 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -780,27 +780,28 @@ static struct class rc_class = {
 static struct {
 	u64	type;
 	char	*name;
+	const char	*module_name;
 } proto_names[] = {
-	{ RC_BIT_NONE,		"none"		},
-	{ RC_BIT_OTHER,		"other"		},
-	{ RC_BIT_UNKNOWN,	"unknown"	},
+	{ RC_BIT_NONE,		"none",		NULL			},
+	{ RC_BIT_OTHER,		"other",	NULL			},
+	{ RC_BIT_UNKNOWN,	"unknown",	NULL			},
 	{ RC_BIT_RC5 |
-	  RC_BIT_RC5X,		"rc-5"		},
-	{ RC_BIT_NEC,		"nec"		},
+	  RC_BIT_RC5X,		"rc-5",		"ir-rc5-decoder"	},
+	{ RC_BIT_NEC,		"nec",		"ir-nec-decoder"	},
 	{ RC_BIT_RC6_0 |
 	  RC_BIT_RC6_6A_20 |
 	  RC_BIT_RC6_6A_24 |
 	  RC_BIT_RC6_6A_32 |
-	  RC_BIT_RC6_MCE,	"rc-6"		},
-	{ RC_BIT_JVC,		"jvc"		},
+	  RC_BIT_RC6_MCE,	"rc-6",		"ir-rc6-decoder"	},
+	{ RC_BIT_JVC,		"jvc",		"ir-jvc-decoder"	},
 	{ RC_BIT_SONY12 |
 	  RC_BIT_SONY15 |
-	  RC_BIT_SONY20,	"sony"		},
-	{ RC_BIT_RC5_SZ,	"rc-5-sz"	},
-	{ RC_BIT_SANYO,		"sanyo"		},
-	{ RC_BIT_SHARP,		"sharp"		},
-	{ RC_BIT_MCE_KBD,	"mce_kbd"	},
-	{ RC_BIT_XMP,		"xmp"		},
+	  RC_BIT_SONY20,	"sony",		"ir-sony-decoder"	},
+	{ RC_BIT_RC5_SZ,	"rc-5-sz",	"ir-rc5-decoder"	},
+	{ RC_BIT_SANYO,		"sanyo",	"ir-sanyo-decoder"	},
+	{ RC_BIT_SHARP,		"sharp",	"ir-sharp-decoder"	},
+	{ RC_BIT_MCE_KBD,	"mce_kbd",	"ir-mce_kbd-decoder"	},
+	{ RC_BIT_XMP,		"xmp",		"ir-xmp-decoder"	},
 };
 
 /**
@@ -979,6 +980,48 @@ static int parse_protocol_change(u64 *protocols, const char *buf)
 	return count;
 }
 
+static void ir_raw_load_modules(u64 *protocols)
+
+{
+	u64 available;
+	int i, ret;
+
+	for (i = 0; i < ARRAY_SIZE(proto_names); i++) {
+		if (proto_names[i].type == RC_BIT_NONE ||
+		    proto_names[i].type & (RC_BIT_OTHER | RC_BIT_UNKNOWN))
+			continue;
+
+		available = ir_raw_get_allowed_protocols();
+		if (!(*protocols & proto_names[i].type & ~available))
+			continue;
+
+		if (!proto_names[i].module_name) {
+			pr_err("Can't enable IR protocol %s\n",
+			       proto_names[i].name);
+			*protocols &= ~proto_names[i].type;
+			continue;
+		}
+
+		ret = request_module("%s", proto_names[i].module_name);
+		if (ret < 0) {
+			pr_err("Couldn't load IR protocol module %s\n",
+			       proto_names[i].module_name);
+			*protocols &= ~proto_names[i].type;
+			continue;
+		}
+		msleep(20);
+		available = ir_raw_get_allowed_protocols();
+		if (!(*protocols & proto_names[i].type & ~available))
+			continue;
+
+		pr_err("Loaded IR protocol module %s, \
+		       but protocol %s still not available\n",
+		       proto_names[i].module_name,
+		       proto_names[i].name);
+		*protocols &= ~proto_names[i].type;
+	}
+}
+
 /**
  * store_protocols() - changes the current/wakeup IR protocol(s)
  * @device:	the device descriptor
@@ -1045,6 +1088,9 @@ static ssize_t store_protocols(struct device *device,
 		goto out;
 	}
 
+	if (dev->driver_type == RC_DRIVER_IR_RAW)
+		ir_raw_load_modules(&new_protocols);
+
 	if (new_protocols != old_protocols) {
 		*current_protocols = new_protocols;
 		IR_dprintk(1, "Protocols changed to 0x%llx\n",
-- 
2.6.2

