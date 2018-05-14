Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:50811 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932301AbeENNNw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 May 2018 09:13:52 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 5/7] imx: fix compiler warning
Date: Mon, 14 May 2018 15:13:44 +0200
Message-Id: <20180514131346.15795-6-hverkuil@xs4all.nl>
In-Reply-To: <20180514131346.15795-1-hverkuil@xs4all.nl>
References: <20180514131346.15795-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/staging/media/imx/imx-media-capture.c: In function 'vidioc_querycap':
drivers/staging/media/imx/imx-media-capture.c:76:2: warning: 'strncpy' output truncated copying 15 bytes from a string of length 17 [-Wstringop-truncation]
  strncpy(cap->driver, "imx-media-capture", sizeof(cap->driver) - 1);
  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/staging/media/imx/imx-media-capture.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-capture.c b/drivers/staging/media/imx/imx-media-capture.c
index 0ccabe04b0e1..4e3fdf8aeef5 100644
--- a/drivers/staging/media/imx/imx-media-capture.c
+++ b/drivers/staging/media/imx/imx-media-capture.c
@@ -73,8 +73,8 @@ static int vidioc_querycap(struct file *file, void *fh,
 {
 	struct capture_priv *priv = video_drvdata(file);
 
-	strncpy(cap->driver, "imx-media-capture", sizeof(cap->driver) - 1);
-	strncpy(cap->card, "imx-media-capture", sizeof(cap->card) - 1);
+	strlcpy(cap->driver, "imx-media-capture", sizeof(cap->driver));
+	strlcpy(cap->card, "imx-media-capture", sizeof(cap->card));
 	snprintf(cap->bus_info, sizeof(cap->bus_info),
 		 "platform:%s", priv->src_sd->name);
 
-- 
2.17.0
