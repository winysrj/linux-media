Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51395 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753905AbcJRUqQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 16:46:16 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Patrick Boettcher <patrick.boettcher@posteo.de>
Subject: [PATCH v2 01/58] b2c2: don't break long lines
Date: Tue, 18 Oct 2016 18:45:13 -0200
Message-Id: <76ebed12387e6c5d5dce358297454db4e6f71ac7.1476822924.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476822924.git.mchehab@s-opensource.com>
References: <cover.1476822924.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476822924.git.mchehab@s-opensource.com>
References: <cover.1476822924.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the 80-cols restrictions, and latter due to checkpatch
warnings, several strings were broken into multiple lines. This
is not considered a good practice anymore, as it makes harder
to grep for strings at the source code.

As we're right now fixing other drivers due to KERN_CONT, we need
to be able to identify what printk strings don't end with a "\n".
It is a way easier to detect those if we don't break long lines.

So, join those continuation lines.

The patch was generated via the script below, and manually
adjusted if needed.

</script>
use Text::Tabs;
while (<>) {
	if ($next ne "") {
		$c=$_;
		if ($c =~ /^\s+\"(.*)/) {
			$c2=$1;
			$next =~ s/\"\n$//;
			$n = expand($next);
			$funpos = index($n, '(');
			$pos = index($c2, '",');
			if ($funpos && $pos > 0) {
				$s1 = substr $c2, 0, $pos + 2;
				$s2 = ' ' x ($funpos + 1) . substr $c2, $pos + 2;
				$s2 =~ s/^\s+//;

				$s2 = ' ' x ($funpos + 1) . $s2 if ($s2 ne "");

				print unexpand("$next$s1\n");
				print unexpand("$s2\n") if ($s2 ne "");
			} else {
				print "$next$c2\n";
			}
			$next="";
			next;
		} else {
			print $next;
		}
		$next="";
	} else {
		if (m/\"$/) {
			if (!m/\\n\"$/) {
				$next=$_;
				next;
			}
		}
	}
	print $_;
}
</script>

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/common/b2c2/flexcop-eeprom.c | 3 +--
 drivers/media/common/b2c2/flexcop-i2c.c    | 4 ++--
 drivers/media/common/b2c2/flexcop-misc.c   | 9 +++------
 drivers/media/common/b2c2/flexcop.c        | 3 +--
 4 files changed, 7 insertions(+), 12 deletions(-)

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
index e41cd23f8e45..58d39a59fc09 100644
--- a/drivers/media/common/b2c2/flexcop-i2c.c
+++ b/drivers/media/common/b2c2/flexcop-i2c.c
@@ -33,8 +33,8 @@ static int flexcop_i2c_operation(struct flexcop_device *fc,
 			return -EREMOTEIO;
 		}
 	}
-	deb_i2c("tried %d times i2c operation, "
-			"never finished or too many ack errors.\n", i);
+	deb_i2c("tried %d times i2c operation, never finished or too many ack errors.\n",
+		i);
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


