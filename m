Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37895 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754374Ab2IKBZ6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Sep 2012 21:25:58 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/2] dvb_usb_v2: call streaming_ctrl() before kill urbs
Date: Tue, 11 Sep 2012 04:25:14 +0300
Message-Id: <1347326714-19514-2-git-send-email-crope@iki.fi>
In-Reply-To: <1347326714-19514-1-git-send-email-crope@iki.fi>
References: <1347326714-19514-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Logically it is better ask hardware to stop streaming before
killing urbs carrying stream. Earlier it was just opposite.

Now code runs:
* submit urbs
* start streaming
** streaming ongoing **
* stop streaming
* kill urbs

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
index e2d73e1..f990159 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
@@ -265,7 +265,6 @@ static inline int dvb_usb_ctrl_feed(struct dvb_demux_feed *dvbdmxfeed,
 	/* stop feeding if it is last pid */
 	if (adap->feed_count == 0) {
 		dev_dbg(&d->udev->dev, "%s: stop feeding\n", __func__);
-		usb_urb_killv2(&adap->stream);
 
 		if (d->props->streaming_ctrl) {
 			ret = d->props->streaming_ctrl(
@@ -274,9 +273,11 @@ static inline int dvb_usb_ctrl_feed(struct dvb_demux_feed *dvbdmxfeed,
 				dev_err(&d->udev->dev, "%s: streaming_ctrl() " \
 						"failed=%d\n", KBUILD_MODNAME,
 						ret);
+				usb_urb_killv2(&adap->stream);
 				goto err_mutex_unlock;
 			}
 		}
+		usb_urb_killv2(&adap->stream);
 		mutex_unlock(&adap->sync_mutex);
 	}
 
-- 
1.7.11.4

