Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40641 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab1DQTzW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Apr 2011 15:55:22 -0400
Received: by wwa36 with SMTP id 36so4886175wwa.1
        for <linux-media@vger.kernel.org>; Sun, 17 Apr 2011 12:55:21 -0700 (PDT)
Subject: [PATCH] dvb-usb return device errors to demuxer v2.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 17 Apr 2011 20:55:14 +0100
Message-ID: <1303070114.2104.2.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Return device errors to demuxer from on/off streamming and
 pid filtering.

Replaces earlier patch that gave false error on stream stopping.

Please test this patch with all dvb-usb devices.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/dvb-usb/dvb-usb-dvb.c |   31 +++++++++++++++++++++----------
 1 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c b/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c
index df1ec3e..b3cb626 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c
@@ -12,7 +12,7 @@
 static int dvb_usb_ctrl_feed(struct dvb_demux_feed *dvbdmxfeed, int onoff)
 {
 	struct dvb_usb_adapter *adap = dvbdmxfeed->demux->priv;
-	int newfeedcount,ret;
+	int newfeedcount, ret;
 
 	if (adap == NULL)
 		return -ENODEV;
@@ -24,9 +24,13 @@ static int dvb_usb_ctrl_feed(struct dvb_demux_feed *dvbdmxfeed, int onoff)
 		deb_ts("stop feeding\n");
 		usb_urb_kill(&adap->stream);
 
-		if (adap->props.streaming_ctrl != NULL)
-			if ((ret = adap->props.streaming_ctrl(adap,0)))
+		if (adap->props.streaming_ctrl != NULL) {
+			ret = adap->props.streaming_ctrl(adap, 0);
+			if (ret < 0) {
 				err("error while stopping stream.");
+				return ret;
+			}
+		}
 	}
 
 	adap->feedcount = newfeedcount;
@@ -49,17 +53,24 @@ static int dvb_usb_ctrl_feed(struct dvb_demux_feed *dvbdmxfeed, int onoff)
 
 		deb_ts("controlling pid parser\n");
 		if (adap->props.caps & DVB_USB_ADAP_HAS_PID_FILTER &&
-			adap->props.caps & DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF &&
-			adap->props.pid_filter_ctrl != NULL)
-			if (adap->props.pid_filter_ctrl(adap,adap->pid_filtering) < 0)
+			adap->props.caps &
+			DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF &&
+			adap->props.pid_filter_ctrl != NULL) {
+			ret = adap->props.pid_filter_ctrl(adap,
+				adap->pid_filtering);
+			if (ret < 0) {
 				err("could not handle pid_parser");
-
+				return ret;
+			}
+		}
 		deb_ts("start feeding\n");
-		if (adap->props.streaming_ctrl != NULL)
-			if (adap->props.streaming_ctrl(adap,1)) {
+		if (adap->props.streaming_ctrl != NULL) {
+			ret = adap->props.streaming_ctrl(adap, 1);
+			if (ret < 0) {
 				err("error while enabling fifo.");
-				return -ENODEV;
+				return ret;
 			}
+		}
 
 	}
 	return 0;
-- 
1.7.4.1

