Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay105.isp.belgacom.be ([195.238.20.132]:40975 "EHLO
	mailrelay105.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1949758AbbEBUHz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 2 May 2015 16:07:55 -0400
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 1/1 linux-next] [media] siano: define SRVM_MAX_PID_FILTERS only once
Date: Sat,  2 May 2015 22:07:45 +0200
Message-Id: <1430597266-11260-1-git-send-email-fabf@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SRVM_MAX_PID_FILTERS was defined in 2 sms_tx_stats structures

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/media/common/siano/smscoreapi.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/common/siano/smscoreapi.h b/drivers/media/common/siano/smscoreapi.h
index eb8bd68..4cc39e4 100644
--- a/drivers/media/common/siano/smscoreapi.h
+++ b/drivers/media/common/siano/smscoreapi.h
@@ -1010,6 +1010,7 @@ struct sms_rx_stats_ex {
 	s32 mrc_in_band_pwr;	/* In band power in dBM */
 };
 
+#define	SRVM_MAX_PID_FILTERS 8
 
 /* statistics information returned as response for
  * SmsHostApiGetstatisticsEx_Req for DVB applications, SMS1100 and up */
@@ -1021,7 +1022,6 @@ struct sms_stats_dvb {
 	struct sms_tx_stats transmission_data;
 
 	/* Burst parameters, valid only for DVB-H */
-#define	SRVM_MAX_PID_FILTERS 8
 	struct sms_pid_data pid_data[SRVM_MAX_PID_FILTERS];
 };
 
@@ -1035,7 +1035,6 @@ struct sms_stats_dvb_ex {
 	struct sms_tx_stats transmission_data;
 
 	/* Burst parameters, valid only for DVB-H */
-#define	SRVM_MAX_PID_FILTERS 8
 	struct sms_pid_data pid_data[SRVM_MAX_PID_FILTERS];
 };
 
-- 
1.9.1

