Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51852 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385Ab1LaL4T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Dec 2011 06:56:19 -0500
Received: by iaeh11 with SMTP id h11so26692546iae.19
        for <linux-media@vger.kernel.org>; Sat, 31 Dec 2011 03:56:19 -0800 (PST)
Date: Sat, 31 Dec 2011 05:56:11 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: David Fries <david@fries.net>
Cc: Istvan Varga <istvan_v@mailbox.hu>, linux-media@vger.kernel.org,
	Darron Broad <darron@kewl.org>,
	Steven Toth <stoth@kernellabs.com>
Subject: [PATCH 2/9] [media] videobuf-dvb: avoid spurious ENOMEM when
 CONFIG_DVB_NET=n
Message-ID: <20111231115611.GD16802@elie.Belkin>
References: <E1RgiId-0003Qe-SC@www.linuxtv.org>
 <20111231115117.GB16802@elie.Belkin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111231115117.GB16802@elie.Belkin>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

videobuf_dvb_register_bus relies on dvb_net_init to set dvbnet->dvbdev
on success, but ever since commit fcc8e7d8c0e2 ("dvb_net: Simplify the
code if DVB NET is not defined"), ->dvbdev is left unset when
networking support is disabled.  Therefore in such configurations
videobuf_dvb_register_bus always returns failure, tripping
little-tested error handling paths and preventing the device from
being initialized and used.

Now that dvb_net_init returns a nonzero value on error, we can use
that as a more reliable error indication.  Do so.

Now your card be used with CONFIG_DVB_NET=n, and the kernel will pass
on a more useful error code describing what happened when
CONFIG_DVB_NET=y but dvb_net_init fails due to resource exhaustion.

Reported-by: David Fries <David@Fries.net>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
 drivers/media/video/videobuf-dvb.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/videobuf-dvb.c b/drivers/media/video/videobuf-dvb.c
index 3de7c7e4402d..59cb54aa2946 100644
--- a/drivers/media/video/videobuf-dvb.c
+++ b/drivers/media/video/videobuf-dvb.c
@@ -226,9 +226,10 @@ static int videobuf_dvb_register_frontend(struct dvb_adapter *adapter,
 	}
 
 	/* register network adapter */
-	dvb_net_init(adapter, &dvb->net, &dvb->demux.dmx);
-	if (dvb->net.dvbdev == NULL) {
-		result = -ENOMEM;
+	result = dvb_net_init(adapter, &dvb->net, &dvb->demux.dmx);
+	if (result < 0) {
+		printk(KERN_WARNING "%s: dvb_net_init failed (errno = %d)\n",
+		       dvb->name, result);
 		goto fail_fe_conn;
 	}
 	return 0;
-- 
1.7.8.2+next.20111228

