Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49513 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385Ab1LaMCF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Dec 2011 07:02:05 -0500
Received: by iaeh11 with SMTP id h11so26698316iae.19
        for <linux-media@vger.kernel.org>; Sat, 31 Dec 2011 04:02:04 -0800 (PST)
Date: Sat, 31 Dec 2011 06:01:56 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: David Fries <david@fries.net>
Cc: Istvan Varga <istvan_v@mailbox.hu>, linux-media@vger.kernel.org,
	Darron Broad <darron@kewl.org>,
	Steven Toth <stoth@kernellabs.com>, Janne Grunau <j@jannau.net>
Subject: [PATCH 4/9] [media] ttusb-budget: use goto for exception handling
Message-ID: <20111231120156.GF16802@elie.Belkin>
References: <E1RgiId-0003Qe-SC@www.linuxtv.org>
 <20111231115117.GB16802@elie.Belkin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111231115117.GB16802@elie.Belkin>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Avoid some repetition by adopting the usual "goto err" idiom for error
handling.

Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
 drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c |   40 +++++++++++---------
 1 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c b/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c
index 420bb42d5233..b0f90b7f0eb1 100644
--- a/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c
+++ b/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c
@@ -1694,10 +1694,8 @@ static int ttusb_probe(struct usb_interface *intf, const struct usb_device_id *i
 	ttusb->i2c_adap.dev.parent	  = &udev->dev;
 
 	result = i2c_add_adapter(&ttusb->i2c_adap);
-	if (result) {
-		dvb_unregister_adapter (&ttusb->adapter);
-		return result;
-	}
+	if (result)
+		goto err_unregister_adapter;
 
 	memset(&ttusb->dvb_demux, 0, sizeof(ttusb->dvb_demux));
 
@@ -1714,33 +1712,29 @@ static int ttusb_probe(struct usb_interface *intf, const struct usb_device_id *i
 	ttusb->dvb_demux.stop_feed = ttusb_stop_feed;
 	ttusb->dvb_demux.write_to_decoder = NULL;
 
-	if ((result = dvb_dmx_init(&ttusb->dvb_demux)) < 0) {
+	result = dvb_dmx_init(&ttusb->dvb_demux);
+	if (result < 0) {
 		printk("ttusb_dvb: dvb_dmx_init failed (errno = %d)\n", result);
-		i2c_del_adapter(&ttusb->i2c_adap);
-		dvb_unregister_adapter (&ttusb->adapter);
-		return -ENODEV;
+		result = -ENODEV;
+		goto err_i2c_del_adapter;
 	}
 //FIXME dmxdev (nur WAS?)
 	ttusb->dmxdev.filternum = ttusb->dvb_demux.filternum;
 	ttusb->dmxdev.demux = &ttusb->dvb_demux.dmx;
 	ttusb->dmxdev.capabilities = 0;
 
-	if ((result = dvb_dmxdev_init(&ttusb->dmxdev, &ttusb->adapter)) < 0) {
+	result = dvb_dmxdev_init(&ttusb->dmxdev, &ttusb->adapter);
+	if (result < 0) {
 		printk("ttusb_dvb: dvb_dmxdev_init failed (errno = %d)\n",
 		       result);
-		dvb_dmx_release(&ttusb->dvb_demux);
-		i2c_del_adapter(&ttusb->i2c_adap);
-		dvb_unregister_adapter (&ttusb->adapter);
-		return -ENODEV;
+		result = -ENODEV;
+		goto err_release_dmx;
 	}
 
 	if (dvb_net_init(&ttusb->adapter, &ttusb->dvbnet, &ttusb->dvb_demux.dmx)) {
 		printk("ttusb_dvb: dvb_net_init failed!\n");
-		dvb_dmxdev_release(&ttusb->dmxdev);
-		dvb_dmx_release(&ttusb->dvb_demux);
-		i2c_del_adapter(&ttusb->i2c_adap);
-		dvb_unregister_adapter (&ttusb->adapter);
-		return -ENODEV;
+		result = -ENODEV;
+		goto err_release_dmxdev;
 	}
 
 	usb_set_intfdata(intf, (void *) ttusb);
@@ -1748,6 +1742,16 @@ static int ttusb_probe(struct usb_interface *intf, const struct usb_device_id *i
 	frontend_init(ttusb);
 
 	return 0;
+
+err_release_dmxdev:
+	dvb_dmxdev_release(&ttusb->dmxdev);
+err_release_dmx:
+	dvb_dmx_release(&ttusb->dvb_demux);
+err_i2c_del_adapter:
+	i2c_del_adapter(&ttusb->i2c_adap);
+err_unregister_adapter:
+	dvb_unregister_adapter (&ttusb->adapter);
+	return result;
 }
 
 static void ttusb_disconnect(struct usb_interface *intf)
-- 
1.7.8.2+next.20111228

