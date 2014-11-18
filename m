Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:48829 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754258AbaKRMve (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Nov 2014 07:51:34 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, m.szyprowski@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv7 PATCH 10/12] vivid: enable vb2_expbuf support.
Date: Tue, 18 Nov 2014 13:51:06 +0100
Message-Id: <1416315068-22936-11-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1416315068-22936-1-git-send-email-hverkuil@xs4all.nl>
References: <1416315068-22936-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Now that vb2 supports DMABUF export for dma-sg and vmalloc memory
modes, we can enable the vb2_expbuf support in vivid.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Pawel Osciak <pawel@osciak.com>
---
 drivers/media/platform/vivid/vivid-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
index 686c3c2..f80d1ca 100644
--- a/drivers/media/platform/vivid/vivid-core.c
+++ b/drivers/media/platform/vivid/vivid-core.c
@@ -586,7 +586,7 @@ static const struct v4l2_ioctl_ops vivid_ioctl_ops = {
 	.vidioc_querybuf		= vb2_ioctl_querybuf,
 	.vidioc_qbuf			= vb2_ioctl_qbuf,
 	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
-/* Not yet	.vidioc_expbuf		= vb2_ioctl_expbuf,*/
+	.vidioc_expbuf			= vb2_ioctl_expbuf,
 	.vidioc_streamon		= vb2_ioctl_streamon,
 	.vidioc_streamoff		= vb2_ioctl_streamoff,
 
-- 
2.1.1

