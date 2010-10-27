Return-path: <mchehab@pedra>
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:57829 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752599Ab0J0TsJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Oct 2010 15:48:09 -0400
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH] tm6000: bugfix set tv standards
Date: Wed, 27 Oct 2010 21:48:05 +0200
Message-Id: <1288208885-5099-1-git-send-email-stefan.ringel@arcor.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Stefan Ringel <stefan.ringel@arcor.de>

bugfix set tv standards


Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/tm6000-video.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
index 9ec8279..c5690b2 100644
--- a/drivers/staging/tm6000/tm6000-video.c
+++ b/drivers/staging/tm6000/tm6000-video.c
@@ -1032,6 +1032,7 @@ static int vidioc_s_std (struct file *file, void *priv, v4l2_std_id *norm)
 	struct tm6000_fh   *fh=priv;
 	struct tm6000_core *dev = fh->dev;
 
+	dev->norm = *norm;
 	rc = tm6000_init_analog_mode(dev);
 
 	fh->width  = dev->width;
-- 
1.7.1

