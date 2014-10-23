Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1782 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932164AbaJWLWX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Oct 2014 07:22:23 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, m.szyprowski@samsung.com,
	laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv4 PATCH 08/15] vivid: enable vb2_expbuf support.
Date: Thu, 23 Oct 2014 13:21:35 +0200
Message-Id: <1414063302-26903-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1414063302-26903-1-git-send-email-hverkuil@xs4all.nl>
References: <1414063302-26903-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Now that vb2 supports DMABUF export for dma-sg and vmalloc memory
modes, we can enable the vb2_expbuf support in vivid.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
index 2c61a62..7de8d9d 100644
--- a/drivers/media/platform/vivid/vivid-core.c
+++ b/drivers/media/platform/vivid/vivid-core.c
@@ -588,7 +588,7 @@ static const struct v4l2_ioctl_ops vivid_ioctl_ops = {
 	.vidioc_querybuf		= vb2_ioctl_querybuf,
 	.vidioc_qbuf			= vb2_ioctl_qbuf,
 	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
-/* Not yet	.vidioc_expbuf		= vb2_ioctl_expbuf,*/
+	.vidioc_expbuf			= vb2_ioctl_expbuf,
 	.vidioc_streamon		= vb2_ioctl_streamon,
 	.vidioc_streamoff		= vb2_ioctl_streamoff,
 
-- 
2.1.1

