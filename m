Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59065 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756479AbcJNUWn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 16:22:43 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Patrick Boettcher <patrick.boettcher@posteo.de>
Subject: [PATCH 01/57] [media] b2c2: don't break long lines
Date: Fri, 14 Oct 2016 17:19:49 -0300
Message-Id: <35a409f863851389e93f874fdb67b469164abab5.1476475771.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
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
 drivers/media/common/b2c2/flexcop-eeprom.c | 3 +--
 drivers/media/common/b2c2/flexcop-i2c.c    | 3 +--
 drivers/media/common/b2c2/flexcop-misc.c   | 9 +++------
 drivers/media/common/b2c2/flexcop.c        | 3 +--
 4 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/media/common/b2c2/flexcop-eeprom.c b/drivers/media/common/b2c2/flexcop-eeprom.c
index a25373a9bd84..844c7836c2a6 100644
--- a/drivers/media/common/b2c2/flexcop-eeprom.c
+++ b/drivers/media/common/b2c2/flexcop-eeprom.c
@@ -136,8 +136,7 @@ int flexcop_eeprom_check_mac_addr(struct flexcop_device *fc, int extended)
 
 	if ((ret = flexcop_eeprom_lrc_read(fc,0x3f8,buf,8,4)) == 0) {
 		if (extended != 0) {
-			err("TODO: extended (EUI64) MAC addresses aren't "
-				"completely supported yet");
+			err("TODO: extended (EUI64) MAC addresses aren't completely supported yet");
 			ret = -EINVAL;
 		} else
 			memcpy(fc->dvb_adapter.proposed_mac,buf,6);
diff --git a/drivers/media/common/b2c2/flexcop-i2c.c b/drivers/media/common/b2c2/flexcop-i2c.c
index e41cd23f8e45..1c1dc91ccd79 100644
--- a/drivers/media/common/b2c2/flexcop-i2c.c
+++ b/drivers/media/common/b2c2/flexcop-i2c.c
@@ -33,8 +33,7 @@ static int flexcop_i2c_operation(struct flexcop_device *fc,
 			return -EREMOTEIO;
 		}
 	}
-	deb_i2c("tried %d times i2c operation, "
-			"never finished or too many ack errors.\n", i);
+	deb_i2c("tried %d times i2c operation, never finished or too many ack errors.\n", i);
 	return -EREMOTEIO;
 }
 
diff --git a/drivers/media/common/b2c2/flexcop-misc.c b/drivers/media/common/b2c2/flexcop-misc.c
index b8eff235367d..bb0d95fe64f9 100644
--- a/drivers/media/common/b2c2/flexcop-misc.c
+++ b/drivers/media/common/b2c2/flexcop-misc.c
@@ -23,18 +23,15 @@ void flexcop_determine_revision(struct flexcop_device *fc)
 		fc->rev = FLEXCOP_III;
 		break;
 	default:
-		err("unknown FlexCop Revision: %x. Please report this to "
-				"linux-dvb@linuxtv.org.",
+		err("unknown FlexCop Revision: %x. Please report this to linux-dvb@linuxtv.org.",
 				v.misc_204.Rev_N_sig_revision_hi);
 		break;
 	}
 
 	if ((fc->has_32_hw_pid_filter = v.misc_204.Rev_N_sig_caps))
-		deb_info("this FlexCop has "
-				"the additional 32 hardware pid filter.\n");
+		deb_info("this FlexCop has the additional 32 hardware pid filter.\n");
 	else
-		deb_info("this FlexCop has "
-				"the 6 basic main hardware pid filter.\n");
+		deb_info("this FlexCop has the 6 basic main hardware pid filter.\n");
 	/* bus parts have to decide if hw pid filtering is used or not. */
 }
 
diff --git a/drivers/media/common/b2c2/flexcop.c b/drivers/media/common/b2c2/flexcop.c
index 0f5114d406f8..4338ab0043b4 100644
--- a/drivers/media/common/b2c2/flexcop.c
+++ b/drivers/media/common/b2c2/flexcop.c
@@ -46,8 +46,7 @@ int b2c2_flexcop_debug;
 EXPORT_SYMBOL_GPL(b2c2_flexcop_debug);
 module_param_named(debug, b2c2_flexcop_debug,  int, 0644);
 MODULE_PARM_DESC(debug,
-		"set debug level (1=info,2=tuner,4=i2c,8=ts,"
-		"16=sram,32=reg (|-able))."
+		"set debug level (1=info,2=tuner,4=i2c,8=ts,16=sram,32=reg (|-able))."
 		DEBSTATUS);
 #undef DEBSTATUS
 
-- 
2.7.4


