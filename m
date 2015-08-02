Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0230.hostedemail.com ([216.40.44.230]:44913 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752089AbbHBUa5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 2 Aug 2015 16:30:57 -0400
Message-ID: <1438547453.29569.10.camel@perches.com>
Subject: [TRIVIAL PATCH] [media] s5p-mfc: Correct misuse of %0x<decimal>
From: Joe Perches <joe@perches.com>
To: Kyungmin Park <kyungmin.park@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Jeongtae Park <jtp.park@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
Date: Sun, 02 Aug 2015 13:30:53 -0700
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Correct misuse of 0x%d in logging message.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index 12497f5..c10ad57 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -520,7 +520,7 @@ static int s5p_mfc_set_enc_stream_buffer_v6(struct s5p_mfc_ctx *ctx,
        writel(addr, mfc_regs->e_stream_buffer_addr); /* 16B align */
        writel(size, mfc_regs->e_stream_buffer_size);
 
-       mfc_debug(2, "stream buf addr: 0x%08lx, size: 0x%d\n",
+       mfc_debug(2, "stream buf addr: 0x%08lx, size: 0x%x\n",
                  addr, size);
 
        return 0;
