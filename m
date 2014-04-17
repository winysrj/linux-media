Return-path: <linux-media-owner@vger.kernel.org>
Received: from forward2l.mail.yandex.net ([84.201.143.145]:59812 "EHLO
	forward2l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbaDQUzx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Apr 2014 16:55:53 -0400
Subject: [PATCH] s2255: Do not free fw_data until timer handler has actually
 stopped using it
From: Kirill Tkhai <tkhai@yandex.ru>
To: linux-media@vger.kernel.org
Cc: tkhai@yandex.ru, sakari.ailus@iki.fi, linux-dev@sensoray.com,
	hans.verkuil@cisco.com, m.chehab@samsung.com
Date: Fri, 18 Apr 2014 00:47:04 +0400
Message-ID: <20140417204704.30337.46941.stgit@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Function del_timer() does not guarantee that timer was really deleted.
If the timer handler is beeing executed at the moment, the function
does nothing. So, we have a race between del_timer() and kfree(), and
it's possible to use already freed memory in the handler.

This is compile-tested only. Please, consider applying or something like it.

[Should CC stable@ ?]

Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
---
 drivers/media/usb/s2255/s2255drv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index 1d4ba2b..503fd65 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -1522,7 +1522,7 @@ static void s2255_destroy(struct s2255_dev *dev)
 	/* board shutdown stops the read pipe if it is running */
 	s2255_board_shutdown(dev);
 	/* make sure firmware still not trying to load */
-	del_timer(&dev->timer);  /* only started in .probe and .open */
+	del_timer_sync(&dev->timer);  /* only started in .probe and .open */
 	if (dev->fw_data->fw_urb) {
 		usb_kill_urb(dev->fw_data->fw_urb);
 		usb_free_urb(dev->fw_data->fw_urb);
@@ -2352,7 +2352,7 @@ errorREQFW:
 errorFWDATA2:
 	usb_free_urb(dev->fw_data->fw_urb);
 errorFWURB:
-	del_timer(&dev->timer);
+	del_timer_sync(&dev->timer);
 errorEP:
 	usb_put_dev(dev->udev);
 errorUDEV:

