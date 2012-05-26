Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:33763 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752762Ab2EZUH4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 26 May 2012 16:07:56 -0400
Received: from maxwell.research.nokia.com (maxwell.research.nokia.com [172.21.199.25])
	by mgw-da02.nokia.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q4QK7sVR021086
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 26 May 2012 23:07:55 +0300
Received: from lanttu (lanttu-o.localdomain [192.168.239.74])
	by maxwell.research.nokia.com (Postfix) with ESMTPS id 206341F4C5A
	for <linux-media@vger.kernel.org>; Sat, 26 May 2012 23:07:53 +0300 (EEST)
Received: from sakke by lanttu with local (Exim 4.72)
	(envelope-from <sakari.ailus@maxwell.research.nokia.com>)
	id 1SYNHC-0006F2-3J
	for linux-media@vger.kernel.org; Sat, 26 May 2012 23:07:50 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/1] v4l: Remove __user from interface structure definitions
Date: Sat, 26 May 2012 23:07:49 +0300
Message-Id: <1338062869-23922-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The __user macro is not strictly needed in videodev2.h, and it also prevents
using the header file as such in the user space. __user is already not used
in many of the interface structs containing pointers.

Stop using __user in videodev2.h.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 include/linux/videodev2.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 370d111..c8e1bb0 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -708,16 +708,16 @@ struct v4l2_framebuffer {
 
 struct v4l2_clip {
 	struct v4l2_rect        c;
-	struct v4l2_clip	__user *next;
+	struct v4l2_clip	*next;
 };
 
 struct v4l2_window {
 	struct v4l2_rect        w;
 	__u32			field;	 /* enum v4l2_field */
 	__u32			chromakey;
-	struct v4l2_clip	__user *clips;
+	struct v4l2_clip	*clips;
 	__u32			clipcount;
-	void			__user *bitmap;
+	void			*bitmap;
 	__u8                    global_alpha;
 };
 
-- 
1.7.2.5

