Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.8]:63235 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab1CWKCz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Mar 2011 06:02:55 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id AAEC3189B85
	for <linux-media@vger.kernel.org>; Wed, 23 Mar 2011 11:02:53 +0100 (CET)
Date: Wed, 23 Mar 2011 11:02:53 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] V4L: fix a macro definition
Message-ID: <Pine.LNX.4.64.1103231102130.6836@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

v4l2_device_unregister_subdev() wrongly uses "arg..." instead of "## arg"
in its body. Fix it.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 include/media/v4l2-device.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/media/v4l2-device.h b/include/media/v4l2-device.h
index 0c2bd30..dc0004e 100644
--- a/include/media/v4l2-device.h
+++ b/include/media/v4l2-device.h
@@ -149,7 +149,7 @@ v4l2_device_register_subdev_nodes(struct v4l2_device *v4l2_dev);
 ({									\
 	struct v4l2_subdev *__sd;					\
 	__v4l2_device_call_subdevs_until_err_p(v4l2_dev, __sd, cond, o,	\
-						f, args...);		\
+						f , ##args);		\
 })
 
 /* Call the specified callback for all subdevs matching grp_id (if 0, then
-- 
1.7.2.5

