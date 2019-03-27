Return-Path: <SRS0=UobA=R6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D750C43381
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 15:19:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02B0520449
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 15:19:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730179AbfC0PTF (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Mar 2019 11:19:05 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:48500 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbfC0PTF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Mar 2019 11:19:05 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: tonyk)
        with ESMTPSA id 37F44281FF2
From:   =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@collabora.com>
To:     linux-media@vger.kernel.org
Cc:     mchehab@kernel.org, hverkuil@xs4all.nl, helen.koike@collabora.com,
        lucmaga@gmail.com, linux-kernel@vger.kernel.org,
        kernel@collabora.com, lkcamp@lists.libreplanetbr.org
Subject: [PATCH v2 04/15] media: vimc: cap: Dynamically define stream pixelformat
Date:   Wed, 27 Mar 2019 12:17:32 -0300
Message-Id: <20190327151743.18528-5-andrealmeid@collabora.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190327151743.18528-1-andrealmeid@collabora.com>
References: <20190327151743.18528-1-andrealmeid@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Define the pixelformat of the streamer depending to the
mode (single/multiplanar).

Signed-off-by: André Almeida <andrealmeid@collabora.com>
---
Change in v2:
- Add a macro to check if device is in multiplanar mode. Now, this check
is done using the capture device capabilities, rather than using the
multiplanar module parameter

 drivers/media/platform/vimc/vimc-capture.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/vimc/vimc-capture.c b/drivers/media/platform/vimc/vimc-capture.c
index de52f20b5c85..add6df565fa9 100644
--- a/drivers/media/platform/vimc/vimc-capture.c
+++ b/drivers/media/platform/vimc/vimc-capture.c
@@ -28,6 +28,10 @@
 
 #define VIMC_CAP_DRV_NAME "vimc-capture"
 
+/* Checks if the device supports multiplanar capture */
+#define IS_MULTIPLANAR(vcap) \
+	(vcap->vdev.device_caps & V4L2_CAP_VIDEO_CAPTURE_MPLANE)
+
 static const u32 vimc_cap_supported_pixfmt[] = {
 	V4L2_PIX_FMT_BGR24,
 	V4L2_PIX_FMT_RGB24,
@@ -282,7 +286,12 @@ static int vimc_cap_start_streaming(struct vb2_queue *vq, unsigned int count)
 		return ret;
 	}
 
-	vcap->stream.producer_pixfmt = vcap->format.fmt.pix.pixelformat;
+	if (IS_MULTIPLANAR(vcap))
+		vcap->stream.producer_pixfmt =
+			vcap->format.fmt.pix_mp.pixelformat;
+	else
+		vcap->stream.producer_pixfmt =
+			vcap->format.fmt.pix.pixelformat;
 
 	ret = vimc_streamer_s_stream(&vcap->stream, &vcap->ved, 1);
 	if (ret) {
-- 
2.21.0

