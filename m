Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:61339 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758112Ab1IHHs2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2011 03:48:28 -0400
Date: Thu, 8 Sep 2011 09:48:14 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sakari Ailus <sakari.ailus@iki.fi>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Pawel Osciak <pawel@osciak.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH] V4L: docbook documentation for struct v4l2_create_buffers
In-Reply-To: <Pine.LNX.4.64.1109080942172.31156@axis700.grange>
Message-ID: <Pine.LNX.4.64.1109080946420.31156@axis700.grange>
References: <1314813768-27752-1-git-send-email-g.liakhovetski@gmx.de>
 <1314813768-27752-3-git-send-email-g.liakhovetski@gmx.de>
 <20110831210615.GQ12368@valkosipuli.localdomain> <Pine.LNX.4.64.1109010850560.21309@axis700.grange>
 <20110901084229.GU12368@valkosipuli.localdomain> <Pine.LNX.4.64.1109080942172.31156@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Obviously, this goes on top of the "multi-size buffers" patch series. 
Thanks again to Sakari for the idea.

 drivers/media/video/v4l2-compat-ioctl32.c |   13 +++++++++++--
 include/linux/videodev2.h                 |   14 +++++++++++---
 2 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
index 85758d2..b1064a1 100644
--- a/drivers/media/video/v4l2-compat-ioctl32.c
+++ b/drivers/media/video/v4l2-compat-ioctl32.c
@@ -159,11 +159,20 @@ struct v4l2_format32 {
 	} fmt;
 };
 
+/**
+ * struct v4l2_create_buffers32 - VIDIOC_CREATE_BUFS32 argument
+ * @index:	on return, index of the first created buffer
+ * @count:	entry: number of requested buffers,
+ *		return: number of created buffers
+ * @memory:	buffer memory type
+ * @format:	frame format, for which buffers are requested
+ * @reserved:	future extensions
+ */
 struct v4l2_create_buffers32 {
-	__u32			index;		/* output: buffers index...index + count - 1 have been created */
+	__u32			index;
 	__u32			count;
 	enum v4l2_memory        memory;
-	struct v4l2_format32	format;		/* filled in by the user, plane sizes calculated by the driver */
+	struct v4l2_format32	format;
 	__u32			reserved[8];
 };
 
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 66a9e53..84852c1 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -2102,12 +2102,20 @@ struct v4l2_dbg_chip_ident {
 	__u32 revision;    /* chip revision, chip specific */
 } __attribute__ ((packed));
 
-/* VIDIOC_CREATE_BUFS */
+/**
+ * struct v4l2_create_buffers - VIDIOC_CREATE_BUFS argument
+ * @index:	on return, index of the first created buffer
+ * @count:	entry: number of requested buffers,
+ *		return: number of created buffers
+ * @memory:	buffer memory type
+ * @format:	frame format, for which buffers are requested
+ * @reserved:	future extensions
+ */
 struct v4l2_create_buffers {
-	__u32			index;		/* output: buffers index...index + count - 1 have been created */
+	__u32			index;
 	__u32			count;
 	enum v4l2_memory        memory;
-	struct v4l2_format	format;		/* "type" is used always, the rest if sizeimage == 0 */
+	struct v4l2_format	format;
 	__u32			reserved[8];
 };
 
-- 
1.7.2.5

