Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51498 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934366AbcJRUqU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 16:46:20 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Eduardo Valentin <edubezval@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH v2 29/58] si4713: don't break long lines
Date: Tue, 18 Oct 2016 18:45:41 -0200
Message-Id: <aebdc05a8e78ca12328245ad7f022659e7f53ea9.1476822925.git.mchehab@s-opensource.com>
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
 drivers/media/radio/si4713/si4713.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/media/radio/si4713/si4713.c b/drivers/media/radio/si4713/si4713.c
index 0b04b56571da..bc2a8b5442ae 100644
--- a/drivers/media/radio/si4713/si4713.c
+++ b/drivers/media/radio/si4713/si4713.c
@@ -716,9 +716,9 @@ static int si4713_tx_tune_status(struct si4713_device *sdev, u8 intack,
 		*power = val[5];
 		*antcap = val[6];
 		*noise = val[7];
-		v4l2_dbg(1, debug, &sdev->sd, "%s: response: %d x 10 kHz "
-				"(power %d, antcap %d, rnl %d)\n", __func__,
-				*frequency, *power, *antcap, *noise);
+		v4l2_dbg(1, debug, &sdev->sd,
+			 "%s: response: %d x 10 kHz (power %d, antcap %d, rnl %d)\n",
+			 __func__, *frequency, *power, *antcap, *noise);
 	}
 
 	return err;
@@ -758,10 +758,9 @@ static int si4713_tx_rds_buff(struct si4713_device *sdev, u8 mode, u16 rdsb,
 		v4l2_dbg(1, debug, &sdev->sd,
 			"%s: status=0x%02x\n", __func__, val[0]);
 		*cbleft = (s8)val[2] - val[3];
-		v4l2_dbg(1, debug, &sdev->sd, "%s: response: interrupts"
-				" 0x%02x cb avail: %d cb used %d fifo avail"
-				" %d fifo used %d\n", __func__, val[1],
-				val[2], val[3], val[4], val[5]);
+		v4l2_dbg(1, debug, &sdev->sd,
+			 "%s: response: interrupts 0x%02x cb avail: %d cb used %d fifo avail %d fifo used %d\n",
+			 __func__, val[1], val[2], val[3], val[4], val[5]);
 	}
 
 	return err;
-- 
2.7.4


