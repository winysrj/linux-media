Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:59264 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751383AbbFGI61 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Jun 2015 04:58:27 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 03/11] sh-vou: fix querycap support
Date: Sun,  7 Jun 2015 10:57:57 +0200
Message-Id: <1433667485-35711-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1433667485-35711-1-git-send-email-hverkuil@xs4all.nl>
References: <1433667485-35711-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Fix v4l2-compliance errors due to empty driver and bus_info fields.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/sh_vou.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index 801d5ef..d7a72a9 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -396,6 +396,8 @@ static int sh_vou_querycap(struct file *file, void  *priv,
 	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
 
 	strlcpy(cap->card, "SuperH VOU", sizeof(cap->card));
+	strlcpy(cap->driver, "sh-vou", sizeof(cap->driver));
+	strlcpy(cap->bus_info, "platform:sh-vou", sizeof(cap->bus_info));
 	cap->device_caps = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
-- 
2.1.4

