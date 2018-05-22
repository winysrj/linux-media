Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway31.websitewelcome.com ([192.185.143.43]:26598 "EHLO
        gateway31.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751689AbeEVQnO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 May 2018 12:43:14 -0400
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway31.websitewelcome.com (Postfix) with ESMTP id AFF1E4F8FE9
        for <linux-media@vger.kernel.org>; Tue, 22 May 2018 11:20:05 -0500 (CDT)
Date: Tue, 22 May 2018 11:20:01 -0500
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] media: dib0700: add code comment
Message-ID: <20180522162001.GA28579@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add FIXME code comment:
/* FIXME: check if it is fe_adap[1] */

It is likely that it should be adap->fe_adap[1].fe in the second clause,
but this has never been verified.

Suggested-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/media/usb/dvb-usb/dib0700_devices.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/dvb-usb/dib0700_devices.c b/drivers/media/usb/dvb-usb/dib0700_devices.c
index c53a969..091389f 100644
--- a/drivers/media/usb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/usb/dvb-usb/dib0700_devices.c
@@ -1745,6 +1745,7 @@ static int dib809x_tuner_attach(struct dvb_usb_adapter *adap)
 		if (dvb_attach(dib0090_register, adap->fe_adap[0].fe, tun_i2c, &dib809x_dib0090_config) == NULL)
 			return -ENODEV;
 	} else {
+		/* FIXME: check if it is fe_adap[1] */
 		if (dvb_attach(dib0090_register, adap->fe_adap[0].fe, tun_i2c, &dib809x_dib0090_config) == NULL)
 			return -ENODEV;
 	}
-- 
2.7.4
