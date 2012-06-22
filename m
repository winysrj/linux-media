Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2653 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932751Ab2FVMVp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jun 2012 08:21:45 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pawel Osciak <pawel@osciak.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 05/34] v4l2-ioctl.c: remove an unnecessary #ifdef.
Date: Fri, 22 Jun 2012 14:20:59 +0200
Message-Id: <05f2265e86ef1f37c0d83761674f2917dafe5eb4.1340366355.git.hans.verkuil@cisco.com>
In-Reply-To: <1340367688-8722-1-git-send-email-hverkuil@xs4all.nl>
References: <1340367688-8722-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1cee710ae251aa69bed8e563a94b419ed99bc41a.1340366355.git.hans.verkuil@cisco.com>
References: <1cee710ae251aa69bed8e563a94b419ed99bc41a.1340366355.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-ioctl.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 3b11e0d..e72babf 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -506,10 +506,8 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO(VIDIOC_TRY_ENCODER_CMD, INFO_FL_CLEAR(v4l2_encoder_cmd, flags)),
 	IOCTL_INFO(VIDIOC_DECODER_CMD, INFO_FL_PRIO),
 	IOCTL_INFO(VIDIOC_TRY_DECODER_CMD, 0),
-#ifdef CONFIG_VIDEO_ADV_DEBUG
 	IOCTL_INFO(VIDIOC_DBG_S_REGISTER, 0),
 	IOCTL_INFO(VIDIOC_DBG_G_REGISTER, 0),
-#endif
 	IOCTL_INFO(VIDIOC_DBG_G_CHIP_IDENT, 0),
 	IOCTL_INFO(VIDIOC_S_HW_FREQ_SEEK, INFO_FL_PRIO),
 	IOCTL_INFO(VIDIOC_ENUM_DV_PRESETS, 0),
-- 
1.7.10

