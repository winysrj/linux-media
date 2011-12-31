Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38248 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab1LaMUG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Dec 2011 07:20:06 -0500
Received: by iaeh11 with SMTP id h11so26717609iae.19
        for <linux-media@vger.kernel.org>; Sat, 31 Dec 2011 04:20:04 -0800 (PST)
Date: Sat, 31 Dec 2011 06:19:56 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: David Fries <david@fries.net>
Cc: Istvan Varga <istvan_v@mailbox.hu>, linux-media@vger.kernel.org,
	Darron Broad <darron@kewl.org>,
	Steven Toth <stoth@kernellabs.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 9/9] [media] firedtv: handle errors from dvb_net_init
Message-ID: <20111231121956.GK16802@elie.Belkin>
References: <E1RgiId-0003Qe-SC@www.linuxtv.org>
 <20111231115117.GB16802@elie.Belkin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111231115117.GB16802@elie.Belkin>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is not common for dvb_net_init to fail, but after the patch
"dvb_net_init: return -errno on error" it can fail due to running out
of memory.  Handle this.

>From an audit of dvb_net_init callers.

Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
That's the end of the series, though it would have been nice to
also check the error handling in

 dvb/mantis/mantis_dvb.c
 dvb/ngene/ngene-core.c (which looks a little strange)
 dvb/pluto2/pluto2.c
 dvb/pt1/pt1.c
 dvb/ttpci/av7110.c 
 dvb/ttpci/budget-core.c
 dvb/ttusb-dec/ttusb_dec.c
 video/au0828/au0828-dvb.c
 video/cx18/cx18-dvb.c
 video/cx231xx/cx231xx-dvb.c
 video/em28xx/em28xx-dvb.c
 video/pvrusb2/pvrusb2-dvb.c
 video/saa7164/saa7164-dvb.c

Hopefully this gives the idea, anyway.  Patch 2 is the important one,
and the patches after that are just toys to show off patch 1.

Warning: the patches are _completely_ _untested_.  Test results
(perhaps from provoking artificial failures in dvb_net_init), just
like other comments, would be very welcome.

'night,
Jonathan

 drivers/media/dvb/firewire/firedtv-dvb.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/firewire/firedtv-dvb.c b/drivers/media/dvb/firewire/firedtv-dvb.c
index fd8bbbfa5c59..eb7496eab130 100644
--- a/drivers/media/dvb/firewire/firedtv-dvb.c
+++ b/drivers/media/dvb/firewire/firedtv-dvb.c
@@ -203,7 +203,9 @@ int fdtv_dvb_register(struct firedtv *fdtv, const char *name)
 	if (err)
 		goto fail_rem_frontend;
 
-	dvb_net_init(&fdtv->adapter, &fdtv->dvbnet, &fdtv->demux.dmx);
+	err = dvb_net_init(&fdtv->adapter, &fdtv->dvbnet, &fdtv->demux.dmx);
+	if (err)
+		goto fail_disconnect_frontend;
 
 	fdtv_frontend_init(fdtv, name);
 	err = dvb_register_frontend(&fdtv->adapter, &fdtv->fe);
@@ -218,6 +220,7 @@ int fdtv_dvb_register(struct firedtv *fdtv, const char *name)
 
 fail_net_release:
 	dvb_net_release(&fdtv->dvbnet);
+fail_disconnect_frontend:
 	fdtv->demux.dmx.close(&fdtv->demux.dmx);
 fail_rem_frontend:
 	fdtv->demux.dmx.remove_frontend(&fdtv->demux.dmx, &fdtv->frontend);
-- 
1.7.8.2+next.20111228

