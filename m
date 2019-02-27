Return-Path: <SRS0=SnUM=RC=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC1A7C00319
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 17:08:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CD1A20842
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 17:08:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730163AbfB0RIy (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Feb 2019 12:08:54 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:48032 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730006AbfB0RI0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Feb 2019 12:08:26 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id DF55F28073F
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v2 3/4] media: v4l: Add a module parameter to control global debugging
Date:   Wed, 27 Feb 2019 14:07:05 -0300
Message-Id: <20190227170706.6258-4-ezequiel@collabora.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190227170706.6258-1-ezequiel@collabora.com>
References: <20190227170706.6258-1-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

In addition to the dev_debug device attribute, which controls
per-device debugging, we now add a module parameter to control
debugging globally.

This will allow to add debugging of v4l2 control logic,
using the newly introduced debug parameter.

In addition, this module parameter adds consistency to the
subsystem, since other v4l2 modules expose the same parameter.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/media/v4l2-core/v4l2-dev.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index 7cfb05204065..39d22bfbe420 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -36,8 +36,16 @@
 #define VIDEO_NUM_DEVICES	256
 #define VIDEO_NAME              "video4linux"
 
+unsigned int videodev_debug;
+module_param_named(debug, videodev_debug, uint, 0644);
+
+/*
+ * The videodev_debug module parameter controls the global debug level,
+ * while the dev_debug device attribute controls the local
+ * per-device debug level.
+ */
 #define dprintk(vdev, flags, fmt, arg...) do {				\
-	if (vdev->dev_debug & flags)					\
+	if ((videodev_debug & flags) || (vdev->dev_debug & flags))	\
 		printk(KERN_DEBUG pr_fmt("%s: %s: " fmt),		\
 		       __func__, video_device_node_name(vdev), ##arg);	\
 } while (0)
-- 
2.20.1

