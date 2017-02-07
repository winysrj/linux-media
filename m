Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:52831 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754625AbdBGQ3r (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 7 Feb 2017 11:29:47 -0500
Received: from axis700.grange ([81.173.166.100]) by mail.gmx.com (mrgmx101
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0Lxt3Q-1cOmBY2TR6-015LHc for
 <linux-media@vger.kernel.org>; Tue, 07 Feb 2017 17:29:44 +0100
Received: from 200r.grange (200r.grange [192.168.1.16])
        by axis700.grange (Postfix) with ESMTP id 53F448B119
        for <linux-media@vger.kernel.org>; Tue,  7 Feb 2017 17:29:37 +0100 (CET)
From: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH v2 3/4] uvcvideo: handle control pipe protocol STALLs
Date: Tue,  7 Feb 2017 17:29:35 +0100
Message-Id: <1486484976-17365-4-git-send-email-guennadi.liakhovetski@intel.com>
In-Reply-To: <1486484976-17365-1-git-send-email-guennadi.liakhovetski@intel.com>
References: <1486484976-17365-1-git-send-email-guennadi.liakhovetski@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When a command ends up in a STALL on the control pipe, use the Request
Error Code control to provide a more precise error information to the
user.

Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
---
 drivers/media/usb/uvc/uvc_video.c | 59 +++++++++++++++++++++++++++++++++++----
 1 file changed, 53 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index 07a6c83..e530839 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -34,15 +34,59 @@ static int __uvc_query_ctrl(struct uvc_device *dev, __u8 query, __u8 unit,
 			__u8 intfnum, __u8 cs, void *data, __u16 size,
 			int timeout)
 {
-	__u8 type = USB_TYPE_CLASS | USB_RECIP_INTERFACE;
+	__u8 type = USB_TYPE_CLASS | USB_RECIP_INTERFACE, tmp, error;
 	unsigned int pipe;
+	int ret;
 
 	pipe = (query & 0x80) ? usb_rcvctrlpipe(dev->udev, 0)
 			      : usb_sndctrlpipe(dev->udev, 0);
 	type |= (query & 0x80) ? USB_DIR_IN : USB_DIR_OUT;
 
-	return usb_control_msg(dev->udev, pipe, query, type, cs << 8,
+	ret = usb_control_msg(dev->udev, pipe, query, type, cs << 8,
 			unit << 8 | intfnum, data, size, timeout);
+
+	if (ret != -EPIPE)
+		return ret;
+
+	tmp = *(u8 *)data;
+
+	pipe = usb_rcvctrlpipe(dev->udev, 0);
+	type = USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_IN;
+	ret = usb_control_msg(dev->udev, pipe, UVC_GET_CUR, type,
+			      UVC_VC_REQUEST_ERROR_CODE_CONTROL << 8,
+			      unit << 8 | intfnum, data, 1, timeout);
+	error = *(u8 *)data;
+	*(u8 *)data = tmp;
+
+	if (ret < 0)
+		return ret;
+
+	if (!ret)
+		return -EINVAL;
+
+	uvc_trace(UVC_TRACE_CONTROL, "Control error %u\n", error);
+
+	switch (error) {
+	case 0:
+		/* Cannot happen - we received a STALL */
+		return -EPIPE;
+	case 1: /* Not ready */
+		return -EAGAIN;
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
+	default: /* reserved or unknown */
+		break;
+	}
+
+	return -EINVAL;
 }
 
 static const char *uvc_query_name(__u8 query)
@@ -80,7 +124,7 @@ int uvc_query_ctrl(struct uvc_device *dev, __u8 query, __u8 unit,
 		uvc_printk(KERN_ERR, "Failed to query (%s) UVC control %u on "
 			"unit %u: %d (exp. %u).\n", uvc_query_name(query), cs,
 			unit, ret, size);
-		return -EIO;
+		return ret < 0 ? ret : -EIO;
 	}
 
 	return 0;
@@ -203,13 +247,15 @@ static int uvc_get_video_ctrl(struct uvc_streaming *stream,
 		uvc_warn_once(stream->dev, UVC_WARN_PROBE_DEF, "UVC non "
 			"compliance - GET_DEF(PROBE) not supported. "
 			"Enabling workaround.\n");
-		ret = -EIO;
+		if (ret >= 0)
+			ret = -EIO;
 		goto out;
 	} else if (ret != size) {
 		uvc_printk(KERN_ERR, "Failed to query (%u) UVC %s control : "
 			"%d (exp. %u).\n", query, probe ? "probe" : "commit",
 			ret, size);
-		ret = -EIO;
+		if (ret >= 0)
+			ret = -EIO;
 		goto out;
 	}
 
@@ -290,7 +336,8 @@ static int uvc_set_video_ctrl(struct uvc_streaming *stream,
 		uvc_printk(KERN_ERR, "Failed to set UVC %s control : "
 			"%d (exp. %u).\n", probe ? "probe" : "commit",
 			ret, size);
-		ret = -EIO;
+		if (ret >= 0)
+			ret = -EIO;
 	}
 
 	kfree(data);
-- 
1.9.3

