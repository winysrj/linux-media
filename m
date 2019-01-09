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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16F1DC43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 00:16:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDD252146F
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 00:16:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RHxrK6ED"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729692AbfAIAQm (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 19:16:42 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43891 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729543AbfAIAQM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 19:16:12 -0500
Received: by mail-pf1-f195.google.com with SMTP id w73so2713631pfk.10;
        Tue, 08 Jan 2019 16:16:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vEf7T3OMQUP21fdiFj7AqVsxJXol5YOpHqFK37hxTmc=;
        b=RHxrK6ED5gfhawSfiZyBd+ntLYdP5d1lmv+rpAuosb9x43G8GPFP9V9pnLYtMzszZC
         2xJ7vPcRZ2iMlsg3JAdeDFAWH9cjrsZECwaeVu/a7i9cyNJm/6DI/SI+Mib3LAFLamSW
         4WgMsfqO53HPtqOP4YpeLYPDqVkyWoofQdTTywc7yLa8Zc/0Yxu+lB4gHaXoaL65zsSp
         CeEMnU4QVh60YhGMC/gqDhOHzh3cXYG2okf//0ft6Q8gJntWhwpZQqna0OCDr08Py2Ao
         22sDHN0agwCyWH4JYfTa2rEUnPddzB6PYi9tbDqHGY3CEK29sabPbTq9v3k/y+FuGG7R
         9eUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vEf7T3OMQUP21fdiFj7AqVsxJXol5YOpHqFK37hxTmc=;
        b=cYcjtvCtadv6VTGdCQezK/SVAXN+qVXTlM+FTp0+Vh5QXmblbg9JmujbVKIlGg+Pbp
         hR/oOiUxLvoZq6MI4PGlG1tqRyYmi3PwIUgEU3USwuF+/uY1M3hjd1WGu+BAnywr6v8M
         AbU1dSwNGuMVTlFaaVBpgqJPVf/Euc7DcPU21ddYRAWFzgbNssohtKZo+PxXuZbMvlr/
         HeIbRGcjzZ5gy/88EpRtV5OJl4T7jqiKZtiJ0S13QwccZzDhPdm/RmRxrp2CtPjc9NMy
         bMi/K3QfqvY94RlkwjEraZ8wMMF5PWHc0zDu9r7CdwPW/5cvp6dQcCU8crgwL/M3QScT
         SrYg==
X-Gm-Message-State: AJcUukdTnw5rcd6rrJMa6GGHRfW2uDO446Pj9UsVoFqPe9wWM8B50ojL
        2blW2qUVGfow5gzFY9rCUvEm5ZGA
X-Google-Smtp-Source: ALg8bN52pFfyf+U8Sgg2QcYNNzm/cFZt+JhagL0mjmqpzDDLUpbAaVCGB6BnER26lgYSUBUj4kDwiw==
X-Received: by 2002:a63:3507:: with SMTP id c7mr3427883pga.315.1546992971286;
        Tue, 08 Jan 2019 16:16:11 -0800 (PST)
Received: from majic.sklembedded.com (c-98-210-181-167.hsd1.ca.comcast.net. [98.210.181.167])
        by smtp.googlemail.com with ESMTPSA id 134sm83978490pgb.78.2019.01.08.16.16.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Jan 2019 16:16:10 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v6 08/12] media: imx-csi: Allow skipping odd chroma rows for YVU420
Date:   Tue,  8 Jan 2019 16:15:47 -0800
Message-Id: <20190109001551.16113-9-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190109001551.16113-1-slongerbeam@gmail.com>
References: <20190109001551.16113-1-slongerbeam@gmail.com>
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
index dbc5a92ec073..47568ec43f4a 100644
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

