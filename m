Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45795 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756907Ab0D0VVX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Apr 2010 17:21:23 -0400
Message-Id: <201004272111.o3RLBMrP019991@imap1.linux-foundation.org>
Subject: [patch 05/11] drivers/media/video/au0828/au0828-video.c: off by one bug
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, akpm@linux-foundation.org,
	error27@gmail.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com
From: akpm@linux-foundation.org
Date: Tue, 27 Apr 2010 14:11:22 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Dan Carpenter <error27@gmail.com>

The "AUVI_INPUT(tmp)" macro uses "tmp" as an index of an array with
AU0828_MAX_INPUT elements.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/au0828/au0828-video.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/video/au0828/au0828-video.c~drivers-media-video-au0828-au0828-videoc-off-by-one-bug drivers/media/video/au0828/au0828-video.c
--- a/drivers/media/video/au0828/au0828-video.c~drivers-media-video-au0828-au0828-videoc-off-by-one-bug
+++ a/drivers/media/video/au0828/au0828-video.c
@@ -1105,7 +1105,7 @@ static int vidioc_enum_input(struct file
 
 	tmp = input->index;
 
-	if (tmp > AU0828_MAX_INPUT)
+	if (tmp >= AU0828_MAX_INPUT)
 		return -EINVAL;
 	if (AUVI_INPUT(tmp).type == 0)
 		return -EINVAL;
_
