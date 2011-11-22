Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1844 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab1KVMDb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Nov 2011 07:03:31 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ian Armstrong <mail01@iarmst.co.uk>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 2/3] zoran: do not set V4L2_FBUF_FLAG_OVERLAY.
Date: Tue, 22 Nov 2011 13:03:21 +0100
Message-Id: <c8c16066497a1b9e1236ff56f2be89395d47b4ec.1321963291.git.hans.verkuil@cisco.com>
In-Reply-To: <1321963402-1259-1-git-send-email-hverkuil@xs4all.nl>
References: <1321963402-1259-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <22fb81ba5ba878d10fe996d5421f983dd34a1988.1321963291.git.hans.verkuil@cisco.com>
References: <22fb81ba5ba878d10fe996d5421f983dd34a1988.1321963291.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The zoran driver does not support this flag, so don't set it.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/zoran/zoran_driver.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/zoran/zoran_driver.c b/drivers/media/video/zoran/zoran_driver.c
index d4d05d2..f7d236a 100644
--- a/drivers/media/video/zoran/zoran_driver.c
+++ b/drivers/media/video/zoran/zoran_driver.c
@@ -1958,7 +1958,6 @@ static int zoran_g_fbuf(struct file *file, void *__fh,
 	mutex_unlock(&zr->resource_lock);
 	fb->fmt.colorspace = V4L2_COLORSPACE_SRGB;
 	fb->fmt.field = V4L2_FIELD_INTERLACED;
-	fb->flags = V4L2_FBUF_FLAG_OVERLAY;
 	fb->capability = V4L2_FBUF_CAP_LIST_CLIPPING;
 
 	return 0;
-- 
1.7.7.3

