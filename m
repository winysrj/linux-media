Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:53315 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753721Ab2GTNZ4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jul 2012 09:25:56 -0400
Received: from zeta.dmz-eu.st.com (zeta.dmz-eu.st.com [164.129.230.9])
	by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id D8209122
	for <linux-media@vger.kernel.org>; Fri, 20 Jul 2012 13:25:38 +0000 (GMT)
Received: from Webmail-eu.st.com (safex1hubcas3.st.com [10.75.90.18])
	by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 884AD475B
	for <linux-media@vger.kernel.org>; Fri, 20 Jul 2012 13:25:38 +0000 (GMT)
From: Nicolas THERY <nicolas.thery@st.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Fri, 20 Jul 2012 15:25:37 +0200
Subject: [PATCH for 3.6] v4l: fix copy/paste typo in vb2_reqbufs comment
Message-ID: <50095C51.5010207@st.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Nicolas Thery <nicolas.thery@st.com>
---
diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index 4e0290a..268c7dd 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -715,8 +715,8 @@ static int __create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create
 }
 
 /**
- * vb2_reqbufs() - Wrapper for __reqbufs() that also verifies the memory and
- * type values.
+ * vb2_create_bufs() - Wrapper for __create_bufs() that also verifies the
+ * memory and type values.
  * @q:		videobuf2 queue
  * @create:	creation parameters, passed from userspace to vidioc_create_bufs
  *		handler in driver