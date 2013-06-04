Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:47848 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab3FDTPM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Jun 2013 15:15:12 -0400
Received: by mail-wg0-f43.google.com with SMTP id x12so561486wgg.34
        for <linux-media@vger.kernel.org>; Tue, 04 Jun 2013 12:15:11 -0700 (PDT)
From: Konke Radlow <koradlow@gmail.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, hdegoede@redhat.com
Subject: [RFC PATCHv2 3/3] libv4l2rds.c: moving functions to get rid of declarations Signed-off-by: Konke Radlow <koradlow@gmail.com>
Date: Tue,  4 Jun 2013 20:15:03 +0100
Message-Id: <a7a5ebcef89b3d108bf3b55a49bff8b408418008.1370373234.git.koradlow@gmail.com>
In-Reply-To: <1370373303-6605-1-git-send-email-koradlow@gmail.com>
References: <1370373303-6605-1-git-send-email-koradlow@gmail.com>
In-Reply-To: <2668df294d662dbf33ebae87bc06fd063ea4cfd2.1370373234.git.koradlow@gmail.com>
References: <2668df294d662dbf33ebae87bc06fd063ea4cfd2.1370373234.git.koradlow@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Konke Radlow <koradlow@gmail.com>
---
 lib/libv4l2rds/libv4l2rds.c |  243 +++++++++++++++++++++----------------------
 1 file changed, 120 insertions(+), 123 deletions(-)

diff --git a/lib/libv4l2rds/libv4l2rds.c b/lib/libv4l2rds/libv4l2rds.c
index 28b78ce..333bf95 100644
--- a/lib/libv4l2rds/libv4l2rds.c
+++ b/lib/libv4l2rds/libv4l2rds.c
@@ -92,11 +92,6 @@ enum rds_state {
 	RDS_C_RECEIVED,
 };
 
-/* function declarations to prevent the need to move large code blocks */
-static int rds_add_tmc_station(struct rds_private_state *priv_state, uint16_t pi);
-static uint32_t rds_decode_af(uint8_t af, bool is_vhf);
-static bool rds_add_tmc_af(struct rds_private_state *priv_state);
-
 static inline uint8_t set_bit(uint8_t input, uint8_t bitmask, bool bitvalue)
 {
 	return bitvalue ? input | bitmask : input & ~bitmask;
@@ -201,6 +196,29 @@ static void rds_decode_d(struct rds_private_state *priv_state, struct v4l2_rds_d
 	grp->data_d_lsb = rds_data->lsb;
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
 /* compare two rds-groups for equality */
 /* used for decoding RDS-TMC, which has the requirement that the same group
  * is at least received twice before it is accepted */
@@ -224,6 +242,103 @@ static bool rds_compare_group(const struct v4l2_rds_group *a,
 	return true;
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
 /* decode additional information of a TMC message into handy representation */
 /* the additional information of TMC messages is submitted in (up to) 4 blocks of
  * 28 bits each, which are to be treated as a consecutive bit-array. This data
@@ -572,102 +687,7 @@ static bool rds_add_af(struct rds_private_state *priv_state)
 	return updated_af;
 }
 
-/* checks if an entry for the given PI already exists and returns the index
- * of that entry if so. Else it adds a new entry to the TMC-Tuning table and returns
- * the index of the new field */
-static int rds_add_tmc_station(struct rds_private_state *priv_state, uint16_t pi)
-{
-	struct v4l2_tmc_tuning *tuning = &priv_state->handle.tmc.tuning;
-	uint8_t index = tuning->index;
-	uint8_t size = tuning->station_cnt;
-	
-	/* check if there's an entry for the given PI key */
-	for (int i = 0; i < tuning->station_cnt; i++) {
-		if (tuning->station[i].pi == pi) {
-			return i;
-		}
-	}
-	/* if the the maximum table size is reached, overwrite old
-	 * entries, starting at the oldest one = 0 */
-	tuning->station[index].pi = pi;
-	tuning->index = (index+1 < MAX_TMC_ALT_STATIONS) ? (index+1) : 0;
-	tuning->station_cnt = (size+1 <= MAX_TMC_ALT_STATIONS) ? (size+1) : MAX_TMC_ALT_STATIONS;
-	return index;
-}
-
-/* tries to add new AFs to the relevant entry in the list of RDS-TMC providers */
-static bool rds_add_tmc_af(struct rds_private_state *priv_state)
-{
-	struct v4l2_rds_group *grp = &priv_state->rds_group;
-	struct v4l2_tmc_alt_freq *afi;
-	uint16_t pi_on = grp->data_d_msb << 8 | grp->data_d_lsb;
-	uint8_t variant = grp->data_b_lsb & 0x0f;
-	uint8_t station_index = rds_add_tmc_station(priv_state, pi_on);
-	uint8_t af_index;
-	uint8_t mapped_af_index;
-	uint32_t freq_a = rds_decode_af(grp->data_c_msb, true);
-	uint32_t freq_b = rds_decode_af(grp->data_c_lsb, true);
-	
-	afi = &priv_state->handle.tmc.tuning.station[station_index].afi;
-	af_index = afi->af_index;
-	mapped_af_index = afi->mapped_af_index;
-
-	/* specific frequencies */
-	if (variant == 6) {
-		/* compare the new AFs to the stored ones, reset them to 0 if the AFs are
-		 * already known */
-		for (int i = 0; i < afi->af_size; i++) {
-			freq_a = (freq_a == afi->af[i]) ? 0 : freq_a;
-			freq_b = (freq_b == afi->af[i]) ? 0 : freq_b;
-		}
-		/* return early if there is nothing to do */
-		if (freq_a == 0 && freq_b == 0)
-			return false;
-
-		/* add the new AFs if they were previously unknown */
-		if (freq_a != 0) {
-			afi->af[af_index] = freq_a;
-			af_index = (af_index+1 < MAX_TMC_AF_CNT) ? af_index+1 : 0;
-			afi->af_size++; 
-		}
-		if (freq_b != 0) {
-			afi->af[af_index] = freq_b;
-			af_index = (af_index+1 < MAX_TMC_AF_CNT) ? af_index+1 : 0;
-			afi->af_size++; 
-		}
-		/* update the information in the handle */
-		afi->af_index = af_index;
-		if (afi->af_size >= MAX_TMC_AF_CNT) 
-			afi->af_size = MAX_TMC_AF_CNT;
-
-		return true;
-	}
 
-	/* mapped frequency pair */
-	else if (variant == 7) {
-		/* check the if there's already a frequency mapped to the new tuning
-		 * frequency, update the mapped frequency in this case */
-		for (int i = 0; i < afi->mapped_af_size; i++) {
-			if (freq_a == afi->mapped_af_tuning[i])
-				afi->mapped_af[i] = freq_b;
-				return true;
-		}
-		/* new pair is unknown, add it to the list */
-		if (freq_a != 0 && freq_b != 0) {
-			mapped_af_index = (mapped_af_index+1 >= MAX_TMC_AF_CNT) ? 0 : mapped_af_index + 1;
-			afi->mapped_af[mapped_af_index] = freq_b;
-			afi->mapped_af_tuning[mapped_af_index] = freq_a;
-			afi->mapped_af_size++; 
-		}
-		/* update the information in the handle */
-		afi->mapped_af_index = mapped_af_index;
-		if (afi->mapped_af_size >= MAX_TMC_AF_CNT) 
-			afi->mapped_af_size = MAX_TMC_AF_CNT;
-
-		return true;
-	}
-	return false;
-}
 
 /* adds one char of the ps name to temporal storage, the value is validated
  * if it is received twice in a row
@@ -975,29 +995,6 @@ static uint32_t rds_decode_group3(struct rds_private_state *priv_state)
 	return updated_fields;
 }
 
-/* decodes the RDS radio frequency representation into Hz
- * @af: 8-bit AF value as transmitted in RDS groups
- * @is_vhf: boolean value defining  which conversion table to use
- * @return: frequency in Hz, 0 in case of wrong input values */
-static uint32_t rds_decode_af(uint8_t af, bool is_vhf) {
-	uint32_t freq = 0;
-
-	/* AF = 0 => "not to be used"
-	 * AF >= 205 => special meanings */
-	if (af == 0 || af >= 205)
-		return 0;
-
-	/* calculate the AF values in HZ */
-	if (is_vhf)
-		freq = 87500000 + af * 100000;
-	else if (freq <= 15)
-		freq = 152000 + af * 9000;
-	else
-		freq = 531000 + af * 9000;
-
-	return freq;
-}
-
 /* decodes the RDS date/time representation into a standard c representation
  * that can be used with c-library functions */
 static time_t rds_decode_mjd(const struct rds_private_state *priv_state)
-- 
1.7.10.4

