Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:21746 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab2GSMAy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jul 2012 08:00:54 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [RFC PATCH 2/6] mem2mem_testdev: set bus_info and device_caps.
Date: Thu, 19 Jul 2012 14:00:20 +0200
Message-Id: <8e6829023ea338cee205b6e27aee75a008e97454.1342699069.git.hans.verkuil@cisco.com>
In-Reply-To: <1342699224-12642-1-git-send-email-hans.verkuil@cisco.com>
References: <1342699224-12642-1-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <903c0da0d6e7354d6f884f0ddec783143165e54c.1342699069.git.hans.verkuil@cisco.com>
References: <903c0da0d6e7354d6f884f0ddec783143165e54c.1342699069.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/mem2mem_testdev.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/mem2mem_testdev.c b/drivers/media/video/mem2mem_testdev.c
index a1d5c15..fe8c565 100644
--- a/drivers/media/video/mem2mem_testdev.c
+++ b/drivers/media/video/mem2mem_testdev.c
@@ -427,10 +427,10 @@ static int vidioc_querycap(struct file *file, void *priv,
 {
 	strncpy(cap->driver, MEM2MEM_NAME, sizeof(cap->driver) - 1);
 	strncpy(cap->card, MEM2MEM_NAME, sizeof(cap->card) - 1);
-	cap->bus_info[0] = 0;
-	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT
+	strlcpy(cap->bus_info, MEM2MEM_NAME, sizeof(cap->bus_info));
+	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT
 			  | V4L2_CAP_STREAMING;
-
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
 
-- 
1.7.10

