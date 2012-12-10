Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp209.alice.it ([82.57.200.105]:39854 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635Ab2LJVhn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Dec 2012 16:37:43 -0500
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCHv2 1/9] [media] dvb-usb: fix indentation of a for loop
Date: Mon, 10 Dec 2012 22:37:09 +0100
Message-Id: <1355175437-21623-2-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1355175437-21623-1-git-send-email-ospite@studenti.unina.it>
References: <1352158096-17737-1-git-send-email-ospite@studenti.unina.it>
 <1355175437-21623-1-git-send-email-ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---
 drivers/media/usb/dvb-usb/dvb-usb-init.c |   60 +++++++++++++++---------------
 1 file changed, 30 insertions(+), 30 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/dvb-usb-init.c b/drivers/media/usb/dvb-usb/dvb-usb-init.c
index 169196e..1adf325 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-init.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-init.c
@@ -38,41 +38,41 @@ static int dvb_usb_adapter_init(struct dvb_usb_device *d, short *adapter_nrs)
 
 		memcpy(&adap->props, &d->props.adapter[n], sizeof(struct dvb_usb_adapter_properties));
 
-	for (o = 0; o < adap->props.num_frontends; o++) {
-		struct dvb_usb_adapter_fe_properties *props = &adap->props.fe[o];
-		/* speed - when running at FULL speed we need a HW PID filter */
-		if (d->udev->speed == USB_SPEED_FULL && !(props->caps & DVB_USB_ADAP_HAS_PID_FILTER)) {
-			err("This USB2.0 device cannot be run on a USB1.1 port. (it lacks a hardware PID filter)");
-			return -ENODEV;
-		}
+		for (o = 0; o < adap->props.num_frontends; o++) {
+			struct dvb_usb_adapter_fe_properties *props = &adap->props.fe[o];
+			/* speed - when running at FULL speed we need a HW PID filter */
+			if (d->udev->speed == USB_SPEED_FULL && !(props->caps & DVB_USB_ADAP_HAS_PID_FILTER)) {
+				err("This USB2.0 device cannot be run on a USB1.1 port. (it lacks a hardware PID filter)");
+				return -ENODEV;
+			}
 
-		if ((d->udev->speed == USB_SPEED_FULL && props->caps & DVB_USB_ADAP_HAS_PID_FILTER) ||
-			(props->caps & DVB_USB_ADAP_NEED_PID_FILTERING)) {
-			info("will use the device's hardware PID filter (table count: %d).", props->pid_filter_count);
-			adap->fe_adap[o].pid_filtering  = 1;
-			adap->fe_adap[o].max_feed_count = props->pid_filter_count;
-		} else {
-			info("will pass the complete MPEG2 transport stream to the software demuxer.");
-			adap->fe_adap[o].pid_filtering  = 0;
-			adap->fe_adap[o].max_feed_count = 255;
-		}
+			if ((d->udev->speed == USB_SPEED_FULL && props->caps & DVB_USB_ADAP_HAS_PID_FILTER) ||
+				(props->caps & DVB_USB_ADAP_NEED_PID_FILTERING)) {
+				info("will use the device's hardware PID filter (table count: %d).", props->pid_filter_count);
+				adap->fe_adap[o].pid_filtering  = 1;
+				adap->fe_adap[o].max_feed_count = props->pid_filter_count;
+			} else {
+				info("will pass the complete MPEG2 transport stream to the software demuxer.");
+				adap->fe_adap[o].pid_filtering  = 0;
+				adap->fe_adap[o].max_feed_count = 255;
+			}
 
-		if (!adap->fe_adap[o].pid_filtering &&
-			dvb_usb_force_pid_filter_usage &&
-			props->caps & DVB_USB_ADAP_HAS_PID_FILTER) {
-			info("pid filter enabled by module option.");
-			adap->fe_adap[o].pid_filtering  = 1;
-			adap->fe_adap[o].max_feed_count = props->pid_filter_count;
-		}
+			if (!adap->fe_adap[o].pid_filtering &&
+				dvb_usb_force_pid_filter_usage &&
+				props->caps & DVB_USB_ADAP_HAS_PID_FILTER) {
+				info("pid filter enabled by module option.");
+				adap->fe_adap[o].pid_filtering  = 1;
+				adap->fe_adap[o].max_feed_count = props->pid_filter_count;
+			}
 
-		if (props->size_of_priv > 0) {
-			adap->fe_adap[o].priv = kzalloc(props->size_of_priv, GFP_KERNEL);
-			if (adap->fe_adap[o].priv == NULL) {
-				err("no memory for priv for adapter %d fe %d.", n, o);
-				return -ENOMEM;
+			if (props->size_of_priv > 0) {
+				adap->fe_adap[o].priv = kzalloc(props->size_of_priv, GFP_KERNEL);
+				if (adap->fe_adap[o].priv == NULL) {
+					err("no memory for priv for adapter %d fe %d.", n, o);
+					return -ENOMEM;
+				}
 			}
 		}
-	}
 
 		if (adap->props.size_of_priv > 0) {
 			adap->priv = kzalloc(adap->props.size_of_priv, GFP_KERNEL);
-- 
1.7.10.4

