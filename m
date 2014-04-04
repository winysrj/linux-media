Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:23598 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752752AbaDDN1M (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Apr 2014 09:27:12 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
	by paasikivi.fi.intel.com (Postfix) with ESMTP id 2EC1C20869
	for <linux-media@vger.kernel.org>; Fri,  4 Apr 2014 16:25:48 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/2] media: v4l: Remove documentation for nonexistend input field in v4l2_buffer
Date: Fri,  4 Apr 2014 16:24:45 +0300
Message-Id: <1396617885-5474-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1396617885-5474-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1396617885-5474-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The input field in struct v4l2_buffer no longer exists but has been replaced
by a reserved field. Remove the field documentation.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 include/uapi/linux/videodev2.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index ea468ee..db4aebd 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -649,7 +649,6 @@ struct v4l2_plane {
  * @length:	size in bytes of the buffer (NOT its payload) for single-plane
  *		buffers (when type != *_MPLANE); number of elements in the
  *		planes array for multi-plane buffers
- * @input:	input number from which the video data has has been captured
  *
  * Contains data exchanged by application and driver using one of the Streaming
  * I/O methods.
-- 
1.8.3.2

