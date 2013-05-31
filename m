Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2763 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab3EaKD0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 06:03:26 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	=?UTF-8?q?Richard=20R=C3=B6jfors?= <richard.rojfors@pelagicore.com>
Subject: [PATCH 16/21] timblogiw: fix querycap.
Date: Fri, 31 May 2013 12:02:36 +0200
Message-Id: <1369994561-25236-17-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369994561-25236-1-git-send-email-hverkuil@xs4all.nl>
References: <1369994561-25236-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Don't set version (the core does that for you), fill in device_caps and
prefix bus_info with "platform:".

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Richard Röjfors <richard.rojfors@pelagicore.com>
---
 drivers/media/platform/timblogiw.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/timblogiw.c b/drivers/media/platform/timblogiw.c
index 99861c63..b557caf 100644
--- a/drivers/media/platform/timblogiw.c
+++ b/drivers/media/platform/timblogiw.c
@@ -239,13 +239,12 @@ static int timblogiw_querycap(struct file *file, void  *priv,
 	struct video_device *vdev = video_devdata(file);
 
 	dev_dbg(&vdev->dev, "%s: Entry\n",  __func__);
-	memset(cap, 0, sizeof(*cap));
 	strncpy(cap->card, TIMBLOGIWIN_NAME, sizeof(cap->card)-1);
 	strncpy(cap->driver, DRIVER_NAME, sizeof(cap->driver) - 1);
-	strlcpy(cap->bus_info, vdev->name, sizeof(cap->bus_info));
-	cap->version = TIMBLOGIW_VERSION_CODE;
-	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
+	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s", vdev->name);
+	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
 		V4L2_CAP_READWRITE;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 
 	return 0;
 }
-- 
1.7.10.4

