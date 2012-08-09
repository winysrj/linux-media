Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1844 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196Ab2HIMOw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Aug 2012 08:14:52 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [RFC PATCH 1/2] Add libv4l2rds library (with changes proposed in RFC)
Date: Thu, 9 Aug 2012 14:14:11 +0200
Cc: Konke Radlow <kradlow@cisco.com>, linux-media@vger.kernel.org,
	koradlow@gmail.com
References: <[RFC PATCH 0/2] Add support for RDS decoding> <bce8b8118e9a8bcc7fd528d8b8d1a0732a9c8954.1344352285.git.kradlow@cisco.com> <5023A5CF.3020702@redhat.com>
In-Reply-To: <5023A5CF.3020702@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208091414.11249.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu August 9 2012 13:58:07 Hans de Goede wrote:
> Hi Konke,
> 
> As Gregor already mentioned there is no need to define libv4l2rdssubdir in configure.ac ,
> so please drop that.
> 
> Other then that I've some minor remarks (comments inline), with all those
> fixed, this one is could to go. So hopefully the next version can be added
> to git master!
> 
> On 08/07/2012 05:11 PM, Konke Radlow wrote:
> > ---
> >   Makefile.am                     |    3 +-
> >   configure.ac                    |    7 +-
> >   lib/include/libv4l2rds.h        |  228 ++++++++++
> >   lib/libv4l2rds/Makefile.am      |   11 +
> >   lib/libv4l2rds/libv4l2rds.c     |  953 +++++++++++++++++++++++++++++++++++++++
> >   lib/libv4l2rds/libv4l2rds.pc.in |   11 +
> >   6 files changed, 1211 insertions(+), 2 deletions(-)
> >   create mode 100644 lib/include/libv4l2rds.h
> >   create mode 100644 lib/libv4l2rds/Makefile.am
> >   create mode 100644 lib/libv4l2rds/libv4l2rds.c
> >   create mode 100644 lib/libv4l2rds/libv4l2rds.pc.in
> >
> 
> <snip>
> 
> > diff --git a/lib/include/libv4l2rds.h b/lib/include/libv4l2rds.h
> > new file mode 100644
> > index 0000000..4aa8593
> > --- /dev/null
> > +++ b/lib/include/libv4l2rds.h
> > @@ -0,0 +1,228 @@
> > +/*
> > + * Copyright 2012 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
> > + * Author: Konke Radlow <koradlow@gmail.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU Lesser General Public License as published by
> > + * the Free Software Foundation; either version 2.1 of the License, or
> > + * (at your option) any later version.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write to the Free Software
> > + * Foundation, Inc., 51 Franklin Street, Suite 500, Boston, MA  02110-1335  USA
> > + */
> > +
> > +#ifndef __LIBV4L2RDS
> > +#define __LIBV4L2RDS
> > +
> > +#include <errno.h>
> > +#include <stdio.h>
> > +#include <stdlib.h>
> > +#include <string.h>
> > +#include <stdbool.h>
> > +#include <unistd.h>
> > +#include <stdint.h>
> > +#include <time.h>
> > +#include <sys/types.h>
> > +#include <sys/mman.h>
> > +#include <config.h>
> 
> You should never include config.h in a public header, also
> are all the headers really needed for the prototypes in this header?
> 
> I don't think so! Please move all the unneeded ones to the libv4l2rds.c
> file!
> 
> > +
> > +#include <linux/videodev2.h>
> > +
> > +#ifdef __cplusplus
> > +extern "C" {
> > +#endif /* __cplusplus */
> > +
> > +#if HAVE_VISIBILITY
> > +#define LIBV4L_PUBLIC __attribute__ ((visibility("default")))
> > +#else
> > +#define LIBV4L_PUBLIC
> > +#endif
> > +
> > +/* used to define the current version (version field) of the v4l2_rds struct */
> > +#define V4L2_RDS_VERSION (1)
> > +
> 
> What is the purpose of this field? Once we've released a v4l-utils with this
> library we are stuck to the API we've defined, having a version field & changing it,
> won't stop us from breaking existing apps, so once we've an official release we
> simply cannot make ABI breaking changes, which is why most of my review sofar
> has concentrated on the API side :)
> 
> I suggest dropping this define and the version field from the struct.

I think it is useful, actually. The v4l2_rds struct is allocated by the v4l2_rds_create
so at least in theory it is possible to extend the struct in the future without breaking
existing apps, provided you have a version number to check.

Regards,

	Hans

> 
> > +/* Constants used to define the size of arrays used to store RDS information */
> > +#define MAX_ODA_CNT 18 	/* there are 16 groups each with type a or b. Of these
> > +			 * 32 distinct groups, 18 can be used for ODA purposes */
> > +#define MAX_AF_CNT 25	/* AF Method A allows a maximum of 25 AFs to be defined
> > +			 * AF Method B does not impose a limit on the number of AFs
> > +			 * but it is not fully supported at the moment and will
> > +			 * not receive more than 25 AFs */
> > +
> > +/* Define Constants for the possible types of RDS information
> > + * used to address the relevant bit in the valid_fields bitmask */
> > +#define V4L2_RDS_PI 		0x01	/* Program Identification */
> > +#define V4L2_RDS_PTY		0x02	/* Program Type */
> > +#define V4L2_RDS_TP		0x04	/* Traffic Program */
> > +#define V4L2_RDS_PS		0x08	/* Program Service Name */
> > +#define V4L2_RDS_TA		0x10	/* Traffic Announcement */
> > +#define V4L2_RDS_DI		0x20	/* Decoder Information */
> > +#define V4L2_RDS_MS		0x40	/* Music / Speech flag */
> > +#define V4L2_RDS_PTYN		0x80	/* Program Type Name */
> > +#define V4L2_RDS_RT		0x100 	/* Radio-Text */
> > +#define V4L2_RDS_TIME		0x200	/* Date and Time information */
> > +#define V4L2_RDS_TMC		0x400	/* TMC availability */
> > +#define V4L2_RDS_AF		0x800	/* AF (alternative freq) available */
> > +#define V4L2_RDS_ECC		0x1000	/* Extended County Code */
> > +#define V4L2_RDS_LC		0x2000	/* Language Code */
> > +
> > +/* Define Constants for the state of the RDS decoding process
> > + * used to address the relevant bit in the decode_information bitmask */
> > +#define V4L2_RDS_GROUP_NEW 	0x01	/* New group received */
> > +#define V4L2_RDS_ODA		0x02	/* Open Data Group announced */
> > +
> > +/* Decoder Information (DI) codes
> > + * used to decode the DI information according to the RDS standard */
> > +#define V4L2_RDS_FLAG_STEREO 		0x01
> > +#define V4L2_RDS_FLAG_ARTIFICIAL_HEAD	0x02
> > +#define V4L2_RDS_FLAG_COMPRESSED	0x04
> > +#define V4L2_RDS_FLAG_STATIC_PTY	0x08
> > +
> > +/* struct to encapsulate one complete RDS group */
> > +/* This structure is used internally to store data until a complete RDS
> > + * group was received and group id dependent decoding can be done.
> > + * It is also used to provide external access to uninterpreted RDS groups
> > + * when manual decoding is required (e.g. special ODA types) */
> > +struct v4l2_rds_group {
> > +	uint16_t pi;		/* Program Identification */
> > +	char group_version;	/* group version ('A' / 'B') */
> > +	uint8_t group_id;	/* group number (0..16) */
> > +
> > +	/* uninterpreted data blocks for decoding (e.g. ODA) */
> > +	uint8_t data_b_lsb;
> > +	uint8_t data_c_msb;
> > +	uint8_t data_c_lsb;
> > +	uint8_t data_d_msb;
> > +	uint8_t data_d_lsb;
> > +};
> > +
> > +/* struct to encapsulate some statistical information about the decoding process */
> > +struct v4l2_rds_statistics {
> > +	uint32_t block_cnt;		/* total amount of received blocks */
> > +	uint32_t group_cnt;		/* total amount of successfully
> > +					 * decoded groups */
> > +	uint32_t block_error_cnt;	/* blocks that were marked as erroneous
> > +					 * and had to be dropped */
> > +	uint32_t group_error_cnt;	/* group decoding processes that had to be
> > +					 * aborted because of erroneous blocks
> > +					 * or wrong order of blocks */
> > +	uint32_t block_corrected_cnt;	/* blocks that contained 1-bit errors
> > +					 * which were corrected */
> > +	uint32_t group_type_cnt[16];	/* number of occurrence for each
> > +					 * defined RDS group */
> > +};
> > +
> > +/* struct to encapsulate the definition of one ODA (Open Data Application) type */
> > +struct v4l2_rds_oda {
> > +	uint8_t group_id;	/* RDS group used to broadcast this ODA */
> > +	char group_version;	/* group version (A / B) for this ODA */
> > +	uint16_t aid;		/* Application Identification for this ODA,
> > +				 * AIDs are centrally administered by the
> > +				 * RDS Registration Office (rds.org.uk) */
> > +};
> > +
> > +/* struct to encapsulate an array of all defined ODA types for a channel */
> > +/* This structure will grow with ODA announcements broadcasted in type 3A
> > + * groups, that were verified not to be no duplicates or redefinitions */
> > +struct v4l2_rds_oda_set {
> > +	uint8_t size;		/* number of ODAs defined by this channel */
> > +	struct v4l2_rds_oda oda[MAX_ODA_CNT];
> > +};
> > +
> > +/* struct to encapsulate an array of Alternative Frequencies for a channel */
> > +/* Every channel can send out AFs for his program. The number of AFs that
> > + * will be broadcasted is announced by the channel */
> > +struct v4l2_rds_af_set {
> > +	uint8_t size;			/* size of the set (might be smaller
> > +					 * than the announced size) */
> > +	uint8_t announced_af;		/* number of announced AF */
> > +	uint32_t af[MAX_AF_CNT];	/* AFs defined in Hz */
> > +};
> > +
> > +/* struct to encapsulate state and RDS information for current decoding process */
> > +/* This is the structure that will be used by external applications, to
> > + * communicate with the library and get access to RDS data */
> > +struct v4l2_rds {
> > +	uint32_t version;	/* version number of this structure */
> > +
> > +	/** state information **/
> > +	uint32_t decode_information;	/* state of decoding process */
> > +	uint32_t valid_fields;		/* currently valid info fields
> > +					 * of this structure */
> > +
> > +	/** RDS info fields **/
> > +	bool is_rbds; 		/* use RBDS standard version of LUTs */
> > +	uint16_t pi;		/* Program Identification */
> > +	uint8_t ps[9];		/* Program Service Name, UTF-8 encoding,
> > +				 * '\0' terminated */
> > +	uint8_t pty;		/* Program Type */
> > +	uint8_t ptyn[9];	/* Program Type Name, UTF-8 encoding,
> > +				 * '\0' terminated */
> > +	bool ptyn_ab_flag;	/* PTYN A/B flag (toggled), to signal
> > +				 * change of PTYN */
> > +	uint8_t rt_length;	/* length of RT string */
> > +	uint8_t rt[65];		/* Radio-Text string, UTF-8 encoding,
> > +				 * '\0' terminated */
> > +	bool rt_ab_flag;	/* RT A/B flag (toggled), to signal
> > +				 * transmission of new RT */
> > +	bool ta;		/* Traffic Announcement */
> > +	bool tp;		/* Traffic Program */
> > +	bool ms;		/* Music / Speech flag */
> > +	uint8_t di;		/* Decoder Information */
> > +	uint8_t ecc;		/* Extended Country Code */
> > +	uint8_t lc;		/* Language Code */
> > +	time_t time;		/* Time and Date of transmission */
> > +
> > +	struct v4l2_rds_statistics rds_statistics;
> > +	struct v4l2_rds_oda_set rds_oda;	/* Open Data Services */
> > +	struct v4l2_rds_af_set rds_af; 		/* Alternative Frequencies */
> > +};
> > +
> > +/* v4l2_rds_init() - initializes a new decoding process
> > + * @is_rbds:	defines which standard is used: true=RBDS, false=RDS
> > + *
> > + * initialize a new instance of the RDS-decoding struct and return
> > + * a handle containing state and RDS information, used to interact
> > + * with the library functions */
> > +LIBV4L_PUBLIC struct v4l2_rds *v4l2_rds_create(bool is_rdbs);
> > +
> > +/* frees all memory allocated for the RDS-decoding struct */
> > +LIBV4L_PUBLIC void v4l2_rds_destroy(struct v4l2_rds *handle);
> > +
> > +/* resets the RDS information in the handle to initial values
> > + * e.g. can be used when radio channel is changed
> > + * @reset_statistics:	true = set all statistic values to 0, false = keep them untouched */
> > +LIBV4L_PUBLIC void v4l2_rds_reset(struct v4l2_rds *handle, bool reset_statistics);
> > +
> > +/* adds a raw RDS block to decode it into RDS groups
> > + * @return:	bitmask with with updated fields set to 1
> > + * @rds_data: 	3 bytes of raw RDS data, obtained by calling read()
> > + * 				on RDS capable V4L2 devices */
> > +LIBV4L_PUBLIC uint32_t v4l2_rds_add(struct v4l2_rds *handle, struct v4l2_rds_data *rds_data);
> > +
> > +/*
> > + * group of functions to translate numerical RDS data into strings
> > + *
> > + * return program description string defined in the RDS/RBDS Standard
> > + * ! return value deepens on selected Standard !*/
> 
>                       ^^^^^^^ Typo!
> 
> > +LIBV4L_PUBLIC const char *v4l2_rds_get_pty_str(const struct v4l2_rds *handle);
> > +LIBV4L_PUBLIC const char *v4l2_rds_get_language_str(const struct v4l2_rds *handle);
> > +LIBV4L_PUBLIC const char *v4l2_rds_get_country_str(const struct v4l2_rds *handle);
> > +LIBV4L_PUBLIC const char *v4l2_rds_get_coverage_str(const struct v4l2_rds *handle);
> > +
> > +/* returns a pointer to the last decoded RDS group, in order to give raw
> > + * access to RDS data if it is required (e.g. ODA decoding) */
> > +LIBV4L_PUBLIC const struct v4l2_rds_group *v4l2_rds_get_group
> > +	(const struct v4l2_rds *handle);
> > +
> > +
> > +#ifdef __cplusplus
> > +}
> > +#endif /* __cplusplus */
> > +#endif
> 
> <snip>
> 
> The rest looks good to me.
> 
> Regards,
> 
> Hans
> 
