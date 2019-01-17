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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 348FFC43387
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 20:15:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02EFE20868
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 20:15:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J/S7bkUI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729577AbfAQUPF (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 17 Jan 2019 15:15:05 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:35837 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729567AbfAQUPF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Jan 2019 15:15:05 -0500
Received: by mail-pl1-f195.google.com with SMTP id p8so5251097plo.2;
        Thu, 17 Jan 2019 12:15:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3e+dMxNIs+9y9RgEfuBUSZuI1L9RakC9z6GiJpLFCgk=;
        b=J/S7bkUIuBKeHUags6OQNlQRtOarBP5DvjBxZa4MMyAY+hFC92SfjVAPhP62nN5I9r
         /P2M4m6LF94MyFl3+tTnPI0Wj0vmNQuiWdjMkvS6C8lPvu1nDVIZ2Pd3BLHHwIxG+xmp
         77mEnwA70ZV04WMyDcW1AEuke/CjVVGFrrOa9X+lubwZFf18MrCYHhPZUkWMEdBrcXdl
         wFF9/GFpjQTGP6XiT0KvAbA7gDaVOoYC7sv3aL3/Ke9v9Wk9Hqp4D1xvYbxx2EFQl1fc
         xFGBMGT/Ie9zDpP8PDBUt+4ZH+y7Vmwhuvts8uqpC9y9oIj1tCc+PfqFG+vHyDPe+I7W
         u0/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3e+dMxNIs+9y9RgEfuBUSZuI1L9RakC9z6GiJpLFCgk=;
        b=eVbqyxDCIYFZQAg/vjYB+SP0uFC3aQJ/5fa+5DfHzfS99qnks9UhujJm/HvviCgdNS
         ZS1z0lwLXFnBG75oODfs10ciGIvtNUzdn4XQrrsUMWd4mUUkNGpgOKR7g8G5rrTOxdTy
         m8v3tBagWigZ2a5jnEh8WbvS1evVdYQ6hHNbWoPfj64HAOXkve6T3wHOrG9ga6yG6jlQ
         KLukjIymwJjaExu/R0QnZDcGmwgbPQwGIojxZu8bPy2Jexs75rYS/mOmF4y3dEOgUPem
         lOuptgMXEYMvhzGy6etuExvEacpTbzBUK8KYeNa2Xp7/CSxf5LSlH/+OdrbcIpULJ81u
         5baA==
X-Gm-Message-State: AJcUukf0KgEAON+ZSfZ1e1vIxdi8vTtDMO1fRfbCOopMLV5sl7GrUdkU
        N7eP5Y+FKYgpPbYcmSi0Skd1tqaHtz4=
X-Google-Smtp-Source: ALg8bN5KtV7F9Vks/KOBSgMQAVKIKn5rUImGWrUqu2Fq1iLei3w3Ka+fg85/ZMdV+m9aSuKsk2jRmg==
X-Received: by 2002:a17:902:724a:: with SMTP id c10mr16564989pll.51.1547756104091;
        Thu, 17 Jan 2019 12:15:04 -0800 (PST)
Received: from majic.sklembedded.com (c-73-202-231-77.hsd1.ca.comcast.net. [73.202.231.77])
        by smtp.googlemail.com with ESMTPSA id b202sm5600744pfb.88.2019.01.17.12.15.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Jan 2019 12:15:03 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 2/2] media: imx: prpencvf: Disable CSI immediately after last EOF
Date:   Thu, 17 Jan 2019 12:13:47 -0800
Message-Id: <20190117201347.27347-3-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190117201347.27347-1-slongerbeam@gmail.com>
References: <20190117201347.27347-1-slongerbeam@gmail.com>
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

Reported-by: Gaël PORTAY <gael.portay@collabora.com>
Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
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

