Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3249 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152AbaJWLWW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Oct 2014 07:22:22 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, m.szyprowski@samsung.com,
	laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv4 PATCH 09/15] mem2mem_testdev: support expbuf
Date: Thu, 23 Oct 2014 13:21:36 +0200
Message-Id: <1414063302-26903-10-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1414063302-26903-1-git-send-email-hverkuil@xs4all.nl>
References: <1414063302-26903-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/mem2mem_testdev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/mem2mem_testdev.c b/drivers/media/platform/mem2mem_testdev.c
index c1b03cf..9ee80cd 100644
--- a/drivers/media/platform/mem2mem_testdev.c
+++ b/drivers/media/platform/mem2mem_testdev.c
@@ -698,6 +698,7 @@ static const struct v4l2_ioctl_ops m2mtest_ioctl_ops = {
 	.vidioc_querybuf	= v4l2_m2m_ioctl_querybuf,
 	.vidioc_qbuf		= v4l2_m2m_ioctl_qbuf,
 	.vidioc_dqbuf		= v4l2_m2m_ioctl_dqbuf,
+	.vidioc_expbuf		= v4l2_m2m_ioctl_expbuf,
 
 	.vidioc_streamon	= v4l2_m2m_ioctl_streamon,
 	.vidioc_streamoff	= v4l2_m2m_ioctl_streamoff,
-- 
2.1.1

