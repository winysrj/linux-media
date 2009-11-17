Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37997 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756302AbZKQWoT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2009 17:44:19 -0500
Message-Id: <200911172243.nAHMhc0D029228@imap1.linux-foundation.org>
Subject: [patch 2/5] quickcam_messenger.c: possible buffer overflow while use strncat
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, akpm@linux-foundation.org,
	strakh@ispras.ru
From: akpm@linux-foundation.org
Date: Tue, 17 Nov 2009 14:43:38 -0800
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Alexander Strakh <strakh@ispras.ru>

In driver ./drivers/media/video/usbvideo/quickcam_messenger.c in line 91:

  91         usb_make_path(dev, cam->input_physname, sizeof(cam->input_physname));

After this line we use strncat:

  92         strncat(cam->input_physname, "/input0", sizeof(cam->input_physname));

where sizeof(cam->input_physname) returns length of cam->input_phisname
without length for null-symbol.  But this parameter must be - "maximum
numbers of bytes to copy", i.e.:
sizeof(cam->input_physname)-strlen(cam->input_physname)-1.

In this case, after call to usb_make_path the similar drivers use strlcat.

Like in: drivers/hid/usbhid/hid-core.c:
1152         usb_make_path(dev, hid->phys, sizeof(hid->phys));
1153         strlcat(hid->phys, "/input", sizeof(hid->phys));

Found by Linux Driver Verification Project.

Use strlcat instead of strncat.

Signed-off-by: Alexander Strakh <strakh@ispras.ru>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/usbvideo/quickcam_messenger.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/video/usbvideo/quickcam_messenger.c~quickcam_messengerc-possible-buffer-overflow-while-use-strncat drivers/media/video/usbvideo/quickcam_messenger.c
--- a/drivers/media/video/usbvideo/quickcam_messenger.c~quickcam_messengerc-possible-buffer-overflow-while-use-strncat
+++ a/drivers/media/video/usbvideo/quickcam_messenger.c
@@ -89,7 +89,7 @@ static void qcm_register_input(struct qc
 	int error;
 
 	usb_make_path(dev, cam->input_physname, sizeof(cam->input_physname));
-	strncat(cam->input_physname, "/input0", sizeof(cam->input_physname));
+	strlcat(cam->input_physname, "/input0", sizeof(cam->input_physname));
 
 	cam->input = input_dev = input_allocate_device();
 	if (!input_dev) {
_
