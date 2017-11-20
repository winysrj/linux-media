Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway31.websitewelcome.com ([192.185.143.39]:46758 "EHLO
        gateway31.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751155AbdKTOtT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Nov 2017 09:49:19 -0500
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway31.websitewelcome.com (Postfix) with ESMTP id 5133AB0EE4
        for <linux-media@vger.kernel.org>; Mon, 20 Nov 2017 08:00:58 -0600 (CST)
Date: Mon, 20 Nov 2017 08:00:55 -0600
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Patrice Chotard <patrice.chotard@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] c8sectpfe: fix potential NULL pointer dereference in
 c8sectpfe_timer_interrupt
Message-ID: <20171120140055.GA728@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

_channel_ is being dereferenced before it is null checked, hence there is a
potential null pointer dereference. Fix this by moving the pointer dereference
after _channel_ has been null checked.

This issue was detected with the help of Coccinelle.

Fixes: c5f5d0f99794 ("[media] c8sectpfe: STiH407/10 Linux DVB demux support")
Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
index 59280ac..23d0ced 100644
--- a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
+++ b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
@@ -83,7 +83,7 @@ static void c8sectpfe_timer_interrupt(unsigned long ac8sectpfei)
 static void channel_swdemux_tsklet(unsigned long data)
 {
 	struct channel_info *channel = (struct channel_info *)data;
-	struct c8sectpfei *fei = channel->fei;
+	struct c8sectpfei *fei;
 	unsigned long wp, rp;
 	int pos, num_packets, n, size;
 	u8 *buf;
@@ -91,6 +91,8 @@ static void channel_swdemux_tsklet(unsigned long data)
 	if (unlikely(!channel || !channel->irec))
 		return;
 
+	fei = channel->fei;
+
 	wp = readl(channel->irec + DMA_PRDS_BUSWP_TP(0));
 	rp = readl(channel->irec + DMA_PRDS_BUSRP_TP(0));
 
-- 
2.7.4
