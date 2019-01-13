Return-Path: <SRS0=qapk=PV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 097ACC43387
	for <linux-media@archiver.kernel.org>; Sun, 13 Jan 2019 23:38:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C50042089F
	for <linux-media@archiver.kernel.org>; Sun, 13 Jan 2019 23:38:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qr3clMIc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbfAMXit (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 13 Jan 2019 18:38:49 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:34886 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726598AbfAMXis (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 13 Jan 2019 18:38:48 -0500
Received: by mail-io1-f68.google.com with SMTP id f4so16365082ion.2
        for <linux-media@vger.kernel.org>; Sun, 13 Jan 2019 15:38:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=AyPyKJCBmxHor4F7WnGYHCioG0sKcM1dZ4zFD6cuw+c=;
        b=Qr3clMIcO/57K9ce8QQ78ZmRpXEHt+JvpAj+bq6kk/ctSZKwMmlOEICjLbUgbATRK+
         2zBWZFx5aqbmFNhFHbcFqYyeeElkOIL/RgBNtHqOBplbHZRskSDb08lqu2OaNM5H9xYB
         Vc7WrVlO5++iQcHrd3UUMr+SoOmx92qZXxDRpqaKRkLK1RQ4cVp7oWMHE/U51XPN1XCx
         AJJoN0aXrc78TlhcYy95rFRpFQunYmVoH5uyIovMnRo+v4R0EUHeSgoZ9mnw2EX6WUtJ
         i+3y9bOjtyv+iqRkPhwRd1/TC+A7GlBsoh/ux6cT/0wK8iur7fYXA7JDqPxBVOtckZtJ
         MQHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=AyPyKJCBmxHor4F7WnGYHCioG0sKcM1dZ4zFD6cuw+c=;
        b=SQ/X2wPTYPepKOPgvAf7ex3WtbG71x1t15Q7dztOwJNRFYnVxsXHBIYkkL6PZUBFBR
         v50z1zarz0Jd+Sy0wFHcJRNq6Rz4A4es9wL4XZhU2koYRSScgJ5p93GeMcz+IsMO54mG
         GjJBwwmLwhXMGAWre54xd89KSXSz6AGnj6J37ysHLIoehBekNTFyAgJKhPtDvSN85CBK
         AzIyvinO9/LzqtLCItnmYqiBTYmurVAE+D3V3Ge5FuqRAnYymrCQUjdYr7GNEOv3WTxc
         wFqukc3uzi2VbFW/NIDzYSvuFkTvkZD8qyvpY9AEiP7uUir3UhZiHbKMonJ/5APdU5xP
         z0Sg==
X-Gm-Message-State: AJcUukdkC9f1rr8tkbDeRFRL7Xi+ZLxIRqh5CSgQODqdiAlEo+KsoxIC
        nM2tcXMmvcCO+iSd7TLN2uU=
X-Google-Smtp-Source: ALg8bN4Cp4+KHFRUjcaoH8XztprDM1gNgBnYQd5E5fjszPFNRBLuwJOZx14ZNjeMujCyQullI3zuLw==
X-Received: by 2002:a5e:9b16:: with SMTP id j22mr14739519iok.21.1547422727633;
        Sun, 13 Jan 2019 15:38:47 -0800 (PST)
Received: from dragon.Home (71-218-4-112.hlrn.qwest.net. [71.218.4.112])
        by smtp.gmail.com with ESMTPSA id t70sm3132285ita.17.2019.01.13.15.38.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 13 Jan 2019 15:38:47 -0800 (PST)
From:   james.hilliard1@gmail.com
To:     mchehab+samsung@kernel.org
Cc:     linux-media@vger.kernel.org,
        James Hilliard <james.hilliard1@gmail.com>
Subject: [PATCH zbar 4/5] Ignore ENOTTY errors when calling VIDIOC_S_CROP
Date:   Mon, 14 Jan 2019 07:38:28 +0800
Message-Id: <1547422709-7111-4-git-send-email-james.hilliard1@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1547422709-7111-1-git-send-email-james.hilliard1@gmail.com>
References: <1547422709-7111-1-git-send-email-james.hilliard1@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: James Hilliard <james.hilliard1@gmail.com>

Silences this error:
ERROR: zbar video in v4l2_reset_crop():
    system error: setting default crop window (VIDIOC_S_CROP): Inappropriate ioctl for device (25)

Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
---
 zbar/video/v4l2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/zbar/video/v4l2.c b/zbar/video/v4l2.c
index 1d685e9..ad6adf4 100644
--- a/zbar/video/v4l2.c
+++ b/zbar/video/v4l2.c
@@ -569,7 +569,7 @@ static inline int v4l2_reset_crop (zbar_video_t *vdo)
     memset(&crop, 0, sizeof(crop));
     crop.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
     crop.c = ccap.defrect;
-    if(v4l2_ioctl(vdo->fd, VIDIOC_S_CROP, &crop) < 0 && errno != EINVAL)
+    if(v4l2_ioctl(vdo->fd, VIDIOC_S_CROP, &crop) < 0 && errno != EINVAL && errno != ENOTTY)
         return(err_capture(vdo, SEV_ERROR, ZBAR_ERR_SYSTEM, __func__,
                            "setting default crop window (VIDIOC_S_CROP)"));
     return(0);
-- 
2.7.4

