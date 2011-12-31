Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44697 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385Ab1LaL6m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Dec 2011 06:58:42 -0500
Received: by iaeh11 with SMTP id h11so26694924iae.19
        for <linux-media@vger.kernel.org>; Sat, 31 Dec 2011 03:58:42 -0800 (PST)
Date: Sat, 31 Dec 2011 05:58:34 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: David Fries <david@fries.net>
Cc: Istvan Varga <istvan_v@mailbox.hu>, linux-media@vger.kernel.org,
	Darron Broad <darron@kewl.org>,
	Steven Toth <stoth@kernellabs.com>,
	Johannes Stezenbach <js@sig21.net>
Subject: [PATCH 3/9] [media] dvb-bt8xx: use goto based exception handling
Message-ID: <20111231115834.GE16802@elie.Belkin>
References: <E1RgiId-0003Qe-SC@www.linuxtv.org>
 <20111231115117.GB16802@elie.Belkin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111231115117.GB16802@elie.Belkin>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Repeating the same cleanup code in each error handling path makes life
unnecessarily difficult for reviewers, who much check each instance of
the same copy+pasted code separately.  A "goto" to the end of the
function is more maintainable and conveys the intent more clearly.

While we're touching this code, also lift some assignments from "if"
conditionals for simplicity.

No functional change intended.

Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
 drivers/media/dvb/bt8xx/dvb-bt8xx.c |   57 ++++++++++++++++------------------
 1 files changed, 27 insertions(+), 30 deletions(-)

diff --git a/drivers/media/dvb/bt8xx/dvb-bt8xx.c b/drivers/media/dvb/bt8xx/dvb-bt8xx.c
index 521d69104982..6aa3b486e865 100644
--- a/drivers/media/dvb/bt8xx/dvb-bt8xx.c
+++ b/drivers/media/dvb/bt8xx/dvb-bt8xx.c
@@ -741,57 +741,42 @@ static int __devinit dvb_bt8xx_load_card(struct dvb_bt8xx_card *card, u32 type)
 	card->demux.stop_feed = dvb_bt8xx_stop_feed;
 	card->demux.write_to_decoder = NULL;
 
-	if ((result = dvb_dmx_init(&card->demux)) < 0) {
+	result = dvb_dmx_init(&card->demux);
+	if (result < 0) {
 		printk("dvb_bt8xx: dvb_dmx_init failed (errno = %d)\n", result);
-
-		dvb_unregister_adapter(&card->dvb_adapter);
-		return result;
+		goto err_unregister_adaptor;
 	}
 
 	card->dmxdev.filternum = 256;
 	card->dmxdev.demux = &card->demux.dmx;
 	card->dmxdev.capabilities = 0;
 
-	if ((result = dvb_dmxdev_init(&card->dmxdev, &card->dvb_adapter)) < 0) {
+	result = dvb_dmxdev_init(&card->dmxdev, &card->dvb_adapter);
+	if (result < 0) {
 		printk("dvb_bt8xx: dvb_dmxdev_init failed (errno = %d)\n", result);
-
-		dvb_dmx_release(&card->demux);
-		dvb_unregister_adapter(&card->dvb_adapter);
-		return result;
+		goto err_dmx_release;
 	}
 
 	card->fe_hw.source = DMX_FRONTEND_0;
 
-	if ((result = card->demux.dmx.add_frontend(&card->demux.dmx, &card->fe_hw)) < 0) {
+	result = card->demux.dmx.add_frontend(&card->demux.dmx, &card->fe_hw);
+	if (result < 0) {
 		printk("dvb_bt8xx: dvb_dmx_init failed (errno = %d)\n", result);
-
-		dvb_dmxdev_release(&card->dmxdev);
-		dvb_dmx_release(&card->demux);
-		dvb_unregister_adapter(&card->dvb_adapter);
-		return result;
+		goto err_dmxdev_release;
 	}
 
 	card->fe_mem.source = DMX_MEMORY_FE;
 
-	if ((result = card->demux.dmx.add_frontend(&card->demux.dmx, &card->fe_mem)) < 0) {
+	result = card->demux.dmx.add_frontend(&card->demux.dmx, &card->fe_mem);
+	if (result < 0) {
 		printk("dvb_bt8xx: dvb_dmx_init failed (errno = %d)\n", result);
-
-		card->demux.dmx.remove_frontend(&card->demux.dmx, &card->fe_hw);
-		dvb_dmxdev_release(&card->dmxdev);
-		dvb_dmx_release(&card->demux);
-		dvb_unregister_adapter(&card->dvb_adapter);
-		return result;
+		goto err_remove_hw_frontend;
 	}
 
-	if ((result = card->demux.dmx.connect_frontend(&card->demux.dmx, &card->fe_hw)) < 0) {
+	result = card->demux.dmx.connect_frontend(&card->demux.dmx, &card->fe_hw);
+	if (result < 0) {
 		printk("dvb_bt8xx: dvb_dmx_init failed (errno = %d)\n", result);
-
-		card->demux.dmx.remove_frontend(&card->demux.dmx, &card->fe_mem);
-		card->demux.dmx.remove_frontend(&card->demux.dmx, &card->fe_hw);
-		dvb_dmxdev_release(&card->dmxdev);
-		dvb_dmx_release(&card->demux);
-		dvb_unregister_adapter(&card->dvb_adapter);
-		return result;
+		goto err_remove_mem_frontend;
 	}
 
 	dvb_net_init(&card->dvb_adapter, &card->dvbnet, &card->demux.dmx);
@@ -801,6 +786,18 @@ static int __devinit dvb_bt8xx_load_card(struct dvb_bt8xx_card *card, u32 type)
 	frontend_init(card, type);
 
 	return 0;
+
+err_remove_mem_frontend:
+	card->demux.dmx.remove_frontend(&card->demux.dmx, &card->fe_mem);
+err_remove_hw_frontend:
+	card->demux.dmx.remove_frontend(&card->demux.dmx, &card->fe_hw);
+err_dmxdev_release:
+	dvb_dmxdev_release(&card->dmxdev);
+err_dmx_release:
+	dvb_dmx_release(&card->demux);
+err_unregister_adaptor:
+	dvb_unregister_adapter(&card->dvb_adapter);
+	return result;
 }
 
 static int __devinit dvb_bt8xx_probe(struct bttv_sub_device *sub)
-- 
1.7.8.2+next.20111228

