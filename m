Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:42787 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752577AbaKJMtl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Nov 2014 07:49:41 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, pawel@osciak.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv6 PATCH 10/16] vim2m: support expbuf
Date: Mon, 10 Nov 2014 13:49:25 +0100
Message-Id: <1415623771-29634-11-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1415623771-29634-1-git-send-email-hverkuil@xs4all.nl>
References: <1415623771-29634-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vim2m.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index 87af47a..1105c11 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -697,6 +697,7 @@ static const struct v4l2_ioctl_ops vim2m_ioctl_ops = {
 	.vidioc_querybuf	= v4l2_m2m_ioctl_querybuf,
 	.vidioc_qbuf		= v4l2_m2m_ioctl_qbuf,
 	.vidioc_dqbuf		= v4l2_m2m_ioctl_dqbuf,
+	.vidioc_expbuf		= v4l2_m2m_ioctl_expbuf,
 
 	.vidioc_streamon	= v4l2_m2m_ioctl_streamon,
 	.vidioc_streamoff	= v4l2_m2m_ioctl_streamoff,
-- 
2.1.1

