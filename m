Return-Path: <SRS0=tJec=Q3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCFF9C43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 23:53:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81A242089F
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 23:53:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ExAQkxES"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbfBTXxr (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Feb 2019 18:53:47 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42592 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbfBTXxq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Feb 2019 18:53:46 -0500
Received: by mail-pg1-f195.google.com with SMTP id b2so7007775pgl.9;
        Wed, 20 Feb 2019 15:53:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=R8xwaSl0ZhiNpJHuoTqTqV7m61d58ZGc33VmhSE032E=;
        b=ExAQkxES/2S67eRw7KvCY9BZys7nmMc589Amz3IZQxBV6MpXZk/yrn+9l9MI7yQzvn
         neIC5jUQH37OQLGNhtkZsQ0ErfGqnYmDrFww0kg1w3i+n4drsPq1OU36Q2B2tHgmpANG
         izjNVql1A0JA4OFp0YMsN9VqD1k2BhHSgA+Cj8BnnSAIAa5po0Cxzsv7TALUj+ZZWLFi
         1hYTx2cJsKHJVafJkjAnrL+xPvtEpQDMPPnSp05S7jB2ZmvJBnAueSB5Op6MYyVGjPTP
         /ZzWCa2ORts5+ANqzZA4fYhJX4l3xwG4plT0Q/DsEewLPNyJ0J0+60OD1txllk76CWgQ
         x8Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=R8xwaSl0ZhiNpJHuoTqTqV7m61d58ZGc33VmhSE032E=;
        b=bZaRmpDRz60UsPEr4tMpo79VczqzajsfR45m18ajwbq0zFfX739uPht3AuODEFiGKp
         TU+gKFlm7XfodF0VfP61QSQcLk73hxgsGzpQuozeVeBxlGjY8rzTqDDjw1LeRthK/JSb
         zWQVKh2uixyYccUvlTdzrXwQLKLrOwIPqIIn5bSrN1OMjAfDGHRsO7nUjixzy0rpFLgz
         FsfSHgVMFpwvgwaBpEmwLiF8fwq/h1QVR9G0Hn/t5uqicpJqrgTL6ZjOepANQZVJ7LUi
         i1NBvci3HgoAtkJSGnqKb9AEfal2Ko6/2MhJq720bRHVPUrV4UmJcKY/PnewwZjVG75l
         XknQ==
X-Gm-Message-State: AHQUAuaoHtIm0506XhW6ezLpiNIQGbeUYegXbO2l1Qqmcq+0kmIlwTVo
        URU1roojX71rraH3FZCA/S73UPdo
X-Google-Smtp-Source: AHgI3IYmG4G3Al1LCY9JvKTI8OCrdeF0i4RT25alz7tY3JubqvowTeqs5qyqiLA/vrjQSqzyCki2ew==
X-Received: by 2002:a63:9dc3:: with SMTP id i186mr35345694pgd.305.1550706824963;
        Wed, 20 Feb 2019 15:53:44 -0800 (PST)
Received: from majic.sklembedded.com (c-73-202-231-77.hsd1.ca.comcast.net. [73.202.231.77])
        by smtp.googlemail.com with ESMTPSA id v15sm25530158pgf.75.2019.02.20.15.53.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Feb 2019 15:53:44 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>, stable@vger.kernel.org,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 4/4] media: imx: Don't register IPU subdevs/links if CSI port missing
Date:   Wed, 20 Feb 2019 15:53:32 -0800
Message-Id: <20190220235332.15984-5-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190220235332.15984-1-slongerbeam@gmail.com>
References: <20190220235332.15984-1-slongerbeam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The second IPU internal sub-devices were being registered and links
to them created even when the second IPU is not present. This is wrong
for i.MX6 S/DL and i.MX53 which have only a single IPU.

Fixes: e130291212df5 ("[media] media: Add i.MX media core driver")

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Cc: stable@vger.kernel.org
---
 drivers/staging/media/imx/imx-media-dev.c     |  7 ---
 .../staging/media/imx/imx-media-internal-sd.c | 22 ++-----
 drivers/staging/media/imx/imx-media-of.c      | 58 +++++++++++++------
 drivers/staging/media/imx/imx-media.h         |  3 +-
 drivers/staging/media/imx/imx7-media-csi.c    |  2 +-
 5 files changed, 46 insertions(+), 46 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
index fc35508d9396..10a63a4fa90b 100644
--- a/drivers/staging/media/imx/imx-media-dev.c
+++ b/drivers/staging/media/imx/imx-media-dev.c
@@ -477,13 +477,6 @@ static int imx_media_probe(struct platform_device *pdev)
 		goto cleanup;
 	}
 
-	ret = imx_media_add_ipu_internal_subdevs(imxmd);
-	if (ret) {
-		v4l2_err(&imxmd->v4l2_dev,
-			 "add_ipu_internal_subdevs failed with %d\n", ret);
-		goto cleanup;
-	}
-
 	ret = imx_media_dev_notifier_register(imxmd);
 	if (ret)
 		goto del_int;
diff --git a/drivers/staging/media/imx/imx-media-internal-sd.c b/drivers/staging/media/imx/imx-media-internal-sd.c
index e620f4adb755..dc510dcfe160 100644
--- a/drivers/staging/media/imx/imx-media-internal-sd.c
+++ b/drivers/staging/media/imx/imx-media-internal-sd.c
@@ -298,13 +298,14 @@ static int add_internal_subdev(struct imx_media_dev *imxmd,
 }
 
 /* adds the internal subdevs in one ipu */
-static int add_ipu_internal_subdevs(struct imx_media_dev *imxmd, int ipu_id)
+int imx_media_add_ipu_internal_subdevs(struct imx_media_dev *imxmd,
+				       int ipu_id)
 {
 	enum isd_enum i;
+	int ret;
 
 	for (i = 0; i < num_isd; i++) {
 		const struct internal_subdev *isd = &int_subdev[i];
-		int ret;
 
 		/*
 		 * the CSIs are represented in the device-tree, so those
@@ -322,25 +323,10 @@ static int add_ipu_internal_subdevs(struct imx_media_dev *imxmd, int ipu_id)
 		}
 
 		if (ret)
-			return ret;
+			goto remove;
 	}
 
 	return 0;
-}
-
-int imx_media_add_ipu_internal_subdevs(struct imx_media_dev *imxmd)
-{
-	int ret;
-
-	ret = add_ipu_internal_subdevs(imxmd, 0);
-	if (ret)
-		goto remove;
-
-	ret = add_ipu_internal_subdevs(imxmd, 1);
-	if (ret)
-		goto remove;
-
-	return 0;
 
 remove:
 	imx_media_remove_ipu_internal_subdevs(imxmd);
diff --git a/drivers/staging/media/imx/imx-media-of.c b/drivers/staging/media/imx/imx-media-of.c
index a26bdeb1af34..12383f4785ad 100644
--- a/drivers/staging/media/imx/imx-media-of.c
+++ b/drivers/staging/media/imx/imx-media-of.c
@@ -23,36 +23,25 @@
 int imx_media_of_add_csi(struct imx_media_dev *imxmd,
 			 struct device_node *csi_np)
 {
-	int ret;
-
 	if (!of_device_is_available(csi_np)) {
 		dev_dbg(imxmd->md.dev, "%s: %pOFn not enabled\n", __func__,
 			csi_np);
-		/* unavailable is not an error */
-		return 0;
+		return -ENODEV;
 	}
 
 	/* add CSI fwnode to async notifier */
-	ret = imx_media_add_async_subdev(imxmd, of_fwnode_handle(csi_np), NULL);
-	if (ret) {
-		if (ret == -EEXIST) {
-			/* already added, everything is fine */
-			return 0;
-		}
-
-		/* other error, can't continue */
-		return ret;
-	}
-
-	return 0;
+	return imx_media_add_async_subdev(imxmd, of_fwnode_handle(csi_np),
+					  NULL);
 }
 EXPORT_SYMBOL_GPL(imx_media_of_add_csi);
 
 int imx_media_add_of_subdevs(struct imx_media_dev *imxmd,
 			     struct device_node *np)
 {
+	bool ipu_found[2] = {false, false};
 	struct device_node *csi_np;
 	int i, ret;
+	u32 ipu_id;
 
 	for (i = 0; ; i++) {
 		csi_np = of_parse_phandle(np, "ports", i);
@@ -60,12 +49,43 @@ int imx_media_add_of_subdevs(struct imx_media_dev *imxmd,
 			break;
 
 		ret = imx_media_of_add_csi(imxmd, csi_np);
-		of_node_put(csi_np);
-		if (ret)
-			return ret;
+		if (ret) {
+			/* unavailable or already added is not an error */
+			if (ret == -ENODEV || ret == -EEXIST) {
+				of_node_put(csi_np);
+				continue;
+			}
+
+			/* other error, can't continue */
+			goto err_out;
+		}
+
+		ret = of_alias_get_id(csi_np->parent, "ipu");
+		if (ret < 0)
+			goto err_out;
+		if (ret > 1) {
+			ret = -EINVAL;
+			goto err_out;
+		}
+
+		ipu_id = ret;
+
+		if (!ipu_found[ipu_id]) {
+			ret = imx_media_add_ipu_internal_subdevs(imxmd,
+								 ipu_id);
+			if (ret)
+				goto err_out;
+		}
+
+		ipu_found[ipu_id] = true;
 	}
 
 	return 0;
+
+err_out:
+	imx_media_remove_ipu_internal_subdevs(imxmd);
+	of_node_put(csi_np);
+	return ret;
 }
 
 /*
diff --git a/drivers/staging/media/imx/imx-media.h b/drivers/staging/media/imx/imx-media.h
index ccbfc4438c85..dd603a6b3a70 100644
--- a/drivers/staging/media/imx/imx-media.h
+++ b/drivers/staging/media/imx/imx-media.h
@@ -252,7 +252,8 @@ struct imx_media_fim *imx_media_fim_init(struct v4l2_subdev *sd);
 void imx_media_fim_free(struct imx_media_fim *fim);
 
 /* imx-media-internal-sd.c */
-int imx_media_add_ipu_internal_subdevs(struct imx_media_dev *imxmd);
+int imx_media_add_ipu_internal_subdevs(struct imx_media_dev *imxmd,
+				       int ipu_id);
 int imx_media_create_ipu_internal_links(struct imx_media_dev *imxmd,
 					struct v4l2_subdev *sd);
 void imx_media_remove_ipu_internal_subdevs(struct imx_media_dev *imxmd);
diff --git a/drivers/staging/media/imx/imx7-media-csi.c b/drivers/staging/media/imx/imx7-media-csi.c
index 3fba7c27c0ec..1ba62fcdcae8 100644
--- a/drivers/staging/media/imx/imx7-media-csi.c
+++ b/drivers/staging/media/imx/imx7-media-csi.c
@@ -1271,7 +1271,7 @@ static int imx7_csi_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, &csi->sd);
 
 	ret = imx_media_of_add_csi(imxmd, node);
-	if (ret < 0)
+	if (ret < 0 && ret != -ENODEV && ret != -EEXIST)
 		goto cleanup;
 
 	ret = imx_media_dev_notifier_register(imxmd);
-- 
2.17.1

