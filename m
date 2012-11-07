Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39460 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188Ab2KGVjS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Nov 2012 16:39:18 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	Milan Tuma <milan.olin@seznam.cz>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH] dvb_usb_v2: fix pid_filter callback error logging
Date: Wed,  7 Nov 2012 23:38:35 +0200
Message-Id: <1352324315-3077-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Code block braces were missing which leds broken error logging and compiler warning.

drivers/media/usb/dvb-usb-v2/dvb_usb_core.c: In function 'dvb_usb_ctrl_feed':
drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:291:12: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Reported-by: Milan Tuma <milan.olin@seznam.cz>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
index 9859d2a..ba51f65 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
@@ -283,14 +283,13 @@ static inline int dvb_usb_ctrl_feed(struct dvb_demux_feed *dvbdmxfeed,
 
 	/* activate the pid on the device pid filter */
 	if (adap->props->caps & DVB_USB_ADAP_HAS_PID_FILTER &&
-			adap->pid_filtering &&
-			adap->props->pid_filter)
+			adap->pid_filtering && adap->props->pid_filter) {
 		ret = adap->props->pid_filter(adap, dvbdmxfeed->index,
 				dvbdmxfeed->pid, (count == 1) ? 1 : 0);
-			if (ret < 0)
-				dev_err(&d->udev->dev, "%s: pid_filter() " \
-						"failed=%d\n", KBUILD_MODNAME,
-						ret);
+		if (ret < 0)
+			dev_err(&d->udev->dev, "%s: pid_filter() failed=%d\n",
+					KBUILD_MODNAME, ret);
+	}
 
 	/* start feeding if it is first pid */
 	if (adap->feed_count == 1 && count == 1) {
-- 
1.7.11.7

