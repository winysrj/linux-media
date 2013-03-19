Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12009 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933228Ab3CSQug (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 12:50:36 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Doron Cohen <doronc@siano-ms.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 29/46] [media] siano: allow showing the complete statistics via debugfs
Date: Tue, 19 Mar 2013 13:49:18 -0300
Message-Id: <1363711775-2120-30-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
References: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Outputs the result of the statistics responses via debugfs.
That can help to track bugs at the stats filling.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/siano/smsdvb.c | 464 +++++++++++++++++++++++++++---------
 1 file changed, 355 insertions(+), 109 deletions(-)

diff --git a/drivers/media/common/siano/smsdvb.c b/drivers/media/common/siano/smsdvb.c
index 70ea3e9..aeadd8a 100644
--- a/drivers/media/common/siano/smsdvb.c
+++ b/drivers/media/common/siano/smsdvb.c
@@ -22,6 +22,7 @@ along with this program.  If not, see <http://www.gnu.org/licenses/>.
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/init.h>
+#include <linux/debugfs.h>
 
 #include "dmxdev.h"
 #include "dvbdev.h"
@@ -55,6 +56,13 @@ struct smsdvb_client_t {
 
 	int event_fe_state;
 	int event_unc_state;
+
+	/* Stats debugfs data */
+	struct dentry		*debugfs;
+	char			*stats_data;
+	atomic_t		stats_count;
+	bool			stats_was_read;
+	wait_queue_head_t	stats_queue;
 };
 
 static struct list_head g_smsdvb_clients;
@@ -140,134 +148,358 @@ u32 sms_to_modulation_table[] = {
 	[3] = DQPSK,
 };
 
-static void smsdvb_print_dvb_stats(struct SMSHOSTLIB_STATISTICS_ST *p)
+static struct dentry *smsdvb_debugfs;
+
+static void smsdvb_print_dvb_stats(struct smsdvb_client_t *client,
+				   struct SMSHOSTLIB_STATISTICS_ST *p)
 {
-	if (!(sms_dbg & 2))
+	int n = 0;
+	char *buf;
+
+	if (!client->stats_data || atomic_read(&client->stats_count))
 		return;
 
-	printk(KERN_DEBUG "IsRfLocked = %d", p->IsRfLocked);
-	printk(KERN_DEBUG "IsDemodLocked = %d", p->IsDemodLocked);
-	printk(KERN_DEBUG "IsExternalLNAOn = %d", p->IsExternalLNAOn);
-	printk(KERN_DEBUG "SNR = %d", p->SNR);
-	printk(KERN_DEBUG "BER = %d", p->BER);
-	printk(KERN_DEBUG "FIB_CRC = %d", p->FIB_CRC);
-	printk(KERN_DEBUG "TS_PER = %d", p->TS_PER);
-	printk(KERN_DEBUG "MFER = %d", p->MFER);
-	printk(KERN_DEBUG "RSSI = %d", p->RSSI);
-	printk(KERN_DEBUG "InBandPwr = %d", p->InBandPwr);
-	printk(KERN_DEBUG "CarrierOffset = %d", p->CarrierOffset);
-	printk(KERN_DEBUG "ModemState = %d", p->ModemState);
-	printk(KERN_DEBUG "Frequency = %d", p->Frequency);
-	printk(KERN_DEBUG "Bandwidth = %d", p->Bandwidth);
-	printk(KERN_DEBUG "TransmissionMode = %d", p->TransmissionMode);
-	printk(KERN_DEBUG "ModemState = %d", p->ModemState);
-	printk(KERN_DEBUG "GuardInterval = %d", p->GuardInterval);
-	printk(KERN_DEBUG "CodeRate = %d", p->CodeRate);
-	printk(KERN_DEBUG "LPCodeRate = %d", p->LPCodeRate);
-	printk(KERN_DEBUG "Hierarchy = %d", p->Hierarchy);
-	printk(KERN_DEBUG "Constellation = %d", p->Constellation);
-	printk(KERN_DEBUG "BurstSize = %d", p->BurstSize);
-	printk(KERN_DEBUG "BurstDuration = %d", p->BurstDuration);
-	printk(KERN_DEBUG "BurstCycleTime = %d", p->BurstCycleTime);
-	printk(KERN_DEBUG "CalculatedBurstCycleTime = %d", p->CalculatedBurstCycleTime);
-	printk(KERN_DEBUG "NumOfRows = %d", p->NumOfRows);
-	printk(KERN_DEBUG "NumOfPaddCols = %d", p->NumOfPaddCols);
-	printk(KERN_DEBUG "NumOfPunctCols = %d", p->NumOfPunctCols);
-	printk(KERN_DEBUG "ErrorTSPackets = %d", p->ErrorTSPackets);
-	printk(KERN_DEBUG "TotalTSPackets = %d", p->TotalTSPackets);
-	printk(KERN_DEBUG "NumOfValidMpeTlbs = %d", p->NumOfValidMpeTlbs);
-	printk(KERN_DEBUG "NumOfInvalidMpeTlbs = %d", p->NumOfInvalidMpeTlbs);
-	printk(KERN_DEBUG "NumOfCorrectedMpeTlbs = %d", p->NumOfCorrectedMpeTlbs);
-	printk(KERN_DEBUG "BERErrorCount = %d", p->BERErrorCount);
-	printk(KERN_DEBUG "BERBitCount = %d", p->BERBitCount);
-	printk(KERN_DEBUG "SmsToHostTxErrors = %d", p->SmsToHostTxErrors);
-	printk(KERN_DEBUG "PreBER = %d", p->PreBER);
-	printk(KERN_DEBUG "CellId = %d", p->CellId);
-	printk(KERN_DEBUG "DvbhSrvIndHP = %d", p->DvbhSrvIndHP);
-	printk(KERN_DEBUG "DvbhSrvIndLP = %d", p->DvbhSrvIndLP);
-	printk(KERN_DEBUG "NumMPEReceived = %d", p->NumMPEReceived);
+	buf = client->stats_data;
+
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "IsRfLocked = %d\n", p->IsRfLocked);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "IsDemodLocked = %d\n", p->IsDemodLocked);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "IsExternalLNAOn = %d\n", p->IsExternalLNAOn);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "SNR = %d\n", p->SNR);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "BER = %d\n", p->BER);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "FIB_CRC = %d\n", p->FIB_CRC);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "TS_PER = %d\n", p->TS_PER);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "MFER = %d\n", p->MFER);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "RSSI = %d\n", p->RSSI);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "InBandPwr = %d\n", p->InBandPwr);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "CarrierOffset = %d\n", p->CarrierOffset);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "ModemState = %d\n", p->ModemState);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "Frequency = %d\n", p->Frequency);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "Bandwidth = %d\n", p->Bandwidth);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "TransmissionMode = %d\n", p->TransmissionMode);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "ModemState = %d\n", p->ModemState);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "GuardInterval = %d\n", p->GuardInterval);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "CodeRate = %d\n", p->CodeRate);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "LPCodeRate = %d\n", p->LPCodeRate);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "Hierarchy = %d\n", p->Hierarchy);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "Constellation = %d\n", p->Constellation);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "BurstSize = %d\n", p->BurstSize);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "BurstDuration = %d\n", p->BurstDuration);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "BurstCycleTime = %d\n", p->BurstCycleTime);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "CalculatedBurstCycleTime = %d\n",
+		      p->CalculatedBurstCycleTime);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "NumOfRows = %d\n", p->NumOfRows);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "NumOfPaddCols = %d\n", p->NumOfPaddCols);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "NumOfPunctCols = %d\n", p->NumOfPunctCols);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "ErrorTSPackets = %d\n", p->ErrorTSPackets);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "TotalTSPackets = %d\n", p->TotalTSPackets);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "NumOfValidMpeTlbs = %d\n", p->NumOfValidMpeTlbs);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "NumOfInvalidMpeTlbs = %d\n", p->NumOfInvalidMpeTlbs);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "NumOfCorrectedMpeTlbs = %d\n", p->NumOfCorrectedMpeTlbs);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "BERErrorCount = %d\n", p->BERErrorCount);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "BERBitCount = %d\n", p->BERBitCount);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "SmsToHostTxErrors = %d\n", p->SmsToHostTxErrors);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "PreBER = %d\n", p->PreBER);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "CellId = %d\n", p->CellId);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "DvbhSrvIndHP = %d\n", p->DvbhSrvIndHP);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "DvbhSrvIndLP = %d\n", p->DvbhSrvIndLP);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "NumMPEReceived = %d\n", p->NumMPEReceived);
+
+	atomic_set(&client->stats_count, n);
+	wake_up(&client->stats_queue);
 }
 
-static void smsdvb_print_isdb_stats(struct SMSHOSTLIB_STATISTICS_ISDBT_ST *p)
+static void smsdvb_print_isdb_stats(struct smsdvb_client_t *client,
+				    struct SMSHOSTLIB_STATISTICS_ISDBT_ST *p)
 {
-	int i;
+	int i, n = 0;
+	char *buf;
 
-	if (!(sms_dbg & 2))
+	if (!client->stats_data || atomic_read(&client->stats_count))
 		return;
 
-	printk(KERN_DEBUG "IsRfLocked = %d", p->IsRfLocked);
-	printk(KERN_DEBUG "IsDemodLocked = %d", p->IsDemodLocked);
-	printk(KERN_DEBUG "IsExternalLNAOn = %d", p->IsExternalLNAOn);
-	printk(KERN_DEBUG "SNR = %d", p->SNR);
-	printk(KERN_DEBUG "RSSI = %d", p->RSSI);
-	printk(KERN_DEBUG "InBandPwr = %d", p->InBandPwr);
-	printk(KERN_DEBUG "CarrierOffset = %d", p->CarrierOffset);
-	printk(KERN_DEBUG "Frequency = %d", p->Frequency);
-	printk(KERN_DEBUG "Bandwidth = %d", p->Bandwidth);
-	printk(KERN_DEBUG "TransmissionMode = %d", p->TransmissionMode);
-	printk(KERN_DEBUG "ModemState = %d", p->ModemState);
-	printk(KERN_DEBUG "GuardInterval = %d", p->GuardInterval);
-	printk(KERN_DEBUG "SystemType = %d", p->SystemType);
-	printk(KERN_DEBUG "PartialReception = %d", p->PartialReception);
-	printk(KERN_DEBUG "NumOfLayers = %d", p->NumOfLayers);
-	printk(KERN_DEBUG "SmsToHostTxErrors = %d", p->SmsToHostTxErrors);
+	buf = client->stats_data;
+
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "IsRfLocked = %d\t\t", p->IsRfLocked);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "IsDemodLocked = %d\t", p->IsDemodLocked);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "IsExternalLNAOn = %d\n", p->IsExternalLNAOn);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "SNR = %d dB\t\t", p->SNR);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "RSSI = %d dBm\t\t", p->RSSI);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "InBandPwr = %d dBm\n", p->InBandPwr);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "CarrierOffset = %d\t", p->CarrierOffset);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "Bandwidth = %d\t\t", p->Bandwidth);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "Frequency = %d Hz\n", p->Frequency);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "TransmissionMode = %d\t", p->TransmissionMode);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "ModemState = %d\t\t", p->ModemState);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "GuardInterval = %d\n", p->GuardInterval);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "SystemType = %d\t\t", p->SystemType);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "PartialReception = %d\t", p->PartialReception);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "NumOfLayers = %d\n", p->NumOfLayers);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "SmsToHostTxErrors = %d\n", p->SmsToHostTxErrors);
 
 	for (i = 0; i < 3; i++) {
-		printk(KERN_DEBUG "%d: CodeRate = %d", i, p->LayerInfo[i].CodeRate);
-		printk(KERN_DEBUG "%d: Constellation = %d", i, p->LayerInfo[i].Constellation);
-		printk(KERN_DEBUG "%d: BER = %d", i, p->LayerInfo[i].BER);
-		printk(KERN_DEBUG "%d: BERErrorCount = %d", i, p->LayerInfo[i].BERErrorCount);
-		printk(KERN_DEBUG "%d: BERBitCount = %d", i, p->LayerInfo[i].BERBitCount);
-		printk(KERN_DEBUG "%d: PreBER = %d", i, p->LayerInfo[i].PreBER);
-		printk(KERN_DEBUG "%d: TS_PER = %d", i, p->LayerInfo[i].TS_PER);
-		printk(KERN_DEBUG "%d: ErrorTSPackets = %d", i, p->LayerInfo[i].ErrorTSPackets);
-		printk(KERN_DEBUG "%d: TotalTSPackets = %d", i, p->LayerInfo[i].TotalTSPackets);
-		printk(KERN_DEBUG "%d: TILdepthI = %d", i, p->LayerInfo[i].TILdepthI);
-		printk(KERN_DEBUG "%d: NumberOfSegments = %d", i, p->LayerInfo[i].NumberOfSegments);
-		printk(KERN_DEBUG "%d: TMCCErrors = %d", i, p->LayerInfo[i].TMCCErrors);
+		if (p->LayerInfo[i].NumberOfSegments < 1 ||
+		    p->LayerInfo[i].NumberOfSegments > 13)
+			continue;
+
+		n += snprintf(&buf[n], PAGE_SIZE - n, "\nLayer %d\n", i);
+		n += snprintf(&buf[n], PAGE_SIZE - n, "\tCodeRate = %d\t",
+			      p->LayerInfo[i].CodeRate);
+		n += snprintf(&buf[n], PAGE_SIZE - n, "Constellation = %d\n",
+			      p->LayerInfo[i].Constellation);
+		n += snprintf(&buf[n], PAGE_SIZE - n, "\tBER = %-5d\t",
+			      p->LayerInfo[i].BER);
+		n += snprintf(&buf[n], PAGE_SIZE - n, "\tBERErrorCount = %-5d\t",
+			      p->LayerInfo[i].BERErrorCount);
+		n += snprintf(&buf[n], PAGE_SIZE - n, "BERBitCount = %-5d\n",
+			      p->LayerInfo[i].BERBitCount);
+		n += snprintf(&buf[n], PAGE_SIZE - n, "\tPreBER = %-5d\t",
+			      p->LayerInfo[i].PreBER);
+		n += snprintf(&buf[n], PAGE_SIZE - n, "\tTS_PER = %-5d\n",
+			      p->LayerInfo[i].TS_PER);
+		n += snprintf(&buf[n], PAGE_SIZE - n, "\tErrorTSPackets = %-5d\t",
+			      p->LayerInfo[i].ErrorTSPackets);
+		n += snprintf(&buf[n], PAGE_SIZE - n, "TotalTSPackets = %-5d\t",
+			      p->LayerInfo[i].TotalTSPackets);
+		n += snprintf(&buf[n], PAGE_SIZE - n, "TILdepthI = %d\n",
+			      p->LayerInfo[i].TILdepthI);
+		n += snprintf(&buf[n], PAGE_SIZE - n,
+			      "\tNumberOfSegments = %d\t",
+			      p->LayerInfo[i].NumberOfSegments);
+		n += snprintf(&buf[n], PAGE_SIZE - n, "TMCCErrors = %d\n",
+			      p->LayerInfo[i].TMCCErrors);
 	}
+
+	atomic_set(&client->stats_count, n);
+	wake_up(&client->stats_queue);
 }
 
 static void
-smsdvb_print_isdb_stats_ex(struct SMSHOSTLIB_STATISTICS_ISDBT_EX_ST *p)
+smsdvb_print_isdb_stats_ex(struct smsdvb_client_t *client,
+			   struct SMSHOSTLIB_STATISTICS_ISDBT_EX_ST *p)
 {
-	int i;
+	int i, n = 0;
+	char *buf;
 
-	if (!(sms_dbg & 2))
+	if (!client->stats_data || atomic_read(&client->stats_count))
 		return;
 
-	printk(KERN_DEBUG "IsRfLocked = %d", p->IsRfLocked);
-	printk(KERN_DEBUG "IsDemodLocked = %d", p->IsDemodLocked);
-	printk(KERN_DEBUG "IsExternalLNAOn = %d", p->IsExternalLNAOn);
-	printk(KERN_DEBUG "SNR = %d", p->SNR);
-	printk(KERN_DEBUG "RSSI = %d", p->RSSI);
-	printk(KERN_DEBUG "InBandPwr = %d", p->InBandPwr);
-	printk(KERN_DEBUG "CarrierOffset = %d", p->CarrierOffset);
-	printk(KERN_DEBUG "Frequency = %d", p->Frequency);
-	printk(KERN_DEBUG "Bandwidth = %d", p->Bandwidth);
-	printk(KERN_DEBUG "TransmissionMode = %d", p->TransmissionMode);
-	printk(KERN_DEBUG "ModemState = %d", p->ModemState);
-	printk(KERN_DEBUG "GuardInterval = %d", p->GuardInterval);
-	printk(KERN_DEBUG "SystemType = %d", p->SystemType);
-	printk(KERN_DEBUG "PartialReception = %d", p->PartialReception);
-	printk(KERN_DEBUG "NumOfLayers = %d", p->NumOfLayers);
-	printk(KERN_DEBUG "SegmentNumber = %d", p->SegmentNumber);
-	printk(KERN_DEBUG "TuneBW = %d", p->TuneBW);
+	buf = client->stats_data;
+
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "IsRfLocked = %d\t\t", p->IsRfLocked);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "IsDemodLocked = %d\t", p->IsDemodLocked);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "IsExternalLNAOn = %d\n", p->IsExternalLNAOn);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "SNR = %d dB\t\t", p->SNR);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "RSSI = %d dBm\t\t", p->RSSI);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "InBandPwr = %d dBm\n", p->InBandPwr);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "CarrierOffset = %d\t", p->CarrierOffset);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "Bandwidth = %d\t\t", p->Bandwidth);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "Frequency = %d Hz\n", p->Frequency);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "TransmissionMode = %d\t", p->TransmissionMode);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "ModemState = %d\t\t", p->ModemState);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "GuardInterval = %d\n", p->GuardInterval);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "SystemType = %d\t\t", p->SystemType);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "PartialReception = %d\t", p->PartialReception);
+	n += snprintf(&buf[n], PAGE_SIZE - n,
+		      "NumOfLayers = %d\n", p->NumOfLayers);
+	n += snprintf(&buf[n], PAGE_SIZE - n, "SegmentNumber = %d\t",
+		      p->SegmentNumber);
+	n += snprintf(&buf[n], PAGE_SIZE - n, "TuneBW = %d\n",
+		      p->TuneBW);
 
 	for (i = 0; i < 3; i++) {
-		printk(KERN_DEBUG "%d: CodeRate = %d", i, p->LayerInfo[i].CodeRate);
-		printk(KERN_DEBUG "%d: Constellation = %d", i, p->LayerInfo[i].Constellation);
-		printk(KERN_DEBUG "%d: BER = %d", i, p->LayerInfo[i].BER);
-		printk(KERN_DEBUG "%d: BERErrorCount = %d", i, p->LayerInfo[i].BERErrorCount);
-		printk(KERN_DEBUG "%d: BERBitCount = %d", i, p->LayerInfo[i].BERBitCount);
-		printk(KERN_DEBUG "%d: PreBER = %d", i, p->LayerInfo[i].PreBER);
-		printk(KERN_DEBUG "%d: TS_PER = %d", i, p->LayerInfo[i].TS_PER);
-		printk(KERN_DEBUG "%d: ErrorTSPackets = %d", i, p->LayerInfo[i].ErrorTSPackets);
-		printk(KERN_DEBUG "%d: TotalTSPackets = %d", i, p->LayerInfo[i].TotalTSPackets);
-		printk(KERN_DEBUG "%d: TILdepthI = %d", i, p->LayerInfo[i].TILdepthI);
-		printk(KERN_DEBUG "%d: NumberOfSegments = %d", i, p->LayerInfo[i].NumberOfSegments);
-		printk(KERN_DEBUG "%d: TMCCErrors = %d", i, p->LayerInfo[i].TMCCErrors);
+		if (p->LayerInfo[i].NumberOfSegments < 1 ||
+		    p->LayerInfo[i].NumberOfSegments > 13)
+			continue;
+
+		n += snprintf(&buf[n], PAGE_SIZE - n, "\nLayer %d\n", i);
+		n += snprintf(&buf[n], PAGE_SIZE - n, "\tCodeRate = %d\t",
+			      p->LayerInfo[i].CodeRate);
+		n += snprintf(&buf[n], PAGE_SIZE - n, "Constellation = %d\n",
+			      p->LayerInfo[i].Constellation);
+		n += snprintf(&buf[n], PAGE_SIZE - n, "\tBER = %-5d\t",
+			      p->LayerInfo[i].BER);
+		n += snprintf(&buf[n], PAGE_SIZE - n, "\tBERErrorCount = %-5d\t",
+			      p->LayerInfo[i].BERErrorCount);
+		n += snprintf(&buf[n], PAGE_SIZE - n, "BERBitCount = %-5d\n",
+			      p->LayerInfo[i].BERBitCount);
+		n += snprintf(&buf[n], PAGE_SIZE - n, "\tPreBER = %-5d\t",
+			      p->LayerInfo[i].PreBER);
+		n += snprintf(&buf[n], PAGE_SIZE - n, "\tTS_PER = %-5d\n",
+			      p->LayerInfo[i].TS_PER);
+		n += snprintf(&buf[n], PAGE_SIZE - n, "\tErrorTSPackets = %-5d\t",
+			      p->LayerInfo[i].ErrorTSPackets);
+		n += snprintf(&buf[n], PAGE_SIZE - n, "TotalTSPackets = %-5d\t",
+			      p->LayerInfo[i].TotalTSPackets);
+		n += snprintf(&buf[n], PAGE_SIZE - n, "TILdepthI = %d\n",
+			      p->LayerInfo[i].TILdepthI);
+		n += snprintf(&buf[n], PAGE_SIZE - n,
+			      "\tNumberOfSegments = %d\t",
+			      p->LayerInfo[i].NumberOfSegments);
+		n += snprintf(&buf[n], PAGE_SIZE - n, "TMCCErrors = %d\n",
+			      p->LayerInfo[i].TMCCErrors);
+	}
+
+	atomic_set(&client->stats_count, n);
+	wake_up(&client->stats_queue);
+}
+
+static int smsdvb_stats_open(struct inode *inode, struct file *file)
+{
+	struct smsdvb_client_t *client = inode->i_private;
+
+	atomic_set(&client->stats_count, 0);
+	client->stats_was_read = false;
+
+	init_waitqueue_head(&client->stats_queue);
+
+	client->stats_data = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	if (client->stats_data == NULL)
+		return -ENOMEM;
+
+	file->private_data = client;
+
+	return 0;
+}
+
+static ssize_t smsdvb_stats_read(struct file *file, char __user *user_buf,
+				      size_t nbytes, loff_t *ppos)
+{
+	struct smsdvb_client_t *client = file->private_data;
+
+	if (!client->stats_data || client->stats_was_read)
+		return 0;
+
+	wait_event_interruptible(client->stats_queue,
+				 atomic_read(&client->stats_count));
+
+	return simple_read_from_buffer(user_buf, nbytes, ppos,
+				       client->stats_data,
+				       atomic_read(&client->stats_count));
+
+	client->stats_was_read = true;
+}
+
+static int smsdvb_stats_release(struct inode *inode, struct file *file)
+{
+	struct smsdvb_client_t *client = file->private_data;
+
+	kfree(client->stats_data);
+	client->stats_data = NULL;
+
+	return 0;
+}
+
+static const struct file_operations debugfs_stats_ops = {
+	.open = smsdvb_stats_open,
+	.read = smsdvb_stats_read,
+	.release = smsdvb_stats_release,
+	.llseek = generic_file_llseek,
+};
+
+static int create_stats_debugfs(struct smsdvb_client_t *client)
+{
+	struct smscore_device_t *coredev = client->coredev;
+	struct dentry *d;
+
+	if (!smsdvb_debugfs)
+		return -ENODEV;
+
+	client->debugfs = debugfs_create_dir(coredev->devpath, smsdvb_debugfs);
+	if (IS_ERR_OR_NULL(client->debugfs)) {
+		sms_info("Unable to create debugfs %s directory.\n",
+			 coredev->devpath);
+		return -ENODEV;
 	}
+
+	d = debugfs_create_file("stats", S_IRUGO | S_IWUSR, client->debugfs,
+				client, &debugfs_stats_ops);
+	if (!d) {
+		debugfs_remove(client->debugfs);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static void release_stats_debugfs(struct smsdvb_client_t *client)
+{
+	if (!client->debugfs)
+		return;
+
+	debugfs_remove_recursive(client->debugfs);
+
+	client->debugfs = NULL;
 }
 
 /* Events that may come from DVB v3 adapter */
@@ -476,7 +708,7 @@ static void smsdvb_update_dvb_stats(struct smsdvb_client_t *client,
 	struct dvb_frontend *fe = &client->frontend;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 
-	smsdvb_print_dvb_stats(p);
+	smsdvb_print_dvb_stats(client, p);
 
 	client->fe_status = sms_to_status(p->IsDemodLocked, p->IsRfLocked);
 
@@ -526,7 +758,7 @@ static void smsdvb_update_isdbt_stats(struct smsdvb_client_t *client,
 	struct SMSHOSTLIB_ISDBT_LAYER_STAT_ST *lr;
 	int i, n_layers;
 
-	smsdvb_print_isdb_stats(p);
+	smsdvb_print_isdb_stats(client, p);
 
 	/* Update ISDB-T transmission parameters */
 	c->frequency = p->Frequency;
@@ -602,7 +834,7 @@ static void smsdvb_update_isdbt_stats_ex(struct smsdvb_client_t *client,
 	struct SMSHOSTLIB_ISDBT_LAYER_STAT_ST *lr;
 	int i, n_layers;
 
-	smsdvb_print_isdb_stats_ex(p);
+	smsdvb_print_isdb_stats_ex(client, p);
 
 	/* Update ISDB-T transmission parameters */
 	c->frequency = p->Frequency;
@@ -766,6 +998,7 @@ static void smsdvb_unregister_client(struct smsdvb_client_t *client)
 
 	list_del(&client->entry);
 
+	release_stats_debugfs(client);
 	smscore_unregister_client(client->smsclient);
 	dvb_unregister_frontend(&client->frontend);
 	dvb_dmxdev_release(&client->dmxdev);
@@ -1303,6 +1536,9 @@ static int smsdvb_hotplug(struct smscore_device_t *coredev,
 	sms_info("success");
 	sms_board_setup(coredev);
 
+	if (create_stats_debugfs(client) < 0)
+		sms_info("failed to create debugfs node");
+
 	return 0;
 
 client_error:
@@ -1325,10 +1561,17 @@ adapter_error:
 static int __init smsdvb_module_init(void)
 {
 	int rc;
+	struct dentry *d;
 
 	INIT_LIST_HEAD(&g_smsdvb_clients);
 	kmutex_init(&g_smsdvb_clientslock);
 
+	d = debugfs_create_dir("smsdvb", usb_debug_root);
+	if (IS_ERR_OR_NULL(d))
+		sms_err("Couldn't create sysfs node for smsdvb");
+	else
+		smsdvb_debugfs = d;
+
 	rc = smscore_register_hotplug(smsdvb_hotplug);
 
 	sms_debug("");
@@ -1346,6 +1589,9 @@ static void __exit smsdvb_module_exit(void)
 	       smsdvb_unregister_client(
 			(struct smsdvb_client_t *) g_smsdvb_clients.next);
 
+	if (smsdvb_debugfs)
+		debugfs_remove_recursive(smsdvb_debugfs);
+
 	kmutex_unlock(&g_smsdvb_clientslock);
 }
 
-- 
1.8.1.4

