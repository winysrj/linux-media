Return-Path: <SRS0=7C2H=RS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EDC3C43381
	for <linux-media@archiver.kernel.org>; Fri, 15 Mar 2019 16:45:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68A91218EA
	for <linux-media@archiver.kernel.org>; Fri, 15 Mar 2019 16:45:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729739AbfCOQpT (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 15 Mar 2019 12:45:19 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:49012 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729702AbfCOQpS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Mar 2019 12:45:18 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: tonyk)
        with ESMTPSA id 4EC08281581
From:   =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@collabora.com>
To:     linux-media@vger.kernel.org
Cc:     mchehab@kernel.org, hverkuil@xs4all.nl, helen.koike@collabora.com,
        lucmaga@gmail.com, linux-kernel@vger.kernel.org,
        kernel@collabora.com
Subject: [PATCH 06/16] media: vimc: cap: Dynamically define stream pixelformat
Date:   Fri, 15 Mar 2019 13:43:49 -0300
Message-Id: <20190315164359.626-7-andrealmeid@collabora.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190315164359.626-1-andrealmeid@collabora.com>
References: <20190315164359.626-1-andrealmeid@collabora.com>
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
 drivers/media/platform/vimc/vimc-capture.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/vimc/vimc-capture.c b/drivers/media/platform/vimc/vimc-capture.c
index c7ec55c4fe13..a93241d53953 100644
--- a/drivers/media/platform/vimc/vimc-capture.c
+++ b/drivers/media/platform/vimc/vimc-capture.c
@@ -282,7 +282,12 @@ static int vimc_cap_start_streaming(struct vb2_queue *vq, unsigned int count)
 		return ret;
 	}
 
-	vcap->stream.producer_pixfmt = vcap->format.fmt.pix.pixelformat;
+	if (vcap->format.type == V4L2_CAP_VIDEO_CAPTURE_MPLANE)
+		vcap->stream.producer_pixfmt =
+			vcap->format.fmt.pix_mp.pixelformat;
+	else
+		vcap->stream.producer_pixfmt =
+			vcap->format.fmt.pix.pixelformat;
 
 	ret = vimc_streamer_s_stream(&vcap->stream, &vcap->ved, 1);
 	if (ret) {
-- 
2.21.0

