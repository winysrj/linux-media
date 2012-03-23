Return-path: <linux-media-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:45003 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab2CWIgI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Mar 2012 04:36:08 -0400
Date: Fri, 23 Mar 2012 11:35:33 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Krufky <mkrufky@linuxtv.org>
Cc: Steven Toth <stoth@kernellabs.com>, Antti Palosaari <crope@iki.fi>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] mxl111sf: remove an unused variable
Message-ID: <20120323083532.GB18239@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We don't use this any more after 3be5bb71fb "[media] mxl111sf: fix error
on stream stop in mxl111sf_ep6_streaming_ctrl()" and it makes GCC
complain.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/dvb/dvb-usb/mxl111sf.c b/drivers/media/dvb/dvb-usb/mxl111sf.c
index 81305de..91834c5 100644
--- a/drivers/media/dvb/dvb-usb/mxl111sf.c
+++ b/drivers/media/dvb/dvb-usb/mxl111sf.c
@@ -340,7 +340,6 @@ static int mxl111sf_ep6_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 	struct mxl111sf_state *state = d->priv;
 	struct mxl111sf_adap_state *adap_state = adap->fe_adap[adap->active_fe].priv;
 	int ret = 0;
-	u8 tmp;
 
 	deb_info("%s(%d)\n", __func__, onoff);
 
