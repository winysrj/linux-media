Return-Path: <SRS0=AYlV=OX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4DADC43387
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 16:40:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 58613206DD
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 16:40:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sOcbuqqS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730090AbeLNQkp (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 14 Dec 2018 11:40:45 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42970 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729619AbeLNQko (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Dec 2018 11:40:44 -0500
Received: by mail-wr1-f66.google.com with SMTP id q18so6043286wrx.9
        for <linux-media@vger.kernel.org>; Fri, 14 Dec 2018 08:40:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JIPWtui+JS8yVaI5mPX+bGhjb5g1JesbJdchtjV2uns=;
        b=sOcbuqqSlt0dQfhv2KX9lOvbD1FWpHTtGtc9OMfsyugy4yC+7JEbC3/fkHYfR/UpSV
         hLa2MbzDyYG+F65HH1O2x8XknNlJtjSeOWCDTnQL74cIahDvWhyeX21Pk8lN7yNCvqEO
         iYBNOx0ZAoWHu0hsMI1BWn6TZS0yVyCBJyvciJmHT3I5fJ54+2bFFI8sPfmj42bzI2aL
         gGZSomM/ynyD8pxRX6weXjwYB/7QHQpcqS4s2tVdvNqpnNefPqN5p4/1pgNjYaRLFE17
         n6R4kSLMQgWTObWzHyYvurMWsepDg77tTWISGfSVUhZvICQtxdQy8d0qlap0yUn+ycPM
         uUHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JIPWtui+JS8yVaI5mPX+bGhjb5g1JesbJdchtjV2uns=;
        b=E+EZzhAPUkBRVMuayB7/uT9xGBazT/68C3la1iB9dP1xFMLWV220gZ15i64ScJNOOv
         SpgWRS5fEbgbrWpKwBlS+qfgAWKQ2P4jf6G3yMDyrmoUFauyHqhIV+hUypHmEfQWutwk
         xfmMUKXnYsHZ07JM+uW4iu5NZByWlbJHfEEcsZAchFH0iZPMNL4O8F/kUYHTPw6oF1Zu
         Qr/y9Y6JpG2RG6vRRO+tuf0+H5AtqT3bl/fetTuJXRVr7imbUf8YtqnYtnK0V3OOepm0
         Pqclq8wI/KqKyYs5S2+tIvXgbubFgA7HEOteAxBrlZnTxEjc5cpvCcSoxT0/kditggf3
         qDaA==
X-Gm-Message-State: AA+aEWbN/AWGzmyjhG3kAGm8FTsKKTBCLBslfy6v5I2yYq5As9rSfn0d
        OrLx6lYnE/vUm85Wk/GNK7RWRqpp
X-Google-Smtp-Source: AFSGD/VaYbxjJpyxIwEXfJDZ23rRdte2EndHqJcVwT0xTHFTUQfTqU5JLoINJa+CCaGoHF6p0P373g==
X-Received: by 2002:a5d:480d:: with SMTP id l13mr3408296wrq.175.1544805642205;
        Fri, 14 Dec 2018 08:40:42 -0800 (PST)
Received: from ped.lan (ip5f5abcae.dynamic.kabel-deutschland.de. [95.90.188.174])
        by smtp.googlemail.com with ESMTPSA id c13sm7680392wrb.38.2018.12.14.08.40.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Dec 2018 08:40:41 -0800 (PST)
From:   Philipp Zabel <philipp.zabel@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH 2/8] media: gspca: support multiple pixel formats in ENUM_FRAMEINTERVALS
Date:   Fri, 14 Dec 2018 17:40:25 +0100
Message-Id: <20181214164031.16757-3-philipp.zabel@gmail.com>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20181214164031.16757-1-philipp.zabel@gmail.com>
References: <20181214164031.16757-1-philipp.zabel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

If a driver supports multiple pixel formats with the same frame size,
ENUM_FRAMEINTERVALS will currently only work for the first pixel format.
Fix this by adding pixelformat support to wxh_to_mode().

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 drivers/media/usb/gspca/gspca.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/gspca/gspca.c b/drivers/media/usb/gspca/gspca.c
index 3137f5d89d80..13361cfa6903 100644
--- a/drivers/media/usb/gspca/gspca.c
+++ b/drivers/media/usb/gspca/gspca.c
@@ -912,13 +912,14 @@ static void gspca_set_default_mode(struct gspca_dev *gspca_dev)
 }
 
 static int wxh_to_mode(struct gspca_dev *gspca_dev,
-			int width, int height)
+			int width, int height, u32 pixelformat)
 {
 	int i;
 
 	for (i = 0; i < gspca_dev->cam.nmodes; i++) {
 		if (width == gspca_dev->cam.cam_mode[i].width
-		    && height == gspca_dev->cam.cam_mode[i].height)
+		    && height == gspca_dev->cam.cam_mode[i].height
+		    && pixelformat == gspca_dev->cam.cam_mode[i].pixelformat)
 			return i;
 	}
 	return -EINVAL;
@@ -1152,7 +1153,8 @@ static int vidioc_enum_frameintervals(struct file *filp, void *priv,
 	int mode;
 	__u32 i;
 
-	mode = wxh_to_mode(gspca_dev, fival->width, fival->height);
+	mode = wxh_to_mode(gspca_dev, fival->width, fival->height,
+			   fival->pixel_format);
 	if (mode < 0)
 		return -EINVAL;
 
-- 
2.20.0

