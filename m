Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:39172 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726823AbeKNX3N (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Nov 2018 18:29:13 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Torbjorn Jansson <torbjorn.jansson@mbox200.swipnet.se>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] pulse8-cec: return 0 when invalidating the logical address
Message-ID: <3bc19549-ea46-1273-11b9-49482e3574f0@xs4all.nl>
Date: Wed, 14 Nov 2018 14:25:53 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Return 0 when invalidating the logical address. The cec core produces
a warning for drivers that do this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Torbjorn Jansson <torbjorn.jansson@mbox200.swipnet.se>
---
diff --git a/drivers/media/usb/pulse8-cec/pulse8-cec.c b/drivers/media/usb/pulse8-cec/pulse8-cec.c
index 365c78b748dd..b085b14f3f87 100644
--- a/drivers/media/usb/pulse8-cec/pulse8-cec.c
+++ b/drivers/media/usb/pulse8-cec/pulse8-cec.c
@@ -586,7 +586,7 @@ static int pulse8_cec_adap_log_addr(struct cec_adapter *adap, u8 log_addr)
 	else
 		pulse8->config_pending = true;
 	mutex_unlock(&pulse8->config_lock);
-	return err;
+	return log_addr == CEC_LOG_ADDR_INVALID ? 0 : err;
 }

 static int pulse8_cec_adap_transmit(struct cec_adapter *adap, u8 attempts,
