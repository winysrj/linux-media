Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40825 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab1LaMEe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Dec 2011 07:04:34 -0500
Received: by iaeh11 with SMTP id h11so26700958iae.19
        for <linux-media@vger.kernel.org>; Sat, 31 Dec 2011 04:04:33 -0800 (PST)
Date: Sat, 31 Dec 2011 06:04:25 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: David Fries <david@fries.net>
Cc: Istvan Varga <istvan_v@mailbox.hu>, linux-media@vger.kernel.org,
	Darron Broad <darron@kewl.org>,
	Steven Toth <stoth@kernellabs.com>,
	Uwe Bugla <uwe.bugla@gmx.de>
Subject: [PATCH 5/9] [media] flexcop: handle errors from dvb_net_init
Message-ID: <20111231120425.GG16802@elie.Belkin>
References: <E1RgiId-0003Qe-SC@www.linuxtv.org>
 <20111231115117.GB16802@elie.Belkin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111231115117.GB16802@elie.Belkin>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Bail out if dvb_net_init encounters an error (for example an
out-of-memory condition), now that it reports them.

Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
 drivers/media/dvb/b2c2/flexcop.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/b2c2/flexcop.c b/drivers/media/dvb/b2c2/flexcop.c
index 2df1b0214dcd..ed3f42776fee 100644
--- a/drivers/media/dvb/b2c2/flexcop.c
+++ b/drivers/media/dvb/b2c2/flexcop.c
@@ -117,11 +117,16 @@ static int flexcop_dvb_init(struct flexcop_device *fc)
 		goto err_connect_frontend;
 	}
 
-	dvb_net_init(&fc->dvb_adapter, &fc->dvbnet, &fc->demux.dmx);
+	if ((ret = dvb_net_init(&fc->dvb_adapter, &fc->dvbnet, &fc->demux.dmx)) < 0) {
+		err("dvb_net_init failed: error %d", ret);
+		goto err_net;
+	}
 
 	fc->init_state |= FC_STATE_DVB_INIT;
 	return 0;
 
+err_net:
+	fc->demux.dmx.disconnect_frontend(&fc->demux.dmx);
 err_connect_frontend:
 	fc->demux.dmx.remove_frontend(&fc->demux.dmx, &fc->mem_frontend);
 err_dmx_add_mem_frontend:
-- 
1.7.8.2+next.20111228

