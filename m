Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.wellnetcz.com ([212.24.148.102]:40504 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476AbZFSUaX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jun 2009 16:30:23 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/4] V4L: radio-si470x, fix lock imbalance
Date: Fri, 19 Jun 2009 22:30:04 +0200
Message-Id: <1245443407-17410-1-git-send-email-jirislaby@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is one path with omitted unlock in si470x_fops_release. Fix that.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/media/radio/radio-si470x.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/radio/radio-si470x.c b/drivers/media/radio/radio-si470x.c
index 640421c..46d2163 100644
--- a/drivers/media/radio/radio-si470x.c
+++ b/drivers/media/radio/radio-si470x.c
@@ -1200,7 +1200,7 @@ static int si470x_fops_release(struct file *file)
 			video_unregister_device(radio->videodev);
 			kfree(radio->buffer);
 			kfree(radio);
-			goto done;
+			goto unlock;
 		}
 
 		/* stop rds reception */
@@ -1213,9 +1213,8 @@ static int si470x_fops_release(struct file *file)
 		retval = si470x_stop(radio);
 		usb_autopm_put_interface(radio->intf);
 	}
-
+unlock:
 	mutex_unlock(&radio->disconnect_lock);
-
 done:
 	return retval;
 }
-- 
1.6.3.2

