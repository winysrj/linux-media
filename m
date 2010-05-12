Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42251 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755647Ab0ELWaD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 May 2010 18:30:03 -0400
Received: from int-mx08.intmail.prod.int.phx2.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o4CMU3ww025422
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 12 May 2010 18:30:03 -0400
Date: Wed, 12 May 2010 18:30:02 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-media@vger.kernel.org, mchehab@infradead.org
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20100512222723.21740.15729.sendpatchset@prarit.bos.redhat.com>
Subject: [PATCH] Add notification to cxusb_dualdig4_rev2_frontend_attach() error handling
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a notification to the dib7000p_i2c_enumeration() failure path in
cxusb_dualdig4_rev2_frontend_attach().

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

diff --git a/drivers/media/dvb/dvb-usb/cxusb.c b/drivers/media/dvb/dvb-usb/cxusb.c
index 320ce88..8965601 100644
--- a/drivers/media/dvb/dvb-usb/cxusb.c
+++ b/drivers/media/dvb/dvb-usb/cxusb.c
@@ -1025,8 +1025,10 @@ static int cxusb_dualdig4_rev2_frontend_attach(struct dvb_usb_adapter *adap)
 	cxusb_bluebird_gpio_pulse(adap->dev, 0x02, 1);
 
 	if (dib7000p_i2c_enumeration(&adap->dev->i2c_adap, 1, 18,
-				 &cxusb_dualdig4_rev2_config) < 0)
+				     &cxusb_dualdig4_rev2_config) < 0) {
+		printk(KERN_WARNING "Unable to enumerate dib7000p\n");
 		return -ENODEV;
+	}
 
 	adap->fe = dvb_attach(dib7000p_attach, &adap->dev->i2c_adap, 0x80,
 			      &cxusb_dualdig4_rev2_config);
