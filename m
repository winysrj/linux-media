Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:49409 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751611AbdIRIOt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Sep 2017 04:14:49 -0400
Subject: [PATCH 2/2] [media] dvb_usb_core: Improve a size determination in two
 functions
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <38627457-f64f-7356-bf5e-fc41296a26e4@users.sourceforge.net>
Message-ID: <204db820-7fd1-579e-442d-ff2b983148f9@users.sourceforge.net>
Date: Mon, 18 Sep 2017 10:14:37 +0200
MIME-Version: 1.0
In-Reply-To: <38627457-f64f-7356-bf5e-fc41296a26e4@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 18 Sep 2017 09:36:33 +0200

Replace the specification of data structures by variable references
as the parameter for the operator "sizeof" to make the corresponding size
determination a bit safer according to the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
index d0fbf0b0b1cb..f0b225ee4515 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
@@ -279,5 +279,5 @@ static int dvb_usb_start_feed(struct dvb_demux_feed *dvbdmxfeed)
 	if (d->props->get_stream_config) {
 		memcpy(&stream_props, &adap->props->stream,
-				sizeof(struct usb_data_stream_properties));
+		       sizeof(stream_props));
 		ret = d->props->get_stream_config(adap->fe[adap->active_fe],
 				&adap->ts_type, &stream_props);
@@ -919,5 +919,5 @@ int dvb_usbv2_probe(struct usb_interface *intf,
 		goto err;
 	}
 
-	d = kzalloc(sizeof(struct dvb_usb_device), GFP_KERNEL);
+	d = kzalloc(sizeof(*d), GFP_KERNEL);
 	if (!d) {
-- 
2.14.1
