Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59256 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887Ab1LaMLF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Dec 2011 07:11:05 -0500
Received: by iaeh11 with SMTP id h11so26708103iae.19
        for <linux-media@vger.kernel.org>; Sat, 31 Dec 2011 04:11:05 -0800 (PST)
Date: Sat, 31 Dec 2011 06:10:57 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: David Fries <david@fries.net>
Cc: Istvan Varga <istvan_v@mailbox.hu>, linux-media@vger.kernel.org,
	Darron Broad <darron@kewl.org>,
	Steven Toth <stoth@kernellabs.com>, Janne Grunau <j@jannau.net>
Subject: [PATCH 8/9] [media] dvb-usb: handle errors from dvb_net_init
Message-ID: <20111231121057.GJ16802@elie.Belkin>
References: <E1RgiId-0003Qe-SC@www.linuxtv.org>
 <20111231115117.GB16802@elie.Belkin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111231115117.GB16802@elie.Belkin>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From an audit of dvb_net_init callers, now that that function
returns -errno on error.

Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
 drivers/media/dvb/dvb-usb/dvb-usb-dvb.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c b/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c
index ba4a7517354f..ddf282f355b3 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c
@@ -141,11 +141,17 @@ int dvb_usb_adapter_dvb_init(struct dvb_usb_adapter *adap, short *adapter_nums)
 		goto err_dmx_dev;
 	}
 
-	dvb_net_init(&adap->dvb_adap, &adap->dvb_net, &adap->demux.dmx);
+	if ((ret = dvb_net_init(&adap->dvb_adap, &adap->dvb_net,
+						&adap->demux.dmx)) < 0) {
+		err("dvb_net_init failed: error %d",ret);
+		goto err_net_init;
+	}
 
 	adap->state |= DVB_USB_ADAP_STATE_DVB;
 	return 0;
 
+err_net_init:
+	dvb_dmxdev_release(&adap->dmxdev);
 err_dmx_dev:
 	dvb_dmx_release(&adap->demux);
 err_dmx:
-- 
1.7.8.2+next.20111228

