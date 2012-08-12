Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4826 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab2HLMaX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Aug 2012 08:30:23 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Konke Radlow <koradlow@gmail.com>
Subject: Re: [RFC PATCH] Add core TMC (Traffic Message Channel) support
Date: Sun, 12 Aug 2012 14:29:43 +0200
Cc: linux-media@vger.kernel.org, hdegoede@redhat.com
References: <[PATCHv2 0/2] Add support for RDS decoding> <1344618292-24776-1-git-send-email-koradlow@gmail.com> <458d51e3ad009e98391bdee04a55b4b082028d72.1344617632.git.koradlow@gmail.com>
In-Reply-To: <458d51e3ad009e98391bdee04a55b4b082028d72.1344617632.git.koradlow@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201208121429.43924.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri August 10 2012 19:04:52 Konke Radlow wrote:
> 
> Signed-off-by: Konke Radlow <koradlow@gmail.com>
> ---
>  lib/include/libv4l2rds.h    |   64 ++++++++
>  lib/libv4l2rds/libv4l2rds.c |  340 ++++++++++++++++++++++++++++++++++++++++++-
>  utils/rds-ctl/rds-ctl.cpp   |   31 +++-
>  3 files changed, 432 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/include/libv4l2rds.h b/lib/include/libv4l2rds.h
> index 37bdd2f..caefc1a 100644
> --- a/lib/include/libv4l2rds.h
> +++ b/lib/include/libv4l2rds.h
> @@ -63,6 +63,9 @@ extern "C" {
>  #define V4L2_RDS_AF		0x800	/* AF (alternative freq) available */
>  #define V4L2_RDS_ECC		0x1000	/* Extended County Code */
>  #define V4L2_RDS_LC		0x2000	/* Language Code */
> +#define V4L2_RDS_TMC_SG		0x4000	/* RDS-TMC single group */
> +#define V4L2_RDS_TMC_MG		0x8000	/* RDS-TMC multi group */
> +#define V4L2_RDS_TMC_SYS	0x10000 /* RDS-TMC system information */
>  
>  /* Define Constants for the state of the RDS decoding process
>   * used to address the relevant bit in the decode_information bitmask */
> @@ -76,6 +79,11 @@ extern "C" {
>  #define V4L2_RDS_FLAG_COMPRESSED	0x04
>  #define V4L2_RDS_FLAG_STATIC_PTY	0x08
>  
> +/* TMC related codes
> + * used to extract TMC fields from RDS groups */
> +#define V4L2_TMC_TUNING_INFO	0x08
> +#define V4L2_TMC_SINGLE_GROUP	0x04
> +
>  /* struct to encapsulate one complete RDS group */
>  /* This structure is used internally to store data until a complete RDS
>   * group was received and group id dependent decoding can be done.
> @@ -137,6 +145,61 @@ struct v4l2_rds_af_set {
>  	uint32_t af[MAX_AF_CNT];	/* AFs defined in Hz */
>  };
>  
> +/* struct to encapsulate an additional data field in a TMC message */
> +struct v4l2_tmc_additional {
> +	uint8_t label;
> +	uint16_t data;
> +};
> +
> +/* struct to encapsulate an arbitrary number of additional data fields
> + * belonging to one TMC message */
> +struct v4l2_tmc_additional_set {
> +	uint8_t size;
> +	/* 28 is the maximal possible number of fields. Additional data

28 should be a define instead of being hardcoded.

> +	 * is limited to 112 bit, and the smallest optional tuple has
> +	 * a size of 4 bit (4 bit identifier + 0 bits of data) */
> +	struct v4l2_tmc_additional fields[28];
> +};
> +
> +/* struct to encapsulate a decoded TMC message with optional additional
> + * data field (in case of a multi-group TMC message) */
> +struct v4l2_rds_tmc_msg {
> +	uint8_t length;	/* length of multi-group message (0..4) */
> +	uint8_t sid;		/* service identifier at time of reception */
> +	uint8_t extent;
> +	uint8_t dp;		/* duration and persistence */
> +	uint16_t event;		/* TMC event code */
> +	uint16_t location;	/* TMC event location */
> +	bool follow_diversion;	/* indicates if the driver is adviced to
> +				 * follow the diversion */
> +	bool neg_direction;	/* indicates negative / positive direction */
> +
> +	/* decoded additional information (only available in multi-group
> +	 * messages) */
> +	struct v4l2_tmc_additional_set additional;
> +};
> +
> +/* struct to encapsulate all TMC related information, including TMC System
> + * Information, TMC Tuning information and a buffer for the last decoded
> + * TMC messages */
> +struct v4l2_rds_tmc {
> +	uint8_t ltn;		/* location_table_number */
> +	bool afi;		/* alternative frequency indicator */
> +	bool enhanced_mode;	/* mode of transmission,
> +				 * if false -> basic => gaps between tmc groups
> +				 * gap defines timing behavior
> +				 * if true -> enhanced => t_a, t_w and t_d
> +				 * define timing behavior of tmc groups */
> +	uint8_t mgs;		/* message geographical scope */
> +	uint8_t sid;		/* service identifier (unique ID on national level) */
> +	uint8_t gap;		/* Gap parameters */
> +	uint8_t t_a;		/* activity time (only if mode = enhanced) */
> +	uint8_t t_w;		/* window time (only if mode = enhanced */
> +	uint8_t t_d;		/* delay time (only if mode = enhanced */
> +	uint8_t spn[9];		/* service provider name */
> +	struct v4l2_rds_tmc_msg tmc_msg;
> +};
> +
>  /* struct to encapsulate state and RDS information for current decoding process */
>  /* This is the structure that will be used by external applications, to
>   * communicate with the library and get access to RDS data */
> @@ -172,6 +235,7 @@ struct v4l2_rds {
>  	struct v4l2_rds_statistics rds_statistics;
>  	struct v4l2_rds_oda_set rds_oda;	/* Open Data Services */
>  	struct v4l2_rds_af_set rds_af; 		/* Alternative Frequencies */
> +	struct v4l2_rds_tmc tmc;		/* TMC information */
>  };
>  
>  /* v4l2_rds_init() - initializes a new decoding process
> diff --git a/lib/libv4l2rds/libv4l2rds.c b/lib/libv4l2rds/libv4l2rds.c
> index 2d6642c..f47adb8 100644
> --- a/lib/libv4l2rds/libv4l2rds.c
> +++ b/lib/libv4l2rds/libv4l2rds.c
> @@ -63,6 +63,22 @@ struct rds_private_state {
>  	uint8_t utc_minute;
>  	uint8_t utc_offset;
>  
> +	/* TMC decoding buffers, to store data before it can be verified,
> +	 * and before all parts of a multi-group message have been received */
> +	uint8_t continuity_id;	/* continuity index of current TMC multigroup */
> +	uint8_t grp_seq_id; 	/* group sequence identifier */
> +	uint32_t optional_tmc[4];	/* buffer for up to 112 bits of optional
> +					 * additional data in multi-group
> +					 * messages */
> +
> +	/* TMC groups are only accepted if the same data was received twice,
> +	 * these structs are used as receive buffers to validate TMC groups */
> +	struct v4l2_rds_group prev_tmc_group;
> +	struct v4l2_rds_group prev_tmc_sys_group;
> +	struct v4l2_rds_tmc_msg new_tmc_msg;
> +
> +	/* buffers for rds data, before group type specific decoding can
> +	 * be done */
>  	struct v4l2_rds_group rds_group;
>  	struct v4l2_rds_data rds_data_raw[4];
>  };
> @@ -179,6 +195,276 @@ static void rds_decode_d(struct rds_private_state *priv_state, struct v4l2_rds_d
>  	grp->data_d_lsb = rds_data->lsb;
>  }
>  
> +/* compare two rds-groups for equality */
> +/* used for decoding RDS-TMC, which has the requirement that the same group
> + * is at least received twice before it is accepted */
> +static bool rds_compare_group(const struct v4l2_rds_group *a,
> +				const struct v4l2_rds_group *b)
> +{
> +	if (a->pi != b->pi)
> +		return false;
> +	if (a->group_version != b->group_version)
> +		return false;
> +	if (a->group_id != b->group_id)
> +		return false;
> +
> +	if (a->data_b_lsb != b->data_b_lsb)
> +		return false;
> +	if (a->data_c_lsb != b->data_c_lsb || a->data_c_msb != b->data_c_msb)
> +		return false;
> +	if (a->data_d_lsb != b->data_d_lsb || a->data_d_msb != b->data_d_msb)
> +		return false;
> +	/* all values are equal */
> +	return true;
> +}
> +
> +/* return a bitmask with with bit_cnt bits set to 1 (starting from lsb) */
> +static uint32_t get_bitmask(uint8_t bit_cnt)
> +{
> +	return (1 << bit_cnt) - 1;
> +}
> +
> +/* decode additional information of a TMC message into handy representation */
> +/* the additional information of TMC messages is submitted in (up to) 4 blocks of
> + * 28 bits each, which are to be treated as a consecutive bit-array. Each additional
> + * information is defined by a 4-bit label, and the length of the following data
> + * is known. If the number of required bits for labels & data fields exeeds 28,
> + * coding continues without interruption in the next block.
> + * The first label starts at Y11 and is followed immediately by the associated data.
> + * The optional bit blocks are represented by an array of 4 uint32_t vars in the
> + * rds_private_state struct. The msb of each variable starts at Y11 (bit 11 of
> + * block 3) and continues down to Z0 (bit 0 of block 4).
> + * The 4 lsb bits are not used (=0) */
> +static struct v4l2_tmc_additional_set *rds_tmc_decode_additional
> +		(struct rds_private_state *priv_state)

The returned pointer is never used. This is a left-over from an earlier version,
so this can be replaced by void.

> +{
> +	struct v4l2_rds_tmc_msg *msg = &priv_state->handle.tmc.tmc_msg;
> +	struct v4l2_tmc_additional *fields = &msg->additional.fields[0];
> +	uint32_t *optional = priv_state->optional_tmc;
> +	const uint8_t data_len = 28;	/* used bits in the fields of the
> +					 * uint32_t optional array */
> +	const uint8_t label_len = 4;	/* fixed length of a label */
> +	uint8_t label;		/* buffer for extracted label */
> +	uint16_t data;		/* buffer for extracted data */
> +	uint8_t pos = 0;	/* current position in optional block */
> +	uint8_t len; 		/* length of next data field to be extracted */
> +	uint8_t o_len;		/* lenght of overhang into next block */
> +	uint8_t block_idx = 0;	/* index for current optional block */
> +	uint8_t *field_idx = &msg->additional.size;	/* index for
> +				 * additional field array */
> +	/* LUT for the length of additional data blocks as defined in
> +	 * ISO 14819-1 sect. 5.5.1 */
> +	static const uint8_t additional_lut[16] = {
> +		3, 3, 5, 5, 5, 8, 8, 8, 8, 11, 16, 16, 16, 16, 0, 0
> +	};
> +
> +	/* reset the additional information from previous messages */
> +	*field_idx = 0;
> +	memset(fields, 0, sizeof(*fields));
> +
> +	/* decode each received optional block */
> +	for (int i = 0; i < msg->length; i++) {
> +		/* extract the label, handle situation where label is split
> +		 * across two adjacent RDS-TMC groups */
> +		if (pos + label_len > data_len) {
> +			o_len = label_len - (data_len - pos);	/* overhang length */
> +			len = data_len - pos;	/* remaining data in current block*/
> +			label = optional[block_idx] >> (32 - pos - len + o_len) &
> +				get_bitmask(len + o_len);
> +			if (++block_idx >= msg->length)
> +				break;
> +			pos = 0;	/* start at beginning of next block */
> +			label |= optional[block_idx] >> (32 - pos - o_len);
> +		} else {
> +			label = optional[block_idx] >> (32 - pos - label_len) &
> +				get_bitmask(label_len);
> +			pos += label_len % data_len;
> +			/* end of optional block reached? */
> +			block_idx = (pos == 0) ? block_idx+1 : block_idx;
> +			if (block_idx >= msg->length)
> +				break;
> +		}
> +
> +		/* extract the associated data block, handle situation where it
> +		 * is split across two adjacent RDS-TMC groups */
> +		len = additional_lut[label];	/* length of data block */
> +		if (pos + len > data_len) {
> +			o_len = len - (data_len - pos);	/* overhang length */
> +			len = data_len - pos;	/* remaining data in current block*/
> +			data = optional[block_idx] >> (32 - pos - len + o_len) &
> +				get_bitmask(len + o_len);
> +			if (++block_idx >= msg->length)
> +				break;
> +			pos = 0;	/* start at beginning of next block */
> +			label |= optional[block_idx] >> (32 - pos - o_len);
> +		} else {
> +			data = optional[block_idx] >> (32 - pos - len) &
> +				get_bitmask(len);
> +			data += len % data_len;
> +			/* end of optional block reached? */
> +			block_idx = (pos == 0) ? block_idx+1 : block_idx;
> +		}
> +
> +		/* if  the label is not "reserved for future use", store
> +		 * the extracted additional information */
> +		if (label == 15) {
> +			continue;
> +		}
> +		fields[*field_idx].label = label;
> +		fields[*field_idx].data = data;
> +		*field_idx += 1;
> +	}
> +	return &msg->additional;
> +}
> +
> +/* decode the TMC system information that is contained in type 3A groups
> + * that announce the presence of TMC */
> +static uint32_t rds_decode_tmc_system(struct rds_private_state *priv_state)
> +{
> +	struct v4l2_rds_group *group = &priv_state->rds_group;
> +	struct v4l2_rds_tmc *tmc = &priv_state->handle.tmc;
> +	uint8_t variant_code;
> +
> +	/* check if the same group was received twice. If not, store new
> +	 * group and return early */
> +	if (!rds_compare_group(&priv_state->prev_tmc_sys_group, &priv_state->rds_group)) {
> +		priv_state->prev_tmc_sys_group = priv_state->rds_group;
> +		return 0x00;
> +	}
> +	/* bits 14-15 of block 3 contain the variant code */
> +	variant_code = priv_state->rds_group.data_c_msb >> 6;
> +	switch (variant_code) {
> +	case 0x00:
> +		/* bits 11-16 of block 3 contain the LTN */
> +		tmc->ltn = (((group->data_c_msb & 0x0f) << 2)) |
> +			(group->data_c_lsb >> 6);
> +		/* bit 5 of block 3 contains the AFI */
> +		tmc->afi = group->data_c_lsb & 0x20;
> +		/* bit 4 of block 3 contains the Mode */
> +		tmc->enhanced_mode = group->data_c_lsb & 0x10;
> +		/* bits 0-3 of block 3 contain the MGS */
> +		tmc->mgs = group->data_c_lsb & 0x0f;
> +		break;
> +	case 0x01:
> +		/* bits 12-13 of block 3 contain the Gap parameters */
> +		tmc->gap = (group->data_c_msb & 0x30) >> 4;
> +		/* bits 11-16 of block 3 contain the SID */
> +		tmc->sid = (((group->data_c_msb & 0x0f) << 2)) |
> +			(group->data_c_lsb >> 6);
> +		/* timing information is only valid in enhanced mode */
> +		if (!tmc->enhanced_mode)
> +			break;
> +		/* bits 4-5 of block 3 contain the activity time */
> +		tmc->t_a = (group->data_c_lsb & 0x30) >> 4;
> +		/* bits 2-3 of block 3 contain the window time */
> +		tmc->t_w = (group->data_c_lsb & 0x0c) >> 2;
> +		/* bits 0-1 of block 3 contain the delay time */
> +		tmc->t_d = group->data_c_lsb & 0x03;
> +		break;
> +	}
> +	return V4L2_RDS_TMC_SYS;
> +}
> +
> +/* decode a single group TMC message */
> +static uint32_t rds_decode_tmc_single_group(struct rds_private_state *priv_state)
> +{
> +	struct v4l2_rds_group *grp = &priv_state->rds_group;
> +	struct v4l2_rds_tmc_msg msg;
> +
> +	/* bits 0-2 of group 2 contain the duration value */
> +	msg.dp = grp->data_b_lsb & 0x07;
> +	/* bit 15 of block 3 indicates follow diversion advice */
> +	msg.follow_diversion = (bool)(grp->data_c_msb & 0x80);

No need for this cast.

> +	/* bit 14 of block 3 indicates the direction */
> +	msg.neg_direction = (bool)(grp->data_c_msb & 0x40);

Ditto.

> +	/* bits 11-13 of block 3 contain the extend of the event */
> +	msg.extent = (grp->data_c_msb & 0x38) >> 3;
> +	/* bits 0-10 of block 3 contain the event */
> +	msg.event = ((grp->data_c_msb & 0x07) << 8) | grp->data_c_lsb;
> +	/* bits 0-15 of block 4 contain the location */
> +	msg.location = (grp->data_d_msb << 8) | grp->data_c_lsb;
> +
> +	/* decoding done, store the new message */
> +	priv_state->handle.tmc.tmc_msg = msg;
> +	priv_state->handle.valid_fields |= V4L2_RDS_TMC_SG;
> +	priv_state->handle.valid_fields &= ~V4L2_RDS_TMC_MG;
> +
> +	return V4L2_RDS_TMC_SG;
> +}
> +
> +/* decode a multi group TMC message and decode the additional fields once
> + * a complete group was decoded */
> +static uint32_t rds_decode_tmc_multi_group(struct rds_private_state *priv_state)
> +{
> +	struct v4l2_rds_group *grp = &priv_state->rds_group;
> +	struct v4l2_rds_tmc_msg *msg = &priv_state->new_tmc_msg;
> +	uint32_t *optional = priv_state->optional_tmc;
> +	bool message_completed = false;
> +	uint8_t grp_seq_id;
> +	uint64_t buffer;
> +
> +	/* bits 12-13 of block 3 contain the group sequence id, for all
> +	 * multi groups except the first group */
> +	grp_seq_id = (grp->data_c_msb & 0x30) >> 4;
> +
> +	/* beginning of a new multigroup ? */
> +	/* bit 15 of block 3 is the first group indicator */
> +	if (grp->data_c_msb & 0x80) {
> +		/* begine decoding of new message */
> +		memset(msg, 0, sizeof(msg));
> +		/* bits 0-3 of block 2 contain continuity index */
> +		priv_state->continuity_id = grp->data_b_lsb & 0x07;
> +		/* bit 15 of block 3 indicates follow diversion advice */
> +		msg->follow_diversion = (bool)(grp->data_c_msb & 0x80);

No need for cast.

> +		/* bit 14 of block 3 indicates the direction */
> +		msg->neg_direction = (bool)(grp->data_c_msb & 0x40);

Ditto.

> +		/* bits 11-13 of block 3 contain the extend of the event */
> +		msg->extent = (grp->data_c_msb & 0x38) >> 3;
> +		/* bits 0-10 of block 3 contain the event */
> +		msg->event = ((grp->data_c_msb & 0x07) << 8) | grp->data_c_lsb;
> +		/* bits 0-15 of block 4 contain the location */
> +		msg->location = (grp->data_d_msb << 8) | grp->data_c_lsb;
> +	}
> +	/* second group of multigroup ? */
> +	/* bit 14 of block 3 ist the second group indicator, and the
> +	 * group continuity id has to match */
> +	else if (grp->data_c_msb & 0x40 &&
> +		(grp->data_b_lsb & 0x07) == priv_state->continuity_id) {
> +		priv_state->grp_seq_id = grp_seq_id;
> +		/* store group for later decoding */
> +		buffer = grp->data_c_msb << 28 | grp->data_c_lsb << 20 |
> +			grp->data_d_msb << 12 | grp->data_d_lsb << 4;
> +		optional[0] = buffer;
> +		msg->length = 1;
> +		if (grp_seq_id == 0)
> +			message_completed = true;
> +	}
> +	/* subsequent groups of multigroup ? */
> +	/* group continuity id has to match, and group sequence number has
> +	 * to be smaller by one than the group sequence id */
> +	else if ((grp->data_b_lsb & 0x07) == priv_state->continuity_id &&
> +		(grp_seq_id == priv_state->grp_seq_id-1)) {
> +		priv_state->grp_seq_id = grp_seq_id;
> +		/* store group for later decoding */
> +		buffer = grp->data_c_msb << 28 | grp->data_c_lsb << 20 |
> +			grp->data_d_msb << 12 | grp->data_d_lsb << 4;
> +		optional[msg->length++] = buffer;
> +		if (grp_seq_id == 0)
> +			message_completed = true;
> +	}
> +
> +	/* complete message received -> decode additional fields and store
> +	 * the new message */
> +	if (message_completed) {
> +		priv_state->handle.tmc.tmc_msg = *msg;
> +		rds_tmc_decode_additional(priv_state);
> +		priv_state->handle.valid_fields |= V4L2_RDS_TMC_MG;
> +		priv_state->handle.valid_fields &= ~V4L2_RDS_TMC_SG;
> +	}
> +
> +	return V4L2_RDS_TMC_MG;
> +}
> +
>  static bool rds_add_oda(struct rds_private_state *priv_state, struct v4l2_rds_oda oda)
>  {
>  	struct v4l2_rds *handle = &priv_state->handle;
> @@ -526,6 +812,12 @@ static uint32_t rds_decode_group3(struct rds_private_state *priv_state)
>  		handle->decode_information |= V4L2_RDS_ODA;
>  		updated_fields |= V4L2_RDS_ODA;
>  	}
> +
> +	/* if it's a TMC announcement decode the contained information */
> +	if (new_oda.aid == 0xcd46 || new_oda.aid == 0xcd47) {
> +		rds_decode_tmc_system(priv_state);
> +	}
> +
>  	return updated_fields;
>  }
>  
> @@ -623,6 +915,50 @@ static uint32_t rds_decode_group4(struct rds_private_state *priv_state)
>  	return updated_fields;
>  }
>  
> +/* group 8A: TMC */
> +static uint32_t rds_decode_group8(struct rds_private_state *priv_state)
> +{
> +	struct v4l2_rds_group *grp = &priv_state->rds_group;
> +	uint8_t tuning_variant = 0x00;

No need to initialize.

> +
> +	/* TMC uses version A exclusively */
> +	if (grp->group_version != 'A')
> +		return 0x00;
> +
> +	/* check if the same group was received twice, store new rds group
> +	 * and return early if the old group doesn't match the new one */
> +	if (!rds_compare_group(&priv_state->prev_tmc_group, &priv_state->rds_group)) {
> +		priv_state->prev_tmc_group = priv_state->rds_group;
> +		return 0x00;
> +	}
> +	/* modify the old group, to prevent that the same TMC message is decoded
> +	 * again in the next iteration (the default number of repetitions for
> +	 * RDS-TMC groups is 3) */
> +	priv_state->prev_tmc_group.group_version = 0x00;
> +
> +	/* handle the new TMC data depending on the message type */
> +	/* -> single group message */
> +	if ((grp->data_b_lsb & V4L2_TMC_SINGLE_GROUP) &&
> +		!(grp->data_b_lsb & V4L2_TMC_TUNING_INFO)) {
> +		return rds_decode_tmc_single_group(priv_state);
> +	}
> +	/* -> multi group message */
> +	if (!(grp->data_b_lsb & V4L2_TMC_SINGLE_GROUP) &&
> +		!(grp->data_b_lsb & V4L2_TMC_TUNING_INFO)) {
> +		return rds_decode_tmc_multi_group(priv_state);
> +	}
> +	/* -> tuning information message, defined for variants 4..9, submitted
> +	 * in bits 0-3 of block 2 */
> +	tuning_variant = grp->data_b_lsb & 0x0f;
> +	if ((grp->data_b_lsb & V4L2_TMC_TUNING_INFO) && tuning_variant >= 4 &&
> +		tuning_variant <= 9) {
> +		/* TODO: Implement tuning information decoding */

Let's not forget this! :-)

It will extend the rds struct, so it would be nice to have this implemented
before an official release is made of this library.

> +		return 0x00;
> +	}
> +
> +	return 0x00;
> +}
> +
>  /* group 10: Program Type Name */
>  static uint32_t rds_decode_group10(struct rds_private_state *priv_state)
>  {
> @@ -685,6 +1021,7 @@ static const decode_group_func decode_group[16] = {
>  	[2] = rds_decode_group2,
>  	[3] = rds_decode_group3,
>  	[4] = rds_decode_group4,
> +	[8] = rds_decode_group8,
>  	[10] = rds_decode_group10,
>  };
>  
> @@ -956,8 +1293,7 @@ const char *v4l2_rds_get_coverage_str(const struct v4l2_rds *handle)
>  	return coverage_lut[coverage];
>  }
>  
> -const struct v4l2_rds_group *v4l2_rds_get_group
> -	(const struct v4l2_rds *handle)
> +const struct v4l2_rds_group *v4l2_rds_get_group(const struct v4l2_rds *handle)
>  {
>  	struct rds_private_state *priv_state = (struct rds_private_state *) handle;
>  	return &priv_state->rds_group;

Regards,

	Hans
