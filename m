Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95F3FC43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 18:17:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6511821738
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 18:17:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UfzmuUr2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbfAISRD (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 13:17:03 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42507 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727685AbfAISRC (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2019 13:17:02 -0500
Received: by mail-pf1-f195.google.com with SMTP id 64so4019791pfr.9;
        Wed, 09 Jan 2019 10:17:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=rYSzVI0OvbJN9zcjKQFFiU9YJ6PIbqf35eYJ6lEUQGw=;
        b=UfzmuUr2B98angPyQObuqq8DgESV3qiCfexOo0dsGjEIvP4/1xjuolow+pEEYAp2R6
         hvV6BUxy5OfcepDpBhAFyCVNQCYanfu1h64x41TaIfEOcP1ndzYRKI/jGlicJJXL1OB9
         i35Quxr1/7B4yjCXKG2OfX/gd17v7O4G/eWfxNDWdWKDmsKujpb8C5IJDuQsunIJtcj0
         gptSeFE1/1ef2fS9NcdO5kbVZo0eVQcDyoMm88V3nnTBcRqvc9AqdLTkx96Um3RPPTtd
         sbehGR276LM4jxLdXyi0o/uCjo80fvUZMWTKkdtwDZJ3VnUCaWi5P+ExHa0P2RU3m/sk
         zbGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=rYSzVI0OvbJN9zcjKQFFiU9YJ6PIbqf35eYJ6lEUQGw=;
        b=Uw0mRLTVzkWLSzXlFikFvFueTbvS2WmWBStFet72W0p9mIrc+BosLx1YVxJ+P6RNTK
         QOBZKCRaJflHnRs0WXEbYu6CPyGE5vV11bKjg1COTpMdYU8W+54PX/4wFMQFncb45TDJ
         gNzBW+aVCZ1272HTxFTwwYcm32nl7eT9yl7XM5d9xZ1iiQ4BMm9Oxv5RCl+bSQ8YDSgs
         j0zeugmhjkuN/GSzsU1JYWjEiawGK9U566KT/u4apmLEiwiMTqGWzwW/fQV5jaUV/KPK
         Yvqvm4cJtWX3zrVMQeMWzz7IaJP8xoW3XxQ2hAyG3fm/04uDd+Jn5tujeVnbdrNqMKVc
         6bIw==
X-Gm-Message-State: AJcUukcMQbWlUOSqx8d5men5SPHu+podYzHbpdER7XhIHK7usbaLrgxe
        bgbMQwx5RTxAchCE/YNyz+q0D3rp
X-Google-Smtp-Source: ALg8bN6SukM7ONhMQLbZr1hNXVTdtKPYiD/o4hr8CSxQnpBOPq5V9l0+7LeR/vc6+UX+T7hfNlpGyw==
X-Received: by 2002:a63:680a:: with SMTP id d10mr6428434pgc.396.1547057820927;
        Wed, 09 Jan 2019 10:17:00 -0800 (PST)
Received: from majic.sklembedded.com (c-98-210-181-167.hsd1.ca.comcast.net. [98.210.181.167])
        by smtp.googlemail.com with ESMTPSA id h19sm97030004pfn.114.2019.01.09.10.16.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Jan 2019 10:17:00 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v7 07/11] media: imx-csi: Allow skipping odd chroma rows for YVU420
Date:   Wed,  9 Jan 2019 10:16:37 -0800
Message-Id: <20190109181642.19378-8-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190109181642.19378-1-slongerbeam@gmail.com>
References: <20190109181642.19378-1-slongerbeam@gmail.com>
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

