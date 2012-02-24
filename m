Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43519 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757222Ab2BXPZE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Feb 2012 10:25:04 -0500
Received: by mail-gx0-f174.google.com with SMTP id h1so1169999ggn.19
        for <linux-media@vger.kernel.org>; Fri, 24 Feb 2012 07:25:03 -0800 (PST)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: mchehab@infradead.org, gregkh@linuxfoundation.org
Cc: tomas.winkler@intel.com, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org, dan.carpenter@oracle.com,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH 9/9] staging: easycap: Split easycap_delete() into several pieces
Date: Fri, 24 Feb 2012 12:24:22 -0300
Message-Id: <1330097062-31663-9-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1330097062-31663-1-git-send-email-elezegarcia@gmail.com>
References: <1330097062-31663-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The patch splits easycap_delete(), which is in charge of
buffer deallocation, into smaller functions each
deallocating a specific kind of buffer.

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/staging/media/easycap/easycap_main.c |  445 ++++++++++++++-----------
 1 files changed, 249 insertions(+), 196 deletions(-)

diff --git a/drivers/staging/media/easycap/easycap_main.c b/drivers/staging/media/easycap/easycap_main.c
index 76a2c5b..aed9537 100644
--- a/drivers/staging/media/easycap/easycap_main.c
+++ b/drivers/staging/media/easycap/easycap_main.c
@@ -701,202 +701,6 @@ static int videodev_release(struct video_device *pvideo_device)
 	return 0;
 }
 
-/*
- * This function is called from within easycap_usb_disconnect() and is
- * protected by semaphores set and cleared by easycap_usb_disconnect().
- * By this stage the device has already been physically unplugged,
- * so peasycap->pusb_device is no longer valid.
- */
-static void easycap_delete(struct kref *pkref)
-{
-	struct easycap *peasycap;
-	struct data_urb *pdata_urb;
-	struct list_head *plist_head, *plist_next;
-	int k, m, gone, kd;
-	int allocation_video_urb;
-	int allocation_video_page;
-	int allocation_video_struct;
-	int allocation_audio_urb;
-	int allocation_audio_page;
-	int allocation_audio_struct;
-	int registered_video, registered_audio;
-
-	peasycap = container_of(pkref, struct easycap, kref);
-	if (!peasycap) {
-		SAM("ERROR: peasycap is NULL: cannot perform deletions\n");
-		return;
-	}
-	kd = easycap_isdongle(peasycap);
-
-	/* Free video urbs */
-	if (peasycap->purb_video_head) {
-		m = 0;
-		list_for_each(plist_head, peasycap->purb_video_head) {
-			pdata_urb = list_entry(plist_head,
-						struct data_urb, list_head);
-			if (pdata_urb && pdata_urb->purb) {
-				usb_free_urb(pdata_urb->purb);
-				pdata_urb->purb = NULL;
-				peasycap->allocation_video_urb--;
-				m++;
-			}
-		}
-
-		JOM(4, "%i video urbs freed\n", m);
-		JOM(4, "freeing video data_urb structures.\n");
-		m = 0;
-		list_for_each_safe(plist_head, plist_next,
-					peasycap->purb_video_head) {
-			pdata_urb = list_entry(plist_head,
-						struct data_urb, list_head);
-			if (pdata_urb) {
-				peasycap->allocation_video_struct -=
-						sizeof(struct data_urb);
-				kfree(pdata_urb);
-				m++;
-			}
-		}
-		JOM(4, "%i video data_urb structures freed\n", m);
-		JOM(4, "setting peasycap->purb_video_head=NULL\n");
-		peasycap->purb_video_head = NULL;
-	}
-
-	/* Free video isoc buffers */
-	JOM(4, "freeing video isoc buffers.\n");
-	m = 0;
-	for (k = 0;  k < VIDEO_ISOC_BUFFER_MANY;  k++) {
-		if (peasycap->video_isoc_buffer[k].pgo) {
-			free_pages((unsigned long)
-				   peasycap->video_isoc_buffer[k].pgo,
-					VIDEO_ISOC_ORDER);
-			peasycap->video_isoc_buffer[k].pgo = NULL;
-			peasycap->allocation_video_page -=
-						BIT(VIDEO_ISOC_ORDER);
-			m++;
-		}
-	}
-	JOM(4, "isoc video buffers freed: %i pages\n",
-			m * (0x01 << VIDEO_ISOC_ORDER));
-	/* Free video field buffers */
-	JOM(4, "freeing video field buffers.\n");
-	gone = 0;
-	for (k = 0;  k < FIELD_BUFFER_MANY;  k++) {
-		for (m = 0;  m < FIELD_BUFFER_SIZE/PAGE_SIZE;  m++) {
-			if (peasycap->field_buffer[k][m].pgo) {
-				free_page((unsigned long)
-					  peasycap->field_buffer[k][m].pgo);
-				peasycap->field_buffer[k][m].pgo = NULL;
-				peasycap->allocation_video_page -= 1;
-				gone++;
-			}
-		}
-	}
-	JOM(4, "video field buffers freed: %i pages\n", gone);
-
-	/* Free video frame buffers */
-	JOM(4, "freeing video frame buffers.\n");
-	gone = 0;
-	for (k = 0;  k < FRAME_BUFFER_MANY;  k++) {
-		for (m = 0;  m < FRAME_BUFFER_SIZE/PAGE_SIZE;  m++) {
-			if (peasycap->frame_buffer[k][m].pgo) {
-				free_page((unsigned long)
-					  peasycap->frame_buffer[k][m].pgo);
-				peasycap->frame_buffer[k][m].pgo = NULL;
-				peasycap->allocation_video_page -= 1;
-				gone++;
-			}
-		}
-	}
-	JOM(4, "video frame buffers freed: %i pages\n", gone);
-
-	/* Free audio urbs */
-	if (peasycap->purb_audio_head) {
-		JOM(4, "freeing audio urbs\n");
-		m = 0;
-		list_for_each(plist_head, (peasycap->purb_audio_head)) {
-			pdata_urb = list_entry(plist_head,
-					struct data_urb, list_head);
-			if (pdata_urb && pdata_urb->purb) {
-				usb_free_urb(pdata_urb->purb);
-				pdata_urb->purb = NULL;
-				peasycap->allocation_audio_urb--;
-				m++;
-			}
-		}
-		JOM(4, "%i audio urbs freed\n", m);
-		JOM(4, "freeing audio data_urb structures.\n");
-		m = 0;
-		list_for_each_safe(plist_head, plist_next,
-					peasycap->purb_audio_head) {
-			pdata_urb = list_entry(plist_head,
-					struct data_urb, list_head);
-			if (pdata_urb) {
-				peasycap->allocation_audio_struct -=
-							sizeof(struct data_urb);
-				kfree(pdata_urb);
-				m++;
-			}
-		}
-		JOM(4, "%i audio data_urb structures freed\n", m);
-		JOM(4, "setting peasycap->purb_audio_head=NULL\n");
-		peasycap->purb_audio_head = NULL;
-	}
-
-	/* Free audio isoc buffers */
-	JOM(4, "freeing audio isoc buffers.\n");
-	m = 0;
-	for (k = 0;  k < AUDIO_ISOC_BUFFER_MANY;  k++) {
-		if (peasycap->audio_isoc_buffer[k].pgo) {
-			free_pages((unsigned long)
-					(peasycap->audio_isoc_buffer[k].pgo),
-					AUDIO_ISOC_ORDER);
-			peasycap->audio_isoc_buffer[k].pgo = NULL;
-			peasycap->allocation_audio_page -=
-					BIT(AUDIO_ISOC_ORDER);
-			m++;
-		}
-	}
-	JOM(4, "easyoss_delete(): isoc audio buffers freed: %i pages\n",
-					m * (0x01 << AUDIO_ISOC_ORDER));
-	JOM(4, "freeing easycap structure.\n");
-	allocation_video_urb    = peasycap->allocation_video_urb;
-	allocation_video_page   = peasycap->allocation_video_page;
-	allocation_video_struct = peasycap->allocation_video_struct;
-	registered_video        = peasycap->registered_video;
-	allocation_audio_urb    = peasycap->allocation_audio_urb;
-	allocation_audio_page   = peasycap->allocation_audio_page;
-	allocation_audio_struct = peasycap->allocation_audio_struct;
-	registered_audio        = peasycap->registered_audio;
-
-	if (0 <= kd && DONGLE_MANY > kd) {
-		if (mutex_lock_interruptible(&mutex_dongle)) {
-			SAY("ERROR: cannot down mutex_dongle\n");
-		} else {
-			JOM(4, "locked mutex_dongle\n");
-			easycapdc60_dongle[kd].peasycap = NULL;
-			mutex_unlock(&mutex_dongle);
-			JOM(4, "unlocked mutex_dongle\n");
-			JOT(4, "   null-->dongle[%i].peasycap\n", kd);
-			allocation_video_struct -= sizeof(struct easycap);
-		}
-	} else {
-		SAY("ERROR: cannot purge dongle[].peasycap");
-	}
-
-	kfree(peasycap);
-
-	SAY("%8i=video urbs    after all deletions\n", allocation_video_urb);
-	SAY("%8i=video pages   after all deletions\n", allocation_video_page);
-	SAY("%8i=video structs after all deletions\n", allocation_video_struct);
-	SAY("%8i=video devices after all deletions\n", registered_video);
-	SAY("%8i=audio urbs    after all deletions\n", allocation_audio_urb);
-	SAY("%8i=audio pages   after all deletions\n", allocation_audio_page);
-	SAY("%8i=audio structs after all deletions\n", allocation_audio_struct);
-	SAY("%8i=audio devices after all deletions\n", registered_audio);
-
-	JOT(4, "ending.\n");
-	return;
-}
 /*****************************************************************************/
 static unsigned int easycap_poll(struct file *file, poll_table *wait)
 {
@@ -2875,6 +2679,56 @@ static struct easycap *alloc_easycap(u8 bInterfaceNumber)
 	return peasycap;
 }
 
+static void free_easycap(struct easycap *peasycap)
+{
+	int allocation_video_urb;
+	int allocation_video_page;
+	int allocation_video_struct;
+	int allocation_audio_urb;
+	int allocation_audio_page;
+	int allocation_audio_struct;
+	int registered_video, registered_audio;
+	int kd;
+
+	JOM(4, "freeing easycap structure.\n");
+	allocation_video_urb    = peasycap->allocation_video_urb;
+	allocation_video_page   = peasycap->allocation_video_page;
+	allocation_video_struct = peasycap->allocation_video_struct;
+	registered_video        = peasycap->registered_video;
+	allocation_audio_urb    = peasycap->allocation_audio_urb;
+	allocation_audio_page   = peasycap->allocation_audio_page;
+	allocation_audio_struct = peasycap->allocation_audio_struct;
+	registered_audio        = peasycap->registered_audio;
+
+	kd = easycap_isdongle(peasycap);
+	if (0 <= kd && DONGLE_MANY > kd) {
+		if (mutex_lock_interruptible(&mutex_dongle)) {
+			SAY("ERROR: cannot down mutex_dongle\n");
+		} else {
+			JOM(4, "locked mutex_dongle\n");
+			easycapdc60_dongle[kd].peasycap = NULL;
+			mutex_unlock(&mutex_dongle);
+			JOM(4, "unlocked mutex_dongle\n");
+			JOT(4, "   null-->dongle[%i].peasycap\n", kd);
+			allocation_video_struct -= sizeof(struct easycap);
+		}
+	} else {
+		SAY("ERROR: cannot purge dongle[].peasycap");
+	}
+
+	/* Free device structure */
+	kfree(peasycap);
+
+	SAY("%8i=video urbs    after all deletions\n", allocation_video_urb);
+	SAY("%8i=video pages   after all deletions\n", allocation_video_page);
+	SAY("%8i=video structs after all deletions\n", allocation_video_struct);
+	SAY("%8i=video devices after all deletions\n", registered_video);
+	SAY("%8i=audio urbs    after all deletions\n", allocation_audio_urb);
+	SAY("%8i=audio pages   after all deletions\n", allocation_audio_page);
+	SAY("%8i=audio structs after all deletions\n", allocation_audio_struct);
+	SAY("%8i=audio devices after all deletions\n", registered_audio);
+}
+
 /*
  * FIXME: Identify the appropriate pointer peasycap for interfaces
  * 1 and 2. The address of peasycap->pusb_device is reluctantly used
@@ -3073,6 +2927,26 @@ static int alloc_framebuffers(struct easycap *peasycap)
 	return 0;
 }
 
+static void free_framebuffers(struct easycap *peasycap)
+{
+	int k, m, gone;
+
+	JOM(4, "freeing video frame buffers.\n");
+	gone = 0;
+	for (k = 0;  k < FRAME_BUFFER_MANY;  k++) {
+		for (m = 0;  m < FRAME_BUFFER_SIZE/PAGE_SIZE;  m++) {
+			if (peasycap->frame_buffer[k][m].pgo) {
+				free_page((unsigned long)
+					peasycap->frame_buffer[k][m].pgo);
+				peasycap->frame_buffer[k][m].pgo = NULL;
+				peasycap->allocation_video_page -= 1;
+				gone++;
+			}
+		}
+	}
+	JOM(4, "video frame buffers freed: %i pages\n", gone);
+}
+
 static int alloc_fieldbuffers(struct easycap *peasycap)
 {
 	int i, j;
@@ -3112,6 +2986,26 @@ static int alloc_fieldbuffers(struct easycap *peasycap)
 	return 0;
 }
 
+static void free_fieldbuffers(struct easycap *peasycap)
+{
+	int k, m, gone;
+
+	JOM(4, "freeing video field buffers.\n");
+	gone = 0;
+	for (k = 0;  k < FIELD_BUFFER_MANY;  k++) {
+		for (m = 0;  m < FIELD_BUFFER_SIZE/PAGE_SIZE;  m++) {
+			if (peasycap->field_buffer[k][m].pgo) {
+				free_page((unsigned long)
+					  peasycap->field_buffer[k][m].pgo);
+				peasycap->field_buffer[k][m].pgo = NULL;
+				peasycap->allocation_video_page -= 1;
+				gone++;
+			}
+		}
+	}
+	JOM(4, "video field buffers freed: %i pages\n", gone);
+}
+
 static int alloc_isocbuffers(struct easycap *peasycap)
 {
 	int i;
@@ -3142,6 +3036,27 @@ static int alloc_isocbuffers(struct easycap *peasycap)
 	return 0;
 }
 
+static void free_isocbuffers(struct easycap *peasycap)
+{
+	int k, m;
+
+	JOM(4, "freeing video isoc buffers.\n");
+	m = 0;
+	for (k = 0;  k < VIDEO_ISOC_BUFFER_MANY;  k++) {
+		if (peasycap->video_isoc_buffer[k].pgo) {
+			free_pages((unsigned long)
+				   peasycap->video_isoc_buffer[k].pgo,
+					VIDEO_ISOC_ORDER);
+			peasycap->video_isoc_buffer[k].pgo = NULL;
+			peasycap->allocation_video_page -=
+						BIT(VIDEO_ISOC_ORDER);
+			m++;
+		}
+	}
+	JOM(4, "isoc video buffers freed: %i pages\n",
+			m * (0x01 << VIDEO_ISOC_ORDER));
+}
+
 static int create_video_urbs(struct easycap *peasycap)
 {
 	struct urb *purb;
@@ -3234,6 +3149,45 @@ static int create_video_urbs(struct easycap *peasycap)
 	return 0;
 }
 
+static void free_video_urbs(struct easycap *peasycap)
+{
+	struct list_head *plist_head, *plist_next;
+	struct data_urb *pdata_urb;
+	int m;
+
+	if (peasycap->purb_video_head) {
+		m = 0;
+		list_for_each(plist_head, peasycap->purb_video_head) {
+			pdata_urb = list_entry(plist_head,
+					struct data_urb, list_head);
+			if (pdata_urb && pdata_urb->purb) {
+				usb_free_urb(pdata_urb->purb);
+				pdata_urb->purb = NULL;
+				peasycap->allocation_video_urb--;
+				m++;
+			}
+		}
+
+		JOM(4, "%i video urbs freed\n", m);
+		JOM(4, "freeing video data_urb structures.\n");
+		m = 0;
+		list_for_each_safe(plist_head, plist_next,
+					peasycap->purb_video_head) {
+			pdata_urb = list_entry(plist_head,
+					struct data_urb, list_head);
+			if (pdata_urb) {
+				peasycap->allocation_video_struct -=
+					sizeof(struct data_urb);
+				kfree(pdata_urb);
+				m++;
+			}
+		}
+		JOM(4, "%i video data_urb structures freed\n", m);
+		JOM(4, "setting peasycap->purb_video_head=NULL\n");
+		peasycap->purb_video_head = NULL;
+	}
+}
+
 static int alloc_audio_buffers(struct easycap *peasycap)
 {
 	void *pbuf;
@@ -3263,6 +3217,27 @@ static int alloc_audio_buffers(struct easycap *peasycap)
 	return 0;
 }
 
+static void free_audio_buffers(struct easycap *peasycap)
+{
+	int k, m;
+
+	JOM(4, "freeing audio isoc buffers.\n");
+	m = 0;
+	for (k = 0;  k < AUDIO_ISOC_BUFFER_MANY;  k++) {
+		if (peasycap->audio_isoc_buffer[k].pgo) {
+			free_pages((unsigned long)
+					(peasycap->audio_isoc_buffer[k].pgo),
+					AUDIO_ISOC_ORDER);
+			peasycap->audio_isoc_buffer[k].pgo = NULL;
+			peasycap->allocation_audio_page -=
+					BIT(AUDIO_ISOC_ORDER);
+			m++;
+		}
+	}
+	JOM(4, "easyoss_delete(): isoc audio buffers freed: %i pages\n",
+					m * (0x01 << AUDIO_ISOC_ORDER));
+}
+
 static int create_audio_urbs(struct easycap *peasycap)
 {
 	struct urb *purb;
@@ -3351,6 +3326,45 @@ static int create_audio_urbs(struct easycap *peasycap)
 	return 0;
 }
 
+static void free_audio_urbs(struct easycap *peasycap)
+{
+	struct list_head *plist_head, *plist_next;
+	struct data_urb *pdata_urb;
+	int m;
+
+	if (peasycap->purb_audio_head) {
+		JOM(4, "freeing audio urbs\n");
+		m = 0;
+		list_for_each(plist_head, (peasycap->purb_audio_head)) {
+			pdata_urb = list_entry(plist_head,
+					struct data_urb, list_head);
+			if (pdata_urb && pdata_urb->purb) {
+				usb_free_urb(pdata_urb->purb);
+				pdata_urb->purb = NULL;
+				peasycap->allocation_audio_urb--;
+				m++;
+			}
+		}
+		JOM(4, "%i audio urbs freed\n", m);
+		JOM(4, "freeing audio data_urb structures.\n");
+		m = 0;
+		list_for_each_safe(plist_head, plist_next,
+					peasycap->purb_audio_head) {
+			pdata_urb = list_entry(plist_head,
+					struct data_urb, list_head);
+			if (pdata_urb) {
+				peasycap->allocation_audio_struct -=
+							sizeof(struct data_urb);
+				kfree(pdata_urb);
+				m++;
+			}
+		}
+		JOM(4, "%i audio data_urb structures freed\n", m);
+		JOM(4, "setting peasycap->purb_audio_head=NULL\n");
+		peasycap->purb_audio_head = NULL;
+	}
+}
+
 static void config_easycap(struct easycap *peasycap,
 			   u8 bInterfaceNumber,
 			   u8 bInterfaceClass,
@@ -3389,6 +3403,45 @@ static void config_easycap(struct easycap *peasycap,
 	}
 }
 
+/*
+ * This function is called from within easycap_usb_disconnect() and is
+ * protected by semaphores set and cleared by easycap_usb_disconnect().
+ * By this stage the device has already been physically unplugged,
+ * so peasycap->pusb_device is no longer valid.
+ */
+static void easycap_delete(struct kref *pkref)
+{
+	struct easycap *peasycap;
+
+	peasycap = container_of(pkref, struct easycap, kref);
+	if (!peasycap) {
+		SAM("ERROR: peasycap is NULL: cannot perform deletions\n");
+		return;
+	}
+
+	/* Free video urbs */
+	free_video_urbs(peasycap);
+
+	/* Free video isoc buffers */
+	free_isocbuffers(peasycap);
+
+	/* Free video field buffers */
+	free_fieldbuffers(peasycap);
+
+	/* Free video frame buffers */
+	free_framebuffers(peasycap);
+
+	/* Free audio urbs */
+	free_audio_urbs(peasycap);
+
+	/* Free audio isoc buffers */
+	free_audio_buffers(peasycap);
+
+	free_easycap(peasycap);
+
+	JOT(4, "ending.\n");
+}
+
 static const struct v4l2_file_operations v4l2_fops = {
 	.owner		= THIS_MODULE,
 	.open		= easycap_open_noinode,
-- 
1.7.3.4

