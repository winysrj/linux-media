Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51902 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932935Ab3CSQt7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 12:49:59 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Doron Cohen <doronc@siano-ms.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 37/46] [media] siano: fix status report with old firmware and ISDB-T
Date: Tue, 19 Mar 2013 13:49:26 -0300
Message-Id: <1363711775-2120-38-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
References: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This seems to be ever broken. That's the status report with
Firmware 2.1, before adding support for sms2270 is:

[22273.787218] smsdvb_onresponse: MSG_SMS_GET_STATISTICS_RES
[22273.792592] IsRfLocked = 1
[22273.792592] IsDemodLocked = 1
...
[22273.792598] TransmissionMode = -64
...
(all unshown fields are filled with zeros)

Of course, transmission mode being a negative number is wrong.
So, we need to take a deeper look on it.

With the debugfs patches applied, it is possible to see that, instead
of filling StatisticsType with 5, and FullSize with the size of the
payload (this is what happens with sms2270 and firmware 8.1),
those fields are also initialized with zero:

StatisticsType = 0	FullSize = 0
IsRfLocked = 1		IsDemodLocked = 1	IsExternalLNAOn = 0
SNR = 0 dB		RSSI = 0 dBm		InBandPwr = 0 dBm
CarrierOffset = 0	Bandwidth = 0		Frequency = 0 Hz
TransmissionMode = -64	ModemState = 0		GuardInterval = 0
SystemType = 0		PartialReception = 0	NumOfLayers = 0
SmsToHostTxErrors = 0

The data under "TransmissionMode" varies according with the signal,
and it is negative. It also matches the value for InBandPwr when
the tuner is on DVB-T (ok, signal doesn't lock, but the power level
should be about the same with the antena fixed, and measured at about
the same time).

So, there's a very high chance that, when StatisticsType is zero, the
signal strength is at the same position as Transmission Mode.

So, discard all other parameters, and provide only signal/rf lock and
signal strength if StatisticsType is 0, for ISDB-T.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/siano/smsdvb-main.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/media/common/siano/smsdvb-main.c b/drivers/media/common/siano/smsdvb-main.c
index 114fe57..ce6ba7b 100644
--- a/drivers/media/common/siano/smsdvb-main.c
+++ b/drivers/media/common/siano/smsdvb-main.c
@@ -338,9 +338,21 @@ static void smsdvb_update_isdbt_stats(struct smsdvb_client_t *client,
 	if (client->prt_isdb_stats)
 		client->prt_isdb_stats(client->debug_data, p);
 
+	client->fe_status = sms_to_status(p->IsDemodLocked, p->IsRfLocked);
+
+	/*
+	 * Firmware 2.1 seems to report only lock status and
+	 * Signal strength. The signal strength indicator is at the
+	 * wrong field.
+	 */
+	if (p->StatisticsType == 0) {
+		c->strength.stat[0].uvalue = ((s32)p->TransmissionMode) * 1000;
+		c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		return;
+	}
+
 	/* Update ISDB-T transmission parameters */
 	c->frequency = p->Frequency;
-	client->fe_status = sms_to_status(p->IsDemodLocked, 0);
 	c->bandwidth_hz = sms_to_bw(p->Bandwidth);
 	c->transmission_mode = sms_to_mode(p->TransmissionMode);
 	c->guard_interval = sms_to_guard_interval(p->GuardInterval);
-- 
1.8.1.4

