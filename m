Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f224.google.com ([209.85.217.224]:60174 "EHLO
	mail-gx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300Ab0BKLIA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Feb 2010 06:08:00 -0500
Subject: [PATCH] drivers/media/radio/si470x/radio-si470x-usb.c fix use
 after free
From: Darren Jenkins <darrenrjenkins@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Tobias Lorenz <tobias.lorenz@gmx.net>,
	Tobias Lorenz <tobias.lorenz@gmx.net>,
	Douglas Schilling Landgraf <dougsland@redhat.com>,
	linux-media@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Janitors <kernel-janitors@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Feb 2010 22:07:53 +1100
Message-ID: <1265886473.27789.6.camel@ICE-BOX>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In si470x_usb_driver_disconnect() radio->disconnect_lock is accessed
after it is freed. This fixes the problem.

Coverity CID: 2530

Signed-off-by: Darren Jenkins <darrenrjenkins@gmail.com>
---
 drivers/media/radio/si470x/radio-si470x-usb.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/media/radio/si470x/radio-si470x-usb.c b/drivers/media/radio/si470x/radio-si470x-usb.c
index a96e1b9..1588a9d 100644
--- a/drivers/media/radio/si470x/radio-si470x-usb.c
+++ b/drivers/media/radio/si470x/radio-si470x-usb.c
@@ -842,9 +842,11 @@ static void si470x_usb_driver_disconnect(struct usb_interface *intf)
 		kfree(radio->int_in_buffer);
 		video_unregister_device(radio->videodev);
 		kfree(radio->buffer);
+		mutex_unlock(&radio->disconnect_lock);
 		kfree(radio);
+	} else {
+		mutex_unlock(&radio->disconnect_lock);
 	}
-	mutex_unlock(&radio->disconnect_lock);
 }
 
 
-- 
1.6.3.3



