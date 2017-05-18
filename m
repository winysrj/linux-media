Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:35034 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752916AbdERIpc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 May 2017 04:45:32 -0400
Received: by mail-wm0-f44.google.com with SMTP id b84so193203449wmh.0
        for <linux-media@vger.kernel.org>; Thu, 18 May 2017 01:45:31 -0700 (PDT)
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: hverkuil@xs4all.nl, linux-media@vger.kernel.org,
        hans.verkuil@cisco.com
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH] cec: stih: fix typos in comments
Date: Thu, 18 May 2017 10:45:10 +0200
Message-Id: <1495097110-20216-2-git-send-email-benjamin.gaignard@linaro.org>
In-Reply-To: <1495097110-20216-1-git-send-email-benjamin.gaignard@linaro.org>
References: <1495097110-20216-1-git-send-email-benjamin.gaignard@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Minor fixes in comments

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
---
 drivers/media/platform/sti/cec/stih-cec.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/sti/cec/stih-cec.c b/drivers/media/platform/sti/cec/stih-cec.c
index 39ff551..65ee143 100644
--- a/drivers/media/platform/sti/cec/stih-cec.c
+++ b/drivers/media/platform/sti/cec/stih-cec.c
@@ -1,6 +1,6 @@
 /*
  * STIH4xx CEC driver
- * Copyright (C) STMicroelectronic SA 2016
+ * Copyright (C) STMicroelectronics SA 2016
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -213,7 +213,8 @@ static int stih_cec_adap_transmit(struct cec_adapter *adap, u8 attempts,
 	for (i = 0; i < msg->len; i++)
 		writeb(msg->msg[i], cec->regs + CEC_TX_DATA_BASE + i);
 
-	/* Start transmission, configure hardware to add start and stop bits
+	/*
+	 * Start transmission, configure hardware to add start and stop bits
 	 * Signal free time is handled by the hardware
 	 */
 	writel(CEC_TX_AUTO_SOM_EN | CEC_TX_AUTO_EOM_EN | CEC_TX_START |
-- 
1.9.1
