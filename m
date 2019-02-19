Return-Path: <SRS0=RQn6=Q2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21192C10F00
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 13:24:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E62162183F
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 13:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550582699;
	bh=NadlLXHtDWSa7zCyRLs89E3jKWtFwAmLgyF4q+rfdM0=;
	h=From:Cc:Subject:Date:To:List-ID:From;
	b=wQlR9JYhvxQfEkKpX2fLB/HdbwPIt3OWj24tBcyuHsKGxrISSJkUxZnSpcR9PsuVh
	 nWo60rkzagovyfYUJVR3YTHD/maGY0Z5gOLS8d9eYh8Xwvt5pPXJv5mnnkUKoDnDqr
	 WdljQasE8rDnmxct7OXmq/D1BAz0VTlbwesIdpsM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728786AbfBSNY5 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Feb 2019 08:24:57 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:49182 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728747AbfBSNY4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Feb 2019 08:24:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=a4D5eqjpPs86CBBsvAftQHWh9l71anAHWt50GV4ud6E=; b=ArpMkG/ST3ipO8MvaBVArBRfW
        3CHvrayle4f78MyG+Jsf9mPl76KVJn9OMDV9tnLL0TEJ3k39yxHxzhePU7SGxTL4rCLC7aibUQSd/
        Wz6AmN8wP1v9iw0r/uAuQNfi1nQcIRp4XNTXzotSQncMelnIufkdvl1EGsUzOGr/nOeeuZLTUmtQe
        YVtGdyZjyR+BnyLLW8CBjXuxZjWRIUIgF1WK5Ngg54ZpSIGEaGpKBsxlgN4msIZx6TGni9A1kVmwq
        kI4FhkoEZD+kpmXdp3yfV6JHdbn/CqEKGRQpWHvd9p8TpVGE8p5UbwQAlVPcCyucm8ZTow+X+jy2/
        8eXH0x+CQ==;
Received: from 177.96.194.24.dynamic.adsl.gvt.net.br ([177.96.194.24] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gw5OJ-0005BK-UR; Tue, 19 Feb 2019 13:24:55 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.91)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1gw5OH-0001Ia-AM; Tue, 19 Feb 2019 08:24:53 -0500
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: [PATCH 1/2] media: imx7-media-csi: don't store a floating pointer
Date:   Tue, 19 Feb 2019 08:24:51 -0500
Message-Id: <1c186d5fd734e63305352986b6c5e84d19375787.1550582690.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

if imx7_csi_try_fmt() fails, outcc variable won't be
initialized and csi->cc[IMX7_CSI_PAD_SRC] would be pointing
to a random location.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/staging/media/imx/imx7-media-csi.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/media/imx/imx7-media-csi.c b/drivers/staging/media/imx/imx7-media-csi.c
index d775e259fece..0b1788d79ce9 100644
--- a/drivers/staging/media/imx/imx7-media-csi.c
+++ b/drivers/staging/media/imx/imx7-media-csi.c
@@ -980,10 +980,10 @@ static int imx7_csi_get_fmt(struct v4l2_subdev *sd,
 	return ret;
 }
 
-static void imx7_csi_try_fmt(struct imx7_csi *csi,
-			     struct v4l2_subdev_pad_config *cfg,
-			     struct v4l2_subdev_format *sdformat,
-			     const struct imx_media_pixfmt **cc)
+static int imx7_csi_try_fmt(struct imx7_csi *csi,
+			    struct v4l2_subdev_pad_config *cfg,
+			    struct v4l2_subdev_format *sdformat,
+			    const struct imx_media_pixfmt **cc)
 {
 	const struct imx_media_pixfmt *in_cc;
 	struct v4l2_mbus_framefmt *in_fmt;
@@ -992,7 +992,7 @@ static void imx7_csi_try_fmt(struct imx7_csi *csi,
 	in_fmt = imx7_csi_get_format(csi, cfg, IMX7_CSI_PAD_SINK,
 				     sdformat->which);
 	if (!in_fmt)
-		return;
+		return -EINVAL;
 
 	switch (sdformat->pad) {
 	case IMX7_CSI_PAD_SRC:
@@ -1023,8 +1023,10 @@ static void imx7_csi_try_fmt(struct imx7_csi *csi,
 						   false);
 		break;
 	default:
+		return -EINVAL;
 		break;
 	}
+	return 0;
 }
 
 static int imx7_csi_set_fmt(struct v4l2_subdev *sd,
@@ -1067,8 +1069,10 @@ static int imx7_csi_set_fmt(struct v4l2_subdev *sd,
 		format.pad = IMX7_CSI_PAD_SRC;
 		format.which = sdformat->which;
 		format.format = sdformat->format;
-		imx7_csi_try_fmt(csi, cfg, &format, &outcc);
-
+		if (imx7_csi_try_fmt(csi, cfg, &format, &outcc)) {
+			ret = -EINVAL;
+			goto out_unlock;
+		}
 		outfmt = imx7_csi_get_format(csi, cfg, IMX7_CSI_PAD_SRC,
 					     sdformat->which);
 		*outfmt = format.format;
-- 
2.20.1

