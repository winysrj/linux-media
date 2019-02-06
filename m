Return-Path: <SRS0=FbF1=QN=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50421C282C2
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 10:26:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F1DB218A3
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 10:26:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OX/wjjtc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729419AbfBFK0Q (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Feb 2019 05:26:16 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33280 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729412AbfBFK0P (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2019 05:26:15 -0500
Received: by mail-wm1-f65.google.com with SMTP id h22so1435113wmb.0
        for <linux-media@vger.kernel.org>; Wed, 06 Feb 2019 02:26:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GWBv8TFqzFxnlkNvYBhlA0CSDp04MBjWsOjyfNPbaXc=;
        b=OX/wjjtcDWMD6RN6LzzHIj+eMrBvTCKDPYF8mNV5zdRzXjopxfzPBHM/EZboO210re
         e8opZBaeOjgWinN4CCeN6lWvmiUsVXyL5xmWavm8ikXsrqGzg3IxBQhPQWnGUrrPjPat
         vmpP2nGrbdbXTypfxc7qwaN+4dl4JyjnojXzg7n4k1Kg7U2XnLhuVxzIJ/cKSZ9Xs8xv
         b6gh56maqQ6eOdC4FQIEK2RGNY7S6P4s7Kl4x1i5CvbhBYFQ8vpGMB5squepbw+2yxIQ
         O8AJ35JicjPQDUs88pWg6uBL4YRHyKEE1LJ7QavHV2KVDIplu5h6akJz+th/qGzKjgZk
         lrsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GWBv8TFqzFxnlkNvYBhlA0CSDp04MBjWsOjyfNPbaXc=;
        b=lwQR82ySowjVk1nEZyKlJToMnWz9RfJQLet9sUud1TDlgMLAv28iCza1y++HDMxyPc
         v6Fb0xDzLY5Lp0bNu4s5dAI3uHiR5+k1i12ZT3g93oxsJ+4cglbzAzgAir04MqAItgy5
         FeMQLR1UWYlFoItDqdJchPXT9tYc4SJXC30Y1C49HeNmiu82Zd5xW/qhNzCGH0Zf6ou4
         V+onKEYv93YHdljKQ8Xs9K56akki+XoEqlY6b8oiBZBzeoo3SJ8qzxmgBN8HQgKgSqW4
         g+3Ctep1d6Psp44Ntq821bSG2o6ulEMp8pN3qoZZSNgKWv6WPIzJyUKJu1BbJ/NTPeNL
         gAjQ==
X-Gm-Message-State: AHQUAuYBEA4UMBNwlnqjll6c9/6MnJu1K+6VAFXOzSFDTOGmuRCPddS8
        hvrqztMPtpuRPeQpZfPYPfL8ug==
X-Google-Smtp-Source: AHgI3IY+j2C4hq3FTrKcMz/JxAWgNe2+CUys1Tpf8i0z9eREKp9LMj2X78qkXcBUb/GFHcQZJ9wKFQ==
X-Received: by 2002:a1c:342:: with SMTP id 63mr2466883wmd.34.1549448773523;
        Wed, 06 Feb 2019 02:26:13 -0800 (PST)
Received: from arch-late.local (a109-49-46-234.cpe.netcabo.pt. [109.49.46.234])
        by smtp.gmail.com with ESMTPSA id i192sm18149631wmg.7.2019.02.06.02.26.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Feb 2019 02:26:13 -0800 (PST)
From:   Rui Miguel Silva <rui.silva@linaro.org>
To:     sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH v13 11/13] media: staging/imx: add i.MX7 entries to TODO file
Date:   Wed,  6 Feb 2019 10:25:20 +0000
Message-Id: <20190206102522.29212-12-rui.silva@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190206102522.29212-1-rui.silva@linaro.org>
References: <20190206102522.29212-1-rui.silva@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add some i.MX7 related entries to TODO file.

Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/staging/media/imx/TODO | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/staging/media/imx/TODO b/drivers/staging/media/imx/TODO
index aeeb15494a49..6f29b5ca5324 100644
--- a/drivers/staging/media/imx/TODO
+++ b/drivers/staging/media/imx/TODO
@@ -45,3 +45,12 @@
 
      Which means a port must not contain mixed-use endpoints, they
      must all refer to media links between V4L2 subdevices.
+
+- i.MX7: all of the above, since it uses the imx media core
+
+- i.MX7: use Frame Interval Monitor
+
+- i.MX7: runtime testing with parallel sensor, links setup and streaming
+
+- i.MX7: runtime testing with different formats, for the time only 10-bit bayer
+  is tested
-- 
2.20.1

