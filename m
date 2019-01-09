Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93DBDC43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 00:16:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6319120883
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 00:16:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a1VM7OHC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729459AbfAIAQJ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 19:16:09 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40586 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727917AbfAIAQI (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 19:16:08 -0500
Received: by mail-pf1-f193.google.com with SMTP id i12so2725090pfo.7;
        Tue, 08 Jan 2019 16:16:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Czin5sL8tW0JC/3lnEKv/S5HZ7pdR7BqrSyW7TzK7EU=;
        b=a1VM7OHC8lgSv15TBVN9mp9osmm70Bc4s8eopOZIopXpxSTWgWo7yLeFOFTqkXHnT6
         fRz7Azvw9KqOrcgPRomKn/5Y+IszcWnaR+GnuI/SPMSAMjjWyXm2ZEGRhNliBTpvbPEf
         cDS/aBNEZgwLjgK+OYvBEdS2+goag8zKOfc/VAp9eJj2C+HBEV0YYHnCu7ZBWsopJRux
         eMqwQaLuQu6h3ZcQzgIUWvJtTGNYUqw4HZnVIsfL7GUV7gSIzaT/zSOYg+CMGy/N9goG
         T1BMhrKgATg4d49cy764BODCsewy2JvqQFFnQcxT/Cs58X2BIv0vwsGLFXGTubdX6ENe
         0E7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Czin5sL8tW0JC/3lnEKv/S5HZ7pdR7BqrSyW7TzK7EU=;
        b=Yf+BFesIjw5GZT29TvsNzyAmVwWAi0tmjIDDgGb2zsDdOHN0tIyjUFqxt8aC3yqUgx
         IW7n2X2151w5+ad555NAgluFQKqTvMKJwLdq8q2FFBpPycS/ZAuoqzIk9iUe38Cy89qm
         Duvt7fuQd6mo++vZSC9M5g0q2zUqFBlSwXCwgtxezZJ7Zxbbe5RGVAhID6krRtkBdmED
         R/oIvF7D59IZdT47qA3HTSHKxLcUQyPHxNakVj2M+qCK9uTTAd9weHjlWRnnuAFfxn32
         7gmPD0RLE1OzibLu9RpOHqoIZWpPEp0CU8JMSOrsJHTJJKIHxrH405ImDvtYlwj4zAPW
         FubQ==
X-Gm-Message-State: AJcUukdF0NEz7V3ytCBDAQoYZvbpnQdHD9Q1gduC5nphtlE3Pt61o57t
        ZehNxaymScM5R7z96bz8is0G7d4w
X-Google-Smtp-Source: ALg8bN5cBC/AlmfBQS/Mf4dkZboVWzl4FuZEHkygAKs8tKw5rqxT30dQDJPrUwCpCzENJ/VIZqp7Sg==
X-Received: by 2002:a63:fa06:: with SMTP id y6mr3419463pgh.177.1546992967008;
        Tue, 08 Jan 2019 16:16:07 -0800 (PST)
Received: from majic.sklembedded.com (c-98-210-181-167.hsd1.ca.comcast.net. [98.210.181.167])
        by smtp.googlemail.com with ESMTPSA id 134sm83978490pgb.78.2019.01.08.16.16.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Jan 2019 16:16:06 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v6 05/12] media: imx-csi: Input connections to CSI should be optional
Date:   Tue,  8 Jan 2019 16:15:44 -0800
Message-Id: <20190109001551.16113-6-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190109001551.16113-1-slongerbeam@gmail.com>
References: <20190109001551.16113-1-slongerbeam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Some imx platforms do not have fwnode connections to all CSI input
ports, and should not be treated as an error. This includes the
imx6q SabreAuto, which has no connections to ipu1_csi1 and ipu2_csi0.
Return -ENOTCONN in imx_csi_parse_endpoint() so that v4l2-fwnode
endpoint parsing will not treat an unconnected endpoint as an error.

Fixes: c893500a16baf ("media: imx: csi: Register a subdev notifier")

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
---
 drivers/staging/media/imx/imx-media-csi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index e3a4f39dbf73..b276672cae1d 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -1815,7 +1815,7 @@ static int imx_csi_parse_endpoint(struct device *dev,
 				  struct v4l2_fwnode_endpoint *vep,
 				  struct v4l2_async_subdev *asd)
 {
-	return fwnode_device_is_available(asd->match.fwnode) ? 0 : -EINVAL;
+	return fwnode_device_is_available(asd->match.fwnode) ? 0 : -ENOTCONN;
 }
 
 static int imx_csi_async_register(struct csi_priv *priv)
-- 
2.17.1

