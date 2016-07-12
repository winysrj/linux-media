Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:57119 "EHLO
	aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030298AbcGLOjk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 10:39:40 -0400
Received: from [10.47.79.81] ([10.47.79.81])
	(authenticated bits=0)
	by aer-core-2.cisco.com (8.14.5/8.14.5) with ESMTP id u6CEdb81008092
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 12 Jul 2016 14:39:38 GMT
To: linux-media <linux-media@vger.kernel.org>
From: Hans Verkuil <hansverk@cisco.com>
Subject: vidioc-g-dv-timings.rst: document interlaced defines
Message-ID: <57850129.9070606@cisco.com>
Date: Tue, 12 Jul 2016 16:39:37 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix missing references.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst b/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
index e19d64e..f7bf21f 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
@@ -100,7 +100,7 @@ EBUSY

        -  ``interlaced``

-       -  Progressive (0) or interlaced (1)
+       -  Progressive (``V4L2_DV_PROGRESSIVE``) or interlaced (``V4L2_DV_INTERLACED``).

     -  .. row 4

diff --git a/Documentation/media/videodev2.h.rst.exceptions b/Documentation/media/videodev2.h.rst.exceptions
index c15660f..b9be796 100644
--- a/Documentation/media/videodev2.h.rst.exceptions
+++ b/Documentation/media/videodev2.h.rst.exceptions
@@ -280,8 +280,8 @@ replace define V4L2_STD_ALL v4l2-std-id

 # V4L2 DT BT timings definitions

-replace define V4L2_DV_PROGRESSIVE v4l2-dv-fixme
-replace define V4L2_DV_INTERLACED v4l2-dv-fixme
+replace define V4L2_DV_PROGRESSIVE v4l2-bt-timings
+replace define V4L2_DV_INTERLACED v4l2-bt-timings

 replace define V4L2_DV_VSYNC_POS_POL v4l2-bt-timings
 replace define V4L2_DV_HSYNC_POS_POL v4l2-bt-timings
