Return-Path: <SRS0=kVnX=P5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43828C37122
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 23:36:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03F552089F
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 23:36:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i8iLK1cU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbfAUXgJ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 18:36:09 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:35348 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbfAUXgH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 18:36:07 -0500
Received: by mail-pl1-f196.google.com with SMTP id p8so10506759plo.2;
        Mon, 21 Jan 2019 15:36:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B0uYN7ReRsHit1t5QoNp2KlyRKVVuxnnmNKWWSOG+BA=;
        b=i8iLK1cUCK8R5lFlPcF4uaRgmC/ohyTMnNY6Is6URWyJibZNN7s0WQT5TAuyrUERDx
         89tnmB1EMt/cGx/HkObEN7EZGryo/R5jZ072YPSCyMD/QKc7LoceTRdY5H8HKlzY7QeJ
         Ga9tOJoVvWRan6xmdxWjAf+HmTPeM6lpx9ETRnUKB9ZpK0XuYp7j8LstfdtBqBHlTcUU
         CX7wa7/jCtsrX8BZIzSPr+D5m0sPcl1/a/r4qKTk/yVEgZOsFt5+pFMMT+79jEQHMACo
         nkkDbIXo4/5A3hj40OYTcr4lQex7DR+b9Qje+U+3Wbjg0B5yrs2ixxrtRI+4epBg/exx
         /n3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B0uYN7ReRsHit1t5QoNp2KlyRKVVuxnnmNKWWSOG+BA=;
        b=cHT3b0PTFMFhD1RG7IdK7rj1ERH/eo3cVFC47DtF1Zwg5iUR7xWxq//MQ4FV6CzPfF
         UE7bNp6KcWo6tdXWVB73Qv4usD9QfIpgJj47dvF4l+NMorAD3ctNPFOfrnz7Ufp+pPy6
         c/zITImn9l6A48rabEffSuScSoB0DtRoB8nV+2InDwk/CCckLIs4w9Un0kfXI3dyVIHU
         5CzzksEnzcKp0xBELHeA53vaOK6eDsXzqBJAeh4G8VoKZcLRv5Q6/ddGeLC1D4N00pxo
         wJCE7nb68fSNHuBT0VaZYK3cRu7U8+tcNMt/BPHMgGp+Br2X5oskVaIaGVVsNXeohJ9g
         qm1A==
X-Gm-Message-State: AJcUukeY9tzWRjfs07Il3KTmFXmJCAhoHhkba6LqVdmLeEEkH+PzJo+x
        /To/1ZVA3mSolMHfeNcVVHjak1YDQKA=
X-Google-Smtp-Source: ALg8bN4lCxCQw5Zo5JBjcpZkmu+LUZrMNMNA/eOPwksIz2MM/UBczAXSylCso6wswBhxo+J1Z6swCA==
X-Received: by 2002:a17:902:2a0a:: with SMTP id i10mr31436769plb.323.1548113766047;
        Mon, 21 Jan 2019 15:36:06 -0800 (PST)
Received: from majic.sklembedded.com (c-73-202-231-77.hsd1.ca.comcast.net. [73.202.231.77])
        by smtp.googlemail.com with ESMTPSA id y9sm14016345pfi.74.2019.01.21.15.36.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Jan 2019 15:36:05 -0800 (PST)
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
Subject: [PATCH v4 3/3] media: imx: prpencvf: Stop upstream before disabling IDMA channel
Date:   Mon, 21 Jan 2019 15:35:52 -0800
Message-Id: <20190121233552.20001-4-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190121233552.20001-1-slongerbeam@gmail.com>
References: <20190121233552.20001-1-slongerbeam@gmail.com>
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
Changes in v4:
- none.
Changes in v3:
- Reword the commit subject and message. No functional changes.
Changes in v2:
- Add Fixes: and Cc: stable
---
 drivers/staging/media/imx/imx-ic-prpencvf.c | 26 ++++++++++++++-------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/media/imx/imx-ic-prpencvf.c b/drivers/staging/media/imx/imx-ic-prpencvf.c
index 053a911d477a..3637693c2bc8 100644
--- a/drivers/staging/media/imx/imx-ic-prpencvf.c
+++ b/drivers/staging/media/imx/imx-ic-prpencvf.c
@@ -706,12 +706,23 @@ static int prp_start(struct prp_priv *priv)
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
@@ -743,6 +754,12 @@ static void prp_stop(struct prp_priv *priv)
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
 
@@ -1173,15 +1190,6 @@ static int prp_s_stream(struct v4l2_subdev *sd, int enable)
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

