Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:55489 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933363Ab1LFNjk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Dec 2011 08:39:40 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, Stefan Ringel <linuxtv@stefanringel.de>
Subject: [PATCH 2/2] [media] tm6000: Fix bad indentation.
Date: Tue,  6 Dec 2011 14:39:36 +0100
Message-Id: <1323178776-12305-2-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1323178776-12305-1-git-send-email-thierry.reding@avionic-design.de>
References: <1322509580-14460-1-git-send-email-linuxtv@stefanringel.de>
 <1323178776-12305-1-git-send-email-thierry.reding@avionic-design.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Function parameters on subsequent lines should never be aligned with the
function name but rather be indented.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 drivers/media/video/tm6000/tm6000-video.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/tm6000/tm6000-video.c b/drivers/media/video/tm6000/tm6000-video.c
index 87eb909..a15fd9d 100644
--- a/drivers/media/video/tm6000/tm6000-video.c
+++ b/drivers/media/video/tm6000/tm6000-video.c
@@ -1649,12 +1649,10 @@ static int tm6000_release(struct file *file)
 
 		if (dev->int_in.endp)
 			usb_set_interface(dev->udev,
-			dev->isoc_in.bInterfaceNumber,
-			2);
+					dev->isoc_in.bInterfaceNumber, 2);
 		else
 			usb_set_interface(dev->udev,
-			dev->isoc_in.bInterfaceNumber,
-			0);
+					dev->isoc_in.bInterfaceNumber, 0);
 
 		/* Start interrupt USB pipe */
 		tm6000_ir_int_start(dev);
-- 
1.7.8

