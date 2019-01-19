Return-Path: <SRS0=jH9h=P3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEB13C6369F
	for <linux-media@archiver.kernel.org>; Sat, 19 Jan 2019 21:46:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CD912087E
	for <linux-media@archiver.kernel.org>; Sat, 19 Jan 2019 21:46:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gbCg5ayo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729883AbfASVqZ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 19 Jan 2019 16:46:25 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54164 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729815AbfASVqX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 19 Jan 2019 16:46:23 -0500
Received: by mail-wm1-f66.google.com with SMTP id d15so7552770wmb.3;
        Sat, 19 Jan 2019 13:46:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ZUDsAPnEhnt2k1sb+3yEFqAh+mhoQp14vu2KJMqARhE=;
        b=gbCg5ayohpLSfevNgyFHpr7IWdCpWAUqjKnSe8Z2vXszHkhGEiagfCV6NdNKXb+YMC
         wi78+C/rZMyJuFtyTPXjOmkvvtVBF+yR4Vj973Uo9iRMlgv+i6jR09XIozZKlifAy97k
         I66iTC6AdETpbCR5tsSgWoBP5Nw1UqYMH0XHSsEdOAEKrEuneEeLL15r9vfYIjLf9RVK
         ImZNvoKPtHUw0CMc24sujQRvTg/J80LrKTieERjwQpJtJtg+k/NGpUW248fON9bl4DMO
         VLw5+whjItOr8m1P/dL0+Kh3G3DfSM7rTt+0ALIVnF36Z4NZiNPxEVSNuCqKba7AnMMF
         0nzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ZUDsAPnEhnt2k1sb+3yEFqAh+mhoQp14vu2KJMqARhE=;
        b=ISr4kpLs2OHqweS6r5mLbCshXN4GsQhMXfT0dov5K+OaWQXbx79vb9j5UFDUFPYRrh
         JovI1Y62fnA65xn0fvlVUdG/sK1hmfo+d3qSOb8IzMwKQKZqwiCzpCWeGsndhYdDmJZd
         9VJKIEONn4+qVrY+TRtOb00m1bi6waAQ4Ab0/ut15n3ZVx00hBuKdkZpkjWexA3uka7a
         pyDnZ7sDBZ4hzpenihCBVzYAWPqXM5ItzFovmIZ/UwYQYzea3cyB0SdzKfsfX8vqaQ/w
         knHu7NmdWRXqnTrWEupCpC2xa95z24TFt4tzdgJQtB1Smm5vPThqFrDu530JGWNePpPI
         w3mA==
X-Gm-Message-State: AJcUukcD8KCa62WQmbP1+MvW29MdCAfXA0CBhdC4HjgfsDaCXNhVGo8O
        fKtWi6j7n9+1AurbqXLLEP9WQej1
X-Google-Smtp-Source: ALg8bN7tdNevzgFC40n1LOkOj3USMtk2DuZ9ZFG3/IitXOetjgBS9DiVQsb1kLrbZ48NEaYR1zFL5A==
X-Received: by 2002:a7b:c7c2:: with SMTP id z2mr18950353wmk.47.1547934380333;
        Sat, 19 Jan 2019 13:46:20 -0800 (PST)
Received: from mappy.world.mentorg.com (sjewanfw1-nat.mentorg.com. [139.181.7.34])
        by smtp.gmail.com with ESMTPSA id o5sm26432048wrw.46.2019.01.19.13.46.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 19 Jan 2019 13:46:19 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>, stable@vger.kernel.org,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 4/4] media: imx: Don't register IPU subdevs/links if CSI port missing
Date:   Sat, 19 Jan 2019 13:46:00 -0800
Message-Id: <20190119214600.30897-5-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190119214600.30897-1-slongerbeam@gmail.com>
References: <20190119214600.30897-1-slongerbeam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The second IPU internal sub-devices were being registered and links
to them created even when the second IPU is not present. This is wrong
for i.MX6 S/DL and i.MX53 which have only a single IPU.

Fixes: e130291212df5 ("[media] media: Add i.MX media core driver")

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
Cc: stable@vger.kernel.org
---
 drivers/staging/media/imx/imx-media-dev.c     |  7 --
 .../staging/media/imx/imx-media-internal-sd.c | 22 +-----
 drivers/staging/media/imx/imx-media-of.c      | 76 ++++++++++++-------
 drivers/staging/media/imx/imx-media.h         |  3 +-
 4 files changed, 53 insertions(+), 55 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
index edf9c80bbbc8..924166cf957b 100644
--- a/drivers/staging/media/imx/imx-media-dev.c
+++ b/drivers/staging/media/imx/imx-media-dev.c
@@ -487,13 +487,6 @@ static int imx_media_probe(struct platform_device *pdev)
 		goto notifier_cleanup;
 	}
 
-	ret = imx_media_add_ipu_internal_subdevs(imxmd);
-	if (ret) {
-		v4l2_err(&imxmd->v4l2_dev,
-			 "add_ipu_internal_subdevs failed with %d\n", ret);
-		goto notifier_cleanup;
-	}
-
 	/* no subdevs? just bail */
 	if (list_empty(&imxmd->notifier.asd_list)) {
 		ret = -ENODEV;
diff --git a/drivers/staging/media/imx/imx-media-internal-sd.c b/drivers/staging/media/imx/imx-media-internal-sd.c
index b8e763dbbecb..3811c12d475b 100644
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
index 2da81a5af274..32ed1a99813f 100644
--- a/drivers/staging/media/imx/imx-media-of.c
+++ b/drivers/staging/media/imx/imx-media-of.c
@@ -20,50 +20,68 @@
 #include <video/imx-ipu-v3.h>
 #include "imx-media.h"
 
-static int of_add_csi(struct imx_media_dev *imxmd, struct device_node *csi_np)
-{
-	int ret;
-
-	if (!of_device_is_available(csi_np)) {
-		dev_dbg(imxmd->md.dev, "%s: %pOFn not enabled\n", __func__,
-			csi_np);
-		/* unavailable is not an error */
-		return 0;
-	}
-
-	/* add CSI fwnode to async notifier */
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
-}
-
 int imx_media_add_of_subdevs(struct imx_media_dev *imxmd,
 			     struct device_node *np)
 {
+	bool ipu_found[2] = {false, false};
 	struct device_node *csi_np;
 	int i, ret;
+	u32 ipu_id;
 
 	for (i = 0; ; i++) {
 		csi_np = of_parse_phandle(np, "ports", i);
 		if (!csi_np)
 			break;
 
-		ret = of_add_csi(imxmd, csi_np);
+		if (!of_device_is_available(csi_np)) {
+			/* ignore this CSI if not available */
+			of_node_put(csi_np);
+			continue;
+		}
+
+		/* add CSI fwnode to async notifier */
+		ret = imx_media_add_async_subdev(imxmd,
+						 of_fwnode_handle(csi_np),
+						 NULL);
+		if (ret) {
+			if (ret == -EEXIST) {
+				/* already added, everything is fine */
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
+
 		of_node_put(csi_np);
-		if (ret)
-			return ret;
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
index 0f915baeac8a..d2432b8ab67d 100644
--- a/drivers/staging/media/imx/imx-media.h
+++ b/drivers/staging/media/imx/imx-media.h
@@ -237,7 +237,8 @@ struct imx_media_fim *imx_media_fim_init(struct v4l2_subdev *sd);
 void imx_media_fim_free(struct imx_media_fim *fim);
 
 /* imx-media-internal-sd.c */
-int imx_media_add_ipu_internal_subdevs(struct imx_media_dev *imxmd);
+int imx_media_add_ipu_internal_subdevs(struct imx_media_dev *imxmd,
+				       int ipu_id);
 int imx_media_create_ipu_internal_links(struct imx_media_dev *imxmd,
 					struct v4l2_subdev *sd);
 void imx_media_remove_ipu_internal_subdevs(struct imx_media_dev *imxmd);
-- 
2.17.1

