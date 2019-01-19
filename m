Return-Path: <SRS0=jH9h=P3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6DD8C61CE8
	for <linux-media@archiver.kernel.org>; Sat, 19 Jan 2019 21:46:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 980AB2084C
	for <linux-media@archiver.kernel.org>; Sat, 19 Jan 2019 21:46:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YtdhT8Rb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729701AbfASVqO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 19 Jan 2019 16:46:14 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50244 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729056AbfASVqO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 19 Jan 2019 16:46:14 -0500
Received: by mail-wm1-f65.google.com with SMTP id n190so7586669wmd.0;
        Sat, 19 Jan 2019 13:46:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=w4pDpNNiZVftYGZN/ZfjMBwdA+nK0DkXdKOIzQhsz4k=;
        b=YtdhT8RbsdmQsBpQBYCWX0f1PY7Jefd/07yOzlZTUBuyPkZ4DvkM2+8YNO2a9NT0dQ
         08rh+SjbGnEGSm9TQvg4hzXhScXLsp5C48NaVELrWom2pt8GT9JwKpHlhz2aGFW9h2TN
         R83DNFAg7IGT4tV9SHZiEaa5ioBYjNrS9vn95hmYtKt8/GG4XCMo7tjo546RYMYObkwb
         e49RTIwV8bbE/7/IFqSw78xu7th9v+zrtV6zleKD4MJ03j9ltclWeHTP7F/Bd3mm7Kmt
         /QGfKuMbpMwWU6zv7zo4iEvrM7G9AzduduUVsXVbCFUC4h7iveihPQlrpgdARcn9O/wm
         gYGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=w4pDpNNiZVftYGZN/ZfjMBwdA+nK0DkXdKOIzQhsz4k=;
        b=i56oWNQxcWfBoe6RH8QIVD7RBtyevA17nH3JZ7HyIOazbk+uq1YjxqS7LLM9oomX27
         M4cD8MIDpVtoIHPjXiWaEG2VJr/qTPoHYSJElv7WxRBWbbK3Y35A691KSiDhuVTVg0HT
         GUPEWsSmSADGJyHg0UCHy5jzdgy8PN9Mmm3IyqSoPlOLEYUAEcP1+/lv8pec3MpqYi2z
         oQE5VyjaEsbS2I6hnHRSWsmbaztBj2BC5Zz/ZQMMat6IJziuAAyO6D2uNkD+E2XJXEiG
         UCRryBAXL3HH9UqAvvYBzbJTxBgqqWBlbMB+RHhRVCekUcZbV7V5ka9AjPgWVUe42mmt
         YwQQ==
X-Gm-Message-State: AJcUukeIPeVFfe/rKpT/t5yneLRx6jnyM+A/UFv1MnUGFZ0fKfFI1yyi
        xgw0KkjK4p1OPJlyLXbYr0Xyn9dZ
X-Google-Smtp-Source: ALg8bN7a4uh70hBn2UPLgTkTDPaqo7nkqhTBtUiBkvqgfA7W3WOlb+EDMZFDlaRl3J2WchsgPBadeA==
X-Received: by 2002:a1c:2b01:: with SMTP id r1mr19430582wmr.7.1547934371081;
        Sat, 19 Jan 2019 13:46:11 -0800 (PST)
Received: from mappy.world.mentorg.com (sjewanfw1-nat.mentorg.com. [139.181.7.34])
        by smtp.gmail.com with ESMTPSA id o5sm26432048wrw.46.2019.01.19.13.46.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 19 Jan 2019 13:46:10 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>, stable@vger.kernel.org,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/4] media: imx: csi: Allow unknown nearest upstream entities
Date:   Sat, 19 Jan 2019 13:45:57 -0800
Message-Id: <20190119214600.30897-2-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190119214600.30897-1-slongerbeam@gmail.com>
References: <20190119214600.30897-1-slongerbeam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On i.MX6, the nearest upstream entity to the CSI can only be the
CSI video muxes or the Synopsys DW MIPI CSI-2 receiver.

However the i.MX53 has no CSI video muxes or a MIPI CSI-2 receiver.
So allow for the nearest upstream entity to the CSI to be something
other than those.

Fixes: bf3cfaa712e5c ("media: staging/imx: get CSI bus type from nearest
upstream entity")

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
Cc: stable@vger.kernel.org
---
 drivers/staging/media/imx/imx-media-csi.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 555aa45e02e3..b9af7d3d4974 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -154,9 +154,10 @@ static inline bool requires_passthrough(struct v4l2_fwnode_endpoint *ep,
 /*
  * Parses the fwnode endpoint from the source pad of the entity
  * connected to this CSI. This will either be the entity directly
- * upstream from the CSI-2 receiver, or directly upstream from the
- * video mux. The endpoint is needed to determine the bus type and
- * bus config coming into the CSI.
+ * upstream from the CSI-2 receiver, directly upstream from the
+ * video mux, or directly upstream from the CSI itself. The endpoint
+ * is needed to determine the bus type and bus config coming into
+ * the CSI.
  */
 static int csi_get_upstream_endpoint(struct csi_priv *priv,
 				     struct v4l2_fwnode_endpoint *ep)
@@ -172,7 +173,8 @@ static int csi_get_upstream_endpoint(struct csi_priv *priv,
 	if (!priv->src_sd)
 		return -EPIPE;
 
-	src = &priv->src_sd->entity;
+	sd = priv->src_sd;
+	src = &sd->entity;
 
 	if (src->function == MEDIA_ENT_F_VID_MUX) {
 		/*
@@ -186,6 +188,14 @@ static int csi_get_upstream_endpoint(struct csi_priv *priv,
 			src = &sd->entity;
 	}
 
+	/*
+	 * If the source is neither the video mux nor the CSI-2 receiver,
+	 * get the source pad directly upstream from CSI itself.
+	 */
+	if (src->function != MEDIA_ENT_F_VID_MUX &&
+	    sd->grp_id != IMX_MEDIA_GRP_ID_CSI2)
+		src = &priv->sd.entity;
+
 	/* get source pad of entity directly upstream from src */
 	pad = imx_media_find_upstream_pad(priv->md, src, 0);
 	if (IS_ERR(pad))
-- 
2.17.1

