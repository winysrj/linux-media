Return-path: <linux-media-owner@vger.kernel.org>
Received: from shell.v3.sk ([92.60.52.57]:55604 "EHLO shell.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754178AbcFANE1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Jun 2016 09:04:27 -0400
From: Lubomir Rintel <lkundrak@v3.sk>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Federico Simoncelli <fsimonce@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Patrick Keshishian <pkeshish@gmail.com>,
	linux-media@vger.kernel.org, Lubomir Rintel <lkundrak@v3.sk>,
	Patrick Keshishian <sidster@boxsoft.com>
Subject: [PATCH] [media] usbtv: improve a comment
Date: Wed,  1 Jun 2016 15:04:07 +0200
Message-Id: <1464786247-15697-1-git-send-email-lkundrak@v3.sk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patrick Keshishian improved the explanation of the protocol when porting
the driver to OpenBSD. Given it's a reverse engineering one and there's
no documetnation it might be helpful to whoever hacks on the driver.

Signed-off-by: Patrick Keshishian <sidster@boxsoft.com>
Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
---
 drivers/media/usb/usbtv/usbtv-video.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/usbtv/usbtv-video.c b/drivers/media/usb/usbtv/usbtv-video.c
index d94d5c5..bae4944 100644
--- a/drivers/media/usb/usbtv/usbtv-video.c
+++ b/drivers/media/usb/usbtv/usbtv-video.c
@@ -265,8 +265,23 @@ static int usbtv_setup_capture(struct usbtv *usbtv)
 /* Copy data from chunk into a frame buffer, deinterlacing the data
  * into every second line. Unfortunately, they don't align nicely into
  * 720 pixel lines, as the chunk is 240 words long, which is 480 pixels.
- * Therefore, we break down the chunk into two halves before copyting,
- * so that we can interleave a line if needed. */
+ * Therefore, we break down the chunk into two halves before copying,
+ * so that we can interleave a line if needed.
+ *
+ * Each "chunk" is 240 words; a word in this context equals 4 bytes.
+ * Image format is YUYV/YUV 4:2:2, consisting of Y Cr Y Cb, defining two
+ * pixels, the Cr and Cb shared between the two pixels, but each having
+ * separate Y values. Thus, the 240 words equal 480 pixels. It therefore,
+ * takes 1.5 chunks to make a 720 pixel-wide line for the frame.
+ * The image is interlaced, so there is a "scan" of odd lines, followed
+ * by "scan" of even numbered lines.
+ *
+ * Following code is writing the chunks in correct sequence, skipping
+ * the rows based on "odd" value.
+ * line 1: chunk[0][  0..479] chunk[0][480..959] chunk[1][  0..479]
+ * line 3: chunk[1][480..959] chunk[2][  0..479] chunk[2][480..959]
+ * ...etc.
+ */
 static void usbtv_chunk_to_vbuf(u32 *frame, __be32 *src, int chunk_no, int odd)
 {
 	int half;
-- 
2.5.5

