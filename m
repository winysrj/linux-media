Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52647 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756776AbZHFXBY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 6 Aug 2009 19:01:24 -0400
Message-Id: <200908062301.n76N1G6Z029973@imap1.linux-foundation.org>
Subject: [patch 5/9] drivers/media/video/bw-qcam.c: fix read buffer overflow
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, akpm@linux-foundation.org,
	roel.kluin@gmail.com
From: akpm@linux-foundation.org
Date: Thu, 06 Aug 2009 16:01:16 -0700
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Roel Kluin <roel.kluin@gmail.com>

parport[n] is checked before n < MAX_CAMS

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/bw-qcam.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/video/bw-qcam.c~drivers-media-video-bw-qcamc-fix-read-buffer-overflow drivers/media/video/bw-qcam.c
--- a/drivers/media/video/bw-qcam.c~drivers-media-video-bw-qcamc-fix-read-buffer-overflow
+++ a/drivers/media/video/bw-qcam.c
@@ -992,7 +992,7 @@ static int accept_bwqcam(struct parport 
 
 	if (parport[0] && strncmp(parport[0], "auto", 4) != 0) {
 		/* user gave parport parameters */
-		for(n=0; parport[n] && n<MAX_CAMS; n++){
+		for (n = 0; n < MAX_CAMS && parport[n]; n++) {
 			char *ep;
 			unsigned long r;
 			r = simple_strtoul(parport[n], &ep, 0);
_
