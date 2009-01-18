Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:11524 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934292AbZARSWQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Jan 2009 13:22:16 -0500
Received: by fg-out-1718.google.com with SMTP id 19so1160813fgg.17
        for <linux-media@vger.kernel.org>; Sun, 18 Jan 2009 10:22:14 -0800 (PST)
Date: Sun, 18 Jan 2009 19:22:30 +0100
From: Luca Tettamanti <kronos.it@gmail.com>
To: linux-media@vger.kernel.org
Cc: Manu Abraham <manu@linuxtv.org>
Subject: [PATCH] saa716x: fix uninitialized splinlocks
Message-ID: <20090118182230.GA19441@dreamland.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix uninitialized spinlocks.

Signed-off-by: Luca Tettamanti <kronos.it@gmail.com>
---
 linux/drivers/media/dvb/dvb-core/dmxdev.c        |    1 +
 linux/drivers/media/dvb/saa716x/saa716x_hybrid.c |    1 +
 2 files changed, 2 insertions(+)

Index: b/linux/drivers/media/dvb/dvb-core/dmxdev.c
===================================================================
--- a/linux/drivers/media/dvb/dvb-core/dmxdev.c	2009-01-18 19:15:52.630015822 +0100
+++ b/linux/drivers/media/dvb/dvb-core/dmxdev.c	2009-01-18 19:16:17.182016807 +0100
@@ -1087,6 +1087,7 @@
 	for (i = 0; i < dmxdev->filternum; i++) {
 		dmxdev->filter[i].dev = dmxdev;
 		dmxdev->filter[i].buffer.data = NULL;
+		spin_lock_init(&dmxdev->filter[i].buffer.lock);
 		dvb_dmxdev_filter_state_set(&dmxdev->filter[i],
 					    DMXDEV_STATE_FREE);
 	}
Index: b/linux/drivers/media/dvb/saa716x/saa716x_hybrid.c
===================================================================
--- a/linux/drivers/media/dvb/saa716x/saa716x_hybrid.c	2009-01-18 19:15:52.590024681 +0100
+++ b/linux/drivers/media/dvb/saa716x/saa716x_hybrid.c	2009-01-18 19:16:17.182016807 +0100
@@ -49,6 +49,7 @@
 		goto fail0;
 	}
 
+	spin_lock_init(&saa716x->gpio_lock);
 	saa716x->verbose	= verbose;
 	saa716x->int_type	= int_type;
 	saa716x->pdev		= pdev;

Luca
-- 
Regole per la felicità:
1. Sii soddisfatto di quello che hai.
2. Assicurati di avere tutto.
