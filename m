Return-path: <mchehab@pedra>
Received: from smtp.outflux.net ([198.145.64.163]:34250 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758178Ab0JFWQD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Oct 2010 18:16:03 -0400
Date: Wed, 6 Oct 2010 15:05:48 -0700
From: Kees Cook <kees.cook@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH] video: fix potential use-before-NULL-check crash
Message-ID: <20101006220548.GV14666@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Moves use to after NULL-check.

Signed-off-by: Kees Cook <kees.cook@canonical.com>
---

Sent before as part of https://patchwork.kernel.org/patch/138711/ but it
still hasn't been applied.

---
 drivers/media/video/em28xx/em28xx-video.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx-video.c b/drivers/media/video/em28xx/em28xx-video.c
index 7b9ec6e..95a4b60 100644
--- a/drivers/media/video/em28xx/em28xx-video.c
+++ b/drivers/media/video/em28xx/em28xx-video.c
@@ -277,12 +277,13 @@ static void em28xx_copy_vbi(struct em28xx *dev,
 {
 	void *startwrite, *startread;
 	int  offset;
-	int bytesperline = dev->vbi_width;
+	int bytesperline;
 
 	if (dev == NULL) {
 		em28xx_isocdbg("dev is null\n");
 		return;
 	}
+	bytesperline = dev->vbi_width;
 
 	if (dma_q == NULL) {
 		em28xx_isocdbg("dma_q is null\n");
-- 
1.7.1


-- 
Kees Cook
Ubuntu Security Team
