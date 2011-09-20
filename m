Return-path: <linux-media-owner@vger.kernel.org>
Received: from mr.siano-ms.com ([62.0.79.70]:6304 "EHLO
	Siano-NV.ser.netvision.net.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932161Ab1ITKTV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Sep 2011 06:19:21 -0400
Subject: [PATCH  16/17]DVB:Siano drivers - extern function
 smscore_send_last_fw_chunk to be used by other modules
From: Doron Cohen <doronc@siano-ms.com>
Reply-To: doronc@siano-ms.com
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 20 Sep 2011 13:32:03 +0300
Message-ID: <1316514723.5199.94.camel@Doron-Ubuntu>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
This patch step externs function smscore_send_last_fw_chunk to be used
by other modules.
Thanks,
Doron Cohen

-----------------------

>From 1e19b238fa7129396df7ddc89e8197669c72a3a4 Mon Sep 17 00:00:00 2001
From: Doron Cohen <doronc@siano-ms.com>
Date: Tue, 20 Sep 2011 09:38:10 +0300
Subject: [PATCH 20/21] extern function smscore_send_last_fw_chunk to be
used by other modules

---
 drivers/media/dvb/siano/smscoreapi.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/siano/smscoreapi.c
b/drivers/media/dvb/siano/smscoreapi.c
index 0555a38..10bd28c 100644
--- a/drivers/media/dvb/siano/smscoreapi.c
+++ b/drivers/media/dvb/siano/smscoreapi.c
@@ -964,6 +964,8 @@ exit_fw_download:
 
 	return rc;
 }
+EXPORT_SYMBOL_GPL(smscore_send_last_fw_chunk);
+
 
 /**
  * notifies all clients registered with the device, notifies hotplugs,
-- 
1.7.4.1

