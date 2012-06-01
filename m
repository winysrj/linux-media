Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:58292 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759324Ab2FAJjP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Jun 2012 05:39:15 -0400
From: Bhupesh Sharma <bhupesh.sharma@st.com>
To: <laurent.pinchart@ideasonboard.com>, <linux-usb@vger.kernel.org>
Cc: <balbi@ti.com>, <linux-media@vger.kernel.org>,
	<gregkh@linuxfoundation.org>,
	Bhupesh Sharma <bhupesh.sharma@st.com>
Subject: [PATCH 1/5] usb: gadget/uvc: Fix string descriptor STALL issue when multiple uvc functions are added to a configuration
Date: Fri, 1 Jun 2012 15:08:54 +0530
Message-ID: <40e0deae81296f6c07fc551fd6d0da611e674676.1338543124.git.bhupesh.sharma@st.com>
In-Reply-To: <cover.1338543124.git.bhupesh.sharma@st.com>
References: <cover.1338543124.git.bhupesh.sharma@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch solved the string descriptor STALL issue when we add multiple UVC
functions in a single configuration using a 'webcam.c' like composite driver.

Signed-off-by: Bhupesh Sharma <bhupesh.sharma@st.com>
---
 drivers/usb/gadget/f_uvc.c |   38 ++++++++++++++++++++++----------------
 1 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/drivers/usb/gadget/f_uvc.c b/drivers/usb/gadget/f_uvc.c
index 2022fe49..054c35a 100644
--- a/drivers/usb/gadget/f_uvc.c
+++ b/drivers/usb/gadget/f_uvc.c
@@ -619,22 +619,28 @@ uvc_bind_config(struct usb_configuration *c,
 	uvc->desc.fs_streaming = fs_streaming;
 	uvc->desc.hs_streaming = hs_streaming;
 
-	/* Allocate string descriptor numbers. */
-	if ((ret = usb_string_id(c->cdev)) < 0)
-		goto error;
-	uvc_en_us_strings[UVC_STRING_ASSOCIATION_IDX].id = ret;
-	uvc_iad.iFunction = ret;
-
-	if ((ret = usb_string_id(c->cdev)) < 0)
-		goto error;
-	uvc_en_us_strings[UVC_STRING_CONTROL_IDX].id = ret;
-	uvc_control_intf.iInterface = ret;
-
-	if ((ret = usb_string_id(c->cdev)) < 0)
-		goto error;
-	uvc_en_us_strings[UVC_STRING_STREAMING_IDX].id = ret;
-	uvc_streaming_intf_alt0.iInterface = ret;
-	uvc_streaming_intf_alt1.iInterface = ret;
+	/* maybe allocate device-global string IDs, and patch descriptors */
+	if (uvc_en_us_strings[UVC_STRING_ASSOCIATION_IDX].id == 0) {
+		/* Allocate string descriptor numbers. */
+		ret = usb_string_id(c->cdev);
+		if (ret < 0)
+			goto error;
+		uvc_en_us_strings[UVC_STRING_ASSOCIATION_IDX].id = ret;
+		uvc_iad.iFunction = ret;
+
+		ret = usb_string_id(c->cdev);
+		if (ret < 0)
+			goto error;
+		uvc_en_us_strings[UVC_STRING_CONTROL_IDX].id = ret;
+		uvc_control_intf.iInterface = ret;
+
+		ret = usb_string_id(c->cdev);
+		if (ret < 0)
+			goto error;
+		uvc_en_us_strings[UVC_STRING_STREAMING_IDX].id = ret;
+		uvc_streaming_intf_alt0.iInterface = ret;
+		uvc_streaming_intf_alt1.iInterface = ret;
+	}
 
 	/* Register the function. */
 	uvc->func.name = "uvc";
-- 
1.7.2.2

