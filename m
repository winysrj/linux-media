Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDDC5C43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 18:31:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC9AB20665
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 18:31:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="auXlhuq4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727728AbfAISbP (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 13:31:15 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33218 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727547AbfAISai (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2019 13:30:38 -0500
Received: by mail-pf1-f195.google.com with SMTP id c123so4066674pfb.0;
        Wed, 09 Jan 2019 10:30:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=rYSzVI0OvbJN9zcjKQFFiU9YJ6PIbqf35eYJ6lEUQGw=;
        b=auXlhuq4rQjZNkZHouAQkfBqVell+CghUl7ty0wBfLDvc4bdXyDARCxEvJnWBf83rS
         PNyfzRyoap5QF1vSGJ7l/PYER2OXORl/SVquk0XSYuTsNQYwyVB7IjrTTzmUnBJr+9g4
         Cfu61B62dHm/RktWA+eJIRX5MnzG4eycqeN0mwlD8FigQ/3STCQmeD+g6cR2MJg0bk4g
         UI2lOCdNHeB6KqTGq+98GOHAywzu40QATPiQdRfcQJy4H23uTHPDIdo9EK3RI8nih5G8
         UJaXK1Pud7vbRD0yT5EKNqEvsAY4g5d9VhQcxk4+Z/INiS1QT1pCmVxw8NU5wtTb3o1Z
         r+Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=rYSzVI0OvbJN9zcjKQFFiU9YJ6PIbqf35eYJ6lEUQGw=;
        b=nLMi3tJ9HY48gy4xPpYHAD0699l/bLqzDisT6Naq0e+IISt1RANgAgD6h9HBDIQooq
         bolyfV6gA7GcfoBKRihNUVv7jOk7tbkbZ5rIq9ZPltBHaQz8SUelaPbGn9CnhCbS1RR/
         syOJILUnxtGpjetxrXkTgwnckZmDEHb40Fq2PgF6ESmJHXVdKnF1YvjUFKaRH0u6rYh5
         OtKN3yS7qKVCfQsI0Nf3uCOawoU3+gJxxjLL9wfIBlekmBXXWlertUV4JqmK9Z0rXCx1
         WYjiDQmUkH9WcX0AVmOSFClh7tC9aGDYmu1+Oc2XwZWa3JOpXif1bI4tp+TLaDjzkCAb
         evNA==
X-Gm-Message-State: AJcUukdVQW9rZqpxEtpyNmSDKWZ3sMkAuy8sl+GaScf/CzBnUzar4TC/
        vXzXqy/VSRwTc/mMnOOou0d03jk7
X-Google-Smtp-Source: ALg8bN6/bZnmmgVWUn7QxH+rUz8ioNd8j9GyyFlnpimjGj88d9Fi+ev+I61r1/UTvGxxAvy8ashMcQ==
X-Received: by 2002:a63:ee0e:: with SMTP id e14mr6297493pgi.8.1547058637386;
        Wed, 09 Jan 2019 10:30:37 -0800 (PST)
Received: from majic.sklembedded.com (c-98-210-181-167.hsd1.ca.comcast.net. [98.210.181.167])
        by smtp.googlemail.com with ESMTPSA id v191sm157551056pgb.77.2019.01.09.10.30.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Jan 2019 10:30:36 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v8 07/11] media: imx-csi: Allow skipping odd chroma rows for YVU420
Date:   Wed,  9 Jan 2019 10:30:10 -0800
Message-Id: <20190109183014.20466-8-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190109183014.20466-1-slongerbeam@gmail.com>
References: <20190109183014.20466-1-slongerbeam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Skip writing U/V components to odd rows for YVU420 in addition to
YUV420 and NV12.

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/staging/media/imx/imx-media-csi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 604d0bd24389..6f1e11b8a7cb 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -452,6 +452,7 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
 		passthrough_bits = 16;
 		break;
 	case V4L2_PIX_FMT_YUV420:
+	case V4L2_PIX_FMT_YVU420:
 	case V4L2_PIX_FMT_NV12:
 		burst_size = (image.pix.width & 0x3f) ?
 			     ((image.pix.width & 0x1f) ?
-- 
2.17.1

