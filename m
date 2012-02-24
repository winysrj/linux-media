Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49727 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757318Ab2BXPZA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Feb 2012 10:25:00 -0500
Received: by mail-yx0-f174.google.com with SMTP id m8so1156267yen.19
        for <linux-media@vger.kernel.org>; Fri, 24 Feb 2012 07:24:59 -0800 (PST)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: mchehab@infradead.org, gregkh@linuxfoundation.org
Cc: tomas.winkler@intel.com, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org, dan.carpenter@oracle.com,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH 8/9] staging: easycap: Clean comment style in easycap_delete()
Date: Fri, 24 Feb 2012 12:24:21 -0300
Message-Id: <1330097062-31663-8-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1330097062-31663-1-git-send-email-elezegarcia@gmail.com>
References: <1330097062-31663-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/staging/media/easycap/easycap_main.c |   43 +++++++++----------------
 1 files changed, 16 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/media/easycap/easycap_main.c b/drivers/staging/media/easycap/easycap_main.c
index de53ed8..76a2c5b 100644
--- a/drivers/staging/media/easycap/easycap_main.c
+++ b/drivers/staging/media/easycap/easycap_main.c
@@ -700,17 +700,13 @@ static int videodev_release(struct video_device *pvideo_device)
 	JOM(4, "ending successfully\n");
 	return 0;
 }
-/*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^*/
-/*****************************************************************************/
-/*--------------------------------------------------------------------------*/
+
 /*
- *  THIS FUNCTION IS CALLED FROM WITHIN easycap_usb_disconnect() AND IS
- *  PROTECTED BY SEMAPHORES SET AND CLEARED BY easycap_usb_disconnect().
- *
- *  BY THIS STAGE THE DEVICE HAS ALREADY BEEN PHYSICALLY UNPLUGGED, SO
- *  peasycap->pusb_device IS NO LONGER VALID.
+ * This function is called from within easycap_usb_disconnect() and is
+ * protected by semaphores set and cleared by easycap_usb_disconnect().
+ * By this stage the device has already been physically unplugged,
+ * so peasycap->pusb_device is no longer valid.
  */
-/*---------------------------------------------------------------------------*/
 static void easycap_delete(struct kref *pkref)
 {
 	struct easycap *peasycap;
@@ -731,11 +727,8 @@ static void easycap_delete(struct kref *pkref)
 		return;
 	}
 	kd = easycap_isdongle(peasycap);
-/*---------------------------------------------------------------------------*/
-/*
- *  FREE VIDEO.
- */
-/*---------------------------------------------------------------------------*/
+
+	/* Free video urbs */
 	if (peasycap->purb_video_head) {
 		m = 0;
 		list_for_each(plist_head, peasycap->purb_video_head) {
@@ -750,7 +743,6 @@ static void easycap_delete(struct kref *pkref)
 		}
 
 		JOM(4, "%i video urbs freed\n", m);
-/*---------------------------------------------------------------------------*/
 		JOM(4, "freeing video data_urb structures.\n");
 		m = 0;
 		list_for_each_safe(plist_head, plist_next,
@@ -768,7 +760,8 @@ static void easycap_delete(struct kref *pkref)
 		JOM(4, "setting peasycap->purb_video_head=NULL\n");
 		peasycap->purb_video_head = NULL;
 	}
-/*---------------------------------------------------------------------------*/
+
+	/* Free video isoc buffers */
 	JOM(4, "freeing video isoc buffers.\n");
 	m = 0;
 	for (k = 0;  k < VIDEO_ISOC_BUFFER_MANY;  k++) {
@@ -784,7 +777,7 @@ static void easycap_delete(struct kref *pkref)
 	}
 	JOM(4, "isoc video buffers freed: %i pages\n",
 			m * (0x01 << VIDEO_ISOC_ORDER));
-/*---------------------------------------------------------------------------*/
+	/* Free video field buffers */
 	JOM(4, "freeing video field buffers.\n");
 	gone = 0;
 	for (k = 0;  k < FIELD_BUFFER_MANY;  k++) {
@@ -799,7 +792,8 @@ static void easycap_delete(struct kref *pkref)
 		}
 	}
 	JOM(4, "video field buffers freed: %i pages\n", gone);
-/*---------------------------------------------------------------------------*/
+
+	/* Free video frame buffers */
 	JOM(4, "freeing video frame buffers.\n");
 	gone = 0;
 	for (k = 0;  k < FRAME_BUFFER_MANY;  k++) {
@@ -814,11 +808,8 @@ static void easycap_delete(struct kref *pkref)
 		}
 	}
 	JOM(4, "video frame buffers freed: %i pages\n", gone);
-/*---------------------------------------------------------------------------*/
-/*
- *  FREE AUDIO.
- */
-/*---------------------------------------------------------------------------*/
+
+	/* Free audio urbs */
 	if (peasycap->purb_audio_head) {
 		JOM(4, "freeing audio urbs\n");
 		m = 0;
@@ -833,7 +824,6 @@ static void easycap_delete(struct kref *pkref)
 			}
 		}
 		JOM(4, "%i audio urbs freed\n", m);
-/*---------------------------------------------------------------------------*/
 		JOM(4, "freeing audio data_urb structures.\n");
 		m = 0;
 		list_for_each_safe(plist_head, plist_next,
@@ -851,7 +841,8 @@ static void easycap_delete(struct kref *pkref)
 		JOM(4, "setting peasycap->purb_audio_head=NULL\n");
 		peasycap->purb_audio_head = NULL;
 	}
-/*---------------------------------------------------------------------------*/
+
+	/* Free audio isoc buffers */
 	JOM(4, "freeing audio isoc buffers.\n");
 	m = 0;
 	for (k = 0;  k < AUDIO_ISOC_BUFFER_MANY;  k++) {
@@ -867,7 +858,6 @@ static void easycap_delete(struct kref *pkref)
 	}
 	JOM(4, "easyoss_delete(): isoc audio buffers freed: %i pages\n",
 					m * (0x01 << AUDIO_ISOC_ORDER));
-/*---------------------------------------------------------------------------*/
 	JOM(4, "freeing easycap structure.\n");
 	allocation_video_urb    = peasycap->allocation_video_urb;
 	allocation_video_page   = peasycap->allocation_video_page;
@@ -895,7 +885,6 @@ static void easycap_delete(struct kref *pkref)
 
 	kfree(peasycap);
 
-/*---------------------------------------------------------------------------*/
 	SAY("%8i=video urbs    after all deletions\n", allocation_video_urb);
 	SAY("%8i=video pages   after all deletions\n", allocation_video_page);
 	SAY("%8i=video structs after all deletions\n", allocation_video_struct);
-- 
1.7.3.4

