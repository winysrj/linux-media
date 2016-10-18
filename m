Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51432 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932372AbcJRUqS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 16:46:18 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH v2 56/58] radio: don't break long lines
Date: Tue, 18 Oct 2016 18:46:08 -0200
Message-Id: <5a247d583f9b9a0433c577f8079feb97c8db3e8b.1476822925.git.mchehab@s-opensource.com>
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
 drivers/media/radio/radio-gemtek.c | 8 ++------
 drivers/media/radio/radio-wl1273.c | 3 +--
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/media/radio/radio-gemtek.c b/drivers/media/radio/radio-gemtek.c
index cff1eb144a5c..ca051ccbc3e4 100644
--- a/drivers/media/radio/radio-gemtek.c
+++ b/drivers/media/radio/radio-gemtek.c
@@ -67,14 +67,10 @@ module_param(probe, bool, 0444);
 MODULE_PARM_DESC(probe, "Enable automatic device probing.");
 
 module_param(hardmute, bool, 0644);
-MODULE_PARM_DESC(hardmute, "Enable 'hard muting' by shutting down PLL, may "
-	 "reduce static noise.");
+MODULE_PARM_DESC(hardmute, "Enable 'hard muting' by shutting down PLL, may reduce static noise.");
 
 module_param_array(io, int, NULL, 0444);
-MODULE_PARM_DESC(io, "Force I/O ports for the GemTek Radio card if automatic "
-	 "probing is disabled or fails. The most common I/O ports are: 0x20c "
-	 "0x30c, 0x24c or 0x34c (0x20c, 0x248 and 0x28c have been reported to "
-	 "work for the combined sound/radiocard).");
+MODULE_PARM_DESC(io, "Force I/O ports for the GemTek Radio card if automatic probing is disabled or fails. The most common I/O ports are: 0x20c 0x30c, 0x24c or 0x34c (0x20c, 0x248 and 0x28c have been reported to work for the combined sound/radiocard).");
 
 module_param_array(radio_nr, int, NULL, 0444);
 MODULE_PARM_DESC(radio_nr, "Radio device numbers");
diff --git a/drivers/media/radio/radio-wl1273.c b/drivers/media/radio/radio-wl1273.c
index a93f681aa9d6..9ce4b12299b4 100644
--- a/drivers/media/radio/radio-wl1273.c
+++ b/drivers/media/radio/radio-wl1273.c
@@ -2068,8 +2068,7 @@ static int wl1273_fm_radio_probe(struct platform_device *pdev)
 			goto err_request_irq;
 		}
 	} else {
-		dev_err(radio->dev, WL1273_FM_DRIVER_NAME ": Core WL1273 IRQ"
-			" not configured");
+		dev_err(radio->dev, WL1273_FM_DRIVER_NAME ": Core WL1273 IRQ not configured");
 		r = -EINVAL;
 		goto pdata_err;
 	}
-- 
2.7.4


