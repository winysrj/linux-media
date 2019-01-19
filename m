Return-Path: <SRS0=jH9h=P3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36827C61CE4
	for <linux-media@archiver.kernel.org>; Sat, 19 Jan 2019 21:46:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E85BD2084C
	for <linux-media@archiver.kernel.org>; Sat, 19 Jan 2019 21:46:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ad9MiAc8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729820AbfASVqW (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 19 Jan 2019 16:46:22 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33151 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729793AbfASVqU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 19 Jan 2019 16:46:20 -0500
Received: by mail-wm1-f65.google.com with SMTP id r24so3443349wmh.0;
        Sat, 19 Jan 2019 13:46:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RmgzoA4J0dAtqBeEiwAlBbV0PSmV+fxJTTx9iib3O40=;
        b=Ad9MiAc8QGcupTnQo+R0LCmw1aHUtmtA1IqInPAHRYaUgiNAZwTxKXOu+i3ggit30U
         WWOMrjw+2nDMOeilytXV449UTia9NgN7x3Iiy6aPATlZElaT8kZ9Sr1VF4YUqC35+wTW
         gHETiizoaNEPBHM0bs2rFmIyJnger801aFYtdERigTcK0Bjd/9tY5xmZtPuqr5UtRP0O
         LTtSNmGfiEKgNCT8XzmME+EssC/kR1ef4YgXHVZNmUmFivuuOk8cUc/JH1CwKVD2cfux
         CMj4UlxLM7FyZlgOl42BsCI+gPBkFt8tm0SV4RlOwdnaHI0rDR1lggDQ4B4UEJgd6uMj
         49oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RmgzoA4J0dAtqBeEiwAlBbV0PSmV+fxJTTx9iib3O40=;
        b=Yyp5c6du0rDETkXDM9pIuNRmQNPyjWbnNKPwvL4dGlZE7XuIhaKtEQq1ysdL9DCpn8
         HXfANxNxlee+L5XS3Etoo6eHgn2wmqW5F7aTOQQeqXsN+ou2SVprSkiOREy726qE5U5F
         tWyd/zWd1F08JJ+fV5f8dERBBDMrvtWNRaaiPMvOacD2cLfCo8XczUyus2mS2yxi28oZ
         Pn/9ouVVoXprRGitJCZfp1d9tncZz2b5kOnZO/pgqSt6FT24yxL54jrooZat6tRGDdTf
         bcQOKhNK1Zdk9E79aDeoG+CmOvGxgylQhFEabJoBRzcTfOX/zwtfzpRBBNGI85+1KRZQ
         pM1g==
X-Gm-Message-State: AJcUukeaNbpolTKkywCA6COumphSYhQ9TpIKocbpFhFDuY4WVi5n5vFu
        gT7Q1/WI64hSRxvePJzaIH4D2RDK
X-Google-Smtp-Source: ALg8bN4kcOOjB85vwezKZZsAPF6RoFwIhZi0oZRR+Oq/nxfbqMdX6Oa7576x69JOe9UWraHv821iQw==
X-Received: by 2002:a1c:96ce:: with SMTP id y197mr20453077wmd.36.1547934377192;
        Sat, 19 Jan 2019 13:46:17 -0800 (PST)
Received: from mappy.world.mentorg.com (sjewanfw1-nat.mentorg.com. [139.181.7.34])
        by smtp.gmail.com with ESMTPSA id o5sm26432048wrw.46.2019.01.19.13.46.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 19 Jan 2019 13:46:16 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>, stable@vger.kernel.org,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 3/4] media: imx: Rename functions that add IPU-internal subdevs/links
Date:   Sat, 19 Jan 2019 13:45:59 -0800
Message-Id: <20190119214600.30897-4-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190119214600.30897-1-slongerbeam@gmail.com>
References: <20190119214600.30897-1-slongerbeam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

For the functions that add and remove the internal IPU subdevice
descriptors and links between them, rename them to make clear they
are the subdevs and links internal to the IPU. Also rename the
platform data structure for the internal IPU subdevices.
No functional changes.

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
Cc: stable@vger.kernel.org
---
 drivers/staging/media/imx/imx-ic-common.c        |  2 +-
 drivers/staging/media/imx/imx-media-dev.c        | 10 +++++-----
 .../staging/media/imx/imx-media-internal-sd.c    | 16 ++++++++--------
 drivers/staging/media/imx/imx-media-vdic.c       |  2 +-
 drivers/staging/media/imx/imx-media.h            | 10 +++++-----
 5 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/media/imx/imx-ic-common.c b/drivers/staging/media/imx/imx-ic-common.c
index cfdd4900a3be..94dc5d88a069 100644
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
index 4b344a4a3706..edf9c80bbbc8 100644
--- a/drivers/staging/media/imx/imx-media-dev.c
+++ b/drivers/staging/media/imx/imx-media-dev.c
@@ -155,7 +155,7 @@ static int imx_media_create_links(struct v4l2_async_notifier *notifier)
 		case IMX_MEDIA_GRP_ID_IC_PRPVF:
 		case IMX_MEDIA_GRP_ID_CSI0:
 		case IMX_MEDIA_GRP_ID_CSI1:
-			ret = imx_media_create_internal_links(imxmd, sd);
+			ret = imx_media_create_ipu_internal_links(imxmd, sd);
 			if (ret)
 				return ret;
 			/*
@@ -487,10 +487,10 @@ static int imx_media_probe(struct platform_device *pdev)
 		goto notifier_cleanup;
 	}
 
-	ret = imx_media_add_internal_subdevs(imxmd);
+	ret = imx_media_add_ipu_internal_subdevs(imxmd);
 	if (ret) {
 		v4l2_err(&imxmd->v4l2_dev,
-			 "add_internal_subdevs failed with %d\n", ret);
+			 "add_ipu_internal_subdevs failed with %d\n", ret);
 		goto notifier_cleanup;
 	}
 
@@ -513,7 +513,7 @@ static int imx_media_probe(struct platform_device *pdev)
 	return 0;
 
 del_int:
-	imx_media_remove_internal_subdevs(imxmd);
+	imx_media_remove_ipu_internal_subdevs(imxmd);
 notifier_cleanup:
 	v4l2_async_notifier_cleanup(&imxmd->notifier);
 	v4l2_device_unregister(&imxmd->v4l2_dev);
@@ -530,7 +530,7 @@ static int imx_media_remove(struct platform_device *pdev)
 	v4l2_info(&imxmd->v4l2_dev, "Removing imx-media\n");
 
 	v4l2_async_notifier_unregister(&imxmd->notifier);
-	imx_media_remove_internal_subdevs(imxmd);
+	imx_media_remove_ipu_internal_subdevs(imxmd);
 	v4l2_async_notifier_cleanup(&imxmd->notifier);
 	v4l2_device_unregister(&imxmd->v4l2_dev);
 	media_device_unregister(&imxmd->md);
diff --git a/drivers/staging/media/imx/imx-media-internal-sd.c b/drivers/staging/media/imx/imx-media-internal-sd.c
index 0fdc45dbfb76..b8e763dbbecb 100644
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
@@ -229,8 +229,8 @@ static int create_ipu_internal_link(struct imx_media_dev *imxmd,
 	return ret;
 }
 
-int imx_media_create_internal_links(struct imx_media_dev *imxmd,
-				    struct v4l2_subdev *sd)
+int imx_media_create_ipu_internal_links(struct imx_media_dev *imxmd,
+					struct v4l2_subdev *sd)
 {
 	const struct internal_subdev *intsd;
 	const struct internal_pad *intpad;
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
index 4a890714193e..efd2e028a098 100644
--- a/drivers/staging/media/imx/imx-media-vdic.c
+++ b/drivers/staging/media/imx/imx-media-vdic.c
@@ -931,7 +931,7 @@ static const struct v4l2_subdev_internal_ops vdic_internal_ops = {
 
 static int imx_vdic_probe(struct platform_device *pdev)
 {
-	struct imx_media_internal_sd_platformdata *pdata;
+	struct imx_media_ipu_internal_sd_pdata *pdata;
 	struct vdic_priv *priv;
 	int ret;
 
diff --git a/drivers/staging/media/imx/imx-media.h b/drivers/staging/media/imx/imx-media.h
index bc7feb81937c..0f915baeac8a 100644
--- a/drivers/staging/media/imx/imx-media.h
+++ b/drivers/staging/media/imx/imx-media.h
@@ -113,7 +113,7 @@ struct imx_media_pad_vdev {
 	struct list_head list;
 };
 
-struct imx_media_internal_sd_platformdata {
+struct imx_media_ipu_internal_sd_pdata {
 	char sd_name[V4L2_SUBDEV_NAME_SIZE];
 	u32 grp_id;
 	int ipu_id;
@@ -237,10 +237,10 @@ struct imx_media_fim *imx_media_fim_init(struct v4l2_subdev *sd);
 void imx_media_fim_free(struct imx_media_fim *fim);
 
 /* imx-media-internal-sd.c */
-int imx_media_add_internal_subdevs(struct imx_media_dev *imxmd);
-int imx_media_create_internal_links(struct imx_media_dev *imxmd,
-				    struct v4l2_subdev *sd);
-void imx_media_remove_internal_subdevs(struct imx_media_dev *imxmd);
+int imx_media_add_ipu_internal_subdevs(struct imx_media_dev *imxmd);
+int imx_media_create_ipu_internal_links(struct imx_media_dev *imxmd,
+					struct v4l2_subdev *sd);
+void imx_media_remove_ipu_internal_subdevs(struct imx_media_dev *imxmd);
 
 /* imx-media-of.c */
 int imx_media_add_of_subdevs(struct imx_media_dev *dev,
-- 
2.17.1

