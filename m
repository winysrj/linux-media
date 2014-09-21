Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2718 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbaIUOsp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Sep 2014 10:48:45 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 02/11] videodev2.h: add config_store to v4l2_ext_controls
Date: Sun, 21 Sep 2014 16:48:20 +0200
Message-Id: <1411310909-32825-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1411310909-32825-1-git-send-email-hverkuil@xs4all.nl>
References: <1411310909-32825-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The ctrl_class is fairly pointless when used with drivers that use the control
framework: you can just fill in 0 and it will just work fine. There are still
some old unconverted drivers that do not support 0 and instead want the control
class there. The idea being that all controls in the list all belong to that
class. This was done to simplify drivers in the absence of the control framework.

When using the control framework the framework itself is smart enough to allow
controls of any class to be included in the control list.

Since configuration store IDs are in the range 1..255 (or so, in any case a relatively
small non-zero positive integer) it makes sense to effectively rename ctrl_class
to config_store. Set it to 0 and you get the normal behavior (you change the current
control value), set it to a configuration store ID and you get/set the control for
that store.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/uapi/linux/videodev2.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 199834b..83ef28a 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1294,7 +1294,10 @@ struct v4l2_ext_control {
 } __attribute__ ((packed));
 
 struct v4l2_ext_controls {
-	__u32 ctrl_class;
+	union {
+		__u32 ctrl_class;
+		__u32 config_store;
+	};
 	__u32 count;
 	__u32 error_idx;
 	__u32 reserved[2];
-- 
2.1.0

