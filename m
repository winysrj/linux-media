Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:48875 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758676Ab0JFI7l (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Oct 2010 04:59:41 -0400
Received: from localhost.localdomain (unknown [91.178.188.185])
	by perceval.irobotique.be (Postfix) with ESMTPSA id 628F635DAB
	for <linux-media@vger.kernel.org>; Wed,  6 Oct 2010 08:59:39 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 05/14] uvcvideo: Print query name in uvc_query_ctrl()
Date: Wed,  6 Oct 2010 10:59:43 +0200
Message-Id: <1286355592-13603-6-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1286355592-13603-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1286355592-13603-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Instead of printing the query hex value in error messages, print its
name to make the messages more readable.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/uvc/uvc_video.c |   30 +++++++++++++++++++++++++++---
 1 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_video.c b/drivers/media/video/uvc/uvc_video.c
index e27cf0d..ef55877 100644
--- a/drivers/media/video/uvc/uvc_video.c
+++ b/drivers/media/video/uvc/uvc_video.c
@@ -45,6 +45,30 @@ static int __uvc_query_ctrl(struct uvc_device *dev, __u8 query, __u8 unit,
 			unit << 8 | intfnum, data, size, timeout);
 }
 
+static const char *uvc_query_name(__u8 query)
+{
+	switch (query) {
+	case UVC_SET_CUR:
+		return "SET_CUR";
+	case UVC_GET_CUR:
+		return "GET_CUR";
+	case UVC_GET_MIN:
+		return "GET_MIN";
+	case UVC_GET_MAX:
+		return "GET_MAX";
+	case UVC_GET_RES:
+		return "GET_RES";
+	case UVC_GET_LEN:
+		return "GET_LEN";
+	case UVC_GET_INFO:
+		return "GET_INFO";
+	case UVC_GET_DEF:
+		return "GET_DEF";
+	default:
+		return "<invalid>";
+	}
+}
+
 int uvc_query_ctrl(struct uvc_device *dev, __u8 query, __u8 unit,
 			__u8 intfnum, __u8 cs, void *data, __u16 size)
 {
@@ -53,9 +77,9 @@ int uvc_query_ctrl(struct uvc_device *dev, __u8 query, __u8 unit,
 	ret = __uvc_query_ctrl(dev, query, unit, intfnum, cs, data, size,
 				UVC_CTRL_CONTROL_TIMEOUT);
 	if (ret != size) {
-		uvc_printk(KERN_ERR, "Failed to query (%u) UVC control %u "
-			"(unit %u) : %d (exp. %u).\n", query, cs, unit, ret,
-			size);
+		uvc_printk(KERN_ERR, "Failed to query (%s) UVC control %u on "
+			"unit %u: %d (exp. %u).\n", uvc_query_name(query), cs,
+			unit, ret, size);
 		return -EIO;
 	}
 
-- 
1.7.2.2

