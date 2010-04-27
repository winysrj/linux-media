Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54970 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756907Ab0D0VVm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Apr 2010 17:21:42 -0400
Message-Id: <201004272111.o3RLBQds020005@imap1.linux-foundation.org>
Subject: [patch 09/11] cx88: improve error handling
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, akpm@linux-foundation.org,
	error27@gmail.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com
From: akpm@linux-foundation.org
Date: Tue, 27 Apr 2010 14:11:26 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Dan Carpenter <error27@gmail.com>

Return -EINVAL if we don't find the right query control id.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/cx88/cx88-video.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/media/video/cx88/cx88-video.c~cx88-improve-error-handling drivers/media/video/cx88/cx88-video.c
--- a/drivers/media/video/cx88/cx88-video.c~cx88-improve-error-handling
+++ a/drivers/media/video/cx88/cx88-video.c
@@ -1537,9 +1537,12 @@ static int radio_queryctrl (struct file 
 		c->id >= V4L2_CID_LASTP1)
 		return -EINVAL;
 	if (c->id == V4L2_CID_AUDIO_MUTE) {
-		for (i = 0; i < CX8800_CTLS; i++)
+		for (i = 0; i < CX8800_CTLS; i++) {
 			if (cx8800_ctls[i].v.id == c->id)
 				break;
+		}
+		if (i == CX8800_CTLS)
+			return -EINVAL;
 		*c = cx8800_ctls[i].v;
 	} else
 		*c = no_ctl;
_
