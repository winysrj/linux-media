Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:59913 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755957AbZKURC5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Nov 2009 12:02:57 -0500
Message-ID: <4B081D40.9030607@freemail.hu>
Date: Sat, 21 Nov 2009 18:02:56 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@skynet.be>,
	V4L Mailing List <linux-media@vger.kernel.org>
CC: cocci@diku.dk, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] usbvideo: limit the length of string creation
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

Use strlcat() to append a string to the previously created first part.
The strlcat() function limits the size of the string to the whole
destination buffer.

The semantic match that finds this kind of problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression dev;
expression phys;
expression str;
expression size;
@@
 	usb_make_path(dev, phys, size);
-	strncat(phys, str, size);
+	strlcat(phys, str, size);
// </smpl>

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -u -p a/drivers/media/video/usbvideo/konicawc.c b/drivers/media/video/usbvideo/konicawc.c
--- a/drivers/media/video/usbvideo/konicawc.c 2009-09-10 00:13:59.000000000 +0200
+++ b/drivers/media/video/usbvideo/konicawc.c 2009-11-21 17:48:52.000000000 +0100
@@ -225,7 +225,7 @@ static void konicawc_register_input(stru
 	int error;

 	usb_make_path(dev, cam->input_physname, sizeof(cam->input_physname));
-	strncat(cam->input_physname, "/input0", sizeof(cam->input_physname));
+	strlcat(cam->input_physname, "/input0", sizeof(cam->input_physname));

 	cam->input = input_dev = input_allocate_device();
 	if (!input_dev) {
diff -u -p a/drivers/media/video/usbvideo/quickcam_messenger.c b/drivers/media/video/usbvideo/quickcam_messenger.c
--- a/drivers/media/video/usbvideo/quickcam_messenger.c 2009-09-10 00:13:59.000000000 +0200
+++ b/drivers/media/video/usbvideo/quickcam_messenger.c 2009-11-21 17:48:53.000000000 +0100
@@ -89,7 +89,7 @@ static void qcm_register_input(struct qc
 	int error;

 	usb_make_path(dev, cam->input_physname, sizeof(cam->input_physname));
-	strncat(cam->input_physname, "/input0", sizeof(cam->input_physname));
+	strlcat(cam->input_physname, "/input0", sizeof(cam->input_physname));

 	cam->input = input_dev = input_allocate_device();
 	if (!input_dev) {
