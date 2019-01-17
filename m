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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BED3AC43387
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 20:49:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88B7E20868
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 20:49:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eMdgydE7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727745AbfAQUtg (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 17 Jan 2019 15:49:36 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:43806 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726905AbfAQUte (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Jan 2019 15:49:34 -0500
Received: by mail-pl1-f195.google.com with SMTP id gn14so5264589plb.10;
        Thu, 17 Jan 2019 12:49:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1CeHF8JpPX+3eBjpFQ299XD9B5rV/dSfOnnUNODOxhY=;
        b=eMdgydE7Iw65oq7L/45dJkOe9F8CNQRLTfSnT4y/hz4V8+FwhMwnNzuRln1evETzdD
         RC85He0XamYQzoho4I4iXC00s6JOI8OL1MQUOPl9HazubvC6k6MIfJ890B4ju0GE7VNp
         uZucUan5vr4kiCa6pcQZHJ8G6xN0O5qRrbFv9mGWxR+2FdCPJeZNYdbCT9N9h0ssUunQ
         izf0nASJMDx92V1O5fNdPerE/Awb9iPAAfcCYO0KWqqqvymSqGQ5gmbzFWbkEfq112y0
         VA5zQqbMZZbyL3fZBuJsCo6bIfAp0PDAoLhPL7FprnTGCste4B8P++m8m+SjwR/S7tbJ
         9stw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1CeHF8JpPX+3eBjpFQ299XD9B5rV/dSfOnnUNODOxhY=;
        b=Tazzi4sgVbRYn8ETRcPiGNvWxlBzWyPDwmYSo/qjeN8hPyahC1t6KzAbwOBPsPFTTM
         lA7eiSv7fB80J7O9DoXv9Yq+qDboyatM0N8RGbvzbdlmNWo9xniqI5rSWlTa8S5hWcXK
         uXPc8CMiJhjl7WRYlLvGbKnir+/5dsC/Ad6pxnqRrROrguLW6D+9H5jImxHYceCi7Tj5
         5C8U1JGxPhfnGYm1MoHinI7XXBDk20dp5p2nFQwUINqaoCSLLx7chMkM3KEwmWe56Qbn
         WzDlBNqGnEipksxLno0cL+owFZ24lIBgudPqDcmfiprw0kpQWY4ibO1nvV6QVrGFTGJs
         HTQw==
X-Gm-Message-State: AJcUukc3sN6S7BP6WLxzbpaCnc/pVbZ92Tly4AHH/x0vljBMsgvTRnqd
        /8QVga0iczZmRYQbdP6CjnEoPpVqs9M=
X-Google-Smtp-Source: ALg8bN5eSjdIv6gzOE/E/Lfjh2VgGg9GNPhMp3Y7t4dlwE08PgvYNeJEFOd2bw7/GKNrjiRndHfLUQ==
X-Received: by 2002:a17:902:f082:: with SMTP id go2mr16475317plb.115.1547758172910;
        Thu, 17 Jan 2019 12:49:32 -0800 (PST)
Received: from majic.sklembedded.com (c-73-202-231-77.hsd1.ca.comcast.net. [73.202.231.77])
        by smtp.googlemail.com with ESMTPSA id b68sm4007481pfg.160.2019.01.17.12.49.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Jan 2019 12:49:32 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>, stable@vger.kernel.org,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 2/2] media: imx: prpencvf: Disable CSI immediately after last EOF
Date:   Thu, 17 Jan 2019 12:49:12 -0800
Message-Id: <20190117204912.28456-3-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190117204912.28456-1-slongerbeam@gmail.com>
References: <20190117204912.28456-1-slongerbeam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The CSI must be disabled immediately after receiving the last EOF before
stream off (and thus before disabling the IDMA channel). This can be
accomplished by moving upstream stream off to just after receiving the
last EOF completion in prp_stop(). For symmetry also move upstream
stream on to end of prp_start().

This fixes a complete system hard lockup on the SabreAuto when streaming
from the ADV7180, by repeatedly sending a stream off immediately followed
by stream on:

while true; do v4l2-ctl  -d1 --stream-mmap --stream-count=3; done

Eventually this either causes the system lockup or EOF timeouts at all
subsequent stream on, until a system reset.

The lockup occurs when disabling the IDMA channel at stream off. Disabling
the CSI before disabling the IDMA channel appears to be a reliable fix for
the hard lockup.

Fixes: f0d9c8924e2c3 ("[media] media: imx: Add IC subdev drivers")

Reported-by: Gaël PORTAY <gael.portay@collabora.com>
Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
Cc: stable@vger.kernel.org
---
Changes in v2:
- Add Fixes: and Cc: stable
---
 drivers/staging/media/imx/imx-ic-prpencvf.c | 26 ++++++++++++++-------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/media/imx/imx-ic-prpencvf.c b/drivers/staging/media/imx/imx-ic-prpencvf.c
index 33ada6612fee..f53cdb608528 100644
--- a/drivers/staging/media/imx/imx-ic-prpencvf.c
+++ b/drivers/staging/media/imx/imx-ic-prpencvf.c
@@ -707,12 +707,23 @@ static int prp_start(struct prp_priv *priv)
 		goto out_free_nfb4eof_irq;
 	}
 
+	/* start upstream */
+	ret = v4l2_subdev_call(priv->src_sd, video, s_stream, 1);
+	ret = (ret && ret != -ENOIOCTLCMD) ? ret : 0;
+	if (ret) {
+		v4l2_err(&ic_priv->sd,
+			 "upstream stream on failed: %d\n", ret);
+		goto out_free_eof_irq;
+	}
+
 	/* start the EOF timeout timer */
 	mod_timer(&priv->eof_timeout_timer,
 		  jiffies + msecs_to_jiffies(IMX_MEDIA_EOF_TIMEOUT));
 
 	return 0;
 
+out_free_eof_irq:
+	devm_free_irq(ic_priv->dev, priv->eof_irq, priv);
 out_free_nfb4eof_irq:
 	devm_free_irq(ic_priv->dev, priv->nfb4eof_irq, priv);
 out_unsetup:
@@ -744,6 +755,12 @@ static void prp_stop(struct prp_priv *priv)
 	if (ret == 0)
 		v4l2_warn(&ic_priv->sd, "wait last EOF timeout\n");
 
+	/* stop upstream */
+	ret = v4l2_subdev_call(priv->src_sd, video, s_stream, 0);
+	if (ret && ret != -ENOIOCTLCMD)
+		v4l2_warn(&ic_priv->sd,
+			  "upstream stream off failed: %d\n", ret);
+
 	devm_free_irq(ic_priv->dev, priv->eof_irq, priv);
 	devm_free_irq(ic_priv->dev, priv->nfb4eof_irq, priv);
 
@@ -1174,15 +1191,6 @@ static int prp_s_stream(struct v4l2_subdev *sd, int enable)
 	if (ret)
 		goto out;
 
-	/* start/stop upstream */
-	ret = v4l2_subdev_call(priv->src_sd, video, s_stream, enable);
-	ret = (ret && ret != -ENOIOCTLCMD) ? ret : 0;
-	if (ret) {
-		if (enable)
-			prp_stop(priv);
-		goto out;
-	}
-
 update_count:
 	priv->stream_count += enable ? 1 : -1;
 	if (priv->stream_count < 0)
-- 
2.17.1

