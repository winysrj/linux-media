Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:35442 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111AbbEZOUn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 May 2015 10:20:43 -0400
Received: by wgme6 with SMTP id e6so30193366wgm.2
        for <linux-media@vger.kernel.org>; Tue, 26 May 2015 07:20:42 -0700 (PDT)
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH] media: davinci: vpbe: use v4l2_get_timestamp()
Date: Tue, 26 May 2015 15:20:27 +0100
Message-Id: <1432650027-26265-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch makes use of helper function v4l2_get_timestamp()
to set the timestamp of vb2 buffer.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpbe_display.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index c4ab46f..f69cdd7 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -71,15 +71,10 @@ static int venc_is_second_field(struct vpbe_display *disp_dev)
 static void vpbe_isr_even_field(struct vpbe_display *disp_obj,
 				struct vpbe_layer *layer)
 {
-	struct timespec timevalue;
-
 	if (layer->cur_frm == layer->next_frm)
 		return;
-	ktime_get_ts(&timevalue);
-	layer->cur_frm->vb.v4l2_buf.timestamp.tv_sec =
-		timevalue.tv_sec;
-	layer->cur_frm->vb.v4l2_buf.timestamp.tv_usec =
-		timevalue.tv_nsec / NSEC_PER_USEC;
+
+	v4l2_get_timestamp(&layer->cur_frm->vb.v4l2_buf.timestamp);
 	vb2_buffer_done(&layer->cur_frm->vb, VB2_BUF_STATE_DONE);
 	/* Make cur_frm pointing to next_frm */
 	layer->cur_frm = layer->next_frm;
-- 
2.1.0

