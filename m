Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:33013 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751669AbbFEK7q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Jun 2015 06:59:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 02/10] sh-vou: fix querycap support
Date: Fri,  5 Jun 2015 12:59:18 +0200
Message-Id: <1433501966-30176-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1433501966-30176-1-git-send-email-hverkuil@xs4all.nl>
References: <1433501966-30176-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Fix v4l2-compliance errors due to empty driver and bus_info fields.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/sh_vou.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index 9e98233..ba1a16c 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -398,6 +398,8 @@ static int sh_vou_querycap(struct file *file, void  *priv,
 	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
 
 	strlcpy(cap->card, "SuperH VOU", sizeof(cap->card));
+	strlcpy(cap->driver, "sh-vou", sizeof(cap->driver));
+	strlcpy(cap->bus_info, "platform:sh-vou", sizeof(cap->bus_info));
 	cap->device_caps = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
-- 
2.1.4

