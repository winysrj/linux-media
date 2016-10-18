Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51608 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934901AbcJRUqX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 16:46:23 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Patrice Chotard <patrice.chotard@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kernel@stlinux.com
Subject: [PATCH v2 26/58] c8sectpfe: don't break long lines
Date: Tue, 18 Oct 2016 18:45:38 -0200
Message-Id: <4c96ee7fef4b5d93e9dd239f4925ae23dad2478c.1476822925.git.mchehab@s-opensource.com>
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

Acked-by: Peter Griffin <peter.griffin@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
index 30c148b9d65e..42b123ff2953 100644
--- a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
+++ b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
@@ -112,8 +112,7 @@ static void channel_swdemux_tsklet(unsigned long data)
 	buf = (u8 *) channel->back_buffer_aligned;
 
 	dev_dbg(fei->dev,
-		"chan=%d channel=%p num_packets = %d, buf = %p, pos = 0x%x\n\t"
-		"rp=0x%lx, wp=0x%lx\n",
+		"chan=%d channel=%p num_packets = %d, buf = %p, pos = 0x%x\n\trp=0x%lx, wp=0x%lx\n",
 		channel->tsin_id, channel, num_packets, buf, pos, rp, wp);
 
 	for (n = 0; n < num_packets; n++) {
@@ -789,8 +788,7 @@ static int c8sectpfe_probe(struct platform_device *pdev)
 		/* sanity check value */
 		if (tsin->tsin_id > fei->hw_stats.num_ib) {
 			dev_err(&pdev->dev,
-				"tsin-num %d specified greater than number\n\t"
-				"of input block hw in SoC! (%d)",
+				"tsin-num %d specified greater than number\n\tof input block hw in SoC! (%d)",
 				tsin->tsin_id, fei->hw_stats.num_ib);
 			ret = -EINVAL;
 			goto err_clk_disable;
@@ -855,8 +853,7 @@ static int c8sectpfe_probe(struct platform_device *pdev)
 		tsin->demux_mapping = index;
 
 		dev_dbg(fei->dev,
-			"channel=%p n=%d tsin_num=%d, invert-ts-clk=%d\n\t"
-			"serial-not-parallel=%d pkt-clk-valid=%d dvb-card=%d\n",
+			"channel=%p n=%d tsin_num=%d, invert-ts-clk=%d\n\tserial-not-parallel=%d pkt-clk-valid=%d dvb-card=%d\n",
 			fei->channel_data[index], index,
 			tsin->tsin_id, tsin->invert_ts_clk,
 			tsin->serial_not_parallel, tsin->async_not_sync,
@@ -1045,8 +1042,8 @@ static void load_imem_segment(struct c8sectpfei *fei, Elf32_Phdr *phdr,
 	 */
 
 	dev_dbg(fei->dev,
-		"Loading IMEM segment %d 0x%08x\n\t"
-		" (0x%x bytes) -> 0x%p (0x%x bytes)\n", seg_num,
+		"Loading IMEM segment %d 0x%08x\n\t (0x%x bytes) -> 0x%p (0x%x bytes)\n",
+seg_num,
 		phdr->p_paddr, phdr->p_filesz,
 		dest, phdr->p_memsz + phdr->p_memsz / 3);
 
@@ -1075,8 +1072,7 @@ static void load_dmem_segment(struct c8sectpfei *fei, Elf32_Phdr *phdr,
 	 */
 
 	dev_dbg(fei->dev,
-		"Loading DMEM segment %d 0x%08x\n\t"
-		"(0x%x bytes) -> 0x%p (0x%x bytes)\n",
+		"Loading DMEM segment %d 0x%08x\n\t(0x%x bytes) -> 0x%p (0x%x bytes)\n",
 		seg_num, phdr->p_paddr, phdr->p_filesz,
 		dst, phdr->p_memsz);
 
-- 
2.7.4


