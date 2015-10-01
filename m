Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60602 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696AbbJAR0U (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Oct 2015 13:26:20 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 5/5] [media] DocBook: Remove a warning at videobuf2-v4l2.h
Date: Thu,  1 Oct 2015 14:26:02 -0300
Message-Id: <d383b57911c8a6c3da1af7b3f72dfecfcd5633d0.1443720347.git.mchehab@osg.samsung.com>
In-Reply-To: <1ccd66cca96a377ef924d2ee76fbb753a7bec9ea.1443720347.git.mchehab@osg.samsung.com>
References: <1ccd66cca96a377ef924d2ee76fbb753a7bec9ea.1443720347.git.mchehab@osg.samsung.com>
In-Reply-To: <1ccd66cca96a377ef924d2ee76fbb753a7bec9ea.1443720347.git.mchehab@osg.samsung.com>
References: <1ccd66cca96a377ef924d2ee76fbb753a7bec9ea.1443720347.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's no need to document to_foo() macros, and the macro is
badly documented anyway. That removes this warning:
	include/media/videobuf2-v4l2.h:43: warning: No description found for parameter 'vb'

While here, remove the parenthesis for container_of(). The
countainer_of() already have parenthesis inside it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/include/media/videobuf2-v4l2.h b/include/media/videobuf2-v4l2.h
index 20d8ad20066c..71f7fe2706b3 100644
--- a/include/media/videobuf2-v4l2.h
+++ b/include/media/videobuf2-v4l2.h
@@ -36,10 +36,10 @@ struct vb2_v4l2_buffer {
 	__u32			sequence;
 };
 
-/**
+/*
  * to_vb2_v4l2_buffer() - cast struct vb2_buffer * to struct vb2_v4l2_buffer *
  */
 #define to_vb2_v4l2_buffer(vb) \
-	(container_of(vb, struct vb2_v4l2_buffer, vb2_buf))
+	container_of(vb, struct vb2_v4l2_buffer, vb2_buf)
 
 #endif /* _MEDIA_VIDEOBUF2_V4L2_H */
-- 
2.4.3

