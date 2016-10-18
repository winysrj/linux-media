Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51633 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935516AbcJRUqY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 16:46:24 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Junghak Sung <jh1009.sung@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Mel Gorman <mgorman@techsingularity.net>
Subject: [PATCH v2 19/58] tw68: don't break long lines
Date: Tue, 18 Oct 2016 18:45:31 -0200
Message-Id: <ef7f84e23e2c5ee6298e0e8724048e8699074b9e.1476822924.git.mchehab@s-opensource.com>
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
 drivers/media/pci/tw68/tw68-video.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/media/pci/tw68/tw68-video.c b/drivers/media/pci/tw68/tw68-video.c
index a45e02367321..58c4dd75bfa1 100644
--- a/drivers/media/pci/tw68/tw68-video.c
+++ b/drivers/media/pci/tw68/tw68-video.c
@@ -279,9 +279,8 @@ static int tw68_set_scale(struct tw68_dev *dev, unsigned int width,
 		height /= 2;		/* we must set for 1-frame */
 
 	pr_debug("%s: width=%d, height=%d, both=%d\n"
-		 "  tvnorm h_delay=%d, h_start=%d, h_stop=%d, "
-		 "v_delay=%d, v_start=%d, v_stop=%d\n" , __func__,
-		width, height, V4L2_FIELD_HAS_BOTH(field),
+		 "  tvnorm h_delay=%d, h_start=%d, h_stop=%d, v_delay=%d, v_start=%d, v_stop=%d\n",
+		__func__, width, height, V4L2_FIELD_HAS_BOTH(field),
 		norm->h_delay, norm->h_start, norm->h_stop,
 		norm->v_delay, norm->video_v_start,
 		norm->video_v_stop);
@@ -309,16 +308,15 @@ static int tw68_set_scale(struct tw68_dev *dev, unsigned int width,
 		V4L2_FIELD_HAS_TOP(field)    ? "T" : "",
 		V4L2_FIELD_HAS_BOTTOM(field) ? "B" : "",
 		v4l2_norm_to_name(dev->tvnorm->id));
-	pr_debug("%s: hactive=%d, hdelay=%d, hscale=%d; "
-		"vactive=%d, vdelay=%d, vscale=%d\n", __func__,
+	pr_debug("%s: hactive=%d, hdelay=%d, hscale=%d; vactive=%d, vdelay=%d, vscale=%d\n",
+		 __func__,
 		hactive, hdelay, hscale, vactive, vdelay, vscale);
 
 	comb =	((vdelay & 0x300)  >> 2) |
 		((vactive & 0x300) >> 4) |
 		((hdelay & 0x300)  >> 6) |
 		((hactive & 0x300) >> 8);
-	pr_debug("%s: setting CROP_HI=%02x, VDELAY_LO=%02x, "
-		"VACTIVE_LO=%02x, HDELAY_LO=%02x, HACTIVE_LO=%02x\n",
+	pr_debug("%s: setting CROP_HI=%02x, VDELAY_LO=%02x, VACTIVE_LO=%02x, HDELAY_LO=%02x, HACTIVE_LO=%02x\n",
 		__func__, comb, vdelay, vactive, hdelay, hactive);
 	tw_writeb(TW68_CROP_HI, comb);
 	tw_writeb(TW68_VDELAY_LO, vdelay & 0xff);
@@ -327,8 +325,8 @@ static int tw68_set_scale(struct tw68_dev *dev, unsigned int width,
 	tw_writeb(TW68_HACTIVE_LO, hactive & 0xff);
 
 	comb = ((vscale & 0xf00) >> 4) | ((hscale & 0xf00) >> 8);
-	pr_debug("%s: setting SCALE_HI=%02x, VSCALE_LO=%02x, "
-		"HSCALE_LO=%02x\n", __func__, comb, vscale, hscale);
+	pr_debug("%s: setting SCALE_HI=%02x, VSCALE_LO=%02x, HSCALE_LO=%02x\n",
+		 __func__, comb, vscale, hscale);
 	tw_writeb(TW68_SCALE_HI, comb);
 	tw_writeb(TW68_VSCALE_LO, vscale);
 	tw_writeb(TW68_HSCALE_LO, hscale);
-- 
2.7.4


