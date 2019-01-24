Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B3E3C282C3
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 16:09:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19E35217D7
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 16:09:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="F31ykdLB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728855AbfAXQJq (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 11:09:46 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40201 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728841AbfAXQJq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 11:09:46 -0500
Received: by mail-wm1-f68.google.com with SMTP id f188so3614546wmf.5
        for <linux-media@vger.kernel.org>; Thu, 24 Jan 2019 08:09:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bakxXHwCXlwTa28lH4zHXABog+LI5vR2e9utn+0vgks=;
        b=F31ykdLBxo9ERlF6pZwsm4ubxD/GxDtjXmwq/y3pcgg+biLSaaBpagGtWV2A/Vn0vB
         i75jc6P6nie1qpd9MLgk/RrUqq/EUURCHAYppiLsvddWl/wm0HiHnZrzr1HXEoO3lcxB
         9xamvcxhXzpwp/Dk8WbF888cuLc3wfkjmToJk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bakxXHwCXlwTa28lH4zHXABog+LI5vR2e9utn+0vgks=;
        b=OTBbfexga2Gn15qjKEUm9ZtjmRWhNcIZUeTxsPhigzPdS3BPjxX/kEfEuFq1XMzQYT
         hPZsjr/IcdlnFhgTSgZmOhTljIjm/Y0dGD9ybiRQb127YCpQt8Q3ISJG7sVJLs/0DT8u
         iciGBMhlkXJjwwlj3i83gzxHR17IrMH3v7KSPXfJzXfc2NGTP1GMtdLYEUjk67Kkl/em
         wAF10d2AJ9yi2zMksl6ix06T+VLJUCwHsktIUeV7/sUTPNjsLv3K2/C+7LS+usf5sqW+
         LthSIyOcCKbC/Fun4j8434mY0NZhcPuThqWLssVb3LYvwTLrHM+0hMIFrVhxVcmkRkCY
         GWFw==
X-Gm-Message-State: AJcUukf/0w2e/uMnjeG2bqyetpRfZyHBuQEOwP/dwM53LqaGsMQzF3y2
        f9hbVnueyYYlGSXHQIyvAZGduQ==
X-Google-Smtp-Source: ALg8bN5hVMhsVZdPkYN44KRIeR3830+Vi9omjcMq3J4i8DopGkBYOIk91+SYl/g4CUhJrrUKCuQoSg==
X-Received: by 2002:a7b:c156:: with SMTP id z22mr3275914wmi.24.1548346184381;
        Thu, 24 Jan 2019 08:09:44 -0800 (PST)
Received: from arch-late.local (a109-49-46-234.cpe.netcabo.pt. [109.49.46.234])
        by smtp.gmail.com with ESMTPSA id e16sm179880299wrn.72.2019.01.24.08.09.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 08:09:43 -0800 (PST)
From:   Rui Miguel Silva <rui.silva@linaro.org>
To:     sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH v11 04/13] media: staging/imx7: add imx7 CSI subdev driver
Date:   Thu, 24 Jan 2019 16:09:19 +0000
Message-Id: <20190124160928.31884-5-rui.silva@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190124160928.31884-1-rui.silva@linaro.org>
References: <20190124160928.31884-1-rui.silva@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This add the media entity subdevice and control driver for the i.MX7
CMOS Sensor Interface.

Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
---
 drivers/staging/media/imx/Kconfig  | 9 ++++++++-
 drivers/staging/media/imx/Makefile | 2 ++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/imx/Kconfig b/drivers/staging/media/imx/Kconfig
index bfc17de56b17..36b276ea2ecc 100644
--- a/drivers/staging/media/imx/Kconfig
+++ b/drivers/staging/media/imx/Kconfig
@@ -11,7 +11,7 @@ config VIDEO_IMX_MEDIA
 	  driver for the i.MX5/6 SOC.
 
 if VIDEO_IMX_MEDIA
-menu "i.MX5/6 Media Sub devices"
+menu "i.MX5/6/7 Media Sub devices"
 
 config VIDEO_IMX_CSI
 	tristate "i.MX5/6 Camera Sensor Interface driver"
@@ -20,5 +20,12 @@ config VIDEO_IMX_CSI
 	---help---
 	  A video4linux camera sensor interface driver for i.MX5/6.
 
+config VIDEO_IMX7_CSI
+	tristate "i.MX7 Camera Sensor Interface driver"
+	depends on VIDEO_IMX_MEDIA && VIDEO_DEV && I2C
+	default y
+	help
+	  Enable support for video4linux camera sensor interface driver for
+	  i.MX7.
 endmenu
 endif
diff --git a/drivers/staging/media/imx/Makefile b/drivers/staging/media/imx/Makefile
index a30b3033f9a3..074f016d3519 100644
--- a/drivers/staging/media/imx/Makefile
+++ b/drivers/staging/media/imx/Makefile
@@ -12,3 +12,5 @@ obj-$(CONFIG_VIDEO_IMX_MEDIA) += imx-media-ic.o
 
 obj-$(CONFIG_VIDEO_IMX_CSI) += imx-media-csi.o
 obj-$(CONFIG_VIDEO_IMX_CSI) += imx6-mipi-csi2.o
+
+obj-$(CONFIG_VIDEO_IMX7_CSI) += imx7-media-csi.o
-- 
2.20.1

