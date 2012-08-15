Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:51343 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab2HOObO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Aug 2012 10:31:14 -0400
Received: by wibhr14 with SMTP id hr14so1487091wib.1
        for <linux-media@vger.kernel.org>; Wed, 15 Aug 2012 07:31:12 -0700 (PDT)
From: Konke Radlow <koradlow@googlemail.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, hdegoede@redhat.com
Subject: [RFC PATCHv2] Add core TMC (Traffic Message Channel) support
Date: Wed, 15 Aug 2012 16:30:58 +0200
Message-Id: <b28393bc6be591265ccf88a258875a1372de89cd.1345041039.git.koradlow@gmail.com>
In-Reply-To: <1345041058-1334-1-git-send-email-koradlow@gmail.com>
References: <[RFC PATCH 0/1] Adding core TMC decoding support to RDS library>
 <1345041058-1334-1-git-send-email-koradlow@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Signed-off-by: Konke Radlow <koradlow@gmail.com>
---
 lib/include/libv4l2rds.h    |   65 +++++++++
 lib/libv4l2rds/libv4l2rds.c |  309 ++++++++++++++++++++++++++++++++++++++++++-
 utils/rds-ctl/rds-ctl.cpp   |   31 ++++-
 3 files changed, 402 insertions(+), 3 deletions(-)

diff --git a/lib/include/libv4l2rds.h b/lib/include/libv4l2rds.h
index d8baf15..3ec7735 100644
--- a/lib/include/libv4l2rds.h
+++ b/lib/include/libv4l2rds.h
@@ -46,6 +46,10 @@ extern "C" {
 			 * AF Method B does not impose a limit on the number of AFs
 			 * but it is not fully supported at the moment and will
 			 * not receive more than 25 AFs */
+#define MAX_TMC_ADDITIONAL 28	/* 28 is the maximal possible number of fields.
+			* Additional data is limited to 112 bit, and the smallest
+			* optional tuple has a size of 4 bit (4 bit identifier +
+			* 0 bits of data) */
 
 /* Define Constants for the possible types of RDS information
  * used to address the relevant bit in the valid_fields bitmask */
@@ -63,6 +67,9 @@ extern "C" {
 #define V4L2_RDS_AF		0x800	/* AF (alternative freq) available */
 #define V4L2_RDS_ECC		0x1000	/* Extended County Code */
 #define V4L2_RDS_LC		0x2000	/* Language Code */
+#define V4L2_RDS_TMC_SG		0x4000	/* RDS-TMC single group */
+#define V4L2_RDS_TMC_MG		0x8000	/* RDS-TMC multi group */
+#define V4L2_RDS_TMC_SYS	0x10000 /* RDS-TMC system information */
 
 /* Define Constants for the state of the RDS decoding process
  * used to address the relevant bit in the decode_information bitmask */
@@ -76,6 +83,11 @@ extern "C" {
 #define V4L2_RDS_FLAG_COMPRESSED	0x04
 #define V4L2_RDS_FLAG_STATIC_PTY	0x08
 
+/* TMC related codes
+ * used to extract TMC fields from RDS groups */
+#define V4L2_TMC_TUNING_INFO	0x08
+#define V4L2_TMC_SINGLE_GROUP	0x04
+
 /* struct to encapsulate one complete RDS group */
 /* This structure is used internally to store data until a complete RDS
  * group was received and group id dependent decoding can be done.
@@ -137,6 +149,58 @@ struct v4l2_rds_af_set {
 	uint32_t af[MAX_AF_CNT];	/* AFs defined in Hz */
 };
 
+/* struct to encapsulate an additional data field in a TMC message */
+struct v4l2_tmc_additional {
+	uint8_t label;
+	uint16_t data;
+};
+
+/* struct to encapsulate an arbitrary number of additional data fields
+ * belonging to one TMC message */
+struct v4l2_tmc_additional_set {
+	uint8_t size;
+	struct v4l2_tmc_additional fields[MAX_TMC_ADDITIONAL];
+};
+
+/* struct to encapsulate a decoded TMC message with optional additional
+ * data field (in case of a multi-group TMC message) */
+struct v4l2_rds_tmc_msg {
+	uint8_t length;	/* length of multi-group message (0..4) */
+	uint8_t sid;		/* service identifier at time of reception */
+	uint8_t extent;
+	uint8_t dp;		/* duration and persistence */
+	uint16_t event;		/* TMC event code */
+	uint16_t location;	/* TMC event location */
+	bool follow_diversion;	/* indicates if the driver is adviced to
+				 * follow the diversion */
+	bool neg_direction;	/* indicates negative / positive direction */
+
+	/* decoded additional information (only available in multi-group
+	 * messages) */
+	struct v4l2_tmc_additional_set additional;
+};
+
+/* struct to encapsulate all TMC related information, including TMC System
+ * Information, TMC Tuning information and a buffer for the last decoded
+ * TMC messages */
+struct v4l2_rds_tmc {
+	uint8_t ltn;		/* location_table_number */
+	bool afi;		/* alternative frequency indicator */
+	bool enhanced_mode;	/* mode of transmission,
+				 * if false -> basic => gaps between tmc groups
+				 * gap defines timing behavior
+				 * if true -> enhanced => t_a, t_w and t_d
+				 * define timing behavior of tmc groups */
+	uint8_t mgs;		/* message geographical scope */
+	uint8_t sid;		/* service identifier (unique ID on national level) */
+	uint8_t gap;		/* Gap parameters */
+	uint8_t t_a;		/* activity time (only if mode = enhanced) */
+	uint8_t t_w;		/* window time (only if mode = enhanced */
+	uint8_t t_d;		/* delay time (only if mode = enhanced */
+	uint8_t spn[9];		/* service provider name */
+	struct v4l2_rds_tmc_msg tmc_msg;
+};
+
 /* struct to encapsulate state and RDS information for current decoding process */
 /* This is the structure that will be used by external applications, to
  * communicate with the library and get access to RDS data */
@@ -172,6 +236,7 @@ struct v4l2_rds {
 	struct v4l2_rds_statistics rds_statistics;
 	struct v4l2_rds_oda_set rds_oda;	/* Open Data Services */
 	struct v4l2_rds_af_set rds_af; 		/* Alternative Frequencies */
+	struct v4l2_rds_tmc tmc;		/* TMC information */
 };
 
 /* v4l2_rds_init() - initializes a new decoding process
diff --git a/lib/libv4l2rds/libv4l2rds.c b/lib/libv4l2rds/libv4l2rds.c
index 783db22..2918061 100644
--- a/lib/libv4l2rds/libv4l2rds.c
+++ b/lib/libv4l2rds/libv4l2rds.c
@@ -63,6 +63,23 @@ struct rds_private_state {
 	uint8_t utc_minute;
 	uint8_t utc_offset;
 
+	/* TMC decoding buffers, to store data before it can be verified,
+	 * and before all parts of a multi-group message have been received */
+	uint8_t continuity_id;	/* continuity index of current TMC multigroup */
+	uint8_t grp_seq_id; 	/* group sequence identifier */
+	bool optional_tmc[112];	/* buffer for up to 112 bits of optional
+				 * additional data in multi-group
+				 * messages (112 is the maximal possible length
+				 * specified by the standard) */
+
+	/* TMC groups are only accepted if the same data was received twice,
+	 * these structs are used as receive buffers to validate TMC groups */
+	struct v4l2_rds_group prev_tmc_group;
+	struct v4l2_rds_group prev_tmc_sys_group;
+	struct v4l2_rds_tmc_msg new_tmc_msg;
+
+	/* buffers for rds data, before group type specific decoding can
+	 * be done */
 	struct v4l2_rds_group rds_group;
 	struct v4l2_rds_data rds_data_raw[4];
 };
@@ -179,6 +196,244 @@ static void rds_decode_d(struct rds_private_state *priv_state, struct v4l2_rds_d
 	grp->data_d_lsb = rds_data->lsb;
 }
 
+/* compare two rds-groups for equality */
+/* used for decoding RDS-TMC, which has the requirement that the same group
+ * is at least received twice before it is accepted */
+static bool rds_compare_group(const struct v4l2_rds_group *a,
+				const struct v4l2_rds_group *b)
+{
+	if (a->pi != b->pi)
+		return false;
+	if (a->group_version != b->group_version)
+		return false;
+	if (a->group_id != b->group_id)
+		return false;
+
+	if (a->data_b_lsb != b->data_b_lsb)
+		return false;
+	if (a->data_c_lsb != b->data_c_lsb || a->data_c_msb != b->data_c_msb)
+		return false;
+	if (a->data_d_lsb != b->data_d_lsb || a->data_d_msb != b->data_d_msb)
+		return false;
+	/* all values are equal */
+	return true;
+}
+
+/* decode additional information of a TMC message into handy representation */
+/* the additional information of TMC messages is submitted in (up to) 4 blocks of
+ * 28 bits each, which are to be treated as a consecutive bit-array. This data
+ * is represented by the optional_tmc array in the private handle, where each
+ * value represents 1 bit. Each additional information set is defined by a 4-bit
+ * label, and an associated data field for which the length is known */ 
+void rds_tmc_decode_additional(struct rds_private_state *priv_state)
+{
+	struct v4l2_rds_tmc_msg *msg = &priv_state->handle.tmc.tmc_msg;
+	struct v4l2_tmc_additional *fields = &msg->additional.fields[0];
+	const uint8_t label_len = 4;	/* fixed length of a label */
+	uint8_t len; 		/* length of next data field to be extracted */
+	uint8_t label;		/* buffer for extracted label */
+	uint16_t data;		/* buffer for extracted data */
+	uint8_t array_idx = 0;	/* index for optional_tmc array */
+	uint8_t *field_idx = &msg->additional.size;	/* index for
+				 * additional field array */
+	/* LUT for the length of additional data blocks as defined in
+	 * ISO 14819-1 sect. 5.5.1 */
+	static const uint8_t additional_lut[16] = {
+		3, 3, 5, 5, 5, 8, 8, 8, 8, 11, 16, 16, 16, 16, 0, 0
+	};
+
+	/* reset the additional information from previous messages */
+	*field_idx = 0;
+	memset(fields, 0, sizeof(*fields));
+
+	/* decode the optional TMC data */
+	while (array_idx < (msg->length * 28)) {
+		/* extract the next label */
+		label = 0;
+		for (int i = 0; i < label_len; i++) {
+			if (priv_state->optional_tmc[array_idx++])
+				label |= 1 << (label_len - 1 - i); 
+		}
+
+		/* extract the associated data block */
+		data = 0;
+		len = additional_lut[label];	/* length of data block */
+		for (int i = 0; i < len; i++) {
+			if (priv_state->optional_tmc[array_idx++])
+				data |= 1 << (len - 1 - i);
+		}
+
+		/* if  the label is not "reserved for future use", or both
+		 * fields are 0, store the extracted additional information */
+		if (label == 15)
+			continue;
+		if (label == 0 && data == 0)
+			continue;
+		fields[*field_idx].label = label;
+		fields[*field_idx].data = data;
+		*field_idx += 1;
+	}
+}
+
+/* decode the TMC system information that is contained in type 3A groups
+ * that announce the presence of TMC */
+static uint32_t rds_decode_tmc_system(struct rds_private_state *priv_state)
+{
+	struct v4l2_rds_group *group = &priv_state->rds_group;
+	struct v4l2_rds_tmc *tmc = &priv_state->handle.tmc;
+	uint8_t variant_code;
+
+	/* check if the same group was received twice. If not, store new
+	 * group and return early */
+	if (!rds_compare_group(&priv_state->prev_tmc_sys_group, &priv_state->rds_group)) {
+		priv_state->prev_tmc_sys_group = priv_state->rds_group;
+		return 0;
+	}
+	/* bits 14-15 of block 3 contain the variant code */
+	variant_code = priv_state->rds_group.data_c_msb >> 6;
+	switch (variant_code) {
+	case 0x00:
+		/* bits 11-16 of block 3 contain the LTN */
+		tmc->ltn = (((group->data_c_msb & 0x0f) << 2)) |
+			(group->data_c_lsb >> 6);
+		/* bit 5 of block 3 contains the AFI */
+		tmc->afi = group->data_c_lsb & 0x20;
+		/* bit 4 of block 3 contains the Mode */
+		tmc->enhanced_mode = group->data_c_lsb & 0x10;
+		/* bits 0-3 of block 3 contain the MGS */
+		tmc->mgs = group->data_c_lsb & 0x0f;
+		break;
+	case 0x01:
+		/* bits 12-13 of block 3 contain the Gap parameters */
+		tmc->gap = (group->data_c_msb & 0x30) >> 4;
+		/* bits 11-16 of block 3 contain the SID */
+		tmc->sid = (((group->data_c_msb & 0x0f) << 2)) |
+			(group->data_c_lsb >> 6);
+		/* timing information is only valid in enhanced mode */
+		if (!tmc->enhanced_mode)
+			break;
+		/* bits 4-5 of block 3 contain the activity time */
+		tmc->t_a = (group->data_c_lsb & 0x30) >> 4;
+		/* bits 2-3 of block 3 contain the window time */
+		tmc->t_w = (group->data_c_lsb & 0x0c) >> 2;
+		/* bits 0-1 of block 3 contain the delay time */
+		tmc->t_d = group->data_c_lsb & 0x03;
+		break;
+	}
+	return V4L2_RDS_TMC_SYS;
+}
+
+/* decode a single group TMC message */
+static uint32_t rds_decode_tmc_single_group(struct rds_private_state *priv_state)
+{
+	struct v4l2_rds_group *grp = &priv_state->rds_group;
+	struct v4l2_rds_tmc_msg msg;
+
+	/* bits 0-2 of group 2 contain the duration value */
+	msg.dp = grp->data_b_lsb & 0x07;
+	/* bit 15 of block 3 indicates follow diversion advice */
+	msg.follow_diversion = grp->data_c_msb & 0x80;
+	/* bit 14 of block 3 indicates the direction */
+	msg.neg_direction = grp->data_c_msb & 0x40;
+	/* bits 11-13 of block 3 contain the extend of the event */
+	msg.extent = (grp->data_c_msb & 0x38) >> 3;
+	/* bits 0-10 of block 3 contain the event */
+	msg.event = ((grp->data_c_msb & 0x07) << 8) | grp->data_c_lsb;
+	/* bits 0-15 of block 4 contain the location */
+	msg.location = (grp->data_d_msb << 8) | grp->data_c_lsb;
+
+	/* decoding done, store the new message */
+	priv_state->handle.tmc.tmc_msg = msg;
+	priv_state->handle.valid_fields |= V4L2_RDS_TMC_SG;
+	priv_state->handle.valid_fields &= ~V4L2_RDS_TMC_MG;
+
+	return V4L2_RDS_TMC_SG;
+}
+
+/* decode a multi group TMC message and decode the additional fields once
+ * a complete group was decoded */
+static uint32_t rds_decode_tmc_multi_group(struct rds_private_state *priv_state)
+{
+	struct v4l2_rds_group *grp = &priv_state->rds_group;
+	struct v4l2_rds_tmc_msg *msg = &priv_state->new_tmc_msg;
+	bool message_completed = false;
+	uint8_t grp_seq_id;
+	uint64_t buffer;
+
+	/* bits 12-13 of block 3 contain the group sequence id, for all
+	 * multi groups except the first group */
+	grp_seq_id = (grp->data_c_msb & 0x30) >> 4;
+
+	/* beginning of a new multigroup ? */
+	/* bit 15 of block 3 is the first group indicator */
+	if (grp->data_c_msb & 0x80) {
+		/* begine decoding of new message */
+		memset(msg, 0, sizeof(msg));
+		memset(priv_state->optional_tmc, 0, 112*sizeof(bool)); 
+		/* bits 0-3 of block 2 contain continuity index */
+		priv_state->continuity_id = grp->data_b_lsb & 0x07;
+		/* bit 15 of block 3 indicates follow diversion advice */
+		msg->follow_diversion = grp->data_c_msb & 0x80;
+		/* bit 14 of block 3 indicates the direction */
+		msg->neg_direction = grp->data_c_msb & 0x40;
+		/* bits 11-13 of block 3 contain the extend of the event */
+		msg->extent = (grp->data_c_msb & 0x38) >> 3;
+		/* bits 0-10 of block 3 contain the event */
+		msg->event = ((grp->data_c_msb & 0x07) << 8) | grp->data_c_lsb;
+		/* bits 0-15 of block 4 contain the location */
+		msg->location = (grp->data_d_msb << 8) | grp->data_c_lsb;
+	}
+	/* second group of multigroup ? */
+	/* bit 14 of block 3 ist the second group indicator, and the
+	 * group continuity id has to match */
+	else if (grp->data_c_msb & 0x40 &&
+		(grp->data_b_lsb & 0x07) == priv_state->continuity_id) {
+		priv_state->grp_seq_id = grp_seq_id;
+		/* store group for later decoding by transforming the bit values
+		 * into boolean values and storing them in an array, to ease
+		 * further handling */
+		msg->length = 1;
+		buffer = grp->data_c_msb << 24 | grp->data_c_lsb << 16 |
+			grp->data_d_msb << 8 | grp->data_d_lsb;
+		/* the buffer contains 28 bits of additional information */
+		for (int i = 27; i >= 0; i--) {
+			if (buffer & (1 << i))
+				priv_state->optional_tmc[27-i] = true;
+		}
+		if (grp_seq_id == 0)
+			message_completed = true;
+	}
+	/* subsequent groups of multigroup ? */
+	/* group continuity id has to match, and group sequence number has
+	 * to be smaller by one than the group sequence id */
+	else if ((grp->data_b_lsb & 0x07) == priv_state->continuity_id &&
+		(grp_seq_id == priv_state->grp_seq_id-1)) {
+		priv_state->grp_seq_id = grp_seq_id;
+		/* store group for later decoding */
+		msg->length += 1;
+		buffer = grp->data_c_msb << 24 | grp->data_c_lsb << 16|
+			grp->data_d_msb << 8 | grp->data_d_lsb;
+		/* the buffer contains 28 bits of additional information */
+		for (int i = 27; i >= 0; i--) {
+			if (buffer & (1 << i))
+				priv_state->optional_tmc[msg->length*28 + 27 - i] = true;
+		}
+		if (grp_seq_id == 0)
+			message_completed = true;
+	}
+
+	/* complete message received -> decode additional fields and store
+	 * the new message */
+	if (message_completed) {
+		priv_state->handle.tmc.tmc_msg = *msg;
+		rds_tmc_decode_additional(priv_state);
+		priv_state->handle.valid_fields |= V4L2_RDS_TMC_MG;
+		priv_state->handle.valid_fields &= ~V4L2_RDS_TMC_SG;
+	}
+
+	return V4L2_RDS_TMC_MG;
+}
+
 static bool rds_add_oda(struct rds_private_state *priv_state, struct v4l2_rds_oda oda)
 {
 	struct v4l2_rds *handle = &priv_state->handle;
@@ -526,6 +781,12 @@ static uint32_t rds_decode_group3(struct rds_private_state *priv_state)
 		handle->decode_information |= V4L2_RDS_ODA;
 		updated_fields |= V4L2_RDS_ODA;
 	}
+
+	/* if it's a TMC announcement decode the contained information */
+	if (new_oda.aid == 0xcd46 || new_oda.aid == 0xcd47) {
+		rds_decode_tmc_system(priv_state);
+	}
+
 	return updated_fields;
 }
 
@@ -623,6 +884,50 @@ static uint32_t rds_decode_group4(struct rds_private_state *priv_state)
 	return updated_fields;
 }
 
+/* group 8A: TMC */
+static uint32_t rds_decode_group8(struct rds_private_state *priv_state)
+{
+	struct v4l2_rds_group *grp = &priv_state->rds_group;
+	uint8_t tuning_variant;
+
+	/* TMC uses version A exclusively */
+	if (grp->group_version != 'A')
+		return 0;
+
+	/* check if the same group was received twice, store new rds group
+	 * and return early if the old group doesn't match the new one */
+	if (!rds_compare_group(&priv_state->prev_tmc_group, &priv_state->rds_group)) {
+		priv_state->prev_tmc_group = priv_state->rds_group;
+		return 0;
+	}
+	/* modify the old group, to prevent that the same TMC message is decoded
+	 * again in the next iteration (the default number of repetitions for
+	 * RDS-TMC groups is 3) */
+	priv_state->prev_tmc_group.group_version = 0;
+
+	/* handle the new TMC data depending on the message type */
+	/* -> single group message */
+	if ((grp->data_b_lsb & V4L2_TMC_SINGLE_GROUP) &&
+		!(grp->data_b_lsb & V4L2_TMC_TUNING_INFO)) {
+		return rds_decode_tmc_single_group(priv_state);
+	}
+	/* -> multi group message */
+	if (!(grp->data_b_lsb & V4L2_TMC_SINGLE_GROUP) &&
+		!(grp->data_b_lsb & V4L2_TMC_TUNING_INFO)) {
+		return rds_decode_tmc_multi_group(priv_state);
+	}
+	/* -> tuning information message, defined for variants 4..9, submitted
+	 * in bits 0-3 of block 2 */
+	tuning_variant = grp->data_b_lsb & 0x0f;
+	if ((grp->data_b_lsb & V4L2_TMC_TUNING_INFO) && tuning_variant >= 4 &&
+		tuning_variant <= 9) {
+		/* TODO: Implement tuning information decoding */
+		return 0;
+	}
+
+	return 0;
+}
+
 /* group 10: Program Type Name */
 static uint32_t rds_decode_group10(struct rds_private_state *priv_state)
 {
@@ -685,6 +990,7 @@ static const decode_group_func decode_group[16] = {
 	[2] = rds_decode_group2,
 	[3] = rds_decode_group3,
 	[4] = rds_decode_group4,
+	[8] = rds_decode_group8,
 	[10] = rds_decode_group10,
 };
 
@@ -956,8 +1262,7 @@ const char *v4l2_rds_get_coverage_str(const struct v4l2_rds *handle)
 	return coverage_lut[coverage];
 }
 
-const struct v4l2_rds_group *v4l2_rds_get_group
-	(const struct v4l2_rds *handle)
+const struct v4l2_rds_group *v4l2_rds_get_group(const struct v4l2_rds *handle)
 {
 	struct rds_private_state *priv_state = (struct rds_private_state *) handle;
 	return &priv_state->rds_group;
diff --git a/utils/rds-ctl/rds-ctl.cpp b/utils/rds-ctl/rds-ctl.cpp
index c872aed..6906431 100644
--- a/utils/rds-ctl/rds-ctl.cpp
+++ b/utils/rds-ctl/rds-ctl.cpp
@@ -76,6 +76,7 @@ enum Option {
 	OptOpenFile,
 	OptPrintBlock,
 	OptSilent,
+	OptTMC,
 	OptTunerIndex,
 	OptVerbose,
 	OptWaitLimit,
@@ -110,6 +111,7 @@ static struct option long_options[] = {
 	{"print-block", no_argument, 0, OptPrintBlock},
 	{"read-rds", no_argument, 0, OptReadRds},
 	{"set-freq", required_argument, 0, OptSetFreq},
+	{"tmc", no_argument, 0, OptTMC},
 	{"tuner-index", required_argument, 0, OptTunerIndex},
 	{"verbose", no_argument, 0, OptVerbose},
 	{"wait-limit", required_argument, 0, OptWaitLimit},
@@ -170,6 +172,8 @@ static void usage_rds(void)
 	       "  --print-block\n"
 	       "                     prints all valid RDS fields, whenever a value is updated\n"
 	       "                     instead of printing only updated values\n"
+	       "  --tmc\n"
+	       "                     enables decoding of TMC (Traffic Message Channel) data\n"
 	       "  --verbose\n"
 	       "                     turn on verbose mode - every received RDS group\n"
 	       "                     will be printed\n"
@@ -491,7 +495,30 @@ static void print_decoder_info(uint8_t di)
 		printf("Not Compressed");
 }
 
-static void print_rds_statistics(struct v4l2_rds_statistics *statistics)
+static void print_rds_tmc(const struct v4l2_rds *handle, uint32_t updated_fields)
+{
+	const struct v4l2_rds_tmc_msg *msg = &handle->tmc.tmc_msg;
+	const struct v4l2_tmc_additional_set *set = &msg->additional;
+
+	if (updated_fields & V4L2_RDS_TMC_SG) {
+		printf("\nTMC Single-grp: location: %04x, event: %04x, extent: %02x "
+			"duration: %02x", msg->location, msg->event,
+			msg->extent, msg->dp);
+		return;
+	}
+	if (updated_fields & V4L2_RDS_TMC_MG) {
+		printf("\nTMC Multi-grp: length: %02d, location: %04x, event: %04x,\n"
+		"               extent: %02x duration: %02x", msg->length, msg->location, msg->event,
+			msg->extent, msg->dp);
+		for (int i = 0; i < set->size; i++) {
+			printf("\n               additional[%02d]: label: %02d, value: %04x",
+			i, set->fields[i].label, set->fields[i].data);
+		}
+		return;
+	}
+}
+
+static void print_rds_statistics(const struct v4l2_rds_statistics *statistics)
 {
 	printf("\n\nRDS Statistics: \n");
 	printf("received blocks / received groups: %u / %u\n",
@@ -583,6 +610,8 @@ static void print_rds_data(const struct v4l2_rds *handle, uint32_t updated_field
 		print_rds_af(&handle->rds_af);
 	if (params.options[OptPrintBlock])
 		printf("\n");
+	if (params.options[OptTMC])
+		print_rds_tmc(handle, updated_fields);
 }
 
 static void read_rds(struct v4l2_rds *handle, const int fd, const int wait_limit)
-- 
1.7.10.4

