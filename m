Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2347 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756714AbaCDKnR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Mar 2014 05:43:17 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, s.nawrocki@samsung.com, m.szyprowski@samsung.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv4 PATCH 06/18] pwc: do not decompress the image unless the state is DONE
Date: Tue,  4 Mar 2014 11:42:14 +0100
Message-Id: <1393929746-39437-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1393929746-39437-1-git-send-email-hverkuil@xs4all.nl>
References: <1393929746-39437-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

There is no point in trying to decompress a captured frame unless
the buffer state is OK. It won't be used in any other state, and
in fact the contents of the buffer might well be corrupt.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/pwc/pwc-if.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
index 619121f..d13e7c9 100644
--- a/drivers/media/usb/pwc/pwc-if.c
+++ b/drivers/media/usb/pwc/pwc-if.c
@@ -619,12 +619,15 @@ static void buffer_finish(struct vb2_buffer *vb)
 	struct pwc_device *pdev = vb2_get_drv_priv(vb->vb2_queue);
 	struct pwc_frame_buf *buf = container_of(vb, struct pwc_frame_buf, vb);
 
-	/*
-	 * Application has called dqbuf and is getting back a buffer we've
-	 * filled, take the pwc data we've stored in buf->data and decompress
-	 * it into a usable format, storing the result in the vb2_buffer
-	 */
-	pwc_decompress(pdev, buf);
+	if (vb->state == VB2_BUF_STATE_DONE) {
+		/*
+		 * Application has called dqbuf and is getting back a buffer
+		 * we've filled, take the pwc data we've stored in buf->data
+		 * and decompress it into a usable format, storing the result
+		 * in the vb2_buffer.
+		 */
+		pwc_decompress(pdev, buf);
+	}
 }
 
 static void buffer_cleanup(struct vb2_buffer *vb)
-- 
1.9.0

