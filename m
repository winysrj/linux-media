Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10788 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755650Ab3CUNCu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Mar 2013 09:02:50 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r2LD2o32009579
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 21 Mar 2013 09:02:50 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/6] siano: convert structure names to lowercase
Date: Thu, 21 Mar 2013 10:02:39 -0300
Message-Id: <1363870963-28552-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363870963-28552-1-git-send-email-mchehab@redhat.com>
References: <1363870963-28552-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several structures defined in uppercase. Convert them
to lowercase, and simplify their names, when possible.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/siano/smscoreapi.h     | 52 ++++++++++++++---------------
 drivers/media/common/siano/smsdvb-debugfs.c |  6 ++--
 drivers/media/common/siano/smsdvb-main.c    | 12 +++----
 drivers/media/common/siano/smsdvb.h         |  9 ++---
 4 files changed, 40 insertions(+), 39 deletions(-)

diff --git a/drivers/media/common/siano/smscoreapi.h b/drivers/media/common/siano/smscoreapi.h
index 4b0cd7d..b65232a 100644
--- a/drivers/media/common/siano/smscoreapi.h
+++ b/drivers/media/common/siano/smscoreapi.h
@@ -676,7 +676,7 @@ struct sms_firmware {
 
 /* statistics information returned as response for
  * SmsHostApiGetstatistics_Req */
-struct SMSHOSTLIB_STATISTICS_ST {
+struct sms_stats {
 	u32 reserved;		/* reserved */
 
 	/* Common parameters */
@@ -764,7 +764,7 @@ struct SMSHOSTLIB_STATISTICS_ST {
 struct sms_msg_statistics_info {
 	u32 request_result;
 
-	struct SMSHOSTLIB_STATISTICS_ST stat;
+	struct sms_stats stat;
 
 	/* Split the calc of the SNR in DAB */
 	u32 signal; /* dB */
@@ -772,7 +772,7 @@ struct sms_msg_statistics_info {
 
 };
 
-struct SMSHOSTLIB_ISDBT_LAYER_STAT_ST {
+struct sms_isdbt_layer_stats {
 	/* Per-layer information */
 	u32 code_rate; /* Code Rate from SMSHOSTLIB_CODE_RATE_ET,
 		       * 255 means layer does not exist */
@@ -792,7 +792,7 @@ struct SMSHOSTLIB_ISDBT_LAYER_STAT_ST {
 	u32 tmcc_errors; /* TMCC errors */
 };
 
-struct SMSHOSTLIB_STATISTICS_ISDBT_ST {
+struct sms_isdbt_stats {
 	u32 statistics_type; /* Enumerator identifying the type of the
 				* structure.  Values are the same as
 				* SMSHOSTLIB_DEVICE_MODES_E
@@ -827,14 +827,14 @@ struct SMSHOSTLIB_STATISTICS_ISDBT_ST {
 
 	/* Per-layer information */
 	/* Layers A, B and C */
-	struct SMSHOSTLIB_ISDBT_LAYER_STAT_ST	LayerInfo[3];
-	/* Per-layer statistics, see SMSHOSTLIB_ISDBT_LAYER_STAT_ST */
+	struct sms_isdbt_layer_stats	LayerInfo[3];
+	/* Per-layer statistics, see sms_isdbt_layer_stats */
 
 	/* Interface information */
 	u32 sms_to_host_tx_errors; /* Total number of transmission errors. */
 };
 
-struct SMSHOSTLIB_STATISTICS_ISDBT_EX_ST {
+struct sms_isdbt_stats_ex {
 	u32 statistics_type; /* Enumerator identifying the type of the
 				* structure.  Values are the same as
 				* SMSHOSTLIB_DEVICE_MODES_E
@@ -872,8 +872,8 @@ struct SMSHOSTLIB_STATISTICS_ISDBT_EX_ST {
 
 	/* Per-layer information */
 	/* Layers A, B and C */
-	struct SMSHOSTLIB_ISDBT_LAYER_STAT_ST	LayerInfo[3];
-	/* Per-layer statistics, see SMSHOSTLIB_ISDBT_LAYER_STAT_ST */
+	struct sms_isdbt_layer_stats	LayerInfo[3];
+	/* Per-layer statistics, see sms_isdbt_layer_stats */
 
 	/* Interface information */
 	u32 reserved1;    /* Was sms_to_host_tx_errors - obsolete . */
@@ -894,7 +894,7 @@ struct SMSHOSTLIB_STATISTICS_ISDBT_EX_ST {
 };
 
 
-struct PID_STATISTICS_DATA_S {
+struct sms_pid_stats_data {
 	struct PID_BURST_S {
 		u32 size;
 		u32 padding_cols;
@@ -909,10 +909,10 @@ struct PID_STATISTICS_DATA_S {
 	u32 tot_cor_tbl;
 };
 
-struct PID_DATA_S {
+struct sms_pid_data {
 	u32 pid;
 	u32 num_rows;
-	struct PID_STATISTICS_DATA_S pid_statistics;
+	struct sms_pid_stats_data pid_statistics;
 };
 
 #define CORRECT_STAT_RSSI(_stat) ((_stat).RSSI *= -1)
@@ -925,7 +925,7 @@ struct PID_DATA_S {
 		else \
 			_stat.transmission_mode = 4;
 
-struct TRANSMISSION_STATISTICS_S {
+struct sms_tx_stats {
 	u32 frequency;		/* frequency in Hz */
 	u32 bandwidth;		/* bandwidth in MHz */
 	u32 transmission_mode;	/* FFT mode carriers in Kilos */
@@ -948,7 +948,7 @@ struct TRANSMISSION_STATISTICS_S {
 	u32 is_demod_locked;	/* 0 - not locked, 1 - locked */
 };
 
-struct RECEPTION_STATISTICS_S {
+struct sms_rx_stats {
 	u32 is_rf_locked;		/* 0 - not locked, 1 - locked */
 	u32 is_demod_locked;	/* 0 - not locked, 1 - locked */
 	u32 is_external_lna_on;	/* 0 - external LNA off, 1 - external LNA on */
@@ -974,7 +974,7 @@ struct RECEPTION_STATISTICS_S {
 	s32 mrc_in_band_pwr;	/* In band power in dBM */
 };
 
-struct RECEPTION_STATISTICS_EX_S {
+struct sms_rx_stats_ex {
 	u32 is_rf_locked;		/* 0 - not locked, 1 - locked */
 	u32 is_demod_locked;	/* 0 - not locked, 1 - locked */
 	u32 is_external_lna_on;	/* 0 - external LNA off, 1 - external LNA on */
@@ -1006,33 +1006,33 @@ struct RECEPTION_STATISTICS_EX_S {
 
 /* statistics information returned as response for
  * SmsHostApiGetstatisticsEx_Req for DVB applications, SMS1100 and up */
-struct SMSHOSTLIB_STATISTICS_DVB_S {
+struct sms_stats_dvb {
 	/* Reception */
-	struct RECEPTION_STATISTICS_S reception_data;
+	struct sms_rx_stats reception_data;
 
 	/* Transmission parameters */
-	struct TRANSMISSION_STATISTICS_S transmission_data;
+	struct sms_tx_stats transmission_data;
 
 	/* Burst parameters, valid only for DVB-H */
 #define	SRVM_MAX_PID_FILTERS 8
-	struct PID_DATA_S pid_data[SRVM_MAX_PID_FILTERS];
+	struct sms_pid_data pid_data[SRVM_MAX_PID_FILTERS];
 };
 
 /* statistics information returned as response for
  * SmsHostApiGetstatisticsEx_Req for DVB applications, SMS1100 and up */
-struct SMSHOSTLIB_STATISTICS_DVB_EX_S {
+struct sms_stats_dvb_ex {
 	/* Reception */
-	struct RECEPTION_STATISTICS_EX_S reception_data;
+	struct sms_rx_stats_ex reception_data;
 
 	/* Transmission parameters */
-	struct TRANSMISSION_STATISTICS_S transmission_data;
+	struct sms_tx_stats transmission_data;
 
 	/* Burst parameters, valid only for DVB-H */
 #define	SRVM_MAX_PID_FILTERS 8
-	struct PID_DATA_S pid_data[SRVM_MAX_PID_FILTERS];
+	struct sms_pid_data pid_data[SRVM_MAX_PID_FILTERS];
 };
 
-struct SRVM_SIGNAL_STATUS_S {
+struct sms_srvm_signal_status {
 	u32 result;
 	u32 snr;
 	u32 ts_packets;
@@ -1048,14 +1048,14 @@ struct SRVM_SIGNAL_STATUS_S {
 	u32 request_id;
 };
 
-struct SMSHOSTLIB_I2C_REQ_ST {
+struct sms_i2c_req {
 	u32	device_address; /* I2c device address */
 	u32	write_count; /* number of bytes to write */
 	u32	read_count; /* number of bytes to read */
 	u8	Data[1];
 };
 
-struct SMSHOSTLIB_I2C_RES_ST {
+struct sms_i2c_res {
 	u32	status; /* non-zero value in case of failure */
 	u32	read_count; /* number of bytes read */
 	u8	Data[1];
diff --git a/drivers/media/common/siano/smsdvb-debugfs.c b/drivers/media/common/siano/smsdvb-debugfs.c
index 5a28506..f63121c 100644
--- a/drivers/media/common/siano/smsdvb-debugfs.c
+++ b/drivers/media/common/siano/smsdvb-debugfs.c
@@ -49,7 +49,7 @@ struct smsdvb_debugfs {
 };
 
 void smsdvb_print_dvb_stats(struct smsdvb_debugfs *debug_data,
-			    struct SMSHOSTLIB_STATISTICS_ST *p)
+			    struct sms_stats *p)
 {
 	int n = 0;
 	char *buf;
@@ -152,7 +152,7 @@ void smsdvb_print_dvb_stats(struct smsdvb_debugfs *debug_data,
 }
 
 void smsdvb_print_isdb_stats(struct smsdvb_debugfs *debug_data,
-			     struct SMSHOSTLIB_STATISTICS_ISDBT_ST *p)
+			     struct sms_isdbt_stats *p)
 {
 	int i, n = 0;
 	char *buf;
@@ -242,7 +242,7 @@ void smsdvb_print_isdb_stats(struct smsdvb_debugfs *debug_data,
 }
 
 void smsdvb_print_isdb_stats_ex(struct smsdvb_debugfs *debug_data,
-				struct SMSHOSTLIB_STATISTICS_ISDBT_EX_ST *p)
+				struct sms_isdbt_stats_ex *p)
 {
 	int i, n = 0;
 	char *buf;
diff --git a/drivers/media/common/siano/smsdvb-main.c b/drivers/media/common/siano/smsdvb-main.c
index cec85fe..29d1c41 100644
--- a/drivers/media/common/siano/smsdvb-main.c
+++ b/drivers/media/common/siano/smsdvb-main.c
@@ -223,7 +223,7 @@ static inline u32 sms_to_bw(u32 value)
 			   FEC_NONE);
 
 static void smsdvb_update_tx_params(struct smsdvb_client_t *client,
-				    struct TRANSMISSION_STATISTICS_S *p)
+				    struct sms_tx_stats *p)
 {
 	struct dvb_frontend *fe = &client->frontend;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
@@ -277,7 +277,7 @@ static void smsdvb_update_per_slices(struct smsdvb_client_t *client,
 }
 
 static void smsdvb_update_dvb_stats(struct smsdvb_client_t *client,
-				    struct SMSHOSTLIB_STATISTICS_ST *p)
+				    struct sms_stats *p)
 {
 	struct dvb_frontend *fe = &client->frontend;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
@@ -329,11 +329,11 @@ static void smsdvb_update_dvb_stats(struct smsdvb_client_t *client,
 };
 
 static void smsdvb_update_isdbt_stats(struct smsdvb_client_t *client,
-				      struct SMSHOSTLIB_STATISTICS_ISDBT_ST *p)
+				      struct sms_isdbt_stats *p)
 {
 	struct dvb_frontend *fe = &client->frontend;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	struct SMSHOSTLIB_ISDBT_LAYER_STAT_ST *lr;
+	struct sms_isdbt_layer_stats *lr;
 	int i, n_layers;
 
 	if (client->prt_isdb_stats)
@@ -425,11 +425,11 @@ static void smsdvb_update_isdbt_stats(struct smsdvb_client_t *client,
 }
 
 static void smsdvb_update_isdbt_stats_ex(struct smsdvb_client_t *client,
-					 struct SMSHOSTLIB_STATISTICS_ISDBT_EX_ST *p)
+					 struct sms_isdbt_stats_ex *p)
 {
 	struct dvb_frontend *fe = &client->frontend;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	struct SMSHOSTLIB_ISDBT_LAYER_STAT_ST *lr;
+	struct sms_isdbt_layer_stats *lr;
 	int i, n_layers;
 
 	if (client->prt_isdb_stats_ex)
diff --git a/drivers/media/common/siano/smsdvb.h b/drivers/media/common/siano/smsdvb.h
index e1ff07c..513f853 100644
--- a/drivers/media/common/siano/smsdvb.h
+++ b/drivers/media/common/siano/smsdvb.h
@@ -19,14 +19,14 @@ struct smsdvb_debugfs;
 struct smsdvb_client_t;
 
 typedef void (*sms_prt_dvb_stats_t)(struct smsdvb_debugfs *debug_data,
-				    struct SMSHOSTLIB_STATISTICS_ST *p);
+				    struct sms_stats *p);
 
 typedef void (*sms_prt_isdb_stats_t)(struct smsdvb_debugfs *debug_data,
-				     struct SMSHOSTLIB_STATISTICS_ISDBT_ST *p);
+				     struct sms_isdbt_stats *p);
 
 typedef void (*sms_prt_isdb_stats_ex_t)
 			(struct smsdvb_debugfs *debug_data,
-			 struct SMSHOSTLIB_STATISTICS_ISDBT_EX_ST *p);
+			 struct sms_isdbt_stats_ex *p);
 
 
 struct smsdvb_client_t {
@@ -68,7 +68,8 @@ struct smsdvb_client_t {
 };
 
 /*
- * This struct is a mix of RECEPTION_STATISTICS_EX_S and SRVM_SIGNAL_STATUS_S.
+ * This struct is a mix of struct sms_rx_stats_ex and
+ * struct sms_srvm_signal_status.
  * It was obtained by comparing the way it was filled by the original code
  */
 struct RECEPTION_STATISTICS_PER_SLICES_S {
-- 
1.8.1.4

