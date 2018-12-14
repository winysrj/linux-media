Return-Path: <SRS0=AYlV=OX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CA66C43387
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 16:40:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C689F206C2
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 16:40:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EetMesHU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729982AbeLNQkm (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 14 Dec 2018 11:40:42 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38970 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729619AbeLNQkm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Dec 2018 11:40:42 -0500
Received: by mail-wr1-f65.google.com with SMTP id t27so6050701wra.6
        for <linux-media@vger.kernel.org>; Fri, 14 Dec 2018 08:40:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oYcA9EHF8OFyGzhe2E5tic7eN4P0pkwHdAnCokxENPA=;
        b=EetMesHUAVKjIAccLAxAunVjFJ+n0oWKHRxHYdDt0/iZbt2N6G8OLBSGxZtMxKy6ac
         yAswuA5Y6OH3kwiGqnJy2So218h68XqzjAOJgc4jHmra82iEcnAKcCuVg+jTHGbWF6Vd
         lUMlBSh3ZLdZeGbRQ11hteK3KN4PBPv1criIlroqwu++3uZ7S6AES+wLQyu85JS0kyD6
         o+Qofz5/+hOhlg7BlI99t/DuM2X953sHfx+pIXbCPnvTqgbIcEc7Pv1kB7HchaW3V7wP
         nW86BD5D+Wcx6WD5xlbHHQdMD7CgYzPE1u9jZ9Uy9jGJtB4TwQFSHp03a7bC0ogsqjUC
         islA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oYcA9EHF8OFyGzhe2E5tic7eN4P0pkwHdAnCokxENPA=;
        b=mn0Bm4eqqN0N6ELc8R1VudhYoXl+eOrFrtffrZmSWeANnlY2JLwC4TB5aHRGUL7u9T
         FG02+CiE+zPgVGYuJyMVQNiPzjizV0yudIIA9Dq4yYFA3CPRJTULuR9bToVTnK3jwxIF
         5tPf6A5H7Ax9aVj+3csKkCaWJNVBS+ewkfQgSiAMujlLN+stQ6Tb7Lq+n6kTlzt88kpk
         ZZAlIhp9nwospOW1C9iCvxOCr2Oylz9qjNR/KpZdKNmvq5pcK0/DZ5XDY3s4l4oc5WL4
         JlbNW/aYrZxpbnsjx++nMf4hmRM76rvoTTEV7cssMJv1ayvTKxwozy0JpX7+ZjBml/ma
         qTcQ==
X-Gm-Message-State: AA+aEWZdR0GnCKyO116VXED3GhjJNCUMIYAF28hsq1Lez1fIcYXJdE7C
        5qptuuvQqQL/EqrzI8J7Vpx4Xh8z
X-Google-Smtp-Source: AFSGD/VQI2xNSGdtqNBA7nN627REP4/VEbsVoInPu6IXvBlB5d7L1fDRK+1P1x2dXlSQHcbOxLrXkQ==
X-Received: by 2002:adf:fc09:: with SMTP id i9mr3055476wrr.299.1544805640310;
        Fri, 14 Dec 2018 08:40:40 -0800 (PST)
Received: from ped.lan (ip5f5abcae.dynamic.kabel-deutschland.de. [95.90.188.174])
        by smtp.googlemail.com with ESMTPSA id c13sm7680392wrb.38.2018.12.14.08.40.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Dec 2018 08:40:39 -0800 (PST)
From:   Philipp Zabel <philipp.zabel@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH 1/8] media: gspca: ov534: replace msleep(10) with usleep_range
Date:   Fri, 14 Dec 2018 17:40:24 +0100
Message-Id: <20181214164031.16757-2-philipp.zabel@gmail.com>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20181214164031.16757-1-philipp.zabel@gmail.com>
References: <20181214164031.16757-1-philipp.zabel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

For short waits, usleep_range should be used instead of msleep,
see Documentation/timers/timers-howto.txt.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 drivers/media/usb/gspca/ov534.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/gspca/ov534.c b/drivers/media/usb/gspca/ov534.c
index d06dc0755b9a..44f06a58bb67 100644
--- a/drivers/media/usb/gspca/ov534.c
+++ b/drivers/media/usb/gspca/ov534.c
@@ -679,7 +679,7 @@ static int sccb_check_status(struct gspca_dev *gspca_dev)
 	int i;
 
 	for (i = 0; i < 5; i++) {
-		msleep(10);
+		usleep_range(10000, 20000);
 		data = ov534_reg_read(gspca_dev, OV534_REG_STATUS);
 
 		switch (data) {
@@ -1277,7 +1277,7 @@ static int sd_init(struct gspca_dev *gspca_dev)
 
 	/* reset sensor */
 	sccb_reg_write(gspca_dev, 0x12, 0x80);
-	msleep(10);
+	usleep_range(10000, 20000);
 
 	/* probe the sensor */
 	sccb_reg_read(gspca_dev, 0x0a);
-- 
2.20.0

