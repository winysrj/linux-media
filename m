Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4804 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbaHTW7q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Aug 2014 18:59:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 17/29] usbtv: fix sparse warnings
Date: Thu, 21 Aug 2014 00:59:16 +0200
Message-Id: <1408575568-20562-18-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1408575568-20562-1-git-send-email-hverkuil@xs4all.nl>
References: <1408575568-20562-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/usb/usbtv/usbtv-video.c:285:14: warning: cast to restricted __be32
drivers/media/usb/usbtv/usbtv-video.c:285:14: warning: cast to restricted __be32
drivers/media/usb/usbtv/usbtv-video.c:285:14: warning: cast to restricted __be32
drivers/media/usb/usbtv/usbtv-video.c:285:14: warning: cast to restricted __be32
drivers/media/usb/usbtv/usbtv-video.c:285:14: warning: cast to restricted __be32
drivers/media/usb/usbtv/usbtv-video.c:285:14: warning: cast to restricted __be32
drivers/media/usb/usbtv/usbtv-video.c:287:20: warning: cast to restricted __be32
drivers/media/usb/usbtv/usbtv-video.c:287:20: warning: cast to restricted __be32
drivers/media/usb/usbtv/usbtv-video.c:287:20: warning: cast to restricted __be32
drivers/media/usb/usbtv/usbtv-video.c:287:20: warning: cast to restricted __be32
drivers/media/usb/usbtv/usbtv-video.c:287:20: warning: cast to restricted __be32
drivers/media/usb/usbtv/usbtv-video.c:287:20: warning: cast to restricted __be32
drivers/media/usb/usbtv/usbtv-video.c:288:15: warning: cast to restricted __be32
drivers/media/usb/usbtv/usbtv-video.c:288:15: warning: cast to restricted __be32
drivers/media/usb/usbtv/usbtv-video.c:288:15: warning: cast to restricted __be32
drivers/media/usb/usbtv/usbtv-video.c:288:15: warning: cast to restricted __be32
drivers/media/usb/usbtv/usbtv-video.c:288:15: warning: cast to restricted __be32
drivers/media/usb/usbtv/usbtv-video.c:288:15: warning: cast to restricted __be32
drivers/media/usb/usbtv/usbtv-video.c:289:20: warning: cast to restricted __be32
drivers/media/usb/usbtv/usbtv-video.c:289:20: warning: cast to restricted __be32
drivers/media/usb/usbtv/usbtv-video.c:289:20: warning: cast to restricted __be32
drivers/media/usb/usbtv/usbtv-video.c:289:20: warning: cast to restricted __be32
drivers/media/usb/usbtv/usbtv-video.c:289:20: warning: cast to restricted __be32
drivers/media/usb/usbtv/usbtv-video.c:289:20: warning: cast to restricted __be32

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/usbtv/usbtv-video.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/usbtv/usbtv-video.c b/drivers/media/usb/usbtv/usbtv-video.c
index 030c585..58698a0 100644
--- a/drivers/media/usb/usbtv/usbtv-video.c
+++ b/drivers/media/usb/usbtv/usbtv-video.c
@@ -256,7 +256,7 @@ static int usbtv_setup_capture(struct usbtv *usbtv)
  * 720 pixel lines, as the chunk is 240 words long, which is 480 pixels.
  * Therefore, we break down the chunk into two halves before copyting,
  * so that we can interleave a line if needed. */
-static void usbtv_chunk_to_vbuf(u32 *frame, u32 *src, int chunk_no, int odd)
+static void usbtv_chunk_to_vbuf(u32 *frame, __be32 *src, int chunk_no, int odd)
 {
 	int half;
 
@@ -274,7 +274,7 @@ static void usbtv_chunk_to_vbuf(u32 *frame, u32 *src, int chunk_no, int odd)
 /* Called for each 256-byte image chunk.
  * First word identifies the chunk, followed by 240 words of image
  * data and padding. */
-static void usbtv_image_chunk(struct usbtv *usbtv, u32 *chunk)
+static void usbtv_image_chunk(struct usbtv *usbtv, __be32 *chunk)
 {
 	int frame_id, odd, chunk_no;
 	u32 *frame;
@@ -365,7 +365,7 @@ static void usbtv_iso_cb(struct urb *ip)
 
 		for (offset = 0; USBTV_CHUNK_SIZE * offset < size; offset++)
 			usbtv_image_chunk(usbtv,
-				(u32 *)&data[USBTV_CHUNK_SIZE * offset]);
+				(__be32 *)&data[USBTV_CHUNK_SIZE * offset]);
 	}
 
 resubmit:
-- 
2.1.0.rc1

