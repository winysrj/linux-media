Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:38422 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751176AbcDOPfo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Apr 2016 11:35:44 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/3] pvrusb2: fix smatch errors
Date: Fri, 15 Apr 2016 17:35:32 +0200
Message-Id: <1460734533-34191-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1460734533-34191-1-git-send-email-hverkuil@xs4all.nl>
References: <1460734533-34191-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

These are false positives, but still easy to fix.

pvrusb2-hdw.c:3676 pvr2_send_request_ex() error: we previously assumed 'write_data' could be null (see line 3648)
pvrusb2-hdw.c:3829 pvr2_send_request_ex() error: we previously assumed 'read_data' could be null (see line 3649)

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
index 1a093e5..83e9a3e 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
@@ -3672,11 +3672,10 @@ static int pvr2_send_request_ex(struct pvr2_hdw *hdw,
 
 
 	hdw->cmd_debug_state = 1;
-	if (write_len) {
+	if (write_len && write_data)
 		hdw->cmd_debug_code = ((unsigned char *)write_data)[0];
-	} else {
+	else
 		hdw->cmd_debug_code = 0;
-	}
 	hdw->cmd_debug_write_len = write_len;
 	hdw->cmd_debug_read_len = read_len;
 
@@ -3688,7 +3687,7 @@ static int pvr2_send_request_ex(struct pvr2_hdw *hdw,
 	setup_timer(&timer, pvr2_ctl_timeout, (unsigned long)hdw);
 	timer.expires = jiffies + timeout;
 
-	if (write_len) {
+	if (write_len && write_data) {
 		hdw->cmd_debug_state = 2;
 		/* Transfer write data to internal buffer */
 		for (idx = 0; idx < write_len; idx++) {
@@ -3795,7 +3794,7 @@ static int pvr2_send_request_ex(struct pvr2_hdw *hdw,
 			goto done;
 		}
 	}
-	if (read_len) {
+	if (read_len && read_data) {
 		/* Validate results of read request */
 		if ((hdw->ctl_read_urb->status != 0) &&
 		    (hdw->ctl_read_urb->status != -ENOENT) &&
-- 
2.8.0.rc3

