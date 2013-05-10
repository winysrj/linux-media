Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:3252 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab3EJLgn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 May 2013 07:36:43 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Konke Radlow <koradlow@gmail.com>
Subject: Re: [RFC PATCH 1/4] libv4l2rds: added support to decode RDS-EON information
Date: Fri, 10 May 2013 13:36:32 +0200
Cc: linux-media@vger.kernel.org, hdegoede@redhat.com
References: <1367943863-28803-1-git-send-email-koradlow@gmail.com> <43cedfcd3ab893d4efbf97587ee0fe6640ee3d39.1367943797.git.koradlow@gmail.com>
In-Reply-To: <43cedfcd3ab893d4efbf97587ee0fe6640ee3d39.1367943797.git.koradlow@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201305101336.32047.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Konke!

Thank you very much for your work on this! I do have a number of comments,
but nothing serious:

On Tue May 7 2013 18:24:20 Konke Radlow wrote:
> Signed-off-by: Konke Radlow <koradlow@gmail.com>
> ---
>  lib/include/libv4l2rds.h    |   35 +++++++-
>  lib/libv4l2rds/libv4l2rds.c |  190 ++++++++++++++++++++++++++++++++++++++++---
>  2 files changed, 208 insertions(+), 17 deletions(-)
> 
> diff --git a/lib/include/libv4l2rds.h b/lib/include/libv4l2rds.h
> index 6a6c7f3..62b28bc 100644
> --- a/lib/include/libv4l2rds.h
> +++ b/lib/include/libv4l2rds.h
> @@ -50,6 +50,9 @@ extern "C" {
>  			* Additional data is limited to 112 bit, and the smallest
>  			* optional tuple has a size of 4 bit (4 bit identifier +
>  			* 0 bits of data) */
> +#define MAX_EON_CNT 20	/* Maximal number of entries in the EON table (for storing
> +			* information about other radio stations, broadcasted
> +			* by the current station) */

How did you derive this number? Is this from the standard or is this just a
reasonable estimate? This should be documented.

>  
>  /* Define Constants for the possible types of RDS information
>   * used to address the relevant bit in the valid_fields bitmask */
> @@ -69,7 +72,9 @@ extern "C" {
>  #define V4L2_RDS_LC		0x2000	/* Language Code */
>  #define V4L2_RDS_TMC_SG		0x4000	/* RDS-TMC single group */
>  #define V4L2_RDS_TMC_MG		0x8000	/* RDS-TMC multi group */
> -#define V4L2_RDS_TMC_SYS	0x10000 /* RDS-TMC system information */
> +#define V4L2_RDS_TMC_SYS	0x10000	/* RDS-TMC system information */
> +#define V4L2_RDS_EON		0x20000	/* Enhanced Other Network Info */
> +#define V4L2_RDS_LSF		0x40000	/* Linkage information */
>  
>  /* Define Constants for the state of the RDS decoding process
>   * used to address the relevant bit in the decode_information bitmask */
> @@ -84,9 +89,10 @@ extern "C" {
>  #define V4L2_RDS_FLAG_STATIC_PTY	0x08
>  
>  /* TMC related codes
> - * used to extract TMC fields from RDS groups */
> -#define V4L2_TMC_TUNING_INFO	0x08
> -#define V4L2_TMC_SINGLE_GROUP	0x04
> + * used to extract TMC fields from RDS-TMC groups
> + * see ISO 14819-1:2003, Figure 2 - RDS-TMC single-grp full message structure */
> +#define V4L2_TMC_TUNING_INFO	0x10	/* Bit 4 indicates Tuning Info / User msg */
> +#define V4L2_TMC_SINGLE_GROUP	0x08	/* Bit 3 indicates Single / Multi-group msg */
>  
>  /* struct to encapsulate one complete RDS group */
>  /* This structure is used internally to store data until a complete RDS
> @@ -149,6 +155,26 @@ struct v4l2_rds_af_set {
>  	uint32_t af[MAX_AF_CNT];	/* AFs defined in Hz */
>  };
>  
> +/* struct to encapsulate one entry in the EON table (Enhanced Other Network) */
> +struct v4l2_rds_eon {
> +	uint32_t valid_fields;
> +	uint16_t pi;
> +	uint8_t ps[9];
> +	uint8_t pty;
> +	bool ta;
> +	bool tp;
> +	uint16_t lsf;		/* Linkage Set Number */
> +	struct v4l2_rds_af_set af;
> +};
> +
> +/* struct to encapsulate a table of EON information */
> +struct v4l2_rds_eon_set {
> +	uint8_t size;		/* size of the table */
> +	uint8_t index;		/* current position in the table */
> +	struct v4l2_rds_eon eon[MAX_EON_CNT];	/* Information about other
> +						 * radio channels */
> +};
> +
>  /* struct to encapsulate an additional data field in a TMC message */
>  struct v4l2_tmc_additional {
>  	uint8_t label;
> @@ -236,6 +262,7 @@ struct v4l2_rds {
>  	struct v4l2_rds_statistics rds_statistics;
>  	struct v4l2_rds_oda_set rds_oda;	/* Open Data Services */
>  	struct v4l2_rds_af_set rds_af; 		/* Alternative Frequencies */
> +	struct v4l2_rds_eon_set rds_eon;	/* EON information */
>  	struct v4l2_rds_tmc tmc;		/* TMC information */
>  };
>  
> diff --git a/lib/libv4l2rds/libv4l2rds.c b/lib/libv4l2rds/libv4l2rds.c
> index 2918061..3a90a3b 100644
> --- a/lib/libv4l2rds/libv4l2rds.c
> +++ b/lib/libv4l2rds/libv4l2rds.c
> @@ -92,6 +92,9 @@ enum rds_state {
>  	RDS_C_RECEIVED,
>  };
>  
> +/* function declarations to prevent the need to move large code blocks */
> +static uint32_t rds_decode_af(uint8_t af, bool is_vhf);

It is better to have a separate patch that just moves code around and nothing
else, than to add a forward declaration. I never like those, except when dealing
with circular references.

> +
>  static inline uint8_t set_bit(uint8_t input, uint8_t bitmask, bool bitvalue)
>  {
>  	return bitvalue ? input | bitmask : input & ~bitmask;
> @@ -455,20 +458,11 @@ static bool rds_add_oda(struct rds_private_state *priv_state, struct v4l2_rds_od
>  /* add a new AF to the list, if it doesn't exist yet */
>  static bool rds_add_af_to_list(struct v4l2_rds_af_set *af_set, uint8_t af, bool is_vhf)
>  {
> -	uint32_t freq = 0;
> -
> -	/* AF0 -> "Not to be used" */
> -	if (af == 0)
> +	/* convert the frequency to Hz, skip on errors */
> +	uint32_t freq = rds_decode_af(af, is_vhf);
> +	if (freq == 0) 
>  		return false;
>  
> -	/* calculate the AF values in HZ */
> -	if (is_vhf)
> -		freq = 87500000 + af * 100000;
> -	else if (freq <= 15)
> -		freq = 152000 + af * 9000;
> -	else
> -		freq = 531000 + af * 9000;
> -
>  	/* prevent buffer overflows */
>  	if (af_set->size >= MAX_AF_CNT || af_set->size >= af_set->announced_af)
>  		return false;
> @@ -543,6 +537,42 @@ static bool rds_add_ps(struct rds_private_state *priv_state, uint8_t pos, uint8_
>  	return true;
>  }
>  
> +/* checks if an entry for the given PI already exists and returns the index
> + * of that entry if so. Else it adds a new entry to the EON table and returns
> + * the index of the new field */
> +static uint8_t rds_add_eon_entry(struct rds_private_state *priv_state, uint16_t pi) {

Newline before '{'.

> +	struct v4l2_rds *handle = &priv_state->handle;
> +	uint8_t index = handle->rds_eon.index;
> +	uint8_t size = handle->rds_eon.size;
> +
> +	/* check if there's an entry for the given PI key */
> +	for (int i = 0; i < handle->rds_eon.size; i++) {
> +		if (handle->rds_eon.eon[i].pi == pi) {
> +			return i;
> +		}
> +	}
> +	/* if the the maximum table size is reached, overwrite old
> +	 * entries, starting at the oldest one = 0 */
> +	handle->rds_eon.eon[index].pi = pi;
> +	handle->rds_eon.eon[index].valid_fields |= V4L2_RDS_PI;
> +	handle->rds_eon.index = (index+1 < MAX_EON_CNT)? (index+1) : 0;

Space before '?'

> +	handle->rds_eon.size = (size+1 <= MAX_EON_CNT)? (size+1) : MAX_EON_CNT;

ditto.

> +	return index;
> +}
> +
> +/* checks if an entry for the given PI already exists */
> +static bool rds_check_eon_entry(struct rds_private_state *priv_state, uint16_t pi) {

'{' on next line.

> +	struct v4l2_rds *handle = &priv_state->handle;
> +
> +	/* check if there's an entry for the given PI key */
> +	for (int i = 0; i <= handle->rds_eon.size; i++) {
> +		if (handle->rds_eon.eon[i].pi == pi) {
> +			return true;
> +		}
> +	}
> +	return false;
> +}
> +
>  /* group of functions to decode successfully received RDS groups into
>   * easily accessible data fields
>   *
> @@ -790,6 +820,29 @@ static uint32_t rds_decode_group3(struct rds_private_state *priv_state)
>  	return updated_fields;
>  }
>  
> +/* decodes the RDS radio frequency representation into Hz
> + * @af: 8-bit AF value as transmitted in RDS groups
> + * @is_vhf: boolean value defining  which conversion table to use
> + * @return: frequency in Hz, 0 in case of wrong input values */
> +static uint32_t rds_decode_af(uint8_t af, bool is_vhf) {
> +	uint32_t freq = 0;
> +
> +	/* AF = 0 => "not to be used"
> +	 * AF >= 205 => special meanings */
> +	if (af == 0 || af >= 205)
> +		return 0;
> +
> +	/* calculate the AF values in HZ */
> +	if (is_vhf)
> +		freq = 87500000 + af * 100000;
> +	else if (freq <= 15)
> +		freq = 152000 + af * 9000;
> +	else
> +		freq = 531000 + af * 9000;
> +
> +	return freq;
> +}
> +
>  /* decodes the RDS date/time representation into a standard c representation
>   * that can be used with c-library functions */
>  static time_t rds_decode_mjd(const struct rds_private_state *priv_state)
> @@ -880,7 +933,6 @@ static uint32_t rds_decode_group4(struct rds_private_state *priv_state)
>  	handle->time = rds_decode_mjd(priv_state);
>  	updated_fields |= V4L2_RDS_TIME;
>  	handle->valid_fields |= V4L2_RDS_TIME;
> -	printf("\nLIB: time_t: %ld", handle->time);
>  	return updated_fields;
>  }
>  
> @@ -981,6 +1033,117 @@ static uint32_t rds_decode_group10(struct rds_private_state *priv_state)
>  	return updated_fields;
>  }
>  
> +/* group 14: EON (Enhanced Other Network) information */
> +static uint32_t rds_decode_group14(struct rds_private_state* priv_state) {

'{' on next line. Please check any other such occurances.

> +	struct v4l2_rds *handle = &priv_state->handle;
> +	struct v4l2_rds_group *grp = &priv_state->rds_group;
> +	uint32_t updated_fields = 0;
> +	uint16_t pi_on;
> +	uint16_t lsf_on;
> +	uint8_t variant_code;
> +	uint8_t eon_index;
> +	uint8_t pty_on;
> +	bool tp_on, ta_on;
> +	bool new_a = false, new_b = false;
> +
> +	if (grp->group_version != 'A') {
> +		return 0;
> +	}

No '{' '}' around a block with a single statement.

> +
> +	/* bits 0-3 of group b contain the variant code */
> +	variant_code = grp->data_b_lsb & 0x0f;
> +
> +	/* group d contains the PI code of the ON (Other Network) */
> +	pi_on = (grp->data_d_msb << 8) | grp->data_d_lsb;
> +
> +	/* bit 4 of group b contains the TP status of the ON*/
> +	tp_on = grp->data_b_lsb & 0x10;
> +	if (rds_check_eon_entry(priv_state, pi_on)) {
> +		/* if there's an entry for this PI(ON) update the TP field */
> +		eon_index = rds_add_eon_entry(priv_state, pi_on);
> +		handle->rds_eon.eon[eon_index].tp = tp_on;
> +		handle->rds_eon.eon[eon_index].valid_fields |= V4L2_RDS_TP;
> +		updated_fields |= V4L2_RDS_EON;
> +	}
> +
> +	/* perform group variant dependent decoding */
> +	if ((variant_code >=5 && variant_code <=11) || variant_code >= 14) {

Space before '11'.

> +		/* 5-9 = mapped FM frequencies -> unsupported
> +		 * 10-11 = unallocated
> +		 * 14 = PIN(ON) -> unsupported (unused RDS feature)
> +		 * 15 = reserved for broadcasters use */
> +		return updated_fields;
> +	}
> +	/* PS Name */
> +	else if (variant_code < 4) {
> +		eon_index = rds_add_eon_entry(priv_state, pi_on);
> +		handle->rds_eon.eon[eon_index].ps[variant_code*2] = grp->data_c_msb;
> +		handle->rds_eon.eon[eon_index].ps[variant_code*2+1] = grp->data_c_lsb;
> +		handle->rds_eon.eon[eon_index].valid_fields |= V4L2_RDS_PS;
> +		updated_fields |= V4L2_RDS_EON;
> +	}
> +	/* Alternative frequencies */
> +	else if (variant_code == 4) {
> +		uint8_t c_msb = grp->data_c_msb;
> +		uint8_t c_lsb = grp->data_c_lsb;
> +		eon_index = rds_add_eon_entry(priv_state, pi_on);
> +
> +		/* 224..249: announcement of AF count (224=0, 249=25)*/

Space before '*/'

> +		if (c_msb >= 224 && c_msb <= 249)
> +		handle->rds_eon.eon[eon_index].af.announced_af = c_msb - 224;

Incorrect indentation, this line needs an additional TAB.

I would also suggest using a temp variable pointing to &handle->rds_eon.eon[eon_index].
That should make it more readable.

> +		/* check if the data represents an AF (for 1 =< val <= 204 the
> +		 * value represents an AF) */
> +		if (c_msb < 205)
> +			new_a = rds_add_af_to_list(&handle->rds_eon.eon[eon_index].af,
> +					grp->data_c_msb, true);
> +		if (c_lsb < 205)
> +			new_b = rds_add_af_to_list(&handle->rds_eon.eon[eon_index].af,
> +					grp->data_c_lsb, true);
> +		/* check if one of the frequencies was previously unknown */
> +		if (new_a || new_b) {
> +			handle->rds_eon.eon[eon_index].valid_fields |= V4L2_RDS_AF;
> +			updated_fields |= V4L2_RDS_EON;
> +		}
> +	}
> +	/* Linkage information */
> +	else if (variant_code == 12) {
> +		eon_index = rds_add_eon_entry(priv_state, pi_on);
> +		/* group c contains the lsf code */
> +		lsf_on = (grp->data_c_msb << 8) | grp->data_c_lsb;
> +		/* check if the lsf code is already known */
> +		new_a = (handle->rds_eon.eon[eon_index].lsf == lsf_on) ? false : true;

Just use:

	new_a = (handle->rds_eon.eon[eon_index].lsf != lsf_on);

Ditto elsewhere.

> +		if (new_a) {
> +			handle->rds_eon.eon[eon_index].lsf = lsf_on;
> +			handle->rds_eon.eon[eon_index].valid_fields |= V4L2_RDS_LSF;
> +			updated_fields |= V4L2_RDS_EON;
> +		}
> +	}
> +	/* PTY(ON) and TA(ON) */
> +	else if (variant_code == 13) {
> +		eon_index = rds_add_eon_entry(priv_state, pi_on);
> +		/* bits 15-10 of group c contain the PTY(ON) */
> +		pty_on = grp->data_c_msb >> 3;
> +		/* bit 0 of group c contains the TA code */
> +		ta_on = grp->data_c_lsb & 0x01;
> +		/* check if the data is new */
> +		new_a = (handle->rds_eon.eon[eon_index].pty == pty_on) ? false : true;
> +		if (new_a) {
> +			handle->rds_eon.eon[eon_index].pty = pty_on;
> +			handle->rds_eon.eon[eon_index].valid_fields |= V4L2_RDS_PTY;
> +		}
> +		new_b = (handle->rds_eon.eon[eon_index].ta == ta_on) ? false : true;
> +		handle->rds_eon.eon[eon_index].ta = ta_on;
> +		handle->rds_eon.eon[eon_index].valid_fields |= V4L2_RDS_TA;
> +		if (new_a || new_b)
> +			updated_fields |= V4L2_RDS_EON;
> +	}
> +	/* set valid field for EON data, if EON table contains entries */
> +	if (handle->rds_eon.size > 0)
> +		handle->valid_fields |= V4L2_RDS_EON;
> +
> +	return updated_fields;
> +}
> +
>  typedef uint32_t (*decode_group_func)(struct rds_private_state *);
>  
>  /* array of function pointers to contain all group specific decoding functions */
> @@ -992,6 +1155,7 @@ static const decode_group_func decode_group[16] = {
>  	[4] = rds_decode_group4,
>  	[8] = rds_decode_group8,
>  	[10] = rds_decode_group10,
> +	[14] = rds_decode_group14
>  };
>  
>  static uint32_t rds_decode_group(struct rds_private_state *priv_state)
> 

Regards,

	Hans
