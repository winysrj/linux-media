Return-Path: <SRS0=Cdzf=R3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D0C2C43381
	for <linux-media@archiver.kernel.org>; Sun, 24 Mar 2019 23:21:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5772120989
	for <linux-media@archiver.kernel.org>; Sun, 24 Mar 2019 23:21:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=umn.edu header.i=@umn.edu header.b="cDTJSBDg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729081AbfCXXVR (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 24 Mar 2019 19:21:17 -0400
Received: from mta-p5.oit.umn.edu ([134.84.196.205]:49892 "EHLO
        mta-p5.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728957AbfCXXVR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Mar 2019 19:21:17 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-p5.oit.umn.edu (Postfix) with ESMTP id 2F5267B9
        for <linux-media@vger.kernel.org>; Sun, 24 Mar 2019 23:21:16 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p5.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p5.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id plam_bYutOFD for <linux-media@vger.kernel.org>;
        Sun, 24 Mar 2019 18:21:16 -0500 (CDT)
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p5.oit.umn.edu (Postfix) with ESMTPS id 0186480C
        for <linux-media@vger.kernel.org>; Sun, 24 Mar 2019 18:21:16 -0500 (CDT)
Received: by mail-io1-f71.google.com with SMTP id c2so6555760ioh.11
        for <linux-media@vger.kernel.org>; Sun, 24 Mar 2019 16:21:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=41fkJ68HbV1EubuETozIxJ2sQJNbc/APWw+PYFA9ZNg=;
        b=cDTJSBDgz9nITl5fN5sj4xglZ4y0ueJVn0zpvT3JQzSd86oPcDMOAX/Vqj36X3RqA1
         1WDxSsuJyXbNQrtFT+zxa/53/xbIVaeO4allLaWanYH5yt0BClYRqCplWwd5F84wNyDn
         MPTywDihlddPxn+W8FYGsB6ABMKMTlVe/zIjbUolzYTRv+rRmfWf3gmGWHGb/qaooAjE
         mvqS7WP5nePxgnXuVpH3sn+dSq0U5ewf75kMneWLfVy1+PpHGutqxPtmL4swff6IReCy
         ioga6P8XJXqYeJ4pQojC4wSALEDJR+b49/Vxx4+Kz7gZXRgr58Lj9cq9C9CyFwePCWzO
         F83Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=41fkJ68HbV1EubuETozIxJ2sQJNbc/APWw+PYFA9ZNg=;
        b=N7P6nB0IL30+ZZHkQt1UHa3kzDiaNOngEbeEJ8s3gUjpOqnm5V1OeANbN7sIZhIv5N
         CwSmTPbs7cFYSJUKQsV6BUjt7f82O1xYCa23iHiGjdrvBCCrlu7rx99kwg3dZhdDGaPf
         LmCN8CzqREVFl43cTW0p1nnnJ2PCNlVWinfREBMAECcnVEiwN+3yugfG3CQatqv06xgt
         WrRA9WEmDQzKjrfL5J+p9fcuaj1hJxhiRZRbp5v1nf82/dPJWGQg7phjNuU0tMFjnTVo
         3y8n/fbNevhSpZ6m6jS1WXZFPk6J6kSYaDi1nw8resaMvDvxrjY/1lbH3i1vp3ynxM1b
         /VMQ==
X-Gm-Message-State: APjAAAVCyFgDMbdGNdC8DlWpuiVfvI3g2rILvTq6j590fb9/WoFiJ1/3
        j5PaOOv6vTEluPhQEWf5XqhpGE2QkCNz8RhEFsuhdS2Q/+egPa74gRutXmaGe4BbVwkgO8mY6L/
        560zwTaHzNSvNNR3FchVXwLZd+EE=
X-Received: by 2002:a05:660c:606:: with SMTP id i6mr5694555itk.154.1553469675671;
        Sun, 24 Mar 2019 16:21:15 -0700 (PDT)
X-Google-Smtp-Source: APXvYqz1YJkCQQM3iesbxKizyV0etr0E+nnhFQ8vMqnS3C8j93farj+XV2e+HZrLW0fHUeEb95jL4g==
X-Received: by 2002:a05:660c:606:: with SMTP id i6mr5694545itk.154.1553469675429;
        Sun, 24 Mar 2019 16:21:15 -0700 (PDT)
Received: from bee.dtc.umn.edu (cs-bee-u.cs.umn.edu. [128.101.106.63])
        by smtp.gmail.com with ESMTPSA id x79sm4327143ita.17.2019.03.24.16.21.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 Mar 2019 16:21:14 -0700 (PDT)
From:   Kangjie Lu <kjlu@umn.edu>
To:     kjlu@umn.edu
Cc:     pakki001@umn.edu, Olli Salonen <olli.salonen@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: tuners: fix a missing check for regmap_write_bits
Date:   Sun, 24 Mar 2019 18:21:10 -0500
Message-Id: <20190324232110.2804-1-kjlu@umn.edu>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

regmap_write_bits could fail and thus deserves a check.

The fix returns its error code upstream in case it fails.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
 drivers/media/tuners/tda18250.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/tuners/tda18250.c b/drivers/media/tuners/tda18250.c
index 20d10ef45ab6..36ede1b02d23 100644
--- a/drivers/media/tuners/tda18250.c
+++ b/drivers/media/tuners/tda18250.c
@@ -703,6 +703,8 @@ static int tda18250_set_params(struct dvb_frontend *fe)
 
 	/* charge pump */
 	ret = regmap_write_bits(dev->regmap, R46_CPUMP, 0x07, buf[2]);
+	if (ret)
+		goto err;
 
 	return 0;
 err:
-- 
2.17.1

