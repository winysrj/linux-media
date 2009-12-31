Return-path: <linux-media-owner@vger.kernel.org>
Received: from cp-out10.libero.it ([212.52.84.110]:49398 "EHLO
	cp-out10.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbZLaLqW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Dec 2009 06:46:22 -0500
Received: from [151.83.159.146] (151.83.159.146) by cp-out10.libero.it (8.5.107)
        id 4B326F6900836642 for linux-media@vger.kernel.org; Thu, 31 Dec 2009 12:46:21 +0100
Subject: [PATCH] em28xx-dvb: fix memleak in dvb_fini()
From: Francesco Lavra <francescolavra@interfree.it>
To: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Thu, 31 Dec 2009 12:47:11 +0100
Message-Id: <1262260031.4401.9.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
this patch fixes a memory leak which occurs when an em28xx card with DVB
extension is unplugged or its DVB extension driver is unloaded. In
dvb_fini(), dev->dvb must be freed before being set to NULL, as is done
in dvb_init() in case of error.
Note that this bug is also present in the latest stable kernel release.
Regards,
Francesco

Signed-off-by: Francesco Lavra <francescolavra@interfree.it>

--- a/linux/drivers/media/video/em28xx/em28xx-dvb.c	2009-12-31 12:23:53.000000000 +0100
+++ b/linux/drivers/media/video/em28xx/em28xx-dvb.c	2009-12-31 12:23:56.000000000 +0100
@@ -607,6 +607,7 @@ static int dvb_fini(struct em28xx *dev)
 
 	if (dev->dvb) {
 		unregister_dvb(dev->dvb);
+		kfree(dev->dvb);
 		dev->dvb = NULL;
 	}
 


