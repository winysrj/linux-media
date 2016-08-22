Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:35533 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754957AbcHVNO3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Aug 2016 09:14:29 -0400
Received: by mail-wm0-f54.google.com with SMTP id f65so120051554wmi.0
        for <linux-media@vger.kernel.org>; Mon, 22 Aug 2016 06:14:28 -0700 (PDT)
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
Subject: [PATCH 8/8] media: vidc: enable building of the video codec driver
Date: Mon, 22 Aug 2016 16:13:39 +0300
Message-Id: <1471871619-25873-9-git-send-email-stanimir.varbanov@linaro.org>
In-Reply-To: <1471871619-25873-1-git-send-email-stanimir.varbanov@linaro.org>
References: <1471871619-25873-1-git-send-email-stanimir.varbanov@linaro.org>
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
index f25344bc7912..e52640417b0a 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -111,6 +111,7 @@ source "drivers/media/platform/s5p-tv/Kconfig"
 source "drivers/media/platform/am437x/Kconfig"
 source "drivers/media/platform/xilinx/Kconfig"
 source "drivers/media/platform/rcar-vin/Kconfig"
+source "drivers/media/platform/qcom/Kconfig"
 
 config VIDEO_TI_CAL
 	tristate "TI CAL (Camera Adaptation Layer) driver"
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index 21771c1a13fb..d8fc75ddcc73 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -51,6 +51,7 @@ obj-$(CONFIG_VIDEO_RENESAS_JPU) 	+= rcar_jpu.o
 obj-$(CONFIG_VIDEO_RENESAS_VSP1)	+= vsp1/
 
 obj-y	+= omap/
+obj-y	+= qcom/
 
 obj-$(CONFIG_VIDEO_AM437X_VPFE)		+= am437x/
 
-- 
2.7.4

