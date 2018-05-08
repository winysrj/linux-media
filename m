Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:60069 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932465AbeEHPHs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 May 2018 11:07:48 -0400
Received: from axis700.grange ([87.78.226.14]) by mail.gmx.com (mrgmx003
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0Mb7pT-1f10J7211P-00KiTz for
 <linux-media@vger.kernel.org>; Tue, 08 May 2018 17:07:46 +0200
Received: from 200r.grange (200r.grange [192.168.1.16])
        by axis700.grange (Postfix) with ESMTP id E6D416198C
        for <linux-media@vger.kernel.org>; Tue,  8 May 2018 17:07:44 +0200 (CEST)
From: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
Subject: [PATCH v8 3/3] uvcvideo: handle control pipe protocol STALLs
Date: Tue,  8 May 2018 17:07:44 +0200
Message-Id: <1525792064-30836-4-git-send-email-guennadi.liakhovetski@intel.com>
In-Reply-To: <1525792064-30836-1-git-send-email-guennadi.liakhovetski@intel.com>
References: <1525792064-30836-1-git-send-email-guennadi.liakhovetski@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When a command ends up in a STALL on the control pipe, use the Request
Error Code control to provide a more precise error information to the
user. For example, if a camera is still busy processing a control,
when the same or an interrelated control set request arrives, the
camera can react with a STALL and then return the "Not ready" status
in response to a UVC_VC_REQUEST_ERROR_CODE_CONTROL command. With this
patch the user would then get an EBUSY error code instead of a
generic EPIPE.

Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
---

v8:

* restrict UVC_VC_REQUEST_ERROR_CODE_CONTROL to the control interface
* fix the wIndex value
* improve error codes
* cosmetic changes

 drivers/media/usb/uvc/uvc_video.c | 52 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 46 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index aa0082f..ce65cd6 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -73,17 +73,57 @@ int uvc_query_ctrl(struct uvc_device *dev, u8 query, u8 unit,
 			u8 intfnum, u8 cs, void *data, u16 size)
 {
 	int ret;
+	u8 error;
+	u8 tmp;
 
 	ret = __uvc_query_ctrl(dev, query, unit, intfnum, cs, data, size,
 				UVC_CTRL_CONTROL_TIMEOUT);
-	if (ret != size) {
-		uvc_printk(KERN_ERR, "Failed to query (%s) UVC control %u on "
-			"unit %u: %d (exp. %u).\n", uvc_query_name(query), cs,
-			unit, ret, size);
-		return -EIO;
+	if (likely(ret == size))
+		return 0;
+
+	uvc_printk(KERN_ERR,
+		   "Failed to query (%s) UVC control %u on unit %u: %d (exp. %u).\n",
+		   uvc_query_name(query), cs, unit, ret, size);
+
+	if (ret != -EPIPE)
+		return ret;
+
+	tmp = *(u8 *)data;
+
+	ret = __uvc_query_ctrl(dev, UVC_GET_CUR, 0, intfnum,
+			       UVC_VC_REQUEST_ERROR_CODE_CONTROL, data, 1,
+			       UVC_CTRL_CONTROL_TIMEOUT);
+
+	error = *(u8 *)data;
+	*(u8 *)data = tmp;
+
+	if (ret != 1)
+		return ret < 0 ? ret : -EPIPE;
+
+	uvc_trace(UVC_TRACE_CONTROL, "Control error %u\n", error);
+
+	switch (error) {
+	case 0:
+		/* Cannot happen - we received a STALL */
+		return -EPIPE;
+	case 1: /* Not ready */
+		return -EBUSY;
+	case 2: /* Wrong state */
+		return -EILSEQ;
+	case 3: /* Power */
+		return -EREMOTE;
+	case 4: /* Out of range */
+		return -ERANGE;
+	case 5: /* Invalid unit */
+	case 6: /* Invalid control */
+	case 7: /* Invalid Request */
+	case 8: /* Invalid value within range */
+		return -EINVAL;
+	default: /* reserved or unknown */
+		break;
 	}
 
-	return 0;
+	return -EPIPE;
 }
 
 static void uvc_fixup_video_ctrl(struct uvc_streaming *stream,
-- 
1.9.3
