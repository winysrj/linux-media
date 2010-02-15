Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:56577 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755838Ab0BORiU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2010 12:38:20 -0500
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, dheitmueller@kernellabs.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 06/11] tm6000: reset the numbers of feeds to 8
Date: Mon, 15 Feb 2010 18:37:19 +0100
Message-Id: <1266255444-7422-6-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1266255444-7422-5-git-send-email-stefan.ringel@arcor.de>
References: <1266255444-7422-1-git-send-email-stefan.ringel@arcor.de>
 <1266255444-7422-2-git-send-email-stefan.ringel@arcor.de>
 <1266255444-7422-3-git-send-email-stefan.ringel@arcor.de>
 <1266255444-7422-4-git-send-email-stefan.ringel@arcor.de>
 <1266255444-7422-5-git-send-email-stefan.ringel@arcor.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <stefan.ringel@arcor.de>

Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>

diff --git a/drivers/staging/tm6000/tm6000-dvb.c b/drivers/staging/tm6000/tm6000-dvb.c
index e16d55e..12a0758 100644
--- a/drivers/staging/tm6000/tm6000-dvb.c
+++ b/drivers/staging/tm6000/tm6000-dvb.c
@@ -285,8 +285,8 @@ int tm6000_dvb_register(struct tm6000_core *dev)
 	dvb->demux.dmx.capabilities = DMX_TS_FILTERING | DMX_SECTION_FILTERING
 							    | DMX_MEMORY_BASED_FILTERING;
 	dvb->demux.priv = dev;
-	dvb->demux.filternum = 5; /* 256; */
-	dvb->demux.feednum = 5; /* 256; */
+	dvb->demux.filternum = 8;
+	dvb->demux.feednum = 8;
 	dvb->demux.start_feed = tm6000_start_feed;
 	dvb->demux.stop_feed = tm6000_stop_feed;
 	dvb->demux.write_to_decoder = NULL;
-- 
1.6.6.1

