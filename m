Return-path: <linux-media-owner@vger.kernel.org>
Received: from 99-34-136-231.lightspeed.bcvloh.sbcglobal.net ([99.34.136.231]:48161
	"EHLO desource.dyndns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756259Ab0EERhP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 May 2010 13:37:15 -0400
From: David Ellingsworth <david@identd.dyndns.org>
To: linux-media@vger.kernel.org
Cc: David Ellingsworth <david@identd.dyndns.org>
Subject: [PATCH/RFC 2/7] dsbr100: fix potential use after free
Date: Wed,  5 May 2010 13:05:25 -0400
Message-Id: <1273079130-21999-3-git-send-email-david@identd.dyndns.org>
In-Reply-To: <1273079130-21999-1-git-send-email-david@identd.dyndns.org>
References: <1273079130-21999-1-git-send-email-david@identd.dyndns.org>
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

