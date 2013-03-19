Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59870 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933214Ab3CSQuc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 12:50:32 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Doron Cohen <doronc@siano-ms.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 26/46] [media] siano: split debug logic from the status update routine
Date: Tue, 19 Mar 2013 13:49:15 -0300
Message-Id: <1363711775-2120-27-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
References: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is confusing to merge both status updates with debug stuff.
Also, it is a better idea to move those status updates to
debugfs, instead of doing a large amount of printk's like that.

So, break them into a separate block of routines.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/siano/smsdvb.c | 250 +++++++++++++++++++-----------------
 1 file changed, 135 insertions(+), 115 deletions(-)

diff --git a/drivers/media/common/siano/smsdvb.c b/drivers/media/common/siano/smsdvb.c
index 1d6b8df..04544f5 100644
--- a/drivers/media/common/siano/smsdvb.c
+++ b/drivers/media/common/siano/smsdvb.c
@@ -61,6 +61,136 @@ static int sms_dbg;
 module_param_named(debug, sms_dbg, int, 0644);
 MODULE_PARM_DESC(debug, "set debug level (info=1, adv=2 (or-able))");
 
+static void smsdvb_print_dvb_stats(struct SMSHOSTLIB_STATISTICS_ST *p)
+{
+	if (!(sms_dbg & 2))
+		return;
+
+	printk(KERN_DEBUG "IsRfLocked = %d", p->IsRfLocked);
+	printk(KERN_DEBUG "IsDemodLocked = %d", p->IsDemodLocked);
+	printk(KERN_DEBUG "IsExternalLNAOn = %d", p->IsExternalLNAOn);
+	printk(KERN_DEBUG "SNR = %d", p->SNR);
+	printk(KERN_DEBUG "BER = %d", p->BER);
+	printk(KERN_DEBUG "FIB_CRC = %d", p->FIB_CRC);
+	printk(KERN_DEBUG "TS_PER = %d", p->TS_PER);
+	printk(KERN_DEBUG "MFER = %d", p->MFER);
+	printk(KERN_DEBUG "RSSI = %d", p->RSSI);
+	printk(KERN_DEBUG "InBandPwr = %d", p->InBandPwr);
+	printk(KERN_DEBUG "CarrierOffset = %d", p->CarrierOffset);
+	printk(KERN_DEBUG "ModemState = %d", p->ModemState);
+	printk(KERN_DEBUG "Frequency = %d", p->Frequency);
+	printk(KERN_DEBUG "Bandwidth = %d", p->Bandwidth);
+	printk(KERN_DEBUG "TransmissionMode = %d", p->TransmissionMode);
+	printk(KERN_DEBUG "ModemState = %d", p->ModemState);
+	printk(KERN_DEBUG "GuardInterval = %d", p->GuardInterval);
+	printk(KERN_DEBUG "CodeRate = %d", p->CodeRate);
+	printk(KERN_DEBUG "LPCodeRate = %d", p->LPCodeRate);
+	printk(KERN_DEBUG "Hierarchy = %d", p->Hierarchy);
+	printk(KERN_DEBUG "Constellation = %d", p->Constellation);
+	printk(KERN_DEBUG "BurstSize = %d", p->BurstSize);
+	printk(KERN_DEBUG "BurstDuration = %d", p->BurstDuration);
+	printk(KERN_DEBUG "BurstCycleTime = %d", p->BurstCycleTime);
+	printk(KERN_DEBUG "CalculatedBurstCycleTime = %d", p->CalculatedBurstCycleTime);
+	printk(KERN_DEBUG "NumOfRows = %d", p->NumOfRows);
+	printk(KERN_DEBUG "NumOfPaddCols = %d", p->NumOfPaddCols);
+	printk(KERN_DEBUG "NumOfPunctCols = %d", p->NumOfPunctCols);
+	printk(KERN_DEBUG "ErrorTSPackets = %d", p->ErrorTSPackets);
+	printk(KERN_DEBUG "TotalTSPackets = %d", p->TotalTSPackets);
+	printk(KERN_DEBUG "NumOfValidMpeTlbs = %d", p->NumOfValidMpeTlbs);
+	printk(KERN_DEBUG "NumOfInvalidMpeTlbs = %d", p->NumOfInvalidMpeTlbs);
+	printk(KERN_DEBUG "NumOfCorrectedMpeTlbs = %d", p->NumOfCorrectedMpeTlbs);
+	printk(KERN_DEBUG "BERErrorCount = %d", p->BERErrorCount);
+	printk(KERN_DEBUG "BERBitCount = %d", p->BERBitCount);
+	printk(KERN_DEBUG "SmsToHostTxErrors = %d", p->SmsToHostTxErrors);
+	printk(KERN_DEBUG "PreBER = %d", p->PreBER);
+	printk(KERN_DEBUG "CellId = %d", p->CellId);
+	printk(KERN_DEBUG "DvbhSrvIndHP = %d", p->DvbhSrvIndHP);
+	printk(KERN_DEBUG "DvbhSrvIndLP = %d", p->DvbhSrvIndLP);
+	printk(KERN_DEBUG "NumMPEReceived = %d", p->NumMPEReceived);
+}
+
+static void smsdvb_print_isdb_stats(struct SMSHOSTLIB_STATISTICS_ISDBT_ST *p)
+{
+	int i;
+
+	if (!(sms_dbg & 2))
+		return;
+
+	printk(KERN_DEBUG "IsRfLocked = %d", p->IsRfLocked);
+	printk(KERN_DEBUG "IsDemodLocked = %d", p->IsDemodLocked);
+	printk(KERN_DEBUG "IsExternalLNAOn = %d", p->IsExternalLNAOn);
+	printk(KERN_DEBUG "SNR = %d", p->SNR);
+	printk(KERN_DEBUG "RSSI = %d", p->RSSI);
+	printk(KERN_DEBUG "InBandPwr = %d", p->InBandPwr);
+	printk(KERN_DEBUG "CarrierOffset = %d", p->CarrierOffset);
+	printk(KERN_DEBUG "Frequency = %d", p->Frequency);
+	printk(KERN_DEBUG "Bandwidth = %d", p->Bandwidth);
+	printk(KERN_DEBUG "TransmissionMode = %d", p->TransmissionMode);
+	printk(KERN_DEBUG "ModemState = %d", p->ModemState);
+	printk(KERN_DEBUG "GuardInterval = %d", p->GuardInterval);
+	printk(KERN_DEBUG "SystemType = %d", p->SystemType);
+	printk(KERN_DEBUG "PartialReception = %d", p->PartialReception);
+	printk(KERN_DEBUG "NumOfLayers = %d", p->NumOfLayers);
+	printk(KERN_DEBUG "SmsToHostTxErrors = %d", p->SmsToHostTxErrors);
+
+	for (i = 0; i < 3; i++) {
+		printk(KERN_DEBUG "%d: CodeRate = %d", i, p->LayerInfo[i].CodeRate);
+		printk(KERN_DEBUG "%d: Constellation = %d", i, p->LayerInfo[i].Constellation);
+		printk(KERN_DEBUG "%d: BER = %d", i, p->LayerInfo[i].BER);
+		printk(KERN_DEBUG "%d: BERErrorCount = %d", i, p->LayerInfo[i].BERErrorCount);
+		printk(KERN_DEBUG "%d: BERBitCount = %d", i, p->LayerInfo[i].BERBitCount);
+		printk(KERN_DEBUG "%d: PreBER = %d", i, p->LayerInfo[i].PreBER);
+		printk(KERN_DEBUG "%d: TS_PER = %d", i, p->LayerInfo[i].TS_PER);
+		printk(KERN_DEBUG "%d: ErrorTSPackets = %d", i, p->LayerInfo[i].ErrorTSPackets);
+		printk(KERN_DEBUG "%d: TotalTSPackets = %d", i, p->LayerInfo[i].TotalTSPackets);
+		printk(KERN_DEBUG "%d: TILdepthI = %d", i, p->LayerInfo[i].TILdepthI);
+		printk(KERN_DEBUG "%d: NumberOfSegments = %d", i, p->LayerInfo[i].NumberOfSegments);
+		printk(KERN_DEBUG "%d: TMCCErrors = %d", i, p->LayerInfo[i].TMCCErrors);
+	}
+}
+
+static void
+smsdvb_print_isdb_stats_ex(struct SMSHOSTLIB_STATISTICS_ISDBT_EX_ST *p)
+{
+	int i;
+
+	if (!(sms_dbg & 2))
+		return;
+
+	printk(KERN_DEBUG "IsRfLocked = %d", p->IsRfLocked);
+	printk(KERN_DEBUG "IsDemodLocked = %d", p->IsDemodLocked);
+	printk(KERN_DEBUG "IsExternalLNAOn = %d", p->IsExternalLNAOn);
+	printk(KERN_DEBUG "SNR = %d", p->SNR);
+	printk(KERN_DEBUG "RSSI = %d", p->RSSI);
+	printk(KERN_DEBUG "InBandPwr = %d", p->InBandPwr);
+	printk(KERN_DEBUG "CarrierOffset = %d", p->CarrierOffset);
+	printk(KERN_DEBUG "Frequency = %d", p->Frequency);
+	printk(KERN_DEBUG "Bandwidth = %d", p->Bandwidth);
+	printk(KERN_DEBUG "TransmissionMode = %d", p->TransmissionMode);
+	printk(KERN_DEBUG "ModemState = %d", p->ModemState);
+	printk(KERN_DEBUG "GuardInterval = %d", p->GuardInterval);
+	printk(KERN_DEBUG "SystemType = %d", p->SystemType);
+	printk(KERN_DEBUG "PartialReception = %d", p->PartialReception);
+	printk(KERN_DEBUG "NumOfLayers = %d", p->NumOfLayers);
+	printk(KERN_DEBUG "SegmentNumber = %d", p->SegmentNumber);
+	printk(KERN_DEBUG "TuneBW = %d", p->TuneBW);
+
+	for (i = 0; i < 3; i++) {
+		printk(KERN_DEBUG "%d: CodeRate = %d", i, p->LayerInfo[i].CodeRate);
+		printk(KERN_DEBUG "%d: Constellation = %d", i, p->LayerInfo[i].Constellation);
+		printk(KERN_DEBUG "%d: BER = %d", i, p->LayerInfo[i].BER);
+		printk(KERN_DEBUG "%d: BERErrorCount = %d", i, p->LayerInfo[i].BERErrorCount);
+		printk(KERN_DEBUG "%d: BERBitCount = %d", i, p->LayerInfo[i].BERBitCount);
+		printk(KERN_DEBUG "%d: PreBER = %d", i, p->LayerInfo[i].PreBER);
+		printk(KERN_DEBUG "%d: TS_PER = %d", i, p->LayerInfo[i].TS_PER);
+		printk(KERN_DEBUG "%d: ErrorTSPackets = %d", i, p->LayerInfo[i].ErrorTSPackets);
+		printk(KERN_DEBUG "%d: TotalTSPackets = %d", i, p->LayerInfo[i].TotalTSPackets);
+		printk(KERN_DEBUG "%d: TILdepthI = %d", i, p->LayerInfo[i].TILdepthI);
+		printk(KERN_DEBUG "%d: NumberOfSegments = %d", i, p->LayerInfo[i].NumberOfSegments);
+		printk(KERN_DEBUG "%d: TMCCErrors = %d", i, p->LayerInfo[i].TMCCErrors);
+	}
+}
+
 /* Events that may come from DVB v3 adapter */
 static void sms_board_dvb3_event(struct smsdvb_client_t *client,
 		enum SMS_DVB3_EVENTS event) {
@@ -115,51 +245,9 @@ static void sms_board_dvb3_event(struct smsdvb_client_t *client,
 }
 
 static void smsdvb_update_dvb_stats(struct RECEPTION_STATISTICS_EX_S *pReceptionData,
-				   struct SMSHOSTLIB_STATISTICS_ST *p)
+				    struct SMSHOSTLIB_STATISTICS_ST *p)
 {
-	if (sms_dbg & 2) {
-		printk(KERN_DEBUG "IsRfLocked = %d", p->IsRfLocked);
-		printk(KERN_DEBUG "IsDemodLocked = %d", p->IsDemodLocked);
-		printk(KERN_DEBUG "IsExternalLNAOn = %d", p->IsExternalLNAOn);
-		printk(KERN_DEBUG "SNR = %d", p->SNR);
-		printk(KERN_DEBUG "BER = %d", p->BER);
-		printk(KERN_DEBUG "FIB_CRC = %d", p->FIB_CRC);
-		printk(KERN_DEBUG "TS_PER = %d", p->TS_PER);
-		printk(KERN_DEBUG "MFER = %d", p->MFER);
-		printk(KERN_DEBUG "RSSI = %d", p->RSSI);
-		printk(KERN_DEBUG "InBandPwr = %d", p->InBandPwr);
-		printk(KERN_DEBUG "CarrierOffset = %d", p->CarrierOffset);
-		printk(KERN_DEBUG "ModemState = %d", p->ModemState);
-		printk(KERN_DEBUG "Frequency = %d", p->Frequency);
-		printk(KERN_DEBUG "Bandwidth = %d", p->Bandwidth);
-		printk(KERN_DEBUG "TransmissionMode = %d", p->TransmissionMode);
-		printk(KERN_DEBUG "ModemState = %d", p->ModemState);
-		printk(KERN_DEBUG "GuardInterval = %d", p->GuardInterval);
-		printk(KERN_DEBUG "CodeRate = %d", p->CodeRate);
-		printk(KERN_DEBUG "LPCodeRate = %d", p->LPCodeRate);
-		printk(KERN_DEBUG "Hierarchy = %d", p->Hierarchy);
-		printk(KERN_DEBUG "Constellation = %d", p->Constellation);
-		printk(KERN_DEBUG "BurstSize = %d", p->BurstSize);
-		printk(KERN_DEBUG "BurstDuration = %d", p->BurstDuration);
-		printk(KERN_DEBUG "BurstCycleTime = %d", p->BurstCycleTime);
-		printk(KERN_DEBUG "CalculatedBurstCycleTime = %d", p->CalculatedBurstCycleTime);
-		printk(KERN_DEBUG "NumOfRows = %d", p->NumOfRows);
-		printk(KERN_DEBUG "NumOfPaddCols = %d", p->NumOfPaddCols);
-		printk(KERN_DEBUG "NumOfPunctCols = %d", p->NumOfPunctCols);
-		printk(KERN_DEBUG "ErrorTSPackets = %d", p->ErrorTSPackets);
-		printk(KERN_DEBUG "TotalTSPackets = %d", p->TotalTSPackets);
-		printk(KERN_DEBUG "NumOfValidMpeTlbs = %d", p->NumOfValidMpeTlbs);
-		printk(KERN_DEBUG "NumOfInvalidMpeTlbs = %d", p->NumOfInvalidMpeTlbs);
-		printk(KERN_DEBUG "NumOfCorrectedMpeTlbs = %d", p->NumOfCorrectedMpeTlbs);
-		printk(KERN_DEBUG "BERErrorCount = %d", p->BERErrorCount);
-		printk(KERN_DEBUG "BERBitCount = %d", p->BERBitCount);
-		printk(KERN_DEBUG "SmsToHostTxErrors = %d", p->SmsToHostTxErrors);
-		printk(KERN_DEBUG "PreBER = %d", p->PreBER);
-		printk(KERN_DEBUG "CellId = %d", p->CellId);
-		printk(KERN_DEBUG "DvbhSrvIndHP = %d", p->DvbhSrvIndHP);
-		printk(KERN_DEBUG "DvbhSrvIndLP = %d", p->DvbhSrvIndLP);
-		printk(KERN_DEBUG "NumMPEReceived = %d", p->NumMPEReceived);
-	}
+	smsdvb_print_dvb_stats(p);
 
 	/* update reception data */
 	pReceptionData->IsRfLocked = p->IsRfLocked;
@@ -179,43 +267,9 @@ static void smsdvb_update_dvb_stats(struct RECEPTION_STATISTICS_EX_S *pReception
 };
 
 static void smsdvb_update_isdbt_stats(struct RECEPTION_STATISTICS_EX_S *pReceptionData,
-				    struct SMSHOSTLIB_STATISTICS_ISDBT_ST *p)
+				      struct SMSHOSTLIB_STATISTICS_ISDBT_ST *p)
 {
-	int i;
-
-	if (sms_dbg & 2) {
-		printk(KERN_DEBUG "IsRfLocked = %d", p->IsRfLocked);
-		printk(KERN_DEBUG "IsDemodLocked = %d", p->IsDemodLocked);
-		printk(KERN_DEBUG "IsExternalLNAOn = %d", p->IsExternalLNAOn);
-		printk(KERN_DEBUG "SNR = %d", p->SNR);
-		printk(KERN_DEBUG "RSSI = %d", p->RSSI);
-		printk(KERN_DEBUG "InBandPwr = %d", p->InBandPwr);
-		printk(KERN_DEBUG "CarrierOffset = %d", p->CarrierOffset);
-		printk(KERN_DEBUG "Frequency = %d", p->Frequency);
-		printk(KERN_DEBUG "Bandwidth = %d", p->Bandwidth);
-		printk(KERN_DEBUG "TransmissionMode = %d", p->TransmissionMode);
-		printk(KERN_DEBUG "ModemState = %d", p->ModemState);
-		printk(KERN_DEBUG "GuardInterval = %d", p->GuardInterval);
-		printk(KERN_DEBUG "SystemType = %d", p->SystemType);
-		printk(KERN_DEBUG "PartialReception = %d", p->PartialReception);
-		printk(KERN_DEBUG "NumOfLayers = %d", p->NumOfLayers);
-		printk(KERN_DEBUG "SmsToHostTxErrors = %d", p->SmsToHostTxErrors);
-
-		for (i = 0; i < 3; i++) {
-			printk(KERN_DEBUG "%d: CodeRate = %d", i, p->LayerInfo[i].CodeRate);
-			printk(KERN_DEBUG "%d: Constellation = %d", i, p->LayerInfo[i].Constellation);
-			printk(KERN_DEBUG "%d: BER = %d", i, p->LayerInfo[i].BER);
-			printk(KERN_DEBUG "%d: BERErrorCount = %d", i, p->LayerInfo[i].BERErrorCount);
-			printk(KERN_DEBUG "%d: BERBitCount = %d", i, p->LayerInfo[i].BERBitCount);
-			printk(KERN_DEBUG "%d: PreBER = %d", i, p->LayerInfo[i].PreBER);
-			printk(KERN_DEBUG "%d: TS_PER = %d", i, p->LayerInfo[i].TS_PER);
-			printk(KERN_DEBUG "%d: ErrorTSPackets = %d", i, p->LayerInfo[i].ErrorTSPackets);
-			printk(KERN_DEBUG "%d: TotalTSPackets = %d", i, p->LayerInfo[i].TotalTSPackets);
-			printk(KERN_DEBUG "%d: TILdepthI = %d", i, p->LayerInfo[i].TILdepthI);
-			printk(KERN_DEBUG "%d: NumberOfSegments = %d", i, p->LayerInfo[i].NumberOfSegments);
-			printk(KERN_DEBUG "%d: TMCCErrors = %d", i, p->LayerInfo[i].TMCCErrors);
-		}
-	}
+	smsdvb_print_isdb_stats(p);
 
 	/* update reception data */
 	pReceptionData->IsRfLocked = p->IsRfLocked;
@@ -249,41 +303,7 @@ static void smsdvb_update_isdbt_stats(struct RECEPTION_STATISTICS_EX_S *pRecepti
 static void smsdvb_update_isdbt_stats_ex(struct RECEPTION_STATISTICS_EX_S *pReceptionData,
 				    struct SMSHOSTLIB_STATISTICS_ISDBT_EX_ST *p)
 {
-	int i;
-
-	if (sms_dbg & 2) {
-		printk(KERN_DEBUG "IsRfLocked = %d", p->IsRfLocked);
-		printk(KERN_DEBUG "IsDemodLocked = %d", p->IsDemodLocked);
-		printk(KERN_DEBUG "IsExternalLNAOn = %d", p->IsExternalLNAOn);
-		printk(KERN_DEBUG "SNR = %d", p->SNR);
-		printk(KERN_DEBUG "RSSI = %d", p->RSSI);
-		printk(KERN_DEBUG "InBandPwr = %d", p->InBandPwr);
-		printk(KERN_DEBUG "CarrierOffset = %d", p->CarrierOffset);
-		printk(KERN_DEBUG "Frequency = %d", p->Frequency);
-		printk(KERN_DEBUG "Bandwidth = %d", p->Bandwidth);
-		printk(KERN_DEBUG "TransmissionMode = %d", p->TransmissionMode);
-		printk(KERN_DEBUG "ModemState = %d", p->ModemState);
-		printk(KERN_DEBUG "GuardInterval = %d", p->GuardInterval);
-		printk(KERN_DEBUG "SystemType = %d", p->SystemType);
-		printk(KERN_DEBUG "PartialReception = %d", p->PartialReception);
-		printk(KERN_DEBUG "NumOfLayers = %d", p->NumOfLayers);
-		printk(KERN_DEBUG "SegmentNumber = %d", p->SegmentNumber);
-		printk(KERN_DEBUG "TuneBW = %d", p->TuneBW);
-		for (i = 0; i < 3; i++) {
-			printk(KERN_DEBUG "%d: CodeRate = %d", i, p->LayerInfo[i].CodeRate);
-			printk(KERN_DEBUG "%d: Constellation = %d", i, p->LayerInfo[i].Constellation);
-			printk(KERN_DEBUG "%d: BER = %d", i, p->LayerInfo[i].BER);
-			printk(KERN_DEBUG "%d: BERErrorCount = %d", i, p->LayerInfo[i].BERErrorCount);
-			printk(KERN_DEBUG "%d: BERBitCount = %d", i, p->LayerInfo[i].BERBitCount);
-			printk(KERN_DEBUG "%d: PreBER = %d", i, p->LayerInfo[i].PreBER);
-			printk(KERN_DEBUG "%d: TS_PER = %d", i, p->LayerInfo[i].TS_PER);
-			printk(KERN_DEBUG "%d: ErrorTSPackets = %d", i, p->LayerInfo[i].ErrorTSPackets);
-			printk(KERN_DEBUG "%d: TotalTSPackets = %d", i, p->LayerInfo[i].TotalTSPackets);
-			printk(KERN_DEBUG "%d: TILdepthI = %d", i, p->LayerInfo[i].TILdepthI);
-			printk(KERN_DEBUG "%d: NumberOfSegments = %d", i, p->LayerInfo[i].NumberOfSegments);
-			printk(KERN_DEBUG "%d: TMCCErrors = %d", i, p->LayerInfo[i].TMCCErrors);
-		}
-	}
+	smsdvb_print_isdb_stats_ex(p);
 
 	/* update reception data */
 	pReceptionData->IsRfLocked = p->IsRfLocked;
-- 
1.8.1.4

