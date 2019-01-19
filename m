Return-Path: <SRS0=jH9h=P3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12102C61CE3
	for <linux-media@archiver.kernel.org>; Sat, 19 Jan 2019 01:05:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C78D92087E
	for <linux-media@archiver.kernel.org>; Sat, 19 Jan 2019 01:05:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lMetuke9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727442AbfASBFK (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 18 Jan 2019 20:05:10 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:32880 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbfASBFJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Jan 2019 20:05:09 -0500
Received: by mail-pl1-f193.google.com with SMTP id z23so7086286plo.0;
        Fri, 18 Jan 2019 17:05:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jo6uF/Bb588VrfKQ3Bf/yZ/V7tccuOBIBhw3APlJnCA=;
        b=lMetuke9K1KS0eEGT2vCBslUwNXHTvYPDEXh4S0/PgR2D4ahJASJJBjRa6iS+vhQDT
         oms7mLcIdtW2xrIhpz0JEX0ABIHSZZzZMUSqYf3F+McfrjybvAqoOg11pC/Hstfv1/n7
         tu8p0LdeuK9W73wKYU6+t6yX47fS2BbHVrayKrU7eaZPDqhO2abPU8g4osEWpuTIyY3L
         dAz48/X53RVhBw89+qzHKqXV03gvzRjQuXGz4O7JP0DcenlVsHxbSDE3RD8qeSmEUUe4
         8/nuXHioswvEKU6XpbTkWstgXCXKyjv8mu14TiP24iSlL7h5vg3M7FwwEmUNsi6vYDQa
         5u2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jo6uF/Bb588VrfKQ3Bf/yZ/V7tccuOBIBhw3APlJnCA=;
        b=B9fxYDypjTd4vwwxT3b92/NTXdkPt435wXkBAYjJhyjbuDHvATzmWCWmdkONX9klf1
         37DM49MKqKRNx3PJ/w0W1MHmEZ4bXhJMuZmvvLNsd2eEorw3aYRmX8ElEqG6lClBs4Ow
         EnGhztcUTF1XXBXr7BapDOubhNSWo8omoFymFbdd7cVVxwvmc1WptsAWjom/jsAYPPjL
         YYFWChSbGesIrl36FAg+0CsIx4MwX67N8zX5LKussrlIb/CLsva0s4BRsxq3EcGLgSTd
         GHzaLzYxRw8Gi4/GEKJvi0lR6SphgOvr5W8HD0MX1IjHnp09tRLojIHtNojpwu31EvZF
         mjFw==
X-Gm-Message-State: AJcUukdgixukbKRg77Hz5OBLjKdYIpQdLaMRnFUmrqEOblTW0+BW7O7Q
        LFryxFc6NDYldpq2nZN5ehF6o+a0u0A=
X-Google-Smtp-Source: ALg8bN6e4fFsttREh9ZKCah554hK1l3bJ+n7efkkNeBEOKsEEUGjmphyhTnKvWzkBuavYdOFjWUotg==
X-Received: by 2002:a17:902:2bc5:: with SMTP id l63mr21500764plb.107.1547859907491;
        Fri, 18 Jan 2019 17:05:07 -0800 (PST)
Received: from majic.sklembedded.com (c-73-202-231-77.hsd1.ca.comcast.net. [73.202.231.77])
        by smtp.googlemail.com with ESMTPSA id w128sm7955307pfw.79.2019.01.18.17.05.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Jan 2019 17:05:06 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Gael PORTAY <gael.portay@collabora.com>,
        Peter Seiderer <ps.report@gmx.net>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        stable@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 2/2] media: imx: prpencvf: Stop upstream before disabling IDMA channel
Date:   Fri, 18 Jan 2019 17:04:57 -0800
Message-Id: <20190119010457.2623-3-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190119010457.2623-1-slongerbeam@gmail.com>
References: <20190119010457.2623-1-slongerbeam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Upstream must be stopped immediately after receiving the last EOF and
before disabling the IDMA channel. This can be accomplished by moving
upstream stream off to just after receiving the last EOF completion in
prp_stop(). For symmetry also move upstream stream on to end of
prp_start().

This fixes a complete system hard lockup on the SabreAuto when streaming
from the ADV7180, by repeatedly sending a stream off immediately followed
by stream on:

while true; do v4l2-ctl  -d1 --stream-mmap --stream-count=3; done

Eventually this either causes the system lockup or EOF timeouts at all
subsequent stream on, until a system reset.

The lockup occurs when disabling the IDMA channel at stream off. Stopping
the video data stream entering the IDMA channel before disabling the
channel itself appears to be a reliable fix for the hard lockup.

Fixes: f0d9c8924e2c3 ("[media] media: imx: Add IC subdev drivers")

Reported-by: Gaël PORTAY <gael.portay@collabora.com>
Tested-by: Gaël PORTAY <gael.portay@collabora.com>
Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
Cc: stable@vger.kernel.org
---
Changes in v3:
- Reword the commit subject and message. No functional changes.
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

