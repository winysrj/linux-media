Return-path: <linux-media-owner@vger.kernel.org>
Received: from cp-out8.libero.it ([212.52.84.108]:49497 "EHLO
	cp-out8.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab0BMLA5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Feb 2010 06:00:57 -0500
Received: from [151.82.20.20] (151.82.20.20) by cp-out8.libero.it (8.5.107)
        id 4B5E3F4101722DEE for linux-media@vger.kernel.org; Sat, 13 Feb 2010 12:00:55 +0100
Subject: [PATCH] em28xx-dvb: fix memleak in dvb_fini()
From: Francesco Lavra <francescolavra@interfree.it>
To: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Sat, 13 Feb 2010 12:02:45 +0100
Message-Id: <1266058965.3974.23.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes a memory leak which occurs when an em28xx card with DVB
extension is unplugged or its DVB extension driver is unloaded. In
dvb_fini(), dev->dvb must be freed before being set to NULL, as is done
in dvb_init() in case of error.

Signed-off-by: Francesco Lavra <francescolavra@interfree.it>
Cc: stable <stable@kernel.org>

---

NOTE: this patch has already reached linux-next, but has not been
requested to be pulled for 2.6.33, as it should.

--- a/drivers/media/video/em28xx/em28xx-dvb.c	2009-12-31 12:23:53.000000000 +0100
+++ b/drivers/media/video/em28xx/em28xx-dvb.c	2009-12-31 12:23:56.000000000 +0100
@@ -606,6 +606,7 @@ static int dvb_fini(struct em28xx *dev)

 	if (dev->dvb) {
 		unregister_dvb(dev->dvb);
+		kfree(dev->dvb);
 		dev->dvb = NULL;
 	}
 


