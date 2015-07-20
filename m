Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:58848 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755127AbbGTNKr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2015 09:10:47 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Anatolij Gustschin <agust@denx.de>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/6] fsl-viu: fill in bus_info in vidioc_querycap.
Date: Mon, 20 Jul 2015 15:09:29 +0200
Message-Id: <1437397773-5752-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1437397773-5752-1-git-send-email-hverkuil@xs4all.nl>
References: <1437397773-5752-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The bus_info field was never filled.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/fsl-viu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/fsl-viu.c b/drivers/media/platform/fsl-viu.c
index f0ec551..ab8012c 100644
--- a/drivers/media/platform/fsl-viu.c
+++ b/drivers/media/platform/fsl-viu.c
@@ -563,6 +563,7 @@ static int vidioc_querycap(struct file *file, void *priv,
 {
 	strcpy(cap->driver, "viu");
 	strcpy(cap->card, "viu");
+	strcpy(cap->bus_info, "platform:viu");
 	cap->device_caps =	V4L2_CAP_VIDEO_CAPTURE |
 				V4L2_CAP_STREAMING     |
 				V4L2_CAP_VIDEO_OVERLAY |
-- 
2.1.4

