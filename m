Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:45925 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758005AbZBXOxT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Feb 2009 09:53:19 -0500
Date: Tue, 24 Feb 2009 15:52:49 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH update] firedtv: dvb_frontend_info for FireDTV S2, fix
 "frequency limits undefined" error
To: Beat Michel Liechti <bml303@gmail.com>
cc: linux1394-devel@lists.sourceforge.net, linux-media@vger.kernel.org,
	Ben Backx <ben@bbackx.com>, Henrik Kurelid <henrik@kurelid.se>
In-Reply-To: <tkrat.8a312fdd39ad20b6@s5r6.in-berlin.de>
Message-ID: <tkrat.f46f5cba7bb5dd9f@s5r6.in-berlin.de>
References: <3e03d4060902231447r1df9f8d0pe65a50773af7fa67@mail.gmail.com>
 <tkrat.8a312fdd39ad20b6@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Beat Michel Liechti <bml303@gmail.com>

I found that the function fdtv_frontend_init in the file firedtv-fe.c was
missing a case for FIREDTV_DVB_S2 which resulted in "frequency limits
undefined" errors in syslog.

Signed-off-by: Beat Michel Liechti <bml303@gmail.com>

Change by Stefan R: combine it with case case FIREDTV_DVB_S as
originally suggested by Beat Michel.  This enables FE_CAN_FEC_AUTO also
for FireDTV-S2 devices which is possible as long as only DVB-S channels
are used.  FE_CAN_FEC_AUTO would be wrong for DVB-S2 channels, but those
cannot be used yet since the driver is not yet converted to S2API.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

If you don't mind, I commit this for now (want to send a mainline pull
request later today) and we work out any remaining loose DVB-S2 ends
from there.

 drivers/media/dvb/firewire/firedtv-fe.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux/drivers/media/dvb/firewire/firedtv-fe.c
===================================================================
--- linux.orig/drivers/media/dvb/firewire/firedtv-fe.c
+++ linux/drivers/media/dvb/firewire/firedtv-fe.c
@@ -185,6 +185,7 @@ void fdtv_frontend_init(struct firedtv *
 
 	switch (fdtv->type) {
 	case FIREDTV_DVB_S:
+	case FIREDTV_DVB_S2:
 		fi->type		= FE_QPSK;
 
 		fi->frequency_min	= 950000;

-- 
Stefan Richter
-=====-==--= --=- ==---
http://arcgraph.de/sr/

