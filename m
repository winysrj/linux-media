Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65215 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385Ab1LaLyZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Dec 2011 06:54:25 -0500
Received: by iaeh11 with SMTP id h11so26690924iae.19
        for <linux-media@vger.kernel.org>; Sat, 31 Dec 2011 03:54:24 -0800 (PST)
Date: Sat, 31 Dec 2011 05:54:16 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: David Fries <david@fries.net>
Cc: Istvan Varga <istvan_v@mailbox.hu>, linux-media@vger.kernel.org,
	Darron Broad <darron@kewl.org>,
	Steven Toth <stoth@kernellabs.com>,
	Hans Petter Selasky <hselasky@c2i.net>
Subject: [PATCH 1/9] [media] DVB: dvb_net_init: return -errno on error
Message-ID: <20111231115416.GC16802@elie.Belkin>
References: <E1RgiId-0003Qe-SC@www.linuxtv.org>
 <20111231115117.GB16802@elie.Belkin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111231115117.GB16802@elie.Belkin>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

dvb_net_init unconditionally returns 0.  Callers such as
videobuf_dvb_register_frontend examine dvbnet->dvbdev instead of the
return value to tell whether the operation succeeded.  If it has been
set to a valid pointer, success; if it was left equal to NULL,
failure.

Alas, there is an edge case where that logic does not work as well:
when network support has been compiled out (CONFIG_DVB_NET=n), we want
dvb_net_init and related operations to behave as no-ops and always
succeed, but there is no appropriate value to which to set dvb->dvbdev
to indicate this.

Let dvb_net_init return a meaningful error code, as preparation for
adapting callers to look at that instead.

The only immediate impact of this patch should be to make the few
callers that already check for an error code from dvb_net_init behave
a little more sensibly when it fails.

Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
 drivers/media/dvb/dvb-core/dvb_net.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_net.c b/drivers/media/dvb/dvb-core/dvb_net.c
index 93d9869e0f15..8766ce8c354d 100644
--- a/drivers/media/dvb/dvb-core/dvb_net.c
+++ b/drivers/media/dvb/dvb-core/dvb_net.c
@@ -1510,9 +1510,7 @@ int dvb_net_init (struct dvb_adapter *adap, struct dvb_net *dvbnet,
 	for (i=0; i<DVB_NET_DEVICES_MAX; i++)
 		dvbnet->state[i] = 0;
 
-	dvb_register_device (adap, &dvbnet->dvbdev, &dvbdev_net,
+	return dvb_register_device(adap, &dvbnet->dvbdev, &dvbdev_net,
 			     dvbnet, DVB_DEVICE_NET);
-
-	return 0;
 }
 EXPORT_SYMBOL(dvb_net_init);
-- 
1.7.8.2+next.20111228

