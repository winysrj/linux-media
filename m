Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44076 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab1LaMGq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Dec 2011 07:06:46 -0500
Received: by iaeh11 with SMTP id h11so26703238iae.19
        for <linux-media@vger.kernel.org>; Sat, 31 Dec 2011 04:06:45 -0800 (PST)
Date: Sat, 31 Dec 2011 06:06:37 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: David Fries <david@fries.net>
Cc: Istvan Varga <istvan_v@mailbox.hu>, linux-media@vger.kernel.org,
	Darron Broad <darron@kewl.org>,
	Steven Toth <stoth@kernellabs.com>, Janne Grunau <j@jannau.net>
Subject: [PATCH 6/9] [media] dvb-bt8xx: handle errors from dvb_net_init
Message-ID: <20111231120637.GH16802@elie.Belkin>
References: <E1RgiId-0003Qe-SC@www.linuxtv.org>
 <20111231115117.GB16802@elie.Belkin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111231115117.GB16802@elie.Belkin>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Clean up and error out if dvb_net_init fails (for example when
running out of memory).

>From an audit of dvb_net_init callers, now that dvb_net_init
has learned to return a nonzero value from time to time.

Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
 drivers/media/dvb/bt8xx/dvb-bt8xx.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/bt8xx/dvb-bt8xx.c b/drivers/media/dvb/bt8xx/dvb-bt8xx.c
index 6aa3b486e865..94e01b47784f 100644
--- a/drivers/media/dvb/bt8xx/dvb-bt8xx.c
+++ b/drivers/media/dvb/bt8xx/dvb-bt8xx.c
@@ -779,7 +779,11 @@ static int __devinit dvb_bt8xx_load_card(struct dvb_bt8xx_card *card, u32 type)
 		goto err_remove_mem_frontend;
 	}
 
-	dvb_net_init(&card->dvb_adapter, &card->dvbnet, &card->demux.dmx);
+	result = dvb_net_init(&card->dvb_adapter, &card->dvbnet, &card->demux.dmx);
+	if (result < 0) {
+		printk("dvb_bt8xx: dvb_net_init failed (errno = %d)\n", result);
+		goto err_disconnect_frontend;
+	}
 
 	tasklet_init(&card->bt->tasklet, dvb_bt8xx_task, (unsigned long) card);
 
@@ -787,6 +791,8 @@ static int __devinit dvb_bt8xx_load_card(struct dvb_bt8xx_card *card, u32 type)
 
 	return 0;
 
+err_disconnect_frontend:
+	card->demux.dmx.disconnect_frontend(&card->demux.dmx);
 err_remove_mem_frontend:
 	card->demux.dmx.remove_frontend(&card->demux.dmx, &card->fe_mem);
 err_remove_hw_frontend:
-- 
1.7.8.2+next.20111228

