Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6085C43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 14:20:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B359D206B6
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 14:20:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730481AbfAIOUa (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 09:20:30 -0500
Received: from mail.bootlin.com ([62.4.15.54]:44910 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730200AbfAIOUa (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 Jan 2019 09:20:30 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id 5EFB720A13; Wed,  9 Jan 2019 15:20:28 +0100 (CET)
Received: from localhost.localdomain (aaubervilliers-681-1-45-241.w90-88.abo.wanadoo.fr [90.88.163.241])
        by mail.bootlin.com (Postfix) with ESMTPSA id E70E32078E;
        Wed,  9 Jan 2019 15:20:17 +0100 (CET)
From:   Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To:     linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Cc:     Maxime Ripard <maxime.ripard@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chen-Yu Tsai <wens@csie.org>, Randy Li <ayaka@soulik.info>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: [PATCH 1/2] media: cedrus: Cleanup duplicate declarations from cedrus_dec header
Date:   Wed,  9 Jan 2019 15:19:19 +0100
Message-Id: <20190109141920.12677-1-paul.kocialkowski@bootlin.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Some leftover declarations are still in the cedrus_dec header although
they were moved to cedrus_video already. Clean them up.

Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
---
 drivers/staging/media/sunxi/cedrus/cedrus_dec.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_dec.h b/drivers/staging/media/sunxi/cedrus/cedrus_dec.h
index 4f423d3a1cad..d1ae7903677b 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_dec.h
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_dec.h
@@ -16,12 +16,6 @@
 #ifndef _CEDRUS_DEC_H_
 #define _CEDRUS_DEC_H_
 
-extern const struct v4l2_ioctl_ops cedrus_ioctl_ops;
-
-void cedrus_device_work(struct work_struct *work);
 void cedrus_device_run(void *priv);
 
-int cedrus_queue_init(void *priv, struct vb2_queue *src_vq,
-		      struct vb2_queue *dst_vq);
-
 #endif
-- 
2.20.1

