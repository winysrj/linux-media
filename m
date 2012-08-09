Return-path: <linux-media-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:39259 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030945Ab2HIPf4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Aug 2012 11:35:56 -0400
Received: from [194.168.151.111] (earthlight.etchedpixels.co.uk [81.2.110.250])
	by lxorguk.ukuu.org.uk (8.14.5/8.14.1) with ESMTP id q79G8vNJ010420
	for <linux-media@vger.kernel.org>; Thu, 9 Aug 2012 17:09:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] mantis: fix silly crash case
To: linux-media@vger.kernel.org
Date: Thu, 09 Aug 2012 17:33:52 +0100
Message-ID: <20120809163327.3072.31345.stgit@bluebook>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Alan Cox <alan@linux.intel.com>

If we set mantis->fe to NULL on an error its not a good idea to then try
passing NULL to the unregister paths and oopsing really.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Resolves-bug: https://bugzilla.kernel.org/show_bug.cgi?id=16473
---

 drivers/media/dvb/mantis/mantis_dvb.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/mantis/mantis_dvb.c b/drivers/media/dvb/mantis/mantis_dvb.c
index e5180e4..5d15c6b 100644
--- a/drivers/media/dvb/mantis/mantis_dvb.c
+++ b/drivers/media/dvb/mantis/mantis_dvb.c
@@ -248,8 +248,10 @@ int __devinit mantis_dvb_init(struct mantis_pci *mantis)
 err5:
 	tasklet_kill(&mantis->tasklet);
 	dvb_net_release(&mantis->dvbnet);
-	dvb_unregister_frontend(mantis->fe);
-	dvb_frontend_detach(mantis->fe);
+	if (mantis->fe) {
+		dvb_unregister_frontend(mantis->fe);
+		dvb_frontend_detach(mantis->fe);
+	}
 err4:
 	mantis->demux.dmx.remove_frontend(&mantis->demux.dmx, &mantis->fe_mem);
 

