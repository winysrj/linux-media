Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:56805 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbaJLLbl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Oct 2014 07:31:41 -0400
Received: by mail-lb0-f182.google.com with SMTP id z11so5047733lbi.41
        for <linux-media@vger.kernel.org>; Sun, 12 Oct 2014 04:31:40 -0700 (PDT)
Date: Sun, 12 Oct 2014 14:31:38 +0300 (EEST)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
cc: crope@iki.fi
Subject: [PATCHv2 4/4] dvbsky: add option to disable IR receiver
In-Reply-To: <543A5D7B.8020401@iki.fi>
Message-ID: <alpine.DEB.2.10.1410121427480.6205@olli-desktop>
References: <1413108191-32510-1-git-send-email-olli.salonen@iki.fi> <1413108191-32510-4-git-send-email-olli.salonen@iki.fi> <543A540A.2010507@iki.fi> <543A5D7B.8020401@iki.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add an option to disable remote controller for DVBSky devices by specifying the disable_rc option at modprobe.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>

---

diff --git a/drivers/media/usb/dvb-usb-v2/dvbsky.c b/drivers/media/usb/dvb-usb-v2/dvbsky.c
index 5c7387a..f2d0eb7 100644
--- a/drivers/media/usb/dvb-usb-v2/dvbsky.c
+++ b/drivers/media/usb/dvb-usb-v2/dvbsky.c
@@ -25,6 +25,10 @@
 #define DVBSKY_MSG_DELAY	0/*2000*/
 #define DVBSKY_BUF_LEN	64
 
+static int dvb_usb_dvbsky_disable_rc;
+module_param_named(disable_rc, dvb_usb_dvbsky_disable_rc, int, 0644);
+MODULE_PARM_DESC(disable_rc, "Disable inbuilt IR receiver.");
+
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 struct dvbsky_state {
@@ -218,6 +222,11 @@ static int dvbsky_rc_query(struct dvb_usb_device *d)
 
 static int dvbsky_get_rc_config(struct dvb_usb_device *d, struct dvb_usb_rc *rc)
 {
+	if (dvb_usb_dvbsky_disable_rc) {
+		rc->map_name = NULL;
+		return 0;
+	}
+
 	rc->allowed_protos = RC_BIT_RC5;
 	rc->query          = dvbsky_rc_query;
 	rc->interval       = 300;

