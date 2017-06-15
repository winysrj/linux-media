Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:35688 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751667AbdFOQcv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Jun 2017 12:32:51 -0400
Received: by mail-wm0-f50.google.com with SMTP id x70so4444744wme.0
        for <linux-media@vger.kernel.org>; Thu, 15 Jun 2017 09:32:50 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH v11 03/19] MAINTAINERS: Add Qualcomm Venus video accelerator driver
Date: Thu, 15 Jun 2017 19:31:44 +0300
Message-Id: <1497544320-2269-4-git-send-email-stanimir.varbanov@linaro.org>
In-Reply-To: <1497544320-2269-1-git-send-email-stanimir.varbanov@linaro.org>
References: <1497544320-2269-1-git-send-email-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add an entry for Venus video encoder/decoder accelerator driver.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 053c3bdd1fe5..2cf03bb969b5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10584,6 +10584,14 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/rkuo/linux-hexagon-kernel.g
 S:	Supported
 F:	arch/hexagon/
 
+QUALCOMM VENUS VIDEO ACCELERATOR DRIVER
+M:	Stanimir Varbanov <stanimir.varbanov@linaro.org>
+L:	linux-media@vger.kernel.org
+L:	linux-arm-msm@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+S:	Maintained
+F:	drivers/media/platform/qcom/venus/
+
 QUALCOMM WCN36XX WIRELESS DRIVER
 M:	Eugene Krasnikov <k.eugene.e@gmail.com>
 L:	wcn36xx@lists.infradead.org
-- 
2.7.4
