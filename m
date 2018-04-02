Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:34840 "EHLO
        homiemail-a69.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755082AbeDBT7b (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 2 Apr 2018 15:59:31 -0400
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org, mchehab@s-opensource.com
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH] cx231xx: Increase USB bridge bandwidth
Date: Mon,  2 Apr 2018 14:59:01 -0500
Message-Id: <1522699141-11464-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The cx231xx USB bridge has issue streaming QAM256 DVB-C channels.
QAM64 channels were fine, but QAM256 channels produced corrupted
transport streams.

cx231xx alt mode 4 does not provide enough bandwidth to acommodate
QAM256 DVB-C channels, most likely DVB-T2 channels would break up
as well. Alt mode 5 increases bridge bandwidth to 90Mbps, and
fixes QAM256 DVB-C streaming.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/usb/cx231xx/cx231xx-dvb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index 7130294..67ed667 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -276,7 +276,7 @@ static int start_streaming(struct cx231xx_dvb *dvb)
 
 	if (dev->USE_ISO) {
 		dev_dbg(dev->dev, "DVB transfer mode is ISO.\n");
-		cx231xx_set_alt_setting(dev, INDEX_TS1, 4);
+		cx231xx_set_alt_setting(dev, INDEX_TS1, 5);
 		rc = cx231xx_set_mode(dev, CX231XX_DIGITAL_MODE);
 		if (rc < 0)
 			return rc;
-- 
2.7.4
