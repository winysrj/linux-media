Return-path: <linux-media-owner@vger.kernel.org>
Received: from 99-34-136-231.lightspeed.bcvloh.sbcglobal.net ([99.34.136.231]:41825
	"EHLO desource.dyndns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757330Ab0E0Qku (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 May 2010 12:40:50 -0400
From: David Ellingsworth <david@identd.dyndns.org>
To: linux-media@vger.kernel.org
Cc: Markus Demleitner <msdemlei@tucana.harvard.edu>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	David Ellingsworth <david@identd.dyndns.org>
Subject: [PATCH/RFC v2 2/8] dsbr100: fix potential use after free
Date: Thu, 27 May 2010 12:39:10 -0400
Message-Id: <1274978356-25836-3-git-send-email-david@identd.dyndns.org>
In-Reply-To: <[PATCH/RFC 0/7] dsbr100: driver cleanup>
References: <[PATCH/RFC 0/7] dsbr100: driver cleanup>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
---
 drivers/media/radio/dsbr100.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/radio/dsbr100.c b/drivers/media/radio/dsbr100.c
index 673eda8..2f96e13 100644
--- a/drivers/media/radio/dsbr100.c
+++ b/drivers/media/radio/dsbr100.c
@@ -354,8 +354,8 @@ static void usb_dsbr100_disconnect(struct usb_interface *intf)
 	radio->removed = 1;
 	mutex_unlock(&radio->lock);
 
-	video_unregister_device(&radio->videodev);
 	v4l2_device_disconnect(&radio->v4l2_dev);
+	video_unregister_device(&radio->videodev);
 }
 
 
-- 
1.7.1

