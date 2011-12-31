Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35557 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab1LaMIx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Dec 2011 07:08:53 -0500
Received: by iaeh11 with SMTP id h11so26705667iae.19
        for <linux-media@vger.kernel.org>; Sat, 31 Dec 2011 04:08:53 -0800 (PST)
Date: Sat, 31 Dec 2011 06:08:45 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: David Fries <david@fries.net>
Cc: Istvan Varga <istvan_v@mailbox.hu>, linux-media@vger.kernel.org,
	Darron Broad <darron@kewl.org>,
	Steven Toth <stoth@kernellabs.com>,
	"Igor M. Liplianin" <liplianin@me.by>
Subject: [PATCH 7/9] [media] dm1105: handle errors from dvb_net_init
Message-ID: <20111231120845.GI16802@elie.Belkin>
References: <E1RgiId-0003Qe-SC@www.linuxtv.org>
 <20111231115117.GB16802@elie.Belkin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111231115117.GB16802@elie.Belkin>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Clean up and error out if dvb_net_init fails (for example due to
ENOMEM).  This involves moving the dvb_net_init call to before
frontend_init to make cleaning up a little easier.

>From an audit of dvb_net_init callers, now that dvb_net_init lets
callers know about errors.

Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
 drivers/media/dvb/dm1105/dm1105.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/dm1105/dm1105.c b/drivers/media/dvb/dm1105/dm1105.c
index 55e6533f15e9..70e040b999e7 100644
--- a/drivers/media/dvb/dm1105/dm1105.c
+++ b/drivers/media/dvb/dm1105/dm1105.c
@@ -1115,11 +1115,14 @@ static int __devinit dm1105_probe(struct pci_dev *pdev,
 	if (ret < 0)
 		goto err_remove_mem_frontend;
 
+	ret = dvb_net_init(dvb_adapter, &dev->dvbnet, dmx);
+	if (ret < 0)
+		goto err_disconnect_frontend;
+
 	ret = frontend_init(dev);
 	if (ret < 0)
 		goto err_disconnect_frontend;
 
-	dvb_net_init(dvb_adapter, &dev->dvbnet, dmx);
 	dm1105_ir_init(dev);
 
 	INIT_WORK(&dev->work, dm1105_dmx_buffer);
-- 
1.7.8.2+next.20111228

