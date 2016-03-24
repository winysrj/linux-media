Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:33418 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755680AbcCXLYA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2016 07:24:00 -0400
Received: by mail-wm0-f43.google.com with SMTP id l68so269902220wml.0
        for <linux-media@vger.kernel.org>; Thu, 24 Mar 2016 04:23:59 -0700 (PDT)
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
	patrice.chotard@st.com, mchehab@osg.samsung.com
Cc: peter.griffin@linaro.org, lee.jones@linaro.org,
	hugues.fruchet@st.com, linux-media@vger.kernel.org
Subject: [PATCH 2/3] [media] c8sectpfe: Demote print to dev_dbg
Date: Thu, 24 Mar 2016 11:23:51 +0000
Message-Id: <1458818632-25552-3-git-send-email-peter.griffin@linaro.org>
In-Reply-To: <1458818632-25552-1-git-send-email-peter.griffin@linaro.org>
References: <1458818632-25552-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
index 875d384..acd0767 100644
--- a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
+++ b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
@@ -585,7 +585,7 @@ static int configure_memdma_and_inputblock(struct c8sectpfei *fei,
 	writel(tsin->pid_buffer_busaddr,
 		fei->io + PIDF_BASE(tsin->tsin_id));
 
-	dev_info(fei->dev, "chan=%d PIDF_BASE=0x%x pid_bus_addr=%pad\n",
+	dev_dbg(fei->dev, "chan=%d PIDF_BASE=0x%x pid_bus_addr=%pad\n",
 		tsin->tsin_id, readl(fei->io + PIDF_BASE(tsin->tsin_id)),
 		&tsin->pid_buffer_busaddr);
 
-- 
1.9.1

