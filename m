Return-Path: <SRS0=OvUS=QF=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 012B2C4151A
	for <linux-media@archiver.kernel.org>; Tue, 29 Jan 2019 16:08:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD6CE2184D
	for <linux-media@archiver.kernel.org>; Tue, 29 Jan 2019 16:08:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727786AbfA2QIR (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 29 Jan 2019 11:08:17 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:46931 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727100AbfA2QIR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Jan 2019 11:08:17 -0500
Received: from dude02.hi.pengutronix.de ([2001:67c:670:100:1d::28] helo=dude02.lab.pengutronix.de)
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <mfe@pengutronix.de>)
        id 1goVvk-0007VO-Pk; Tue, 29 Jan 2019 17:08:08 +0100
Received: from mfe by dude02.lab.pengutronix.de with local (Exim 4.89)
        (envelope-from <mfe@pengutronix.de>)
        id 1goVvj-0000dn-EK; Tue, 29 Jan 2019 17:08:07 +0100
From:   Marco Felsch <m.felsch@pengutronix.de>
To:     mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        sakari.ailus@linux.intel.com
Cc:     devicetree@vger.kernel.org, p.zabel@pengutronix.de,
        javierm@redhat.com, afshin.nasser@gmail.com,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH v4 4/7] media: v4l2-subdev: add stubs for v4l2_subdev_get_try_*
Date:   Tue, 29 Jan 2019 17:07:54 +0100
Message-Id: <20190129160757.2314-5-m.felsch@pengutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190129160757.2314-1-m.felsch@pengutronix.de>
References: <20190129160757.2314-1-m.felsch@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::28
X-SA-Exim-Mail-From: mfe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

In case of missing CONFIG_VIDEO_V4L2_SUBDEV_API those helpers aren't
available. So each driver have to add ifdefs around those helpers or
add the CONFIG_VIDEO_V4L2_SUBDEV_API as dependcy.

Make these helpers available in case of CONFIG_VIDEO_V4L2_SUBDEV_API
isn't set to avoid ifdefs. This approach is less error prone too.

Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
---
 include/media/v4l2-subdev.h | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 47af609dc8f1..90c9a301d72a 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -916,8 +916,6 @@ struct v4l2_subdev_fh {
 #define to_v4l2_subdev_fh(fh)	\
 	container_of(fh, struct v4l2_subdev_fh, vfh)
 
-#if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
-
 /**
  * v4l2_subdev_get_try_format - ancillary routine to call
  *	&struct v4l2_subdev_pad_config->try_fmt
@@ -931,9 +929,13 @@ static inline struct v4l2_mbus_framefmt
 			    struct v4l2_subdev_pad_config *cfg,
 			    unsigned int pad)
 {
+#if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
 	if (WARN_ON(pad >= sd->entity.num_pads))
 		pad = 0;
 	return &cfg[pad].try_fmt;
+#else
+	return NULL;
+#endif
 }
 
 /**
@@ -949,9 +951,13 @@ static inline struct v4l2_rect
 			  struct v4l2_subdev_pad_config *cfg,
 			  unsigned int pad)
 {
+#if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
 	if (WARN_ON(pad >= sd->entity.num_pads))
 		pad = 0;
 	return &cfg[pad].try_crop;
+#else
+	return NULL;
+#endif
 }
 
 /**
@@ -967,11 +973,14 @@ static inline struct v4l2_rect
 			     struct v4l2_subdev_pad_config *cfg,
 			     unsigned int pad)
 {
+#if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
 	if (WARN_ON(pad >= sd->entity.num_pads))
 		pad = 0;
 	return &cfg[pad].try_compose;
-}
+#else
+	return NULL;
 #endif
+}
 
 extern const struct v4l2_file_operations v4l2_subdev_fops;
 
-- 
2.20.1

