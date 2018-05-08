Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:44822 "EHLO
        homiemail-a116.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755971AbeEHVU1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 May 2018 17:20:27 -0400
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mspieth@digivation.com.au
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 5/5] cx23885: Add some missing register documentation
Date: Tue,  8 May 2018 16:20:20 -0500
Message-Id: <1525814420-25243-6-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1525814420-25243-1-git-send-email-brad@nextdimension.cc>
References: <1525814420-25243-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document what these two register calls are doing.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/pci/cx23885/cx23885-core.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx23885/cx23885-core.c b/drivers/media/pci/cx23885/cx23885-core.c
index 1150160..ca19e0d 100644
--- a/drivers/media/pci/cx23885/cx23885-core.c
+++ b/drivers/media/pci/cx23885/cx23885-core.c
@@ -1465,8 +1465,15 @@ int cx23885_start_dma(struct cx23885_tsport *port,
 		reg = reg | 0xa;
 		cx_write(PAD_CTRL, reg);
 
-		/* FIXME and these two registers should be documented. */
+		/* Sets MOE_CLK_DIS to disable MoE clock */
+		/* sets MCLK_DLY_SEL/BCLK_DLY_SEL to 1 buffer delay each */
 		cx_write(CLK_DELAY, cx_read(CLK_DELAY) | 0x80000011);
+
+		/* ALT_GPIO_ALT_SET: GPIO[0]
+		 * IR_ALT_TX_SEL: GPIO[1]
+		 * GPIO1_ALT_SEL: VIP_656_DATA[0]
+		 * GPIO0_ALT_SEL: VIP_656_CLK
+		 */
 		cx_write(ALT_PIN_OUT_SEL, 0x10100045);
 	}
 
-- 
2.7.4
