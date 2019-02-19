Return-Path: <SRS0=RQn6=Q2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B23E8C43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 07:38:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 819F1217D9
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 07:38:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725802AbfBSHi2 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Feb 2019 02:38:28 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:33956 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725794AbfBSHi1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Feb 2019 02:38:27 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id vzywgf5ZOLMwIvzyzgmm1N; Tue, 19 Feb 2019 08:38:26 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Steve Longerbeam <slongerbeam@gmail.com>,
        Rui Miguel Silva <rui.silva@linaro.org>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH] imx7-media-csi.c: fix merge breakage
Message-ID: <bd961821-0cab-7bb5-372e-4e79f85988f1@xs4all.nl>
Date:   Tue, 19 Feb 2019 08:38:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfDGA+4u7ntdQDOps6EtS0MtLKlGGUKGQWShr+fezhuVgybz+hNPbx4ks+ck5Tcw7WcLTku8vH4+vhqBlWYidFGj5G36STOSA00zYm7BqYPcBJhv1E0xJ
 wFl8qtarA3wcsanvJSHKoraxOWXeGjYTOmLTuw7claworZ5VSNWvQVR2Ragn7gLIPAH4d5K9+zjp9FNdg2uipJpTopce+f/t/LA5nerOFysUiDdZsiXf+KAA
 XI1hsR9RIXQRLRiAyJ48rA==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Commit 5964cbd86922 ("imx: Set capture compose rectangle in
capture_device_set_format") broke the compilation of commit
05f634040c0d ("staging/imx7: add imx7 CSI subdev driver").

These patches came in through different pull requests and
nobody noticed that the first changed functions that the
second relied upon.

Update imx7-media-csi.c accordingly.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
diff --git a/drivers/staging/media/imx/imx7-media-csi.c b/drivers/staging/media/imx/imx7-media-csi.c
index c1cf80bcad64..d775e259fece 100644
--- a/drivers/staging/media/imx/imx7-media-csi.c
+++ b/drivers/staging/media/imx/imx7-media-csi.c
@@ -1036,6 +1036,7 @@ static int imx7_csi_set_fmt(struct v4l2_subdev *sd,
 	const struct imx_media_pixfmt *outcc;
 	struct v4l2_mbus_framefmt *outfmt;
 	struct v4l2_pix_format vdev_fmt;
+	struct v4l2_rect vdev_compose;
 	const struct imx_media_pixfmt *cc;
 	struct v4l2_mbus_framefmt *fmt;
 	struct v4l2_subdev_format format;
@@ -1082,11 +1083,11 @@ static int imx7_csi_set_fmt(struct v4l2_subdev *sd,
 	csi->cc[sdformat->pad] = cc;

 	/* propagate output pad format to capture device */
-	imx_media_mbus_fmt_to_pix_fmt(&vdev_fmt,
+	imx_media_mbus_fmt_to_pix_fmt(&vdev_fmt, &vdev_compose,
 				      &csi->format_mbus[IMX7_CSI_PAD_SRC],
 				      csi->cc[IMX7_CSI_PAD_SRC]);
 	mutex_unlock(&csi->lock);
-	imx_media_capture_device_set_format(vdev, &vdev_fmt);
+	imx_media_capture_device_set_format(vdev, &vdev_fmt, &vdev_compose);

 	return 0;

