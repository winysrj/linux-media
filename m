Return-path: <mchehab@pedra>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:56905 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667Ab1DPQak (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Apr 2011 12:30:40 -0400
Received: by wwk4 with SMTP id 4so526100wwk.1
        for <linux-media@vger.kernel.org>; Sat, 16 Apr 2011 09:30:39 -0700 (PDT)
Subject: [PATCH] dvb-usb return device errors to demuxer.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 16 Apr 2011 17:30:32 +0100
Message-ID: <1302971432.3068.4.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Return device errors to demuxer from on/off streamming and
 pid filtering.

Please test this patch with all dvb-usb devices.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/dvb-usb/dvb-usb-dvb.c |   32 ++++++++++++++++++++----------
 1 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c b/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c
index df1ec3e..965698b 100644
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
@@ -24,9 +24,12 @@ static int dvb_usb_ctrl_feed(struct dvb_demux_feed *dvbdmxfeed, int onoff)
 		deb_ts("stop feeding\n");
 		usb_urb_kill(&adap->stream);
 
-		if (adap->props.streaming_ctrl != NULL)
-			if ((ret = adap->props.streaming_ctrl(adap,0)))
-				err("error while stopping stream.");
+		if (adap->props.streaming_ctrl != NULL) {
+			ret = adap->props.streaming_ctrl(adap, 0);
+			err("error while stopping stream.");
+			if (ret < 0)
+				return ret;
+		}
 	}
 
 	adap->feedcount = newfeedcount;
@@ -49,17 +52,24 @@ static int dvb_usb_ctrl_feed(struct dvb_demux_feed *dvbdmxfeed, int onoff)
 
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

