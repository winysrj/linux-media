Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:45379 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030816AbeEYXxw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 May 2018 19:53:52 -0400
Received: by mail-pf0-f194.google.com with SMTP id c10-v6so3257036pfi.12
        for <linux-media@vger.kernel.org>; Fri, 25 May 2018 16:53:51 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: Philipp Zabel <p.zabel@pengutronix.de>,
        =?UTF-8?q?Krzysztof=20Ha=C5=82asa?= <khalasa@piap.pl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 4/6] media: imx-csi: Enable interlaced scan for field type alternate
Date: Fri, 25 May 2018 16:53:34 -0700
Message-Id: <1527292416-26187-5-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1527292416-26187-1-git-send-email-steve_longerbeam@mentor.com>
References: <1527292416-26187-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Interlaced scan, a.k.a. interweave, should be enabled at the CSI IDMAC
output pad if the input field type is 'alternate' (in addition to field
types 'seq-tb' and 'seq-bt').

Which brings up whether V4L2_FIELD_HAS_BOTH() macro should be used
to determine enabling interlaced/interweave scan. That macro
includes the 'interlaced' field types, and in those cases the data
is already interweaved with top/bottom field lines. A heads-up for
now that this if statement may need to call V4L2_FIELD_IS_SEQUENTIAL()
instead, I have no sensor hardware that sends 'interlaced' data, so can't
test.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/media/imx/imx-media-csi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 9bc555c..eef3483 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -477,7 +477,8 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
 	ipu_smfc_set_burstsize(priv->smfc, burst_size);
 
 	if (image.pix.field == V4L2_FIELD_NONE &&
-	    V4L2_FIELD_HAS_BOTH(infmt->field))
+	    (V4L2_FIELD_HAS_BOTH(infmt->field) ||
+	     infmt->field == V4L2_FIELD_ALTERNATE))
 		ipu_cpmem_interlaced_scan(priv->idmac_ch,
 					  image.pix.bytesperline);
 
-- 
2.7.4
