Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48603 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754187AbcJNRrE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 13:47:04 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 02/25] [media] tuner-xc2028: don't break long lines
Date: Fri, 14 Oct 2016 14:45:40 -0300
Message-Id: <9bf38507a2f5d397ef6b8d67f9e405170d6999c9.1476466574.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476466574.git.mchehab@s-opensource.com>
References: <cover.1476466574.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476466574.git.mchehab@s-opensource.com>
References: <cover.1476466574.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the 80-cols checkpatch warnings, several strings
were broken into multiple lines. This is not considered
a good practice anymore, as it makes harder to grep for
strings at the source code. So, join those continuation
lines.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/tuners/tuner-xc2028.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/media/tuners/tuner-xc2028.c b/drivers/media/tuners/tuner-xc2028.c
index 55f6c858b9c3..e07c5fb59cc6 100644
--- a/drivers/media/tuners/tuner-xc2028.c
+++ b/drivers/media/tuners/tuner-xc2028.c
@@ -56,8 +56,7 @@ MODULE_PARM_DESC(no_poweroff, "0 (default) powers device off when not used.\n"
 static char audio_std[8];
 module_param_string(audio_std, audio_std, sizeof(audio_std), 0);
 MODULE_PARM_DESC(audio_std,
-	"Audio standard. XC3028 audio decoder explicitly "
-	"needs to know what audio\n"
+	"Audio standard. XC3028 audio decoder explicitly needs to know what audio\n"
 	"standard is needed for some video standards with audio A2 or NICAM.\n"
 	"The valid values are:\n"
 	"A2\n"
@@ -69,8 +68,8 @@ MODULE_PARM_DESC(audio_std,
 
 static char firmware_name[30];
 module_param_string(firmware_name, firmware_name, sizeof(firmware_name), 0);
-MODULE_PARM_DESC(firmware_name, "Firmware file name. Allows overriding the "
-				"default firmware name\n");
+MODULE_PARM_DESC(firmware_name,
+		 "Firmware file name. Allows overriding the default firmware name\n");
 
 static LIST_HEAD(hybrid_tuner_instance_list);
 static DEFINE_MUTEX(xc2028_list_mutex);
@@ -346,8 +345,7 @@ static int load_all_firmwares(struct dvb_frontend *fe,
 
 		n++;
 		if (n >= n_array) {
-			tuner_err("More firmware images in file than "
-				  "were expected!\n");
+			tuner_err("More firmware images in file than were expected!\n");
 			goto corrupt;
 		}
 
@@ -496,8 +494,8 @@ static int seek_firmware(struct dvb_frontend *fe, unsigned int type,
 	}
 
 	if (best_nr_matches > 0) {
-		tuner_dbg("Selecting best matching firmware (%d bits) for "
-			  "type=", best_nr_matches);
+		tuner_dbg("Selecting best matching firmware (%d bits) for type=",
+			  best_nr_matches);
 		dump_firm_type(type);
 		printk(KERN_CONT
 		       "(%x), id %016llx:\n", type, (unsigned long long)*id);
@@ -840,8 +838,7 @@ static int check_firmware(struct dvb_frontend *fe, unsigned int type,
 		goto fail;
 	}
 
-	tuner_dbg("Device is Xceive %d version %d.%d, "
-		  "firmware version %d.%d\n",
+	tuner_dbg("Device is Xceive %d version %d.%d, firmware version %d.%d\n",
 		  hwmodel, (version & 0xf000) >> 12, (version & 0xf00) >> 8,
 		  (version & 0xf0) >> 4, version & 0xf);
 
@@ -855,8 +852,7 @@ static int check_firmware(struct dvb_frontend *fe, unsigned int type,
 			tuner_err("Incorrect readback of firmware version.\n");
 			goto fail;
 		} else {
-			tuner_err("Returned an incorrect version. However, "
-				  "read is not reliable enough. Ignoring it.\n");
+			tuner_err("Returned an incorrect version. However, read is not reliable enough. Ignoring it.\n");
 			hwmodel = 3028;
 		}
 	}
@@ -867,8 +863,7 @@ static int check_firmware(struct dvb_frontend *fe, unsigned int type,
 		priv->hwvers  = version & 0xff00;
 	} else if (priv->hwmodel == 0 || priv->hwmodel != hwmodel ||
 		   priv->hwvers != (version & 0xff00)) {
-		tuner_err("Read invalid device hardware information - tuner "
-			  "hung?\n");
+		tuner_err("Read invalid device hardware information - tuner hung?\n");
 		goto fail;
 	}
 
-- 
2.7.4


