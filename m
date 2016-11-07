Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:38573 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753603AbcKGRfl (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 Nov 2016 12:35:41 -0500
Received: by mail-wm0-f49.google.com with SMTP id f82so133008760wmf.1
        for <linux-media@vger.kernel.org>; Mon, 07 Nov 2016 09:34:42 -0800 (PST)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH v3 9/9] media: venus: enable building of Venus video codec driver
Date: Mon,  7 Nov 2016 19:34:03 +0200
Message-Id: <1478540043-24558-10-git-send-email-stanimir.varbanov@linaro.org>
In-Reply-To: <1478540043-24558-1-git-send-email-stanimir.varbanov@linaro.org>
References: <1478540043-24558-1-git-send-email-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds changes in v4l2 platform directory to include the
vidc driver and show it in kernel config.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/Kconfig  | 1 +
 drivers/media/platform/Makefile | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 754edbf1a326..8a2fa7c973e1 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -120,6 +120,7 @@ source "drivers/media/platform/am437x/Kconfig"
 source "drivers/media/platform/xilinx/Kconfig"
 source "drivers/media/platform/rcar-vin/Kconfig"
 source "drivers/media/platform/atmel/Kconfig"
+source "drivers/media/platform/qcom/Kconfig"
 
 config VIDEO_TI_CAL
 	tristate "TI CAL (Camera Adaptation Layer) driver"
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index f842933d17de..5106553a3307 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -52,6 +52,7 @@ obj-$(CONFIG_VIDEO_RENESAS_JPU) 	+= rcar_jpu.o
 obj-$(CONFIG_VIDEO_RENESAS_VSP1)	+= vsp1/
 
 obj-y	+= omap/
+obj-y	+= qcom/
 
 obj-$(CONFIG_VIDEO_AM437X_VPFE)		+= am437x/
 
-- 
2.7.4

