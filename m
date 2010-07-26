Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:40248 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752658Ab0GZPi7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Jul 2010 11:38:59 -0400
Received: from lyakh (helo=localhost)
	by axis700.grange with local-esmtp (Exim 4.63)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1OdPlr-0002T4-3R
	for linux-media@vger.kernel.org; Mon, 26 Jul 2010 17:39:15 +0200
Date: Mon, 26 Jul 2010 17:39:15 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: V4L2: avoid name conflicts in macros
Message-ID: <Pine.LNX.4.64.1007261738380.9816@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

"sd" and "err" are too common names to be used in macros for local variables.
Prefix them with an underscore to avoid name clashing.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 include/media/v4l2-device.h |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/media/v4l2-device.h b/include/media/v4l2-device.h
index 5d5d550..aaa9f00 100644
--- a/include/media/v4l2-device.h
+++ b/include/media/v4l2-device.h
@@ -99,11 +99,11 @@ void v4l2_device_unregister_subdev(struct v4l2_subdev *sd);
    while walking the subdevs list. */
 #define __v4l2_device_call_subdevs(v4l2_dev, cond, o, f, args...) 	\
 	do { 								\
-		struct v4l2_subdev *sd; 				\
+		struct v4l2_subdev *__sd; 				\
 									\
-		list_for_each_entry(sd, &(v4l2_dev)->subdevs, list)   	\
-			if ((cond) && sd->ops->o && sd->ops->o->f) 	\
-				sd->ops->o->f(sd , ##args); 		\
+		list_for_each_entry(__sd, &(v4l2_dev)->subdevs, list)   \
+			if ((cond) && __sd->ops->o && __sd->ops->o->f) 	\
+				__sd->ops->o->f(__sd , ##args); 	\
 	} while (0)
 
 /* Call the specified callback for all subdevs matching the condition.
@@ -112,16 +112,16 @@ void v4l2_device_unregister_subdev(struct v4l2_subdev *sd);
    subdev while walking the subdevs list. */
 #define __v4l2_device_call_subdevs_until_err(v4l2_dev, cond, o, f, args...) \
 ({ 									\
-	struct v4l2_subdev *sd; 					\
-	long err = 0; 							\
+	struct v4l2_subdev *__sd; 					\
+	long __err = 0;							\
 									\
-	list_for_each_entry(sd, &(v4l2_dev)->subdevs, list) { 		\
-		if ((cond) && sd->ops->o && sd->ops->o->f) 		\
-			err = sd->ops->o->f(sd , ##args); 		\
-		if (err && err != -ENOIOCTLCMD)				\
+	list_for_each_entry(__sd, &(v4l2_dev)->subdevs, list) { 	\
+		if ((cond) && __sd->ops->o && __sd->ops->o->f) 		\
+			__err = __sd->ops->o->f(__sd , ##args); 	\
+		if (__err && __err != -ENOIOCTLCMD)			\
 			break; 						\
 	} 								\
-	(err == -ENOIOCTLCMD) ? 0 : err; 				\
+	(__err == -ENOIOCTLCMD) ? 0 : __err; 				\
 })
 
 /* Call the specified callback for all subdevs matching grp_id (if 0, then
-- 
1.6.2.4

