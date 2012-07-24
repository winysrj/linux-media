Return-path: <linux-media-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:46074 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911Ab2GXPB4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jul 2012 11:01:56 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH, RESEND] cx25821,medusa: incorrect check on decoder type
To: linux-media@vger.kernel.org, akpm@linux-foundation.org
Date: Tue, 24 Jul 2012 17:00:24 +0100
Message-ID: <20120724160011.6932.97726.stgit@bluebook>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Alan Cox <alan@linux.intel.com>

Unsupported requests should be ignored but in fact affected VDEC_A

Reported-by: dcb314@hotmail.com
Resolves-bug: https://bugzilla.kernel.org/show_bug.cgi?id=44051
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/media/video/cx25821/cx25821-medusa-video.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/video/cx25821/cx25821-medusa-video.c b/drivers/media/video/cx25821/cx25821-medusa-video.c
index 313fb20..6a92e5c 100644
--- a/drivers/media/video/cx25821/cx25821-medusa-video.c
+++ b/drivers/media/video/cx25821/cx25821-medusa-video.c
@@ -499,7 +499,7 @@ static void medusa_set_decoderduration(struct cx25821_dev *dev, int decoder,
 	mutex_lock(&dev->lock);
 
 	/* no support */
-	if (decoder < VDEC_A && decoder > VDEC_H) {
+	if (decoder < VDEC_A || decoder > VDEC_H) {
 		mutex_unlock(&dev->lock);
 		return;
 	}

