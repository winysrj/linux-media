Return-path: <mchehab@pedra>
Received: from cmsout02.mbox.net ([165.212.64.32]:55527 "EHLO
	cmsout02.mbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940Ab1DEVvZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Apr 2011 17:51:25 -0400
Received: from cmsout02.mbox.net (co02-lo [127.0.0.1])
	by cmsout02.mbox.net (Postfix) with ESMTP id 5D09F134502
	for <linux-media@vger.kernel.org>; Tue,  5 Apr 2011 21:51:25 +0000 (GMT)
Message-ID: <4D9B8EC2.1030303@usa.net>
Date: Tue, 05 Apr 2011 23:50:58 +0200
From: Issa Gorissen <flop.m@usa.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [PATCH] Ngene cam device name
References: <777PcLohh6368S03.1299940473@web03.cms.usa.net> <4D7B8A07.70602@linuxtv.org> <19855.55774.192407.326483@morden.metzler> <201103290057.03664@orion.escape-edv.de>
In-Reply-To: <201103290057.03664@orion.escape-edv.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello all,

Here is the patch for the NGene card family and the new caio device

Signed-off-by: Issa Gorissen <flop.m@usa.net>
---
 drivers/media/dvb/dvb-core/dvbdev.c  |    2 +-
 drivers/media/dvb/dvb-core/dvbdev.h  |    1 +
 drivers/media/dvb/ngene/ngene-core.c |    2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvbdev.c b/drivers/media/dvb/dvb-core/dvbdev.c
index f732877..7a64b81 100644
--- a/drivers/media/dvb/dvb-core/dvbdev.c
+++ b/drivers/media/dvb/dvb-core/dvbdev.c
@@ -47,7 +47,7 @@ static DEFINE_MUTEX(dvbdev_register_lock);
 
 static const char * const dnames[] = {
 	"video", "audio", "sec", "frontend", "demux", "dvr", "ca",
-	"net", "osd"
+	"net", "osd", "caio"
 };
 
 #ifdef CONFIG_DVB_DYNAMIC_MINORS
diff --git a/drivers/media/dvb/dvb-core/dvbdev.h b/drivers/media/dvb/dvb-core/dvbdev.h
index fcc6ae9..c63c70d 100644
--- a/drivers/media/dvb/dvb-core/dvbdev.h
+++ b/drivers/media/dvb/dvb-core/dvbdev.h
@@ -47,6 +47,7 @@
 #define DVB_DEVICE_CA         6
 #define DVB_DEVICE_NET        7
 #define DVB_DEVICE_OSD        8
+#define DVB_DEVICE_CAIO       9
 
 #define DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr) \
 	static short adapter_nr[] = \
diff --git a/drivers/media/dvb/ngene/ngene-core.c b/drivers/media/dvb/ngene/ngene-core.c
index 175a0f6..17cdd38 100644
--- a/drivers/media/dvb/ngene/ngene-core.c
+++ b/drivers/media/dvb/ngene/ngene-core.c
@@ -1523,7 +1523,7 @@ static int init_channel(struct ngene_channel *chan)
 		set_transfer(&chan->dev->channel[2], 1);
 		dvb_register_device(adapter, &chan->ci_dev,
 				    &ngene_dvbdev_ci, (void *) chan,
-				    DVB_DEVICE_SEC);
+				    DVB_DEVICE_CAIO);
 		if (!chan->ci_dev)
 			goto err;
 	}

