Return-Path: <SRS0=kVnX=P5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FA62C37121
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 23:36:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B32C2089F
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 23:36:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dyIBGIgL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726154AbfAUXgQ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 18:36:16 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:42232 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbfAUXgF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 18:36:05 -0500
Received: by mail-pl1-f194.google.com with SMTP id y1so10479958plp.9;
        Mon, 21 Jan 2019 15:36:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=a/eetTcJ26ZJlFP+3ea80N+KYWA4OeXHxe/dNYX7NA8=;
        b=dyIBGIgLRAxkBkwyD6W1b5pSU318eaGzlHrsa0L/LbVEYjbXXhu0/kJ8bjlom42B0/
         KD4izrywQD0mkVGddQENFBsN/Wn63lGbEgRt545/5xQ/Muu6Ugel/XjDhhZtHUlXdK97
         T2pnadE1nqnaYd2ebo5kKITaV+kMlbNU8ETtSOPMpdD7eXfdlpiz0qXt9fbJSZQ7Kn/x
         leN68vQoxpSbop+g5jFx16Gv39/AAurmjL9ev+FPTPd0e/1oK2ohUU6IO+a3RHnu2BM3
         4pLCJsEMFqLSDpbtq/OxXXf5NPpLLQwBhTZcwuKxT02iRW2knVzHEaccszdBtgijxy+l
         KG4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=a/eetTcJ26ZJlFP+3ea80N+KYWA4OeXHxe/dNYX7NA8=;
        b=gnikZPsyW4Uj1hO08wEk9F/ay8Iju9Ua4bCcBi4sd72IdSNzknSljd53fmG2AyDBfJ
         Ej4O6QJL1tks3Fx/+OB9b8Uk/q8e1BbwpxyxOQJ/aPJmKm6VXPA+eEY9tNilTlIb41ck
         v2Kqw/JECUVQHhbIcayCHlugvQf1h2H8+AxLb1UD5Z+6qnTZy40QMGIf1Lv/O0P9p/cm
         vVs9DnHCg6pPWc/fbmVspJ9dcAM8DGo6+lv+m6WPplzK54QMQfrSF1QX3dO0iSwjOWRL
         sPKrpfZtQFjWPewEfv5tyrO3iU2b800gsmoegekpM/uv+J8WySvVBjQ7kTkNwp1ZOLYk
         8tMA==
X-Gm-Message-State: AJcUukdoNP53T/HdEhptK/iGtDS8CdUGwkO6GP6CS6Rqdw+HsieA8kwy
        tNOsZvq8mQmtBt2r+6R0Bm3pWtveCwI=
X-Google-Smtp-Source: ALg8bN6ZRy5BR102hzT1bO+iPt7CrxkKwuw9z6EIlJVuHkre+mCJsqNOQ8TeswKBln+kSCO2J5GmlA==
X-Received: by 2002:a17:902:201:: with SMTP id 1mr31737705plc.62.1548113764561;
        Mon, 21 Jan 2019 15:36:04 -0800 (PST)
Received: from majic.sklembedded.com (c-73-202-231-77.hsd1.ca.comcast.net. [73.202.231.77])
        by smtp.googlemail.com with ESMTPSA id y9sm14016345pfi.74.2019.01.21.15.36.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Jan 2019 15:36:03 -0800 (PST)
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
Subject: [PATCH v4 2/3] media: imx: csi: Stop upstream before disabling IDMA channel
Date:   Mon, 21 Jan 2019 15:35:51 -0800
Message-Id: <20190121233552.20001-3-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190121233552.20001-1-slongerbeam@gmail.com>
References: <20190121233552.20001-1-slongerbeam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Move upstream stream off to just after receiving the last EOF completion
and disabling the CSI (and thus before disabling the IDMA channel) in
csi_stop(). For symmetry also move upstream stream on to beginning of
csi_start().

Doing this makes csi_s_stream() more symmetric with prp_s_stream() which
will require the same change to fix a hard lockup.

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
Cc: stable@vger.kernel.org
---
 drivers/staging/media/imx/imx-media-csi.c | 25 ++++++++++++-----------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 920e38885292..d851ca2497b4 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -753,10 +753,16 @@ static int csi_start(struct csi_priv *priv)
 
 	output_fi = &priv->frame_interval[priv->active_output_pad];
 
+	/* start upstream */
+	ret = v4l2_subdev_call(priv->src_sd, video, s_stream, 1);
+	ret = (ret && ret != -ENOIOCTLCMD) ? ret : 0;
+	if (ret)
+		return ret;
+
 	if (priv->dest == IPU_CSI_DEST_IDMAC) {
 		ret = csi_idmac_start(priv);
 		if (ret)
-			return ret;
+			goto stop_upstream;
 	}
 
 	ret = csi_setup(priv);
@@ -784,6 +790,8 @@ static int csi_start(struct csi_priv *priv)
 idmac_stop:
 	if (priv->dest == IPU_CSI_DEST_IDMAC)
 		csi_idmac_stop(priv);
+stop_upstream:
+	v4l2_subdev_call(priv->src_sd, video, s_stream, 0);
 	return ret;
 }
 
@@ -799,6 +807,9 @@ static void csi_stop(struct csi_priv *priv)
 	 */
 	ipu_csi_disable(priv->csi);
 
+	/* stop upstream */
+	v4l2_subdev_call(priv->src_sd, video, s_stream, 0);
+
 	if (priv->dest == IPU_CSI_DEST_IDMAC) {
 		csi_idmac_stop(priv);
 
@@ -966,23 +977,13 @@ static int csi_s_stream(struct v4l2_subdev *sd, int enable)
 		goto update_count;
 
 	if (enable) {
-		/* upstream must be started first, before starting CSI */
-		ret = v4l2_subdev_call(priv->src_sd, video, s_stream, 1);
-		ret = (ret && ret != -ENOIOCTLCMD) ? ret : 0;
-		if (ret)
-			goto out;
-
 		dev_dbg(priv->dev, "stream ON\n");
 		ret = csi_start(priv);
-		if (ret) {
-			v4l2_subdev_call(priv->src_sd, video, s_stream, 0);
+		if (ret)
 			goto out;
-		}
 	} else {
 		dev_dbg(priv->dev, "stream OFF\n");
-		/* CSI must be stopped first, then stop upstream */
 		csi_stop(priv);
-		v4l2_subdev_call(priv->src_sd, video, s_stream, 0);
 	}
 
 update_count:
-- 
2.17.1

