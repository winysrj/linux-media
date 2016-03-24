Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:34943 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755882AbcCXLX6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2016 07:23:58 -0400
Received: by mail-wm0-f41.google.com with SMTP id l68so232228677wml.0
        for <linux-media@vger.kernel.org>; Thu, 24 Mar 2016 04:23:58 -0700 (PDT)
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
	patrice.chotard@st.com, mchehab@osg.samsung.com
Cc: peter.griffin@linaro.org, lee.jones@linaro.org,
	hugues.fruchet@st.com, linux-media@vger.kernel.org
Subject: [PATCH 1/3] [media] c8sectpfe: Fix broken circular buffer wp management
Date: Thu, 24 Mar 2016 11:23:50 +0000
Message-Id: <1458818632-25552-2-git-send-email-peter.griffin@linaro.org>
In-Reply-To: <1458818632-25552-1-git-send-email-peter.griffin@linaro.org>
References: <1458818632-25552-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

During the review process, a regression was intoduced in the
circular buffer write pointer management. This means that wp
doesn't get managed properly once the buffer becomes full.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
index 78e3cb9..875d384 100644
--- a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
+++ b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
@@ -130,7 +130,7 @@ static void channel_swdemux_tsklet(unsigned long data)
 		writel(channel->back_buffer_busaddr, channel->irec +
 			DMA_PRDS_BUSRP_TP(0));
 	else
-		writel(wp, channel->irec + DMA_PRDS_BUSWP_TP(0));
+		writel(wp, channel->irec + DMA_PRDS_BUSRP_TP(0));
 }
 
 static int c8sectpfe_start_feed(struct dvb_demux_feed *dvbdmxfeed)
-- 
1.9.1

