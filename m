Return-Path: <SRS0=G3Vt=RO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFDA2C43381
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 05:34:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87A752075C
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 05:34:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oeOhE5Pg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725823AbfCKFev (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Mar 2019 01:34:51 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:37475 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725770AbfCKFeu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Mar 2019 01:34:50 -0400
Received: by mail-qt1-f194.google.com with SMTP id z17so3763134qtn.4
        for <linux-media@vger.kernel.org>; Sun, 10 Mar 2019 22:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Eqjq30kzRSGqfL9HUMZBZUvQ3NAmv9Lm5hbIlUN5W9Y=;
        b=oeOhE5Pgaat0ZPM6wEvig4Ug6+TBbUKnC5VHaR/gMr8ES10nDGSzH/5zNiqCuIvcS8
         /+KxqBj7PYTBGZb4ABszHCLIIgsn838MBlaedtmohOVxvK50VfTDzyK6rwty47OkIhNS
         YpSq0dJeSYmQrZUHd/woTI1EKw8DzemqviSxcgqZXIEJ1EfModW/HzcHSsbtdSSpuFPS
         VArHo/jFm65HCgk9kvqJBgNMJka2BTfUfRhSBamA9H6+5WArE/a8zF37Mggdig+XCcqc
         8V205F3Q4/3o+8jVtYHNtbOzYl47Zo99XVQp1p3XT+nuOTGRY56M4xO/V7w4zF3qs6X9
         OMew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Eqjq30kzRSGqfL9HUMZBZUvQ3NAmv9Lm5hbIlUN5W9Y=;
        b=MSrimOobQrYrGM22xo1Z/SgReZFVfpIFEkd492PBznLgwQ9gepa2I+mQhWQVTJwyPQ
         cNxCdr5Z6WPd/q8ccRBx+UKgl6QloQRMtfKlTF2q8NAzeF6hDaN9ztcBAAcC/wcD/qPM
         ImZ3Ep9/G976glmz93AJvtBFhHPdpGnGW70mj17awuHyfgZtZI03K4N+3bYadpeeIgka
         qJ1dyw44wgA112h055o9XOYB2qOTMlZVbjKINTC6jxyStC2cXhFI5cDWVEHK0ufjlplp
         XC1fL/ZDwfaFaoX/KmnZggoUgQOzbzR7pFW7HzeIDhwqTYoog5TF1tjF+SqKWgEZdSKq
         s2tQ==
X-Gm-Message-State: APjAAAVS17a26kLTVHpLvwPEK/pxnD7YU3R+4DAJShBbzphzwj9EOByc
        /CZk3bxsOgcTZBnPFE27DfIdRrh4
X-Google-Smtp-Source: APXvYqyFfIM51bb53vCbbOdU7hbc/pn3VSoQOeObAw9M5YAyz3cG6wJ90OvZ5clvJgn2m1Nc/m3xfw==
X-Received: by 2002:ac8:2cd6:: with SMTP id 22mr12438538qtx.112.1552282489752;
        Sun, 10 Mar 2019 22:34:49 -0700 (PDT)
Received: from Elysium.fibertel.com.ar ([181.164.130.177])
        by smtp.gmail.com with ESMTPSA id c7sm62988qth.46.2019.03.10.22.34.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 10 Mar 2019 22:34:49 -0700 (PDT)
From:   Lucas Leonardo Ciancaglini <leociancalucas@gmail.com>
To:     p.zabel@pengutronix.de
Cc:     linux-media@vger.kernel.org,
        Lucas Leonardo Ciancaglini <leociancalucas@gmail.com>
Subject: [PATCH] media: staging/imx: Fix inconsistent long line breaks
Date:   Mon, 11 Mar 2019 02:34:38 -0300
Message-Id: <20190311053438.22445-1-leociancalucas@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Small readability changes to make the breaking of some lines
cleaner.

Signed-off-by: Lucas Leonardo Ciancaglini <leociancalucas@gmail.com>
---
 drivers/staging/media/imx/imx-media-dev.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
index 28a3d23aad5b..3c76d9814374 100644
--- a/drivers/staging/media/imx/imx-media-dev.c
+++ b/drivers/staging/media/imx/imx-media-dev.c
@@ -50,12 +50,14 @@ int imx_media_add_async_subdev(struct imx_media_dev *imxmd,
 	int ret;
 
 	if (fwnode) {
-		asd = v4l2_async_notifier_add_fwnode_subdev(
-			&imxmd->notifier, fwnode, sizeof(*imxasd));
+		asd = v4l2_async_notifier_add_fwnode_subdev(&imxmd->notifier,
+							    fwnode,
+							    sizeof(*imxasd));
 	} else {
 		devname = dev_name(&pdev->dev);
-		asd = v4l2_async_notifier_add_devname_subdev(
-			&imxmd->notifier, devname, sizeof(*imxasd));
+		asd = v4l2_async_notifier_add_devname_subdev(&imxmd->notifier,
+							     devname,
+							     sizeof(*imxasd));
 	}
 
 	if (IS_ERR(asd)) {
@@ -266,10 +268,9 @@ static int imx_media_alloc_pad_vdev_lists(struct imx_media_dev *imxmd)
 
 	list_for_each_entry(sd, &imxmd->v4l2_dev.subdevs, list) {
 		entity = &sd->entity;
-		vdev_lists = devm_kcalloc(
-			imxmd->md.dev,
-			entity->num_pads, sizeof(*vdev_lists),
-			GFP_KERNEL);
+		vdev_lists = devm_kcalloc(imxmd->md.dev,
+					  entity->num_pads, sizeof(*vdev_lists),
+					  GFP_KERNEL);
 		if (!vdev_lists)
 			return -ENOMEM;
 
-- 
2.21.0

