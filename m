Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3555 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762AbaAFOVm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jan 2014 09:21:42 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 09/27] videodev2.h: add config_store to v4l2_ext_controls
Date: Mon,  6 Jan 2014 15:21:08 +0100
Message-Id: <1389018086-15903-10-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1389018086-15903-1-git-send-email-hverkuil@xs4all.nl>
References: <1389018086-15903-1-git-send-email-hverkuil@xs4all.nl>
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
index 0803da9..789f876 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1233,7 +1233,10 @@ struct v4l2_ext_control {
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
1.8.5.2

