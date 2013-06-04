Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:64738 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab3FDTPK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Jun 2013 15:15:10 -0400
Received: by mail-we0-f179.google.com with SMTP id w59so578160wes.10
        for <linux-media@vger.kernel.org>; Tue, 04 Jun 2013 12:15:09 -0700 (PDT)
From: Konke Radlow <koradlow@gmail.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, hdegoede@redhat.com
Subject: [RFC PATCHv2 1/3] libv4l2rds: support RDS-EON and TMC-tuning info
Date: Tue,  4 Jun 2013 20:15:01 +0100
Message-Id: <2668df294d662dbf33ebae87bc06fd063ea4cfd2.1370373234.git.koradlow@gmail.com>
In-Reply-To: <1370373303-6605-1-git-send-email-koradlow@gmail.com>
References: <1370373303-6605-1-git-send-email-koradlow@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Konke Radlow <koradlow@gmail.com>

libv4l2rds: added support to decode RDS-EON information

Signed-off-by: Konke Radlow <koradlow@gmail.com>

libv4l2rds: added support to decode RDS-TMC tuning information

Signed-off-by: Konke Radlow <koradlow@gmail.com>

libv4l2rds.c: fixing compiler warnings due to missing pointer dereferencing
and implementing changes proposed in RFC replies (RDS-EON patch)

Signed-off-by: Konke Radlow <koradlow@gmail.com>

libv4l2rds: implementing changes proposed in RFC replies (TMC-Tuning patch)

Signed-off-by: Konke Radlow <koradlow@gmail.com>
---
 lib/include/libv4l2rds.h    |   79 +++++++++-
 lib/libv4l2rds/libv4l2rds.c |  363 ++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 417 insertions(+), 25 deletions(-)

diff --git a/lib/include/libv4l2rds.h b/lib/include/libv4l2rds.h
index 6a6c7f3..e1078de 100644
--- a/lib/include/libv4l2rds.h
+++ b/lib/include/libv4l2rds.h
@@ -37,7 +37,7 @@ extern "C" {
 #endif
 
 /* used to define the current version (version field) of the v4l2_rds struct */
-#define V4L2_RDS_VERSION (1)
+#define V4L2_RDS_VERSION (2)
 
 /* Constants used to define the size of arrays used to store RDS information */
 #define MAX_ODA_CNT 18 	/* there are 16 groups each with type a or b. Of these
@@ -50,6 +50,16 @@ extern "C" {
 			* Additional data is limited to 112 bit, and the smallest
 			* optional tuple has a size of 4 bit (4 bit identifier +
 			* 0 bits of data) */
+#define MAX_TMC_ALT_STATIONS 32 /* defined by ISO 14819-1:2003, 7.5.3.3  */
+#define MAX_TMC_AF_CNT 4	/* limit for the numbers of AFs stored per alternative TMC
+			* station. This value is not defined by the standard, but based on observation
+			* of real-world RDS-TMC streams. The maximum encountered number of AFs per
+			* station during testing was 2 */
+#define MAX_EON_CNT 20	/* Maximal number of entries in the EON table (for storing
+			* information about other radio stations, broadcasted by the current station). 
+			* This value is not defined by the standard, but based on observation
+			* of real-world RDS-TMC streams. EON doesn't seem to be a widely used feature
+			* and the maximum number of EON encountered during testing was 8 */
 
 /* Define Constants for the possible types of RDS information
  * used to address the relevant bit in the valid_fields bitmask */
@@ -69,7 +79,10 @@ extern "C" {
 #define V4L2_RDS_LC		0x2000	/* Language Code */
 #define V4L2_RDS_TMC_SG		0x4000	/* RDS-TMC single group */
 #define V4L2_RDS_TMC_MG		0x8000	/* RDS-TMC multi group */
-#define V4L2_RDS_TMC_SYS	0x10000 /* RDS-TMC system information */
+#define V4L2_RDS_TMC_SYS	0x10000	/* RDS-TMC system information */
+#define V4L2_RDS_EON		0x20000	/* Enhanced Other Network Info */
+#define V4L2_RDS_LSF		0x40000	/* Linkage information */
+#define V4L2_RDS_TMC_TUNING	0x80000	/* RDS-TMC tuning information */
 
 /* Define Constants for the state of the RDS decoding process
  * used to address the relevant bit in the decode_information bitmask */
@@ -84,9 +97,10 @@ extern "C" {
 #define V4L2_RDS_FLAG_STATIC_PTY	0x08
 
 /* TMC related codes
- * used to extract TMC fields from RDS groups */
-#define V4L2_TMC_TUNING_INFO	0x08
-#define V4L2_TMC_SINGLE_GROUP	0x04
+ * used to extract TMC fields from RDS-TMC groups
+ * see ISO 14819-1:2003, Figure 2 - RDS-TMC single-grp full message structure */
+#define V4L2_TMC_TUNING_INFO	0x10	/* Bit 4 indicates Tuning Info / User msg */
+#define V4L2_TMC_SINGLE_GROUP	0x08	/* Bit 3 indicates Single / Multi-group msg */
 
 /* struct to encapsulate one complete RDS group */
 /* This structure is used internally to store data until a complete RDS
@@ -149,6 +163,57 @@ struct v4l2_rds_af_set {
 	uint32_t af[MAX_AF_CNT];	/* AFs defined in Hz */
 };
 
+/* struct to encapsulate one entry in the EON table (Enhanced Other Network) */
+struct v4l2_rds_eon {
+	uint32_t valid_fields;
+	uint16_t pi;
+	uint8_t ps[9];
+	uint8_t pty;
+	bool ta;
+	bool tp;
+	uint16_t lsf;		/* Linkage Set Number */
+	struct v4l2_rds_af_set af;
+};
+
+/* struct to encapsulate a table of EON information */
+struct v4l2_rds_eon_set {
+	uint8_t size;		/* size of the table */
+	uint8_t index;		/* current position in the table */
+	struct v4l2_rds_eon eon[MAX_EON_CNT];	/* Information about other
+						 * radio channels */
+};
+
+/* struct to encapsulate alternative frequencies (AFs) for RDS-TMC stations.
+ * AFs listed in af[] can be used unconditionally. 
+ * AFs listed in mapped_af[n] should only be used if the current 
+ * tuner frequency matches the value in mapped_af_tuning[n] */
+struct v4l2_tmc_alt_freq {
+	uint8_t af_size;		/* number of known AFs */
+	uint8_t af_index;
+	uint8_t mapped_af_size;		/* number of mapped AFs */
+	uint8_t mapped_af_index;
+	uint32_t af[MAX_TMC_AF_CNT];		/* AFs defined in Hz */
+	uint32_t mapped_af[MAX_TMC_AF_CNT];		/* mapped AFs defined in Hz */
+	uint32_t mapped_af_tuning[MAX_TMC_AF_CNT];	/* mapped AFs defined in Hz */
+};
+
+/* struct to encapsulate information about stations carrying RDS-TMC services */
+struct v4l2_tmc_station {
+	uint16_t pi;
+	uint8_t ltn;	/* database-ID of ON */
+	uint8_t msg;	/* msg parameters of ON */
+	uint8_t sid;	/* service-ID of ON */
+	struct v4l2_tmc_alt_freq afi;
+};
+
+/* struct to encapsulate tuning information for TMC */
+struct v4l2_tmc_tuning {
+	uint8_t station_cnt;	/* number of announced alternative stations */
+	uint8_t index;
+	struct v4l2_tmc_station station[MAX_TMC_ALT_STATIONS];	/* information
+							* about other stations carrying the same RDS-TMC service */
+};
+
 /* struct to encapsulate an additional data field in a TMC message */
 struct v4l2_tmc_additional {
 	uint8_t label;
@@ -199,6 +264,9 @@ struct v4l2_rds_tmc {
 	uint8_t t_d;		/* delay time (only if mode = enhanced */
 	uint8_t spn[9];		/* service provider name */
 	struct v4l2_rds_tmc_msg tmc_msg;
+
+	/* tuning information for alternative service providers */
+	struct v4l2_tmc_tuning tuning;
 };
 
 /* struct to encapsulate state and RDS information for current decoding process */
@@ -236,6 +304,7 @@ struct v4l2_rds {
 	struct v4l2_rds_statistics rds_statistics;
 	struct v4l2_rds_oda_set rds_oda;	/* Open Data Services */
 	struct v4l2_rds_af_set rds_af; 		/* Alternative Frequencies */
+	struct v4l2_rds_eon_set rds_eon;	/* EON information */
 	struct v4l2_rds_tmc tmc;		/* TMC information */
 };
 
diff --git a/lib/libv4l2rds/libv4l2rds.c b/lib/libv4l2rds/libv4l2rds.c
index 2918061..28b78ce 100644
--- a/lib/libv4l2rds/libv4l2rds.c
+++ b/lib/libv4l2rds/libv4l2rds.c
@@ -92,6 +92,11 @@ enum rds_state {
 	RDS_C_RECEIVED,
 };
 
+/* function declarations to prevent the need to move large code blocks */
+static int rds_add_tmc_station(struct rds_private_state *priv_state, uint16_t pi);
+static uint32_t rds_decode_af(uint8_t af, bool is_vhf);
+static bool rds_add_tmc_af(struct rds_private_state *priv_state);
+
 static inline uint8_t set_bit(uint8_t input, uint8_t bitmask, bool bitvalue)
 {
 	return bitvalue ? input | bitmask : input & ~bitmask;
@@ -368,7 +373,7 @@ static uint32_t rds_decode_tmc_multi_group(struct rds_private_state *priv_state)
 	/* bit 15 of block 3 is the first group indicator */
 	if (grp->data_c_msb & 0x80) {
 		/* begine decoding of new message */
-		memset(msg, 0, sizeof(msg));
+		memset(msg, 0, sizeof(*msg));
 		memset(priv_state->optional_tmc, 0, 112*sizeof(bool)); 
 		/* bits 0-3 of block 2 contain continuity index */
 		priv_state->continuity_id = grp->data_b_lsb & 0x07;
@@ -434,6 +439,60 @@ static uint32_t rds_decode_tmc_multi_group(struct rds_private_state *priv_state)
 	return V4L2_RDS_TMC_MG;
 }
 
+/* decode the RDS-TMC tuning information that is contained in type 8A groups
+ * (variants 4 to 9) that announce the presence alternative transmitters 
+ * providing the same RDS-TMC service */
+static uint32_t rds_decode_tmc_tuning(struct rds_private_state *priv_state)
+{
+	struct v4l2_rds_group *group = &priv_state->rds_group;
+	struct v4l2_rds_tmc *tmc = &priv_state->handle.tmc;
+	uint8_t variant_code = group->data_b_lsb & 0x0f;
+	uint16_t pi_on = (group->data_d_msb << 8) | group->data_d_lsb;
+	uint8_t index;
+
+	/* variants 4 and 5 carry the service provider name */
+	if (variant_code >= 4 && variant_code <= 5) {
+		int offset = 4 * (variant_code - 4);
+		tmc->spn[0 + offset] = group->data_c_msb;
+		tmc->spn[1 + offset] = group->data_c_lsb;
+		tmc->spn[2 + offset] = group->data_d_msb;
+		tmc->spn[3 + offset] = group->data_d_lsb;
+
+	/* variant 6 provides specific frequencies for the same RDS-TMC service
+	 * on a network with a different PI code */
+	/* variant 7 provides mapped frequency pair information which should only
+	 * be used if the terminal is tuned to the tuning frequency */
+	} else if (variant_code == 6 || variant_code == 7) {
+		rds_add_tmc_af(priv_state);
+
+	/* variant 8 indicates up to 2 PI codes of adjacent networks carrying 
+	 * the same RDS-TMC service on all transmitters of the network */ 
+	} else if (variant_code == 8) {
+		uint16_t pi_on_2 = (group->data_c_msb << 8) | group->data_c_lsb;
+
+		/* try to add both transmitted PI codes to the table */
+		rds_add_tmc_station(priv_state, pi_on);
+		/* PI = 0 is used as a filler code */
+		if (pi_on_2 != 0)
+			rds_add_tmc_station(priv_state, pi_on_2);
+
+	/* variant 9 provides PI codes of other networks with different system 
+	 * parameters */
+	} else if (variant_code == 9) {
+		index = rds_add_tmc_station(priv_state, pi_on);
+
+		/* bits 0 - 5 contain the service-ID of the ON */
+		tmc->tuning.station[index].sid = group->data_c_lsb & 0x3F;
+		/* bits 6-10 contain the msg parameters of the ON */
+		tmc->tuning.station[index].msg = (group->data_c_msb & 0x03) << 2;
+		tmc->tuning.station[index].msg |= (group->data_c_lsb >> 6) & 0x03;
+		/* bits 11-15 contain the database-ID of the ON */
+		tmc->tuning.station[index].ltn = group->data_c_msb >> 2;
+	}
+
+	return V4L2_RDS_TMC_TUNING;
+}
+
 static bool rds_add_oda(struct rds_private_state *priv_state, struct v4l2_rds_oda oda)
 {
 	struct v4l2_rds *handle = &priv_state->handle;
@@ -455,20 +514,11 @@ static bool rds_add_oda(struct rds_private_state *priv_state, struct v4l2_rds_od
 /* add a new AF to the list, if it doesn't exist yet */
 static bool rds_add_af_to_list(struct v4l2_rds_af_set *af_set, uint8_t af, bool is_vhf)
 {
-	uint32_t freq = 0;
-
-	/* AF0 -> "Not to be used" */
-	if (af == 0)
+	/* convert the frequency to Hz, skip on errors */
+	uint32_t freq = rds_decode_af(af, is_vhf);
+	if (freq == 0) 
 		return false;
 
-	/* calculate the AF values in HZ */
-	if (is_vhf)
-		freq = 87500000 + af * 100000;
-	else if (freq <= 15)
-		freq = 152000 + af * 9000;
-	else
-		freq = 531000 + af * 9000;
-
 	/* prevent buffer overflows */
 	if (af_set->size >= MAX_AF_CNT || af_set->size >= af_set->announced_af)
 		return false;
@@ -505,7 +555,7 @@ static bool rds_add_af(struct rds_private_state *priv_state)
 			updated_af = true;
 		c_lsb = 0; /* invalidate */
 	}
-	/* 224..249: announcement of AF count (224=0, 249=25)*/
+	/* 224..249: announcement of AF count (224=0, 249=25) */
 	if (c_msb >= 224 && c_msb <= 249)
 		af_set->announced_af = c_msb - 224;
 	/* check if the data represents an AF (for 1 =< val <= 204 the
@@ -522,6 +572,103 @@ static bool rds_add_af(struct rds_private_state *priv_state)
 	return updated_af;
 }
 
+/* checks if an entry for the given PI already exists and returns the index
+ * of that entry if so. Else it adds a new entry to the TMC-Tuning table and returns
+ * the index of the new field */
+static int rds_add_tmc_station(struct rds_private_state *priv_state, uint16_t pi)
+{
+	struct v4l2_tmc_tuning *tuning = &priv_state->handle.tmc.tuning;
+	uint8_t index = tuning->index;
+	uint8_t size = tuning->station_cnt;
+	
+	/* check if there's an entry for the given PI key */
+	for (int i = 0; i < tuning->station_cnt; i++) {
+		if (tuning->station[i].pi == pi) {
+			return i;
+		}
+	}
+	/* if the the maximum table size is reached, overwrite old
+	 * entries, starting at the oldest one = 0 */
+	tuning->station[index].pi = pi;
+	tuning->index = (index+1 < MAX_TMC_ALT_STATIONS) ? (index+1) : 0;
+	tuning->station_cnt = (size+1 <= MAX_TMC_ALT_STATIONS) ? (size+1) : MAX_TMC_ALT_STATIONS;
+	return index;
+}
+
+/* tries to add new AFs to the relevant entry in the list of RDS-TMC providers */
+static bool rds_add_tmc_af(struct rds_private_state *priv_state)
+{
+	struct v4l2_rds_group *grp = &priv_state->rds_group;
+	struct v4l2_tmc_alt_freq *afi;
+	uint16_t pi_on = grp->data_d_msb << 8 | grp->data_d_lsb;
+	uint8_t variant = grp->data_b_lsb & 0x0f;
+	uint8_t station_index = rds_add_tmc_station(priv_state, pi_on);
+	uint8_t af_index;
+	uint8_t mapped_af_index;
+	uint32_t freq_a = rds_decode_af(grp->data_c_msb, true);
+	uint32_t freq_b = rds_decode_af(grp->data_c_lsb, true);
+	
+	afi = &priv_state->handle.tmc.tuning.station[station_index].afi;
+	af_index = afi->af_index;
+	mapped_af_index = afi->mapped_af_index;
+
+	/* specific frequencies */
+	if (variant == 6) {
+		/* compare the new AFs to the stored ones, reset them to 0 if the AFs are
+		 * already known */
+		for (int i = 0; i < afi->af_size; i++) {
+			freq_a = (freq_a == afi->af[i]) ? 0 : freq_a;
+			freq_b = (freq_b == afi->af[i]) ? 0 : freq_b;
+		}
+		/* return early if there is nothing to do */
+		if (freq_a == 0 && freq_b == 0)
+			return false;
+
+		/* add the new AFs if they were previously unknown */
+		if (freq_a != 0) {
+			afi->af[af_index] = freq_a;
+			af_index = (af_index+1 < MAX_TMC_AF_CNT) ? af_index+1 : 0;
+			afi->af_size++; 
+		}
+		if (freq_b != 0) {
+			afi->af[af_index] = freq_b;
+			af_index = (af_index+1 < MAX_TMC_AF_CNT) ? af_index+1 : 0;
+			afi->af_size++; 
+		}
+		/* update the information in the handle */
+		afi->af_index = af_index;
+		if (afi->af_size >= MAX_TMC_AF_CNT) 
+			afi->af_size = MAX_TMC_AF_CNT;
+
+		return true;
+	}
+
+	/* mapped frequency pair */
+	else if (variant == 7) {
+		/* check the if there's already a frequency mapped to the new tuning
+		 * frequency, update the mapped frequency in this case */
+		for (int i = 0; i < afi->mapped_af_size; i++) {
+			if (freq_a == afi->mapped_af_tuning[i])
+				afi->mapped_af[i] = freq_b;
+				return true;
+		}
+		/* new pair is unknown, add it to the list */
+		if (freq_a != 0 && freq_b != 0) {
+			mapped_af_index = (mapped_af_index+1 >= MAX_TMC_AF_CNT) ? 0 : mapped_af_index + 1;
+			afi->mapped_af[mapped_af_index] = freq_b;
+			afi->mapped_af_tuning[mapped_af_index] = freq_a;
+			afi->mapped_af_size++; 
+		}
+		/* update the information in the handle */
+		afi->mapped_af_index = mapped_af_index;
+		if (afi->mapped_af_size >= MAX_TMC_AF_CNT) 
+			afi->mapped_af_size = MAX_TMC_AF_CNT;
+
+		return true;
+	}
+	return false;
+}
+
 /* adds one char of the ps name to temporal storage, the value is validated
  * if it is received twice in a row
  * @pos:	position of the char within the PS name (0..7)
@@ -543,6 +690,44 @@ static bool rds_add_ps(struct rds_private_state *priv_state, uint8_t pos, uint8_
 	return true;
 }
 
+/* checks if an entry for the given PI already exists and returns the index
+ * of that entry if so. Else it adds a new entry to the EON table and returns
+ * the index of the new field */
+static uint8_t rds_add_eon_entry(struct rds_private_state *priv_state, uint16_t pi)
+{
+	struct v4l2_rds *handle = &priv_state->handle;
+	uint8_t index = handle->rds_eon.index;
+	uint8_t size = handle->rds_eon.size;
+
+	/* check if there's an entry for the given PI key */
+	for (int i = 0; i < handle->rds_eon.size; i++) {
+		if (handle->rds_eon.eon[i].pi == pi) {
+			return i;
+		}
+	}
+	/* if the the maximum table size is reached, overwrite old
+	 * entries, starting at the oldest one = 0 */
+	handle->rds_eon.eon[index].pi = pi;
+	handle->rds_eon.eon[index].valid_fields |= V4L2_RDS_PI;
+	handle->rds_eon.index = (index+1 < MAX_EON_CNT) ? (index+1) : 0;
+	handle->rds_eon.size = (size+1 <= MAX_EON_CNT) ? (size+1) : MAX_EON_CNT;
+	return index;
+}
+
+/* checks if an entry for the given PI already exists */
+static bool rds_check_eon_entry(struct rds_private_state *priv_state, uint16_t pi)
+{
+	struct v4l2_rds *handle = &priv_state->handle;
+
+	/* check if there's an entry for the given PI key */
+	for (int i = 0; i <= handle->rds_eon.size; i++) {
+		if (handle->rds_eon.eon[i].pi == pi) {
+			return true;
+		}
+	}
+	return false;
+}
+
 /* group of functions to decode successfully received RDS groups into
  * easily accessible data fields
  *
@@ -790,6 +975,29 @@ static uint32_t rds_decode_group3(struct rds_private_state *priv_state)
 	return updated_fields;
 }
 
+/* decodes the RDS radio frequency representation into Hz
+ * @af: 8-bit AF value as transmitted in RDS groups
+ * @is_vhf: boolean value defining  which conversion table to use
+ * @return: frequency in Hz, 0 in case of wrong input values */
+static uint32_t rds_decode_af(uint8_t af, bool is_vhf) {
+	uint32_t freq = 0;
+
+	/* AF = 0 => "not to be used"
+	 * AF >= 205 => special meanings */
+	if (af == 0 || af >= 205)
+		return 0;
+
+	/* calculate the AF values in HZ */
+	if (is_vhf)
+		freq = 87500000 + af * 100000;
+	else if (freq <= 15)
+		freq = 152000 + af * 9000;
+	else
+		freq = 531000 + af * 9000;
+
+	return freq;
+}
+
 /* decodes the RDS date/time representation into a standard c representation
  * that can be used with c-library functions */
 static time_t rds_decode_mjd(const struct rds_private_state *priv_state)
@@ -880,7 +1088,6 @@ static uint32_t rds_decode_group4(struct rds_private_state *priv_state)
 	handle->time = rds_decode_mjd(priv_state);
 	updated_fields |= V4L2_RDS_TIME;
 	handle->valid_fields |= V4L2_RDS_TIME;
-	printf("\nLIB: time_t: %ld", handle->time);
 	return updated_fields;
 }
 
@@ -916,13 +1123,13 @@ static uint32_t rds_decode_group8(struct rds_private_state *priv_state)
 		!(grp->data_b_lsb & V4L2_TMC_TUNING_INFO)) {
 		return rds_decode_tmc_multi_group(priv_state);
 	}
-	/* -> tuning information message, defined for variants 4..9, submitted
-	 * in bits 0-3 of block 2 */
+	/* -> tuning information message, defined for variants 4..9,
+	 * submitted in bits 0-3 of block 2 */
 	tuning_variant = grp->data_b_lsb & 0x0f;
 	if ((grp->data_b_lsb & V4L2_TMC_TUNING_INFO) && tuning_variant >= 4 &&
 		tuning_variant <= 9) {
-		/* TODO: Implement tuning information decoding */
-		return 0;
+		priv_state->handle.valid_fields |= V4L2_RDS_TMC_TUNING;
+		return rds_decode_tmc_tuning(priv_state);
 	}
 
 	return 0;
@@ -981,6 +1188,121 @@ static uint32_t rds_decode_group10(struct rds_private_state *priv_state)
 	return updated_fields;
 }
 
+/* group 14: EON (Enhanced Other Network) information */
+static uint32_t rds_decode_group14(struct rds_private_state* priv_state)
+{
+	struct v4l2_rds *handle = &priv_state->handle;
+	struct v4l2_rds_group *grp = &priv_state->rds_group;
+	struct v4l2_rds_eon *eon_entry;
+	uint32_t updated_fields = 0;
+	uint16_t pi_on;
+	uint16_t lsf_on;
+	uint8_t variant_code;
+	uint8_t eon_index;
+	uint8_t pty_on;
+	bool tp_on, ta_on;
+	bool new_a = false, new_b = false;
+
+	if (grp->group_version != 'A')
+		return 0;
+
+	/* bits 0-3 of group b contain the variant code */
+	variant_code = grp->data_b_lsb & 0x0f;
+
+	/* group d contains the PI code of the ON (Other Network) */
+	pi_on = (grp->data_d_msb << 8) | grp->data_d_lsb;
+
+	/* bit 4 of group b contains the TP status of the ON*/
+	tp_on = grp->data_b_lsb & 0x10;
+	if (rds_check_eon_entry(priv_state, pi_on)) {
+		/* if there's an entry for this PI(ON) update the TP field */
+		eon_index = rds_add_eon_entry(priv_state, pi_on);
+		eon_entry = &handle->rds_eon.eon[eon_index];
+		eon_entry->tp = tp_on;
+		eon_entry->valid_fields |= V4L2_RDS_TP;
+		updated_fields |= V4L2_RDS_EON;
+	}
+
+	/* perform group variant dependent decoding */
+	if ((variant_code >=5 && variant_code <= 11) || variant_code >= 14) {
+		/* 5-9 = mapped FM frequencies -> unsupported
+		 * 10-11 = unallocated
+		 * 14 = PIN(ON) -> unsupported (unused RDS feature)
+		 * 15 = reserved for broadcasters use */
+		return updated_fields;
+	}
+	
+	/* retrieve the EON entry corresponding to the PI(ON) code or add a new
+	 * entry to the table if no entry exists */
+	eon_index = rds_add_eon_entry(priv_state, pi_on);
+	eon_entry = &handle->rds_eon.eon[eon_index];
+
+	/* PS Name */
+	if (variant_code < 4) {
+		eon_entry->ps[variant_code*2] = grp->data_c_msb;
+		eon_entry->ps[variant_code*2+1] = grp->data_c_lsb;
+		eon_entry->valid_fields |= V4L2_RDS_PS;
+		updated_fields |= V4L2_RDS_EON;
+	}
+	/* Alternative frequencies */
+	else if (variant_code == 4) {
+		uint8_t c_msb = grp->data_c_msb;
+		uint8_t c_lsb = grp->data_c_lsb;
+
+		/* 224..249: announcement of AF count (224=0, 249=25) */
+		if (c_msb >= 224 && c_msb <= 249)
+			eon_entry->af.announced_af = c_msb - 224;
+		/* check if the data represents an AF (for 1 =< val <= 204 the
+		 * value represents an AF) */
+		if (c_msb < 205)
+			new_a = rds_add_af_to_list(&eon_entry->af,
+					grp->data_c_msb, true);
+		if (c_lsb < 205)
+			new_b = rds_add_af_to_list(&eon_entry->af,
+					grp->data_c_lsb, true);
+		/* check if one of the frequencies was previously unknown */
+		if (new_a || new_b) {
+			eon_entry->valid_fields |= V4L2_RDS_AF;
+			updated_fields |= V4L2_RDS_EON;
+		}
+	}
+	/* Linkage information */
+	else if (variant_code == 12) {
+		/* group c contains the lsf code */
+		lsf_on = (grp->data_c_msb << 8) | grp->data_c_lsb;
+		/* check if the lsf code is already known */
+		new_a = (eon_entry->lsf == lsf_on);
+		if (new_a) {
+			eon_entry->lsf = lsf_on;
+			eon_entry->valid_fields |= V4L2_RDS_LSF;
+			updated_fields |= V4L2_RDS_EON;
+		}
+	}
+	/* PTY(ON) and TA(ON) */
+	else if (variant_code == 13) {
+		/* bits 15-10 of group c contain the PTY(ON) */
+		pty_on = grp->data_c_msb >> 3;
+		/* bit 0 of group c contains the TA code */
+		ta_on = grp->data_c_lsb & 0x01;
+		/* check if the data is new */
+		new_a = (eon_entry->pty == pty_on);
+		if (new_a) {
+			eon_entry->pty = pty_on;
+			eon_entry->valid_fields |= V4L2_RDS_PTY;
+		}
+		new_b = (eon_entry->ta == ta_on);
+		eon_entry->ta = ta_on;
+		eon_entry->valid_fields |= V4L2_RDS_TA;
+		if (new_a || new_b)
+			updated_fields |= V4L2_RDS_EON;
+	}
+	/* set valid field for EON data, if EON table contains entries */
+	if (handle->rds_eon.size > 0)
+		handle->valid_fields |= V4L2_RDS_EON;
+
+	return updated_fields;
+}
+
 typedef uint32_t (*decode_group_func)(struct rds_private_state *);
 
 /* array of function pointers to contain all group specific decoding functions */
@@ -992,6 +1314,7 @@ static const decode_group_func decode_group[16] = {
 	[4] = rds_decode_group4,
 	[8] = rds_decode_group8,
 	[10] = rds_decode_group10,
+	[14] = rds_decode_group14
 };
 
 static uint32_t rds_decode_group(struct rds_private_state *priv_state)
@@ -1068,7 +1391,7 @@ uint32_t v4l2_rds_add(struct v4l2_rds *handle, struct v4l2_rds_data *rds_data)
 		if (block_id == 0) {
 			*decode_state = RDS_A_RECEIVED;
 			/* begin reception of a new data group, reset raw buffer to 0 */
-			memset(rds_data_raw, 0, sizeof(rds_data_raw));
+			memset(rds_data_raw, 0, sizeof(*rds_data_raw));
 			rds_data_raw[0] = *rds_data;
 		} else {
 			/* ignore block if it is not the first block of a group */
-- 
1.7.10.4

