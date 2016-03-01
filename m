Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:36162 "EHLO
	mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbcCAT3H (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Mar 2016 14:29:07 -0500
Received: by mail-lf0-f52.google.com with SMTP id l83so73078685lfd.3
        for <linux-media@vger.kernel.org>; Tue, 01 Mar 2016 11:29:06 -0800 (PST)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: torbjorn.jansson@mbox200.swipnet.se, mchehab@osg.samsung.com,
	Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH] dvb-core: fix return code checking for devices with CA
Date: Tue,  1 Mar 2016 21:28:54 +0200
Message-Id: <1456860534-1386-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The test for the return code was mistakenly inverted. This caused DVB
devices with CA module to fail on modprobe.

Tested with TechnoTrend CT2-4650 CI USB tuner.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/dvb-core/dvbdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index 1b9732e..e1684c5 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -681,7 +681,7 @@ int dvb_create_media_graph(struct dvb_adapter *adap,
 	if (demux && ca) {
 		ret = media_create_pad_link(demux, 1, ca,
 					    0, MEDIA_LNK_FL_ENABLED);
-		if (!ret)
+		if (ret)
 			return -ENOMEM;
 	}
 
-- 
1.9.1

