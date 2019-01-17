Return-Path: <SRS0=I7H+=PZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27B36C43387
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 20:58:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDF7420851
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 20:58:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oJtNvb6q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729520AbfAQU6q (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 17 Jan 2019 15:58:46 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33477 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726913AbfAQU6q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Jan 2019 15:58:46 -0500
Received: by mail-pg1-f194.google.com with SMTP id z11so4981876pgu.0;
        Thu, 17 Jan 2019 12:58:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=cRa9K9MKtMyR4OGRgKLP+N4UO7HLSkDOtiZhxV3KTSA=;
        b=oJtNvb6qgxD1flBBt4O6/GR3V3WQZTfJVczb1NhZn1aMcuyRSot2Ea0QVl3fU5kSAm
         sLs1hSONNTkbdffoIVdJTeZOA5cW5aZakYkdW6H6a6ZbZxaiDsA6RalHhra2O9jQ7cQC
         67CLmaJbpLV9BNdJfRHA+eeTnpnt/1R/ZjqpExYkGs/LFaPzabk5+gkic04i4C21vNUC
         WxhzEkjNSvhyn6fFiz88qz3//vXgxEjfA3aZAWR1sAEqf7U8Z7POwzMbeWbKXwbFQ/Yl
         Hm+AnQDSxnPct1oY3rc8/l4DpTpbniVHWvrB+6D1QEP1ghepQ4e+SVnKUF13IZ0CezO9
         RPAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=cRa9K9MKtMyR4OGRgKLP+N4UO7HLSkDOtiZhxV3KTSA=;
        b=YXdcUJ4eGu3qQ0i2ZJ65baRuFgW1lu8rK5TserpBkPEYeqSGxLFx6X91jcJJ8xJfZS
         J31EvHUSw8jMAzCMfxoZeZGLUZjHlVIdU5AWj8YwNzNpoOzZc3E2/F/2WUuUk1IWWLnE
         YIlgY8o0KFoxeMqJBCbh3Ez7IXmsc23g+ikn6neLAxnNWKCFGIbRMHziGV3ksFDFhPG5
         54txV/wYNgk9xdTmqPjDDd21RrvpuQYC5CUSCrw59Hkz+4mfy9+LMjos/mh9zCqvVk9q
         KQaqYDNe2M7WyGlHANC8q4J2J8Gy4qc4E1/T3zpxN0KRFnwtyp9szc7+2nhaSYO5L1Oy
         xEBA==
X-Gm-Message-State: AJcUukck04xl46+SRUCTqPEEMr2veP0oy4KW5toA7GFGlYvxtqgmC8/Z
        t7TmzCv0T21F7bsKa4Cz1uW626wuJSA=
X-Google-Smtp-Source: ALg8bN5/aMcYaBWDIN+5wiQrKQ14IKDm0niifYm2BTTTSm4fni4oK99lfRT6L9vhdBDZkTZ1EkKXCw==
X-Received: by 2002:a63:b34f:: with SMTP id x15mr15007723pgt.243.1547758724251;
        Thu, 17 Jan 2019 12:58:44 -0800 (PST)
Received: from majic.sklembedded.com (c-73-202-231-77.hsd1.ca.comcast.net. [73.202.231.77])
        by smtp.googlemail.com with ESMTPSA id h74sm4229828pfd.35.2019.01.17.12.58.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Jan 2019 12:58:43 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>, stable@vger.kernel.org,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2] media: imx-csi: Input connections to CSI should be optional
Date:   Thu, 17 Jan 2019 12:58:37 -0800
Message-Id: <20190117205837.29003-1-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Some imx platforms do not have fwnode connections to all CSI input
ports, and should not be treated as an error. This includes the
imx6q SabreAuto, which has no connections to ipu1_csi1 and ipu2_csi0.
Return -ENOTCONN in imx_csi_parse_endpoint() so that v4l2-fwnode
endpoint parsing will not treat an unconnected CSI input port as
an error.

Fixes: c893500a16baf ("media: imx: csi: Register a subdev notifier")

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Acked-by: Tim Harvey <tharvey@gateworks.com>
Cc: stable@vger.kernel.org
---
Changes in v2:
- Added some acks and Cc: stable. No functional changes.
---
 drivers/staging/media/imx/imx-media-csi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 555aa45e02e3..e18f58f56dfb 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -1861,7 +1861,7 @@ static int imx_csi_parse_endpoint(struct device *dev,
 				  struct v4l2_fwnode_endpoint *vep,
 				  struct v4l2_async_subdev *asd)
 {
-	return fwnode_device_is_available(asd->match.fwnode) ? 0 : -EINVAL;
+	return fwnode_device_is_available(asd->match.fwnode) ? 0 : -ENOTCONN;
 }
 
 static int imx_csi_async_register(struct csi_priv *priv)
-- 
2.17.1

