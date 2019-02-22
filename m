Return-Path: <SRS0=hjs2=Q5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC9FCC43381
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 10:17:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9741C20823
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 10:17:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BLLZucUn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbfBVKR2 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 22 Feb 2019 05:17:28 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34154 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726184AbfBVKR1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Feb 2019 05:17:27 -0500
Received: by mail-wm1-f67.google.com with SMTP id y185so8556380wmd.1
        for <linux-media@vger.kernel.org>; Fri, 22 Feb 2019 02:17:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zv0rxKqQsLgGZ5uFT0zZ4DKYZwC9uuUeZe3dGDeLZoY=;
        b=BLLZucUne98WFjnJEEt3bw0LmB0+hTEibOqg5jzSX/RyWO+eELpYp2K1wkcfzIvDI1
         XIWYNpEX2r3Zgiy337MB98krg+ZPVhJTrNlJO6JuXE7ATiQSidqAf6vVTL25V8x2p9Fy
         a+NpHsopCNGan62dztwHrXk8oUVeuGcXFV3ExhUX6sS5mBKA/aV/lMszgU81wtut7Aqu
         cKSc8gkEfBNiywiuk9Kc9lqvmQVrxtGTlxOllYlsgy96ulgmkWosbtcBl2i66jES797X
         SALXJxRgdw9pNdLDahPlXWQhin9i70EXu2Hftw+6tyNQejukxVzjtsIx8am+9zzN6qyh
         O0GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zv0rxKqQsLgGZ5uFT0zZ4DKYZwC9uuUeZe3dGDeLZoY=;
        b=ATp2/GLQsfeUzybMOKhzvKdxaHBUw08BnKnC6g5CnPmYbkyzI19S6uP3ML+NPH/Ki9
         9CTdMkyWCs58qjx/Ugy7p2tHKpUiWJicuRJu8fZFCNwZIYPdFo8MtrBkYUwDA6TTUX0E
         p04DSb6zDTunu+MPlqmqXw2xOo6CWIqsc5ZeAwz5AQ+Bj47qNUKKupoQxkKw7UJdH8wU
         igY7pfZNl+18KvK6SgP++p3lfFOXh8x3lWiUPRJ1Bhn3q53eeb/5RFDPwmhV556/oo99
         7H2zBJYVwS4hN/WlO4WG3VtCXDN2Tp0IAtNNc07Wl2146+CzBCBs7I+IT4ZRTr6Y8zcy
         eWgw==
X-Gm-Message-State: AHQUAuYAu5Esz7MDs/VtjZjISDHPFvvn/QyTuQCOQ/zF6u1MjEIuANRP
        jVhoeBYJTu6P9kRWiePbPDgg9g==
X-Google-Smtp-Source: AHgI3IaML1oRFzszEFkclWx3Ru3/Mf8VyQDOEALwY3nFKJieu4X9+0kVFTMdnL7cIilJR/Yhae+zAg==
X-Received: by 2002:a1c:cf43:: with SMTP id f64mr1826846wmg.61.1550830645979;
        Fri, 22 Feb 2019 02:17:25 -0800 (PST)
Received: from arch-late.local (a109-49-46-234.cpe.netcabo.pt. [109.49.46.234])
        by smtp.gmail.com with ESMTPSA id u12sm1141064wmf.44.2019.02.22.02.17.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Feb 2019 02:17:25 -0800 (PST)
From:   Rui Miguel Silva <rui.silva@linaro.org>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc:     linux-media@vger.kernel.org,
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH] media: imx7-media-csi: don't store a floating pointer
Date:   Fri, 22 Feb 2019 10:17:10 +0000
Message-Id: <20190222101710.28465-1-rui.silva@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190222070143.GF1711@kadam>
References: <20190222070143.GF1711@kadam>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

if imx7_csi_try_fmt() fails, cc variable won't be
initialized and csi->cc[sdformat->pad] would be pointing
to a random location.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
---
 drivers/staging/media/imx/imx7-media-csi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/imx/imx7-media-csi.c b/drivers/staging/media/imx/imx7-media-csi.c
index 3fba7c27c0ec..894e5be3f17c 100644
--- a/drivers/staging/media/imx/imx7-media-csi.c
+++ b/drivers/staging/media/imx/imx7-media-csi.c
@@ -1051,7 +1051,9 @@ static int imx7_csi_set_fmt(struct v4l2_subdev *sd,
 		goto out_unlock;
 	}
 
-	imx7_csi_try_fmt(csi, cfg, sdformat, &cc);
+	ret = imx7_csi_try_fmt(csi, cfg, sdformat, &cc);
+	if (ret < 0)
+		goto out_unlock;
 
 	fmt = imx7_csi_get_format(csi, cfg, sdformat->pad, sdformat->which);
 	if (!fmt) {
-- 
2.20.1

