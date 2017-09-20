Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:57012 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751551AbdITGix (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 02:38:53 -0400
Subject: [PATCH 3/3] [media] pvrusb2-ioread: Delete unnecessary braces in six
 functions
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mike Isely <isely@pobox.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <c8117427-6d4d-0a1c-96c7-56e25d838b3e@users.sourceforge.net>
Message-ID: <4d51ebb3-67bc-42c5-4be7-1379f2fb259b@users.sourceforge.net>
Date: Wed, 20 Sep 2017 08:38:46 +0200
MIME-Version: 1.0
In-Reply-To: <c8117427-6d4d-0a1c-96c7-56e25d838b3e@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 20 Sep 2017 08:15:51 +0200

Do not use curly brackets at some source code places
where a single statement should be sufficient.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/pvrusb2/pvrusb2-ioread.c | 38 ++++++++++++------------------
 1 file changed, 15 insertions(+), 23 deletions(-)

diff --git a/drivers/media/usb/pvrusb2/pvrusb2-ioread.c b/drivers/media/usb/pvrusb2/pvrusb2-ioread.c
index 4349f9b5f838..9a0eb2875c9a 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-ioread.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-ioread.c
@@ -120,9 +120,8 @@ void pvr2_ioread_set_sync_key(struct pvr2_ioread *cp,
 		cp->sync_key_len = 0;
 		if (sync_key_len) {
 			cp->sync_key_ptr = kmalloc(sync_key_len,GFP_KERNEL);
-			if (cp->sync_key_ptr) {
+			if (cp->sync_key_ptr)
 				cp->sync_key_len = sync_key_len;
-			}
 		}
 	}
 	if (!cp->sync_key_len) return;
@@ -203,9 +202,9 @@ int pvr2_ioread_setup(struct pvr2_ioread *cp,struct pvr2_stream *sp)
 				   cp);
 			pvr2_ioread_stop(cp);
 			pvr2_stream_kill(cp->stream);
-			if (pvr2_stream_get_buffer_count(cp->stream)) {
+			if (pvr2_stream_get_buffer_count(cp->stream))
 				pvr2_stream_set_buffer_count(cp->stream,0);
-			}
+
 			cp->stream = NULL;
 		}
 		if (sp) {
@@ -238,13 +237,10 @@ int pvr2_ioread_set_enabled(struct pvr2_ioread *cp,int fl)
 	if ((!fl) == (!(cp->enabled))) return ret;
 
 	mutex_lock(&cp->mutex);
-	do {
-		if (fl) {
-			ret = pvr2_ioread_start(cp);
-		} else {
-			pvr2_ioread_stop(cp);
-		}
-	} while (0);
+	if (fl)
+		ret = pvr2_ioread_start(cp);
+	else
+		pvr2_ioread_stop(cp);
 	mutex_unlock(&cp->mutex);
 	return ret;
 }
@@ -318,13 +314,12 @@ static void pvr2_ioread_filter(struct pvr2_ioread *cp)
 		for (idx = cp->c_data_offs; idx < cp->c_data_len; idx++) {
 			if (cp->sync_buf_offs >= cp->sync_key_len) break;
 			if (cp->c_data_ptr[idx] ==
-			    cp->sync_key_ptr[cp->sync_buf_offs]) {
+			    cp->sync_key_ptr[cp->sync_buf_offs])
 				// Found the next key byte
 				(cp->sync_buf_offs)++;
-			} else {
+			else
 				// Whoops, mismatched.  Start key over...
 				cp->sync_buf_offs = 0;
-			}
 		}
 
 		// Consume what we've walked through
@@ -360,10 +355,10 @@ static void pvr2_ioread_filter(struct pvr2_ioread *cp)
 int pvr2_ioread_avail(struct pvr2_ioread *cp)
 {
 	int ret;
-	if (!(cp->enabled)) {
+
+	if (!cp->enabled)
 		// Stream is not enabled; so this is an I/O error
 		return -EIO;
-	}
 
 	if (cp->sync_state == 1) {
 		pvr2_ioread_filter(cp);
@@ -372,15 +367,13 @@ int pvr2_ioread_avail(struct pvr2_ioread *cp)
 
 	ret = 0;
 	if (cp->stream_running) {
-		if (!pvr2_stream_get_ready_count(cp->stream)) {
+		if (!pvr2_stream_get_ready_count(cp->stream))
 			// No data available at all right now.
 			ret = -EAGAIN;
-		}
 	} else {
-		if (pvr2_stream_get_ready_count(cp->stream) < BUFFER_COUNT/2) {
+		if (pvr2_stream_get_ready_count(cp->stream) < BUFFER_COUNT / 2)
 			// Haven't buffered up enough yet; try again later
 			ret = -EAGAIN;
-		}
 	}
 
 	if ((!(cp->spigot_open)) != (!(ret == 0))) {
@@ -476,14 +469,13 @@ cp);
 	mutex_unlock(&cp->mutex);
 
 	if (!ret) {
-		if (copied_cnt) {
+		if (copied_cnt)
 			// If anything was copied, return that count
 			ret = copied_cnt;
-		} else {
+		else
 			// Nothing copied; suggest to caller that another
 			// attempt should be tried again later
 			ret = -EAGAIN;
-		}
 	}
 
 	pvr2_trace(PVR2_TRACE_DATA_FLOW,
-- 
2.14.1
