Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51547 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934818AbcJRUqW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 16:46:22 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Benoit Parrot <bparrot@ti.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH v2 27/58] ti-vpe: don't break long lines
Date: Tue, 18 Oct 2016 18:45:39 -0200
Message-Id: <f914ec921ba7399efe28ea3a1003387e1cf22dab.1476822925.git.mchehab@s-opensource.com>
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

Acked-by: Benoit Parrot <bparrot@ti.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/ti-vpe/vpdma.c | 22 ++++++++++------------
 drivers/media/platform/ti-vpe/vpe.c   |  3 +--
 2 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/vpdma.c b/drivers/media/platform/ti-vpe/vpdma.c
index 3e2e3a33e6ed..4aff05915051 100644
--- a/drivers/media/platform/ti-vpe/vpdma.c
+++ b/drivers/media/platform/ti-vpe/vpdma.c
@@ -466,10 +466,10 @@ static void dump_cfd(struct vpdma_cfd *cfd)
 
 	pr_debug("word2: payload_addr = 0x%08x\n", cfd->payload_addr);
 
-	pr_debug("word3: pkt_type = %d, direct = %d, class = %d, dest = %d, "
-		"payload_len = %d\n", cfd_get_pkt_type(cfd),
-		cfd_get_direct(cfd), class, cfd_get_dest(cfd),
-		cfd_get_payload_len(cfd));
+	pr_debug("word3: pkt_type = %d, direct = %d, class = %d, dest = %d, payload_len = %d\n",
+		 cfd_get_pkt_type(cfd),
+		 cfd_get_direct(cfd), class, cfd_get_dest(cfd),
+		 cfd_get_payload_len(cfd));
 }
 
 /*
@@ -574,8 +574,7 @@ static void dump_dtd(struct vpdma_dtd *dtd)
 	pr_debug("%s data transfer descriptor for channel %d\n",
 		dir == DTD_DIR_OUT ? "outbound" : "inbound", chan);
 
-	pr_debug("word0: data_type = %d, notify = %d, field = %d, 1D = %d, "
-		"even_ln_skp = %d, odd_ln_skp = %d, line_stride = %d\n",
+	pr_debug("word0: data_type = %d, notify = %d, field = %d, 1D = %d, even_ln_skp = %d, odd_ln_skp = %d, line_stride = %d\n",
 		dtd_get_data_type(dtd), dtd_get_notify(dtd), dtd_get_field(dtd),
 		dtd_get_1d(dtd), dtd_get_even_line_skip(dtd),
 		dtd_get_odd_line_skip(dtd), dtd_get_line_stride(dtd));
@@ -586,17 +585,16 @@ static void dump_dtd(struct vpdma_dtd *dtd)
 
 	pr_debug("word2: start_addr = %pad\n", &dtd->start_addr);
 
-	pr_debug("word3: pkt_type = %d, mode = %d, dir = %d, chan = %d, "
-		"pri = %d, next_chan = %d\n", dtd_get_pkt_type(dtd),
-		dtd_get_mode(dtd), dir, chan, dtd_get_priority(dtd),
-		dtd_get_next_chan(dtd));
+	pr_debug("word3: pkt_type = %d, mode = %d, dir = %d, chan = %d, pri = %d, next_chan = %d\n",
+		 dtd_get_pkt_type(dtd),
+		 dtd_get_mode(dtd), dir, chan, dtd_get_priority(dtd),
+		 dtd_get_next_chan(dtd));
 
 	if (dir == DTD_DIR_IN)
 		pr_debug("word4: frame_width = %d, frame_height = %d\n",
 			dtd_get_frame_width(dtd), dtd_get_frame_height(dtd));
 	else
-		pr_debug("word4: desc_write_addr = 0x%08x, write_desc = %d, "
-			"drp_data = %d, use_desc_reg = %d\n",
+		pr_debug("word4: desc_write_addr = 0x%08x, write_desc = %d, drp_data = %d, use_desc_reg = %d\n",
 			dtd_get_desc_write_addr(dtd), dtd_get_write_desc(dtd),
 			dtd_get_drop_data(dtd), dtd_get_use_desc(dtd));
 
diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 0189f7f7cb03..1cf4a4c1b899 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -1263,8 +1263,7 @@ static irqreturn_t vpe_irq(int irq_vpe, void *data)
 	}
 
 	if (irqst0 | irqst1) {
-		dev_warn(dev->v4l2_dev.dev, "Unexpected interrupt: "
-			"INT0_STATUS0 = 0x%08x, INT0_STATUS1 = 0x%08x\n",
+		dev_warn(dev->v4l2_dev.dev, "Unexpected interrupt: INT0_STATUS0 = 0x%08x, INT0_STATUS1 = 0x%08x\n",
 			irqst0, irqst1);
 	}
 
-- 
2.7.4


