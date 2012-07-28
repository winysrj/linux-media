Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1821 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752246Ab2G1LC7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Jul 2012 07:02:59 -0400
Message-ID: <5013C828.9090307@redhat.com>
Date: Sat, 28 Jul 2012 13:08:24 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Konke Radlow <kradlow@cisco.com>
CC: linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] Initial version of the RDS-decoder library  Signed-off-by:
 Konke Radlow <kradlow@cisco.com>
References: <201207261621.26669.kradlow@cisco.com>
In-Reply-To: <201207261621.26669.kradlow@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

First of all many thanks for working on this! Note I've also taken
a quick look at the original patch with the actual implementation and that looks
good. I'm replying here because in my mind the API is the most interesting
thing to discuss.

Comments inline.

On 07/26/2012 06:21 PM, Konke Radlow wrote:
> PATCH 1/2 was missing the public header for the rds library. I'm sorry for
> that mistake:
>
> diff --git a/lib/include/libv4l2rds.h b/lib/include/libv4l2rds.h
> new file mode 100644
> index 0000000..04843d3
> --- /dev/null
> +++ b/lib/include/libv4l2rds.h
> @@ -0,0 +1,203 @@
> +/*
> + * Copyright 2012 Cisco Systems, Inc. and/or its affiliates. All rights
> reserved.
> + * Author: Konke Radlow <koradlow@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU Lesser General Public License as published
> by
> + * the Free Software Foundation; either version 2.1 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin Street, Suite 500, Boston, MA  02110-1335
> USA
> + */
> +
> +#ifndef __LIBV4L2RDS
> +#define __LIBV4L2RDS
> +
> +#include <errno.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <stdbool.h>
> +#include <unistd.h>
> +#include <stdint.h>
> +#include <sys/types.h>
> +#include <sys/mman.h>
> +
> +#include <linux/videodev2.h>
> +
> +#ifdef __cplusplus
> +extern "C" {
> +#endif /* __cplusplus */
> +
> +#if __GNUC__ >= 4
> +#define LIBV4L_PUBLIC __attribute__ ((visibility("default")))
> +#else
> +#define LIBV4L_PUBLIC
> +#endif
> +
> +/* used to define the current version (version field) of the v4l2_rds struct */
> +#define V4L2_RDS_VERSION (1)	
> +
> +/* Constants used to define the size of arrays used to store RDS information
> */
> +#define MAX_ODA_CNT 18 	/* there are 16 groups each with type a or b. Of these
> +			 * 32 distinct groups, 18 can be used for ODA  purposes*/
> +#define MAX_AF_CNT 25	/* AF Method A allows a maximum of 25 AFs to be
> defined
> +			 * AF Method B does not impose a limit on the number of AFs
> +			 * but it is not fully supported at the moment and will
> +			 * not receive more than 25 AFs */
> +
> +/* Define Constants for the possible types of RDS information
> + * used to address the relevant bit in the valid_bitmask */
> +#define V4L2_RDS_PI 		0x01	/* Program Identification */
> +#define V4L2_RDS_PTY		0x02	/* Program Type */
> +#define V4L2_RDS_TP		0x04	/* Traffic Program */
> +#define V4L2_RDS_PS		0x08	/* Program Service Name */
> +#define V4L2_RDS_TA		0x10	/* Traffic Announcement */
> +#define V4L2_RDS_DI		0x20	/* Decoder Information */
> +#define V4L2_RDS_MS		0x40	/* Music / Speech code */
> +#define V4L2_RDS_PTYN		0x80	/* Program Type Name */
> +#define V4L2_RDS_RT		0x100 	/* Radio-Text */
> +#define V4L2_RDS_TIME		0x200	/* Date and Time information */
> +#define V4L2_RDS_TMC		0x400	/* TMC availability */
> +#define V4L2_RDS_AF		0x800	/* AF (alternative freq) available */
> +#define V4L2_RDS_ECC		0x1000	/* Extended County Code */
> +#define V4L2_RDS_LC		0x2000	/* Language Code */
> +
> +/* Define Constants for the state of the RDS decoding process
> + * used to address the relevant bit in the state_bitmask */
> +#define V4L2_RDS_GROUP_NEW 	0x01	/* New group received */
> +#define V4L2_RDS_ODA		0x02	/* Open Data Group announced */
> +
> +/* Decoder Information (DI) codes
> + * used to decode the DI information according to the RDS standard */
> +#define V4L2_RDS_FLAG_STEREO 		0x01
> +#define V4L2_RDS_FLAG_ARTIFICIAL_HEAD	0x02
> +#define V4L2_RDS_FLAG_COMPRESSED	0x04
> +#define V4L2_RDS_FLAG_STATIC_PTY	0x08
> +
> +/* struct to encapsulate one complete RDS group */
> +struct v4l2_rds_group {
> +	uint16_t pi;
> +	char group_version;
> +	bool traffic_prog;
> +	uint8_t group_id;
> +	uint8_t pty;
> +	uint8_t data_b_lsb;
> +	uint8_t data_c_msb;
> +	uint8_t data_c_lsb;
> +	uint8_t data_d_msb;
> +	uint8_t data_d_lsb;
> +};
> +
> +/* struct to encapsulate some statistical information about the decoding
> process */
> +struct v4l2_rds_statistics {
> +	uint32_t block_cnt;
> +	uint32_t group_cnt;
> +	uint32_t block_error_cnt;
> +	uint32_t group_error_cnt;
> +	uint32_t block_corrected_cnt;
> +	uint32_t group_type_cnt[16];
> +};
> +
> +/* struct to encapsulate the definition of one ODA (Open Data Application)
> type */
> +struct v4l2_rds_oda {
> +	uint8_t group_id;
> +	char group_version;
> +	uint16_t aid;		/* Application Identification */
> +};
> +
> +/* struct to encapsulate an array of all defined ODA types for a channel */
> +struct v4l2_rds_oda_set {
> +	uint8_t size;
> +	struct v4l2_rds_oda oda[MAX_ODA_CNT];
> +};
> +
> +/* struct to encapsulate an array of all defined Alternative Frequencies for a
> channel */
> +struct v4l2_rds_af_set {
> +	uint8_t size;
> +	uint8_t announced_af;		/* number of announced AF */
> +	uint32_t af[MAX_AF_CNT];	/* AFs defined in Hz */
> +};
> +
> +/* struct to encapsulate state and RDS information for current decoding
> process */


Most fields in this struct (and in the other structs for that matter) could do
with some more documentation.

> +struct v4l2_rds {
> +	uint32_t version;
> +
> +	/** state information **/
> +	uint32_t decode_information;	/* defines the state of the decoding process
> */
> +	uint32_t valid_fields;	/* defines the RDS info fields that are valid atm
> */
> +
> +	/** RDS info fields **/
> +	bool is_rbds; 		/* use RBDS standard version of LUTs */
> +	uint16_t pi;
> +	uint8_t ps[8];

Looking at rds-ctl, this contains a string, please make it 9 bytes and always 0 terminate it!
I also notice in rds-ctl that you filter the chars for being valid ascii and if not replace
them with a space. Does the spec say anything about the encoding used for this string? Could
we maybe convert it to UTF-8 inside the library so that apps can just consume the string?

> +	uint8_t pty;
> +	uint8_t ptyn[8];

Same remark as for ps.

> +	bool ptyn_ab_flag;	/* PTYN A/B flag (toggled), to signal change of program
> type */
> +	uint8_t rt_pos;
> +	uint8_t rt_length;
> +	uint8_t rt[64];

Same remark as for ps.

> +	bool rt_ab_flag;	/* RT A/B flag (toggled), to signal transmission of new
> RT */
> +	bool ta;
> +	bool tp;
> +	bool ms;
> +	uint8_t di;
> +	uint8_t ecc;
> +	uint8_t lc;
> +	uint32_t julian_date;
> +	uint8_t utc_hour;
> +	uint8_t utc_minute;
> +	uint8_t utc_offset;
> +
> +	struct v4l2_rds_statistics rds_statistics;
> +	struct v4l2_rds_oda_set rds_oda;
> +	struct v4l2_rds_af_set rds_af;
> +};
> +
> +/* v4l2_rds_init() - initializes a new decoding process
> + * @rds:	defines which standard is used: true=RDS, false=RBDS
> + *
> + * initialize a new instance of the RDS-decoding struct and return
> + * a handle containing state and RDS information, used to interact
> + * with the library functions */
> +LIBV4L_PUBLIC struct v4l2_rds *v4l2_rds_create(bool is_rds);
> +
> +/* frees all memory allocated for the struct */
> +LIBV4L_PUBLIC void v4l2_rds_destroy(struct v4l2_rds *handle);
> +
> +/* resets the RDS information in the handle to initial values
> + * e.g. can be used when radio channel is changed
> + * @reset_statistics:	true = set all statistic values to 0, false = keep
> them untouched */
> +LIBV4L_PUBLIC void v4l2_rds_reset(struct v4l2_rds *handle, bool
> reset_statistics);
> +
> +/* adds a raw RDS block to decode it into RDS groups
> + * @return:	bitmask with with updated fields set to 1
> + * @rds_data: 	3 bytes of raw RDS data, obtained by calling read()
> + * 				on RDS capable V4L2 devices */
> +LIBV4L_PUBLIC uint32_t v4l2_rds_add(struct v4l2_rds *handle, struct
> v4l2_rds_data *rds_data);

Unless I'm missing something, you are no defining struct v4l2_rds_data anywhere,
why not just make this a uint8_t ?

> +
> +/*
> + * group of functions to translate numerical RDS data into strings
> + *
> + * return program description string defined in the RDS/RBDS Standard
> + * ! return value deepens on selected Standard !*/
> +LIBV4L_PUBLIC const char *v4l2_rds_get_pty_str(const struct v4l2_rds
> *handle);
> +LIBV4L_PUBLIC const char *v4l2_rds_get_language_str(const struct v4l2_rds
> *handle);
> +LIBV4L_PUBLIC const char *v4l2_rds_get_country_str(const struct v4l2_rds
> *handle);
> +LIBV4L_PUBLIC const char *v4l2_rds_get_coverage_str(const struct v4l2_rds
> *handle);
> +
> +/* returns a pointer to the last decoded RDS group, in order to give raw
> + * access to RDS data if it is required (e.g. ODA decoding) */
> +LIBV4L_PUBLIC const struct v4l2_rds_group *v4l2_rds_get_group
> +	(const struct v4l2_rds *handle);
> +#ifdef __cplusplus
> +}
> +#endif /* __cplusplus */
> +#endif


Regards,

Hans
