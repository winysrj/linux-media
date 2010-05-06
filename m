Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:34688 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750978Ab0EFO13 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 6 May 2010 10:27:29 -0400
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH] tm6000: README - add vbi
Date: Thu,  6 May 2010 16:25:52 +0200
Message-Id: <1273155952-1498-1-git-send-email-stefan.ringel@arcor.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <stefan.ringel@arcor.de>

Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/README |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/tm6000/README b/drivers/staging/tm6000/README
index 078e803..c340ebc 100644
--- a/drivers/staging/tm6000/README
+++ b/drivers/staging/tm6000/README
@@ -4,6 +4,7 @@ Todo:
 	  URB control transfers
 	- Properly add the locks at tm6000-video
 	- Add audio support
+	- Add vbi support
 	- Add IR support
 	- Do several cleanups
 	- I think that frame1/frame0 are inverted. This causes a funny effect at the image.
-- 
1.7.0.3

