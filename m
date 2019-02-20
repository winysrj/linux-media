Return-Path: <SRS0=tJec=Q3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AEB1C43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 23:54:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5BB4020880
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 23:54:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="meL1aP8D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbfBTXx5 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Feb 2019 18:53:57 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33139 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfBTXxo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Feb 2019 18:53:44 -0500
Received: by mail-pf1-f196.google.com with SMTP id c123so12760063pfb.0;
        Wed, 20 Feb 2019 15:53:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=TUNgXugUPdi2D5irskH/ROTRx7A7lur86DBNUjDfACA=;
        b=meL1aP8DPfFLV3WVQVb2mm/9mve39BnBwa71YAp1f6/E/tgz5JrI620unkeoCyqMyk
         xRGpSfnsur1Pzszdhz8JfG601TnEpcOpSZBlM5Aa8dklkLiq6GVXFs8QyQkBw6sKnmDP
         JQwaO/jXZNMXBVVRx12jwgwBspMx0h6K9raxMo+sOrwzQ8luhATk9ZNlMjDXnMV9ZtkM
         maL+lK8b5QOV2DqnZQYa7m1m2Pgu+3aIdExQXBRfhfFwgfm2mjgGzQRTH21/WWb96XdO
         Hs9Nix1gDK1fsBRCYgLy1Xc2wNyMPeJJIZsU3Tz+Fi+DQpxeBkXk1f8zU3V6W4nmcdrw
         huYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=TUNgXugUPdi2D5irskH/ROTRx7A7lur86DBNUjDfACA=;
        b=MhBG8bIxMyY9uCSi6xmrJmSkB7QM8k0jFgwdAXKKK2hxwdpU0V/CuQiyJdBG+9AGQx
         83BIZe092L4EDURa013T24oXVNsHGfy6a1OH0Fub9oaR3OsqSvAxH9ody44HsOecEHjR
         N73w3Vz1F8yiTM45nL+kSM/suzMyul+3k6xQei2NE2QaVXbFeB21h2zgDP/DbQ6F8Hzi
         jf28t9Jyla/SNOZ1SZ3hMWt++Kp2mw3fZBYo4IK5wLzkhPrUdmnL0YaMoa4FEvkSw/Br
         LjOCRpuHEE3FKW2FaR82sYG2v9xtEDHmCdePSbOAwa2Ur+NOZN2EYxbGiHQIvRT2yYuf
         wDBA==
X-Gm-Message-State: AHQUAuajniPACdJizHP0NxLT2wsR5dD0ur/8TDQYRPDnhJNTIdonKqjb
        HdS9GJcCrppwF9tKhhWI+6vrQhde
X-Google-Smtp-Source: AHgI3IZ8Ar7YPr8oTgyORntEG0F9FtMxmsNQo1HGown3LmdTVBSAL9XfbMwAldlMNFsQPZo71pjfiw==
X-Received: by 2002:a63:c64f:: with SMTP id x15mr30992227pgg.16.1550706823403;
        Wed, 20 Feb 2019 15:53:43 -0800 (PST)
Received: from majic.sklembedded.com (c-73-202-231-77.hsd1.ca.comcast.net. [73.202.231.77])
        by smtp.googlemail.com with ESMTPSA id v15sm25530158pgf.75.2019.02.20.15.53.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Feb 2019 15:53:42 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>, stable@vger.kernel.org,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 3/4] media: imx: Rename functions that add IPU-internal subdevs
Date:   Wed, 20 Feb 2019 15:53:31 -0800
Message-Id: <20190220235332.15984-4-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190220235332.15984-1-slongerbeam@gmail.com>
References: <20190220235332.15984-1-slongerbeam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

For the functions that add and remove the internal IPU subdevice
descriptors, rename them to make clear they are the subdevs internal
to the IPU. Also rename the platform data structure for the internal
IPU subdevices. No functional changes.

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
Acked-by: Philipp Zabel <p.zabel@pengutronix.de>
Cc: stable@vger.kernel.org
---
 drivers/staging/media/imx/imx-ic-common.c         |  2 +-
 drivers/staging/media/imx/imx-media-dev.c         |  8 ++++----
 drivers/staging/media/imx/imx-media-internal-sd.c | 12 ++++++------
 drivers/staging/media/imx/imx-media-vdic.c        |  2 +-
 drivers/staging/media/imx/imx-media.h             |  6 +++---
 5 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/media/imx/imx-ic-common.c b/drivers/staging/media/imx/imx-ic-common.c
index 765919487a73..90a926891eb9 100644
--- a/drivers/staging/media/imx/imx-ic-common.c
+++ b/drivers/staging/media/imx/imx-ic-common.c
@@ -26,7 +26,7 @@ static struct imx_ic_ops *ic_ops[IC_NUM_OPS] = {
 
 static int imx_ic_probe(struct platform_device *pdev)
 {
-	struct imx_media_internal_sd_platformdata *pdata;
+	struct imx_media_ipu_internal_sd_pdata *pdata;
 	struct imx_ic_priv *priv;
 	int ret;
 
diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
index 28a3d23aad5b..fc35508d9396 100644
--- a/drivers/staging/media/imx/imx-media-dev.c
+++ b/drivers/staging/media/imx/imx-media-dev.c
@@ -477,10 +477,10 @@ static int imx_media_probe(struct platform_device *pdev)
 		goto cleanup;
 	}
 
-	ret = imx_media_add_internal_subdevs(imxmd);
+	ret = imx_media_add_ipu_internal_subdevs(imxmd);
 	if (ret) {
 		v4l2_err(&imxmd->v4l2_dev,
-			 "add_internal_subdevs failed with %d\n", ret);
+			 "add_ipu_internal_subdevs failed with %d\n", ret);
 		goto cleanup;
 	}
 
@@ -491,7 +491,7 @@ static int imx_media_probe(struct platform_device *pdev)
 	return 0;
 
 del_int:
-	imx_media_remove_internal_subdevs(imxmd);
+	imx_media_remove_ipu_internal_subdevs(imxmd);
 cleanup:
 	v4l2_async_notifier_cleanup(&imxmd->notifier);
 	v4l2_device_unregister(&imxmd->v4l2_dev);
@@ -508,7 +508,7 @@ static int imx_media_remove(struct platform_device *pdev)
 	v4l2_info(&imxmd->v4l2_dev, "Removing imx-media\n");
 
 	v4l2_async_notifier_unregister(&imxmd->notifier);
-	imx_media_remove_internal_subdevs(imxmd);
+	imx_media_remove_ipu_internal_subdevs(imxmd);
 	v4l2_async_notifier_cleanup(&imxmd->notifier);
 	media_device_unregister(&imxmd->md);
 	v4l2_device_unregister(&imxmd->v4l2_dev);
diff --git a/drivers/staging/media/imx/imx-media-internal-sd.c b/drivers/staging/media/imx/imx-media-internal-sd.c
index 5e10d95e5529..e620f4adb755 100644
--- a/drivers/staging/media/imx/imx-media-internal-sd.c
+++ b/drivers/staging/media/imx/imx-media-internal-sd.c
@@ -1,7 +1,7 @@
 /*
  * Media driver for Freescale i.MX5/6 SOC
  *
- * Adds the internal subdevices and the media links between them.
+ * Adds the IPU internal subdevices and the media links between them.
  *
  * Copyright (c) 2016 Mentor Graphics Inc.
  *
@@ -192,7 +192,7 @@ static struct v4l2_subdev *find_sink(struct imx_media_dev *imxmd,
 
 	/*
 	 * retrieve IPU id from subdev name, note: can't get this from
-	 * struct imx_media_internal_sd_platformdata because if src is
+	 * struct imx_media_ipu_internal_sd_pdata because if src is
 	 * a CSI, it has different struct ipu_client_platformdata which
 	 * does not contain IPU id.
 	 */
@@ -270,7 +270,7 @@ static int add_internal_subdev(struct imx_media_dev *imxmd,
 			       const struct internal_subdev *isd,
 			       int ipu_id)
 {
-	struct imx_media_internal_sd_platformdata pdata;
+	struct imx_media_ipu_internal_sd_pdata pdata;
 	struct platform_device_info pdevinfo = {};
 	struct platform_device *pdev;
 
@@ -328,7 +328,7 @@ static int add_ipu_internal_subdevs(struct imx_media_dev *imxmd, int ipu_id)
 	return 0;
 }
 
-int imx_media_add_internal_subdevs(struct imx_media_dev *imxmd)
+int imx_media_add_ipu_internal_subdevs(struct imx_media_dev *imxmd)
 {
 	int ret;
 
@@ -343,11 +343,11 @@ int imx_media_add_internal_subdevs(struct imx_media_dev *imxmd)
 	return 0;
 
 remove:
-	imx_media_remove_internal_subdevs(imxmd);
+	imx_media_remove_ipu_internal_subdevs(imxmd);
 	return ret;
 }
 
-void imx_media_remove_internal_subdevs(struct imx_media_dev *imxmd)
+void imx_media_remove_ipu_internal_subdevs(struct imx_media_dev *imxmd)
 {
 	struct imx_media_async_subdev *imxasd;
 	struct v4l2_async_subdev *asd;
diff --git a/drivers/staging/media/imx/imx-media-vdic.c b/drivers/staging/media/imx/imx-media-vdic.c
index 2808662e2597..8a9af4688fd4 100644
--- a/drivers/staging/media/imx/imx-media-vdic.c
+++ b/drivers/staging/media/imx/imx-media-vdic.c
@@ -934,7 +934,7 @@ static const struct v4l2_subdev_internal_ops vdic_internal_ops = {
 
 static int imx_vdic_probe(struct platform_device *pdev)
 {
-	struct imx_media_internal_sd_platformdata *pdata;
+	struct imx_media_ipu_internal_sd_pdata *pdata;
 	struct vdic_priv *priv;
 	int ret;
 
diff --git a/drivers/staging/media/imx/imx-media.h b/drivers/staging/media/imx/imx-media.h
index ae964c8d5be1..ccbfc4438c85 100644
--- a/drivers/staging/media/imx/imx-media.h
+++ b/drivers/staging/media/imx/imx-media.h
@@ -115,7 +115,7 @@ struct imx_media_pad_vdev {
 	struct list_head list;
 };
 
-struct imx_media_internal_sd_platformdata {
+struct imx_media_ipu_internal_sd_pdata {
 	char sd_name[V4L2_SUBDEV_NAME_SIZE];
 	u32 grp_id;
 	int ipu_id;
@@ -252,10 +252,10 @@ struct imx_media_fim *imx_media_fim_init(struct v4l2_subdev *sd);
 void imx_media_fim_free(struct imx_media_fim *fim);
 
 /* imx-media-internal-sd.c */
-int imx_media_add_internal_subdevs(struct imx_media_dev *imxmd);
+int imx_media_add_ipu_internal_subdevs(struct imx_media_dev *imxmd);
 int imx_media_create_ipu_internal_links(struct imx_media_dev *imxmd,
 					struct v4l2_subdev *sd);
-void imx_media_remove_internal_subdevs(struct imx_media_dev *imxmd);
+void imx_media_remove_ipu_internal_subdevs(struct imx_media_dev *imxmd);
 
 /* imx-media-of.c */
 int imx_media_add_of_subdevs(struct imx_media_dev *dev,
-- 
2.17.1

