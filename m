Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-hk1lp0126.outbound.protection.outlook.com ([207.46.51.126]:36805
	"EHLO APAC01-HK1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753070AbaFHNUw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Jun 2014 09:20:52 -0400
From: James Harper <james@ejbdigital.com.au>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "m.chehab@samsung.com" <m.chehab@samsung.com>
Subject: regression in dib0700
Date: Sun, 8 Jun 2014 13:20:45 +0000
Message-ID: <05b085d5192b4c92a9d474f49b60535c@SIXPR04MB304.apcprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Somewhere along the way there's been a regression in dib0700 for my "Leadtek Winfast DTV Dongle (STK7700P based)"

One is the addition of dvb_detach(&state->dib7000p_ops);

The other is a missing .size_of_priv

The following is required to get it working again, although obviously commenting out dvb_detach isn't really correct. dvb_detach looks like it is supposed to take a function as an argument...

James

diff --git a/drivers/media/usb/dvb-usb/dib0700_devices.c b/drivers/media/usb/dvb-usb/dib0700_devices.c
index d067bb7..4c80151 100644
--- a/drivers/media/usb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/usb/dvb-usb/dib0700_devices.c
@@ -721,7 +721,7 @@ static int stk7700p_frontend_attach(struct dvb_usb_adapter *adap)
                adap->fe_adap[0].fe = state->dib7000p_ops.init(&adap->dev->i2c_adap, 18, &stk7700p_dib7000p_config);
                st->is_dib7000pc = 1;
        } else {
-               dvb_detach(&state->dib7000p_ops);
+               //dvb_detach(&state->dib7000p_ops);
                memset(&state->dib7000p_ops, 0, sizeof(state->dib7000p_ops));
                adap->fe_adap[0].fe = dvb_attach(dib7000m_attach, &adap->dev->i2c_adap, 18, &stk7700p_dib7000m_config);
        }
@@ -3788,6 +3788,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {

                                DIB0700_DEFAULT_STREAMING_CONFIG(0x02),
                        }},
+                               .size_of_priv     = sizeof(struct dib0700_adapter_state),
                        },
                },
