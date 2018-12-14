Return-Path: <SRS0=AYlV=OX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14784C43387
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 16:40:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AFC09206C2
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 16:40:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lotR3Idk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730198AbeLNQkq (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 14 Dec 2018 11:40:46 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34967 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729923AbeLNQkp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Dec 2018 11:40:45 -0500
Received: by mail-wm1-f66.google.com with SMTP id c126so6411871wmh.0
        for <linux-media@vger.kernel.org>; Fri, 14 Dec 2018 08:40:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cM2oDmuzvLvmEn6yyFJ6F8PgqNDtdcssA+pnNdwFjXg=;
        b=lotR3Idk7LOnEF8wuuA2LnUPk53szQdTZAGj7jdtpZXNrBHN0jmyXKrFr9LwHQ7gIY
         PYitFZAgIwXECJ2qH9TwbhKOmgT2N4YsHnH5rLkqhqnIt4EIJp6TIKKhx1JYIoLV+XJ2
         Fm+XHu5BMt+ikBMySwMbPI0mFVk5JQJETKxfRijViTxOk7RtlXYHG3HnFHmacZeJLJCx
         8c4Rk1aSxAHvsnJdf7AzxudKTtO/ZBCEDSLmUW/gkXZTpZQEXdsn/XrnaTzzXynbE/eI
         Fd7k8exaMe50Ph5Lx+j3OmDcjgGKGx1JKSn24q2vi2AqZpz3mG1MMqt5kavQo/g0rmx1
         HFoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cM2oDmuzvLvmEn6yyFJ6F8PgqNDtdcssA+pnNdwFjXg=;
        b=X5SRgMfh5PprZrg0KxUor9run9n0+RovoKM8YVBnK4z63Je4Tan0RCzrPOHzhm0K5A
         nP1vbw3YoK83aZLBtHRL6RlAWTbWi6VvfoTA/fvERXNvIdE/lpUqmwu55B3ompEFn0zh
         Vx8NCXGDKJU3z5JiU56h5A6i8GGxDCUVGLoH7Oqy4IMEx0e72Oo5EYhWwWxlNT/T+C4c
         N5J+TzQDhFATKgrZ2S7mLj60AMFRnqvxUyXOLXY02HpbQml0/cKk2mfJPDUFvCf98I5/
         PpXhhqiMTqm5LnKiHyCU1iLqKIdAEoan22OsOAiUY2l7xPOgXOPk+lumjBdYzJPOJtEI
         3Nuw==
X-Gm-Message-State: AA+aEWYW+A2FFjHRfujzbR4AchDvhW9y2sk8ZLFlzgfmYNW39OrrmMvN
        4zETKlWP6osD+OHuIedy06Gwbkca
X-Google-Smtp-Source: AFSGD/V45rwN2MKwTBZsBgHnQJFjGiJVmNzYhC9ug+2XcWFKICkym4n6tdN70TjQ6zhrH+j+8xS3Wg==
X-Received: by 2002:a1c:b70b:: with SMTP id h11mr4006736wmf.72.1544805643442;
        Fri, 14 Dec 2018 08:40:43 -0800 (PST)
Received: from ped.lan (ip5f5abcae.dynamic.kabel-deutschland.de. [95.90.188.174])
        by smtp.googlemail.com with ESMTPSA id c13sm7680392wrb.38.2018.12.14.08.40.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Dec 2018 08:40:42 -0800 (PST)
From:   Philipp Zabel <philipp.zabel@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH 3/8] media: gspca: support multiple pixel formats in TRY_FMT
Date:   Fri, 14 Dec 2018 17:40:26 +0100
Message-Id: <20181214164031.16757-4-philipp.zabel@gmail.com>
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
TRY_FMT will currently always return the first pixel format.
Fix this by adding pixelformat support to wxh_to_nearest_mode().

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 drivers/media/usb/gspca/gspca.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/gspca/gspca.c b/drivers/media/usb/gspca/gspca.c
index 13361cfa6903..ac70b36d67b7 100644
--- a/drivers/media/usb/gspca/gspca.c
+++ b/drivers/media/usb/gspca/gspca.c
@@ -926,10 +926,16 @@ static int wxh_to_mode(struct gspca_dev *gspca_dev,
 }
 
 static int wxh_to_nearest_mode(struct gspca_dev *gspca_dev,
-			int width, int height)
+			int width, int height, u32 pixelformat)
 {
 	int i;
 
+	for (i = gspca_dev->cam.nmodes; --i > 0; ) {
+		if (width >= gspca_dev->cam.cam_mode[i].width
+		    && height >= gspca_dev->cam.cam_mode[i].height
+		    && pixelformat == gspca_dev->cam.cam_mode[i].pixelformat)
+			return i;
+	}
 	for (i = gspca_dev->cam.nmodes; --i > 0; ) {
 		if (width >= gspca_dev->cam.cam_mode[i].width
 		    && height >= gspca_dev->cam.cam_mode[i].height)
@@ -1059,7 +1065,7 @@ static int try_fmt_vid_cap(struct gspca_dev *gspca_dev,
 		    fmt->fmt.pix.pixelformat, w, h);
 
 	/* search the nearest mode for width and height */
-	mode = wxh_to_nearest_mode(gspca_dev, w, h);
+	mode = wxh_to_nearest_mode(gspca_dev, w, h, fmt->fmt.pix.pixelformat);
 
 	/* OK if right palette */
 	if (gspca_dev->cam.cam_mode[mode].pixelformat
-- 
2.20.0

