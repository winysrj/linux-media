Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:48791 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754264AbaKRMvf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Nov 2014 07:51:35 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, m.szyprowski@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv7 PATCH 11/12] vim2m: support expbuf
Date: Tue, 18 Nov 2014 13:51:07 +0100
Message-Id: <1416315068-22936-12-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1416315068-22936-1-git-send-email-hverkuil@xs4all.nl>
References: <1416315068-22936-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Pawel Osciak <pawel@osciak.com>
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

