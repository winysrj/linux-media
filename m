Return-Path: <SRS0=RQn6=Q2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B76E4C43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 09:01:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82F2B21904
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 09:01:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727752AbfBSJBX (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Feb 2019 04:01:23 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39496 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727315AbfBSJBX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Feb 2019 04:01:23 -0500
Received: by mail-wr1-f66.google.com with SMTP id l5so20154705wrw.6
        for <linux-media@vger.kernel.org>; Tue, 19 Feb 2019 01:01:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lBFymejVO6nyQQvMVd1TUt4bRT7eP4YLeQu2FDz6j7M=;
        b=Ys3Gx6tiWALIrDcFhUbCBitSokqJa+nrkeJ2ruSILnv55i+pIHwXO8oZbhfMHAS/A/
         fyv/4+zCEnQbuMnlRwnvFseuTXhhsOcIsz0rwXNyz7uHCbcs2nDb4Hn2MnF+ItUVhugH
         1DqkhhbfAMq2nCbfeDrlBwhbQrmJ/utn2sHY/ASLaIOf7V7ARt/sg5u5sGub0/JgfO+b
         Qlo1x6dcp20ZPV1Rqu6zgpHkhVWT65tG+bMN3mYQIm8bRdiSEoizMx5KhRRIKFAzQO9o
         yjKhkKj2TFsGO5QaIKhks/0cOrLgsOxn5pxuomZfliTsj9Ql9zvgoLSy87i5KVSljxqp
         PGTQ==
X-Gm-Message-State: AHQUAuaa/u+EesqSUY6RXpDEkVR+0nt4RGQd9sfaQmL7IOXU+0ajKkp0
        dwRQjhJ6zzsPWoAa8cFm3VfS4w==
X-Google-Smtp-Source: AHgI3IZqIulMrW23qsi+TjpzBIPzRnWNszRUrCEIbyeC+HTx9LCU/HtIFsKXuQ47oEbXLU4QHAfc9A==
X-Received: by 2002:a05:6000:128f:: with SMTP id f15mr19075527wrx.74.1550566881168;
        Tue, 19 Feb 2019 01:01:21 -0800 (PST)
Received: from minerva.redhat.com ([90.168.169.92])
        by smtp.gmail.com with ESMTPSA id f196sm2745727wme.36.2019.02.19.01.01.19
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 Feb 2019 01:01:20 -0800 (PST)
From:   Javier Martinez Canillas <javierm@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Javier Martinez Canillas <javierm@redhat.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        devel@driverdev.osuosl.org, Philipp Zabel <p.zabel@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media@vger.kernel.org
Subject: [PATCH] media: staging/imx: Allow driver to build if COMPILE_TEST is enabled
Date:   Tue, 19 Feb 2019 10:01:04 +0100
Message-Id: <20190219090104.1143-1-javierm@redhat.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The driver has runtime but no build time dependency with IMX_IPUV3_CORE,
so can be built for testing purposes if COMPILE_TEST option is enabled.

This is useful to have more build coverage and make sure that the driver
is not affected by changes that could cause build regressions.

Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>

---

 drivers/staging/media/imx/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/imx/Kconfig b/drivers/staging/media/imx/Kconfig
index 36b276ea2ec..5045e24c470 100644
--- a/drivers/staging/media/imx/Kconfig
+++ b/drivers/staging/media/imx/Kconfig
@@ -1,7 +1,7 @@
 config VIDEO_IMX_MEDIA
 	tristate "i.MX5/6 V4L2 media core driver"
 	depends on ARCH_MXC || COMPILE_TEST
-	depends on MEDIA_CONTROLLER && VIDEO_V4L2 && IMX_IPUV3_CORE
+	depends on MEDIA_CONTROLLER && VIDEO_V4L2 && (IMX_IPUV3_CORE || COMPILE_TEST)
 	depends on VIDEO_V4L2_SUBDEV_API
 	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
-- 
2.20.1

