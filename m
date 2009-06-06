Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.233]:59400 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbZFFKHZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Jun 2009 06:07:25 -0400
Received: by rv-out-0506.google.com with SMTP id f9so831855rvb.1
        for <linux-media@vger.kernel.org>; Sat, 06 Jun 2009 03:07:27 -0700 (PDT)
Subject: [PATCH]usbvision-core.c: vfree does its own NULL check
From: "Figo.zhang" <figo1802@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 06 Jun 2009 18:06:49 +0800
Message-Id: <1244282809.3185.14.camel@myhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

vfree() does it's own NULL checking,so no need for check before
calling it.

Signed-off-by: Figo.zhang <figo1802@gmail.com>
---  
drivers/media/video/usbvision/usbvision-core.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/usbvision/usbvision-core.c b/drivers/media/video/usbvision/usbvision-core.c
index 8bc03b9..1603b2b 100644
--- a/drivers/media/video/usbvision/usbvision-core.c
+++ b/drivers/media/video/usbvision/usbvision-core.c
@@ -390,10 +390,9 @@ int usbvision_scratch_alloc(struct usb_usbvision *usbvision)
 
 void usbvision_scratch_free(struct usb_usbvision *usbvision)
 {
-	if (usbvision->scratch != NULL) {
-		vfree(usbvision->scratch);
-		usbvision->scratch = NULL;
-	}
+	vfree(usbvision->scratch);
+	usbvision->scratch = NULL;
+	
 }
 
 /*
@@ -506,10 +505,9 @@ int usbvision_decompress_alloc(struct usb_usbvision *usbvision)
  */
 void usbvision_decompress_free(struct usb_usbvision *usbvision)
 {
-	if (usbvision->IntraFrameBuffer != NULL) {
-		vfree(usbvision->IntraFrameBuffer);
-		usbvision->IntraFrameBuffer = NULL;
-	}
+	vfree(usbvision->IntraFrameBuffer);
+	usbvision->IntraFrameBuffer = NULL;
+	
 }
 
 /************************************************************


