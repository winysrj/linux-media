Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.ispras.ru ([83.149.198.201]:42388 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753998AbZJGLy4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Oct 2009 07:54:56 -0400
From: Alexander Strakh <strakh@ispras.ru>
To: Jaya Kumar <jayalk@intworks.biz>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] quickcam_messenger.c: possible buffer overflow while use strncat.
Date: Wed, 7 Oct 2009 15:56:54 +0000
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200910071556.54534.strakh@ispras.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

	In driver ./drivers/media/video/usbvideo/quickcam_messenger.c in line 91:
  91         usb_make_path(dev, cam->input_physname, sizeof(cam-
>input_physname));
After this line we use strncat:
  92         strncat(cam->input_physname, "/input0", sizeof(cam-
>input_physname));
 where sizeof(cam->input_physname) returns length of cam->input_phisname 
without length for null-symbol. But this parameter must be -  "maximum numbers 
of bytes to copy", i.e.: sizeof(cam->input_physname)-strlen(cam-
>input_physname)-1.
	In this case, after call to usb_make_path the similar drivers use strlcat. 
Like in: drivers/hid/usbhid/hid-core.c:
1152         usb_make_path(dev, hid->phys, sizeof(hid->phys));
1153         strlcat(hid->phys, "/input", sizeof(hid->phys));

Found by Linux Driver Verification Project.

Use strlcat instead of strncat.

Signed-off-by:Alexander Strakh <strakh@ispras.ru>

---
diff --git a/./a/drivers/media/video/usbvideo/quickcam_messenger.c 
b/./b/drivers/media/video/usbvideo/quickcam_messenger.c
index 803d3e4..c4d1b96 100644
--- a/./a/drivers/media/video/usbvideo/quickcam_messenger.c
+++ b/./b/drivers/media/video/usbvideo/quickcam_messenger.c
@@ -89,7 +89,7 @@ static void qcm_register_input(struct qcm *cam, struct 
usb_device *dev)
 	int error;
 
 	usb_make_path(dev, cam->input_physname, sizeof(cam->input_physname));
-	strncat(cam->input_physname, "/input0", sizeof(cam->input_physname));
+	strlcat(cam->input_physname, "/input0", sizeof(cam->input_physname));
 
 	cam->input = input_dev = input_allocate_device();
 	if (!input_dev) {

