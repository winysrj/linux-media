Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.bendigoit.com.au ([203.16.224.4]:56025 "EHLO
	smtp1.bendigoit.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102AbaFIAnL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Jun 2014 20:43:11 -0400
From: James Harper <james.harper@ejbdigital.com.au>
To: james.harper@ejbdigital.com.au
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] Fix regression in some dib0700 based devices.
Date: Mon,  9 Jun 2014 10:24:20 +1000
Message-Id: <1402273460-10509-1-git-send-email-james.harper@ejbdigital.com.au>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix regression in some dib0700 based devices.
Set size_of_priv, and don't call dvb_detach unnecessarily.
This resolves the oops(s) for my "Leadtek Winfast DTV Dongle (STK7700P based)"

Signed-off-by: James Harper <james.harper@ejbdigital.com.au>
---
 drivers/media/usb/dvb-usb/dib0700_devices.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb/dib0700_devices.c b/drivers/media/usb/dvb-usb/dib0700_devices.c
index d067bb7..25355fa 100644
--- a/drivers/media/usb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/usb/dvb-usb/dib0700_devices.c
@@ -721,7 +721,6 @@ static int stk7700p_frontend_attach(struct dvb_usb_adapter *adap)
 		adap->fe_adap[0].fe = state->dib7000p_ops.init(&adap->dev->i2c_adap, 18, &stk7700p_dib7000p_config);
 		st->is_dib7000pc = 1;
 	} else {
-		dvb_detach(&state->dib7000p_ops);
 		memset(&state->dib7000p_ops, 0, sizeof(state->dib7000p_ops));
 		adap->fe_adap[0].fe = dvb_attach(dib7000m_attach, &adap->dev->i2c_adap, 18, &stk7700p_dib7000m_config);
 	}
@@ -3788,6 +3787,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 
 				DIB0700_DEFAULT_STREAMING_CONFIG(0x02),
 			}},
+				.size_of_priv     = sizeof(struct dib0700_adapter_state),
 			},
 		},
 
-- 
2.0.0

