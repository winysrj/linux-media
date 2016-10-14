Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59205 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757094AbcJNUWn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 16:22:43 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Patrice Chotard <patrice.chotard@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kernel@stlinux.com
Subject: [PATCH 28/57] [media] c8sectpfe: don't break long lines
Date: Fri, 14 Oct 2016 17:20:16 -0300
Message-Id: <b82cb64c6328c81104143d8a509d4ab6f77873a2.1476475771.git.mchehab@s-opensource.com>
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
 drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
index 30c148b9d65e..7a2c8fdfbe51 100644
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
@@ -1045,8 +1042,7 @@ static void load_imem_segment(struct c8sectpfei *fei, Elf32_Phdr *phdr,
 	 */
 
 	dev_dbg(fei->dev,
-		"Loading IMEM segment %d 0x%08x\n\t"
-		" (0x%x bytes) -> 0x%p (0x%x bytes)\n", seg_num,
+		"Loading IMEM segment %d 0x%08x\n\t (0x%x bytes) -> 0x%p (0x%x bytes)\n", seg_num,
 		phdr->p_paddr, phdr->p_filesz,
 		dest, phdr->p_memsz + phdr->p_memsz / 3);
 
@@ -1075,8 +1071,7 @@ static void load_dmem_segment(struct c8sectpfei *fei, Elf32_Phdr *phdr,
 	 */
 
 	dev_dbg(fei->dev,
-		"Loading DMEM segment %d 0x%08x\n\t"
-		"(0x%x bytes) -> 0x%p (0x%x bytes)\n",
+		"Loading DMEM segment %d 0x%08x\n\t(0x%x bytes) -> 0x%p (0x%x bytes)\n",
 		seg_num, phdr->p_paddr, phdr->p_filesz,
 		dst, phdr->p_memsz);
 
-- 
2.7.4


