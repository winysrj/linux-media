Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:21895 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878Ab3L2EMl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Dec 2013 23:12:41 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MYJ004ARVP4G870@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Sat, 28 Dec 2013 23:12:40 -0500 (EST)
Date: Sun, 29 Dec 2013 01:58:55 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: =?UTF-8?B?QW5kcsOp?= Roth <neolynx@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 08/13] libdvbv5: ATSC EIT
Message-id: <20131229015855.4ff13cc5.m.chehab@samsung.com>
In-reply-to: <1388245561-8751-8-git-send-email-neolynx@gmail.com>
References: <1388245561-8751-1-git-send-email-neolynx@gmail.com>
 <1388245561-8751-8-git-send-email-neolynx@gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 28 Dec 2013 16:45:56 +0100
André Roth <neolynx@gmail.com> escreveu:

> Signed-off-by: André Roth <neolynx@gmail.com>
> ---
>  lib/include/descriptors/atsc_eit.h     |  91 +++++++++++++++++++++
>  lib/include/descriptors/atsc_header.h  |  64 +++++++++++++++
>  lib/include/descriptors/mgt.h          |  25 +++---
>  lib/include/descriptors/vct.h          |  39 ++++-----
>  lib/include/dvb-scan.h                 |   2 +-
>  lib/libdvbv5/Makefile.am               |   3 +
>  lib/libdvbv5/descriptors.c             |  19 +++--
>  lib/libdvbv5/descriptors/atsc_eit.c    | 143 +++++++++++++++++++++++++++++++++
>  lib/libdvbv5/descriptors/atsc_header.c |  48 +++++++++++
>  lib/libdvbv5/descriptors/eit.c         |   2 +-
>  lib/libdvbv5/descriptors/mgt.c         |  41 +++++-----
>  lib/libdvbv5/descriptors/vct.c         |  39 +++++----
>  lib/libdvbv5/dvb-file.c                |   2 +-
>  lib/libdvbv5/dvb-scan.c                |  10 +--
>  14 files changed, 442 insertions(+), 86 deletions(-)
>  create mode 100644 lib/include/descriptors/atsc_eit.h
>  create mode 100644 lib/include/descriptors/atsc_header.h
>  create mode 100644 lib/libdvbv5/descriptors/atsc_eit.c
>  create mode 100644 lib/libdvbv5/descriptors/atsc_header.c
> 
> diff --git a/lib/include/descriptors/atsc_eit.h b/lib/include/descriptors/atsc_eit.h
> new file mode 100644
> index 0000000..ded7a64
> --- /dev/null
> +++ b/lib/include/descriptors/atsc_eit.h
> @@ -0,0 +1,91 @@
> +/*
> + * Copyright (c) 2011-2012 - Mauro Carvalho Chehab <mchehab@redhat.com>

I'm not the author.

> + * Copyright (c) 2012 - Andre Roth <neolynx@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation version 2
> + * of the License.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
> + * Or, point your browser to http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
> + *
> + */
> +
> +#ifndef _ATSC_EIT_H
> +#define _ATSC_EIT_H
> +
> +#include <stdint.h>
> +#include <unistd.h> /* ssize_t */
> +#include <time.h>
> +
> +#include "descriptors/atsc_header.h"
> +#include "descriptors.h"
> +
> +#define ATSC_TABLE_EIT        0xCB
> +
> +struct atsc_table_eit_event {
> +	union {
> +		uint16_t bitfield;
> +		struct {
> +	          uint16_t event_id:14;
> +	          uint16_t one:2;
> +		} __attribute__((packed));
> +	} __attribute__((packed));
> +	uint32_t start_time;
> +	union {
> +		uint32_t bitfield2;
> +		struct {
> +			uint32_t title_length:8;
> +			uint32_t duration:20;
> +			uint32_t etm:2;
> +			uint32_t one2:2;
> +			uint32_t :2;
> +		} __attribute__((packed));
> +	} __attribute__((packed));
> +	struct dvb_desc *descriptor;
> +	struct atsc_table_eit_event *next;
> +	struct tm start;
> +	uint16_t source_id;
> +} __attribute__((packed));
> +
> +union atsc_table_eit_desc_length {
> +	uint16_t bitfield;
> +	struct {
> +		uint16_t desc_length:12;
> +		uint16_t reserved:4;
> +	} __attribute__((packed));
> +} __attribute__((packed));
> +
> +struct atsc_table_eit {
> +	struct atsc_table_header header;
> +	uint8_t events;
> +	struct atsc_table_eit_event *event;
> +} __attribute__((packed));
> +
> +#define atsc_eit_event_foreach(_event, _eit) \
> +	for( struct atsc_table_eit_event *_event = _eit->event; _event; _event = _event->next ) \
> +
> +struct dvb_v5_fe_parms;
> +
> +#ifdef __cplusplus
> +extern "C" {
> +#endif
> +
> +void atsc_table_eit_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length);
> +void atsc_table_eit_free(struct atsc_table_eit *eit);
> +void atsc_table_eit_print(struct dvb_v5_fe_parms *parms, struct atsc_table_eit *eit);
> +void atsc_time(const uint32_t start_time, struct tm *tm);
> +
> +#ifdef __cplusplus
> +}
> +#endif
> +
> +#endif
> diff --git a/lib/include/descriptors/atsc_header.h b/lib/include/descriptors/atsc_header.h
> new file mode 100644
> index 0000000..481d15f
> --- /dev/null
> +++ b/lib/include/descriptors/atsc_header.h
> @@ -0,0 +1,64 @@
> +/*
> + * Copyright (c) 2011-2012 - Mauro Carvalho Chehab <mchehab@redhat.com>

I'm not the author.


> + * Copyright (c) 2012 - Andre Roth <neolynx@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation version 2
> + * of the License.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
> + * Or, point your browser to http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
> + *
> + */
> +
> +#ifndef _ATSC_HEADER_H
> +#define _ATSC_HEADER_H
> +
> +#include <stdint.h>
> +#include <unistd.h> /* ssize_t */
> +
> +#define ATSC_BASE_PID  0x1FFB
> +
> +struct atsc_table_header {
> +	uint8_t  table_id;
> +	union {
> +		uint16_t bitfield;
> +		struct {
> +			uint16_t section_length:12;
> +			uint16_t one:2;
> +			uint16_t priv:1;
> +			uint16_t syntax:1;
> +		} __attribute__((packed));
> +	};
> +	uint16_t id;
> +	uint8_t  current_next:1;
> +	uint8_t  version:5;
> +	uint8_t  one2:2;
> +
> +	uint8_t  section_id;
> +	uint8_t  last_section;
> +	uint8_t  protocol_version;
> +} __attribute__((packed));
> +
> +struct dvb_v5_fe_parms;
> +
> +#ifdef __cplusplus
> +extern "C" {
> +#endif
> +
> +int  atsc_table_header_init (struct atsc_table_header *t);
> +void atsc_table_header_print(struct dvb_v5_fe_parms *parms, const struct atsc_table_header *t);
> +
> +#ifdef __cplusplus
> +}
> +#endif
> +
> +#endif
> diff --git a/lib/include/descriptors/mgt.h b/lib/include/descriptors/mgt.h
> index 4a68f2c..889d026 100644
> --- a/lib/include/descriptors/mgt.h
> +++ b/lib/include/descriptors/mgt.h
> @@ -25,12 +25,12 @@
>  #include <stdint.h>
>  #include <unistd.h> /* ssize_t */
>  
> -#include "descriptors/header.h"
> +#include "descriptors/atsc_header.h"
>  #include "descriptors.h"
>  
> -#define DVB_TABLE_MGT      0xC7
> +#define ATSC_TABLE_MGT 0xC7
>  
> -struct dvb_table_mgt_table {
> +struct atsc_table_mgt_table {
>  	uint16_t type;
>  	union {
>  		uint16_t bitfield;
> @@ -50,20 +50,19 @@ struct dvb_table_mgt_table {
>  		} __attribute__((packed));
>  	} __attribute__((packed));
>  	struct dvb_desc *descriptor;
> -	struct dvb_table_mgt_table *next;
> +	struct atsc_table_mgt_table *next;
>  } __attribute__((packed));
>  
> -struct dvb_table_mgt {
> -	struct dvb_table_header header;
> -        uint8_t  protocol_version;
> +struct atsc_table_mgt {
> +	struct atsc_table_header header;
>          uint16_t tables;
> -        struct dvb_table_mgt_table *table;
> +        struct atsc_table_mgt_table *table;
>  	struct dvb_desc *descriptor;
>  } __attribute__((packed));
>  
>  
> -#define dvb_mgt_transport_foreach( tran, mgt ) \
> -  for( struct dvb_table_mgt_transport *tran = mgt->transport; tran; tran = tran->next ) \
> +#define dvb_mgt_table_foreach( tran, mgt ) \
> +  for( struct dvb_table_mgt_table *tran = mgt->table; tran; tran = tran->next ) \
>  
>  struct dvb_v5_fe_parms;
>  
> @@ -71,9 +70,9 @@ struct dvb_v5_fe_parms;
>  extern "C" {
>  #endif
>  
> -void dvb_table_mgt_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length);
> -void dvb_table_mgt_free(struct dvb_table_mgt *mgt);
> -void dvb_table_mgt_print(struct dvb_v5_fe_parms *parms, struct dvb_table_mgt *mgt);
> +void atsc_table_mgt_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length);
> +void atsc_table_mgt_free(struct atsc_table_mgt *mgt);
> +void atsc_table_mgt_print(struct dvb_v5_fe_parms *parms, struct atsc_table_mgt *mgt);
>  
>  #ifdef __cplusplus
>  }
> diff --git a/lib/include/descriptors/vct.h b/lib/include/descriptors/vct.h
> index 505a407..8afd0b8 100644
> --- a/lib/include/descriptors/vct.h
> +++ b/lib/include/descriptors/vct.h
> @@ -25,25 +25,25 @@
>  #include <stdint.h>
>  #include <unistd.h> /* ssize_t */
>  
> -#include "descriptors/header.h"
> +#include "descriptors/atsc_header.h"
>  #include "descriptors.h"
>  
> -#define DVB_TABLE_TVCT     0xc8
> -#define DVB_TABLE_CVCT     0xc9
> -#define DVB_TABLE_VCT_PID  0x1ffb
> +#define ATSC_TABLE_TVCT     0xc8
> +#define ATSC_TABLE_CVCT     0xc9
> +#define ATSC_TABLE_VCT_PID  0x1ffb
>  
> -struct dvb_table_vct_channel {
> +struct atsc_table_vct_channel {
>  	uint16_t	__short_name[7];
>  
>  	union {
> -		uint32_t bitfield;
> +		uint32_t bitfield1;

I think you're touching here again, reverting what you've done on a 
previous patch.

>  		struct {
>  			uint32_t	modulation_mode:8;
>  			uint32_t	minor_channel_number:10;
>  			uint32_t	major_channel_number:10;
>  			uint32_t	reserved1:4;
>  		} __attribute__((packed));
> -	};
> +	} __attribute__((packed));
>  
>  	uint32_t	carrier_frequency;
>  	uint16_t	channel_tsid;
> @@ -61,7 +61,8 @@ struct dvb_table_vct_channel {
>  			uint16_t	ETM_location:2;
>  
>  		} __attribute__((packed));
> -	};
> +	} __attribute__((packed));
> +
>  	uint16_t source_id;
>  	union {
>  		uint16_t bitfield3;
> @@ -69,22 +70,22 @@ struct dvb_table_vct_channel {
>  			uint16_t descriptors_length:10;
>  			uint16_t reserved3:6;
>  		} __attribute__((packed));
> -	};
> +	} __attribute__((packed));
>  
>  	/*
>  	 * Everything after descriptor (including it) won't be bit-mapped
>  	 * to the data parsed from the MPEG TS. So, metadata are added there
>  	 */
>  	struct dvb_desc *descriptor;
> -	struct dvb_table_vct_channel *next;
> +	struct atsc_table_vct_channel *next;
>  
>  	/* The channel_short_name is converted to locale charset by vct.c */
>  
>  	char short_name[32];
>  } __attribute__((packed));
>  
> -struct dvb_table_vct {
> -	struct dvb_table_header header;
> +struct atsc_table_vct {
> +	struct atsc_table_header header;
>  
>  	uint8_t ATSC_protocol_version;
>  	uint8_t num_channels_in_section;
> @@ -93,12 +94,12 @@ struct dvb_table_vct {
>  	 * Everything after descriptor (including it) won't be bit-mapped
>  	 * to the data parsed from the MPEG TS. So, metadata are added there
>  	 */
> -	struct dvb_table_vct_channel *channel;
> +	struct atsc_table_vct_channel *channel;
>  	struct dvb_desc *descriptor;
>  } __attribute__((packed));
>  
>  
> -union dvb_table_vct_descriptor_length {
> +union atsc_table_vct_descriptor_length {
>  	uint16_t bitfield;
>  	struct {
>  		uint16_t descriptor_length:10;
> @@ -106,8 +107,8 @@ union dvb_table_vct_descriptor_length {
>  	};
>  };
>  
> -#define dvb_vct_channel_foreach(_channel, _vct) \
> -	for (struct dvb_table_vct_channel *_channel = _vct->channel; _channel; _channel = _channel->next) \
> +#define atsc_vct_channel_foreach(_channel, _vct) \
> +	for (struct atsc_table_vct_channel *_channel = _vct->channel; _channel; _channel = _channel->next) \
>  
>  struct dvb_v5_fe_parms;
>  
> @@ -115,9 +116,9 @@ struct dvb_v5_fe_parms;
>  extern "C" {
>  #endif
>  
> -void dvb_table_vct_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length);
> -void dvb_table_vct_free(struct dvb_table_vct *vct);
> -void dvb_table_vct_print(struct dvb_v5_fe_parms *parms, struct dvb_table_vct *vct);
> +void atsc_table_vct_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length);
> +void atsc_table_vct_free(struct atsc_table_vct *vct);
> +void atsc_table_vct_print(struct dvb_v5_fe_parms *parms, struct atsc_table_vct *vct);
>  
>  #ifdef __cplusplus
>  }
> diff --git a/lib/include/dvb-scan.h b/lib/include/dvb-scan.h
> index b5dbfa9..9aef531 100644
> --- a/lib/include/dvb-scan.h
> +++ b/lib/include/dvb-scan.h
> @@ -49,7 +49,7 @@ struct dvb_v5_descriptors {
>  	unsigned num_entry;
>  
>  	struct dvb_table_pat *pat;
> -	struct dvb_table_vct *vct;
> +	struct atsc_table_vct *vct;
>  	struct dvb_v5_descriptors_program *program;
>  	struct dvb_table_nit *nit;
>  	struct dvb_table_sdt *sdt;
> diff --git a/lib/libdvbv5/Makefile.am b/lib/libdvbv5/Makefile.am
> index 9d4b6b9..368baf8 100644
> --- a/lib/libdvbv5/Makefile.am
> +++ b/lib/libdvbv5/Makefile.am
> @@ -48,8 +48,11 @@ libdvbv5_la_SOURCES = \
>    descriptors/nit.c  ../include/descriptors/nit.h \
>    descriptors/sdt.c  ../include/descriptors/sdt.h \
>    descriptors/vct.c  ../include/descriptors/vct.h \
> +  descriptors/atsc_header.c ../include/descriptors/atsc_header.h \
>    descriptors/vct.c  ../include/descriptors/vct.h \
>    descriptors/mgt.c  ../include/descriptors/mgt.h \
> +  descriptors/eit.c  ../include/descriptors/eit.h \
> +  descriptors/atsc_eit.c  ../include/descriptors/atsc_eit.h \
>    descriptors/desc_service_location.c  ../include/descriptors/desc_service_location.h \
>    descriptors/mpeg_ts.c  ../include/descriptors/mpeg_ts.h \
>    descriptors/mpeg_pes.c  ../include/descriptors/mpeg_pes.h \
> diff --git a/lib/libdvbv5/descriptors.c b/lib/libdvbv5/descriptors.c
> index bd1bc03..6df8b8b 100644
> --- a/lib/libdvbv5/descriptors.c
> +++ b/lib/libdvbv5/descriptors.c
> @@ -37,6 +37,7 @@
>  #include "descriptors/eit.h"
>  #include "descriptors/vct.h"
>  #include "descriptors/mgt.h"
> +#include "descriptors/atsc_eit.h"
>  #include "descriptors/desc_language.h"
>  #include "descriptors/desc_network_name.h"
>  #include "descriptors/desc_cable_delivery.h"
> @@ -76,14 +77,16 @@ void dvb_desc_default_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc
>  }
>  
>  const struct dvb_table_init dvb_table_initializers[] = {
> -	[DVB_TABLE_PAT] = { dvb_table_pat_init, sizeof(struct dvb_table_pat) },
> -	[DVB_TABLE_PMT] = { dvb_table_pmt_init, sizeof(struct dvb_table_pmt) },
> -	[DVB_TABLE_NIT] = { dvb_table_nit_init, sizeof(struct dvb_table_nit) },
> -	[DVB_TABLE_SDT] = { dvb_table_sdt_init, sizeof(struct dvb_table_sdt) },
> -	[DVB_TABLE_EIT] = { dvb_table_eit_init, sizeof(struct dvb_table_eit) },
> -	[DVB_TABLE_TVCT] = { dvb_table_vct_init, sizeof(struct dvb_table_vct) },
> -	[DVB_TABLE_CVCT] = { dvb_table_vct_init, sizeof(struct dvb_table_vct) },
> +	[DVB_TABLE_PAT]          = { dvb_table_pat_init, sizeof(struct dvb_table_pat) },
> +	[DVB_TABLE_PMT]          = { dvb_table_pmt_init, sizeof(struct dvb_table_pmt) },
> +	[DVB_TABLE_NIT]          = { dvb_table_nit_init, sizeof(struct dvb_table_nit) },
> +	[DVB_TABLE_SDT]          = { dvb_table_sdt_init, sizeof(struct dvb_table_sdt) },
> +	[DVB_TABLE_EIT]          = { dvb_table_eit_init, sizeof(struct dvb_table_eit) },
>  	[DVB_TABLE_EIT_SCHEDULE] = { dvb_table_eit_init, sizeof(struct dvb_table_eit) },
> +	[ATSC_TABLE_TVCT]        = { atsc_table_vct_init, sizeof(struct atsc_table_vct) },
> +	[ATSC_TABLE_CVCT]        = { atsc_table_vct_init, sizeof(struct atsc_table_vct) },
> +	[ATSC_TABLE_MGT]         = { atsc_table_mgt_init, sizeof(struct atsc_table_mgt) },
> +	[ATSC_TABLE_EIT]         = { atsc_table_eit_init, sizeof(struct atsc_table_eit) },
>  };
>  
>  char *default_charset = "iso-8859-1";
> @@ -1355,6 +1358,6 @@ void hexdump(struct dvb_v5_fe_parms *parms, const char *prefix, const unsigned c
>  		for (i = strlen(hex); i < 49; i++)
>  			strncat(spaces, " ", sizeof(spaces));
>  		ascii[j] = '\0';
> -		dvb_log("%s%s %s %s", prefix, hex, spaces, ascii);
> +		dvb_log("%s %s %s %s", prefix, hex, spaces, ascii);
>  	}
>  }
> diff --git a/lib/libdvbv5/descriptors/atsc_eit.c b/lib/libdvbv5/descriptors/atsc_eit.c
> new file mode 100644
> index 0000000..b827ecb
> --- /dev/null
> +++ b/lib/libdvbv5/descriptors/atsc_eit.c
> @@ -0,0 +1,143 @@
> +/*
> + * Copyright (c) 2011-2012 - Mauro Carvalho Chehab <mchehab@redhat.com>

I'm not the author.

> + * Copyright (c) 2012 - Andre Roth <neolynx@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation version 2
> + * of the License.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
> + * Or, point your browser to http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
> + *
> + */
> +
> +#include "descriptors/atsc_eit.h"
> +#include "dvb-fe.h"
> +
> +void atsc_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length)
> +{
> +	const uint8_t *p = buf;
> +	struct atsc_table_eit *eit = (struct atsc_table_eit *) table;
> +	struct atsc_table_eit_event **head;
> +
> +	if (*table_length > 0) {
> +		memcpy(eit, p, sizeof(struct atsc_table_eit) - sizeof(eit->event));

Check before copy. Use offset_of().
> +
> +		/* find end of curent list */
> +		head = &eit->event;
> +		while (*head != NULL)
> +			head = &(*head)->next;
> +	} else {
> +		memcpy(eit, p, sizeof(struct atsc_table_eit) - sizeof(eit->event));

check before copy. Use offset_of().

> +		*table_length = sizeof(struct atsc_table_eit);
> +
> +		eit->event = NULL;
> +		head = &eit->event;
> +	}
> +	p += sizeof(struct atsc_table_eit) - sizeof(eit->event);
> +
> +        hexdump(parms, "eit", p, 64 );
> +
> +        int i = 0;
> +	struct atsc_table_eit_event *last = NULL;
> +	while (i++ < eit->events && (uint8_t *) p < buf + buflen - 4) {
> +		struct atsc_table_eit_event *event = (struct atsc_table_eit_event *) malloc(sizeof(struct atsc_table_eit_event));
> +		memcpy(event, p, sizeof(struct atsc_table_eit_event) -
> +				 sizeof(event->descriptor) -
> +				 sizeof(event->next) -
> +				 sizeof(event->start) -
> +				 sizeof(event->source_id));
> +		p += sizeof(struct atsc_table_eit_event) -
> +		     sizeof(event->descriptor) -
> +		     sizeof(event->next) -
> +		     sizeof(event->start) -
> +		     sizeof(event->source_id);

Please use offset_of().

> +
> +		bswap16(event->bitfield);
> +		bswap32(event->start_time);
> +		bswap32(event->bitfield2);
> +		event->descriptor = NULL;
> +		event->next = NULL;
> +                atsc_time(event->start_time, &event->start);
> +		event->source_id = eit->header.id;
> +
> +                //FIXME: title
> +                p += event->title_length - 1;
> +
> +		if(!*head)
> +			*head = event;
> +		if(last)
> +			last->next = event;
> +
> +		/* get the descriptors for each program */
> +		struct dvb_desc **head_desc = &event->descriptor;
> +                union atsc_table_eit_desc_length dl = *(union atsc_table_eit_desc_length *) p;

data declarations at the beginning.

> +                bswap16(dl.bitfield);
> +                p += sizeof(union atsc_table_eit_desc_length);
> +		dvb_parse_descriptors(parms, p, dl.desc_length, head_desc);
> +
> +		p += dl.desc_length;
> +		last = event;
> +	}
> +}
> +
> +void atsc_table_eit_free(struct atsc_table_eit *eit)
> +{
> +	struct atsc_table_eit_event *event = eit->event;
> +	while (event) {
> +		dvb_free_descriptors((struct dvb_desc **) &event->descriptor);
> +		struct atsc_table_eit_event *tmp = event;
> +		event = event->next;
> +		free(tmp);
> +	}
> +	free(eit);
> +}
> +
> +void atsc_table_eit_print(struct dvb_v5_fe_parms *parms, struct atsc_table_eit *eit)
> +{
> +	dvb_log("EIT");
> +	atsc_table_header_print(parms, &eit->header);
> +	const struct atsc_table_eit_event *event = eit->event;
> +	uint16_t events = 0;
> +	while (event) {
> +		char start[255];
> +		strftime(start, sizeof(start), "%F %T", &event->start);
> +		dvb_log("|-  event %7d", event->event_id);
> +		dvb_log("|   Source                %d", event->source_id);
> +		dvb_log("|   Starttime             %d", event->start_time);
> +		dvb_log("|   Start                 %s UTC", start);
> +		dvb_log("|   Duration              %dh %dm %ds", event->duration / 3600, (event->duration % 3600) / 60, event->duration % 60);
> +		dvb_log("|   ETM                   %d", event->etm);
> +		dvb_log("|   title length          %d", event->title_length);
> +		dvb_print_descriptors(parms, event->descriptor);
> +		event = event->next;
> +		events++;
> +	}
> +	dvb_log("|_  %d events", events);
> +}
> +
> +void atsc_time(const uint32_t start_time, struct tm *tm)
> +{
> +  tm->tm_sec   = 0;
> +  tm->tm_min   = 0;
> +  tm->tm_hour  = 0;
> +  tm->tm_mday  = 6;
> +  tm->tm_mon   = 0;
> +  tm->tm_year  = 80;
> +  tm->tm_isdst = -1;
> +  tm->tm_wday  = 0;
> +  tm->tm_yday  = 0;
> +  mktime(tm);
> +  tm->tm_sec += start_time;
> +  mktime(tm);
> +}
> +
> +
> diff --git a/lib/libdvbv5/descriptors/atsc_header.c b/lib/libdvbv5/descriptors/atsc_header.c
> new file mode 100644
> index 0000000..7b31fa1
> --- /dev/null
> +++ b/lib/libdvbv5/descriptors/atsc_header.c
> @@ -0,0 +1,48 @@
> +/*
> + * Copyright (c) 2011-2012 - Mauro Carvalho Chehab <mchehab@redhat.com>

I'm not the author.

> + * Copyright (c) 2012 - Andre Roth <neolynx@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation version 2
> + * of the License.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
> + * Or, point your browser to http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
> + *
> + */
> +
> +#include "descriptors/atsc_header.h"
> +#include "descriptors.h"
> +#include "dvb-fe.h"
> +
> +int atsc_table_header_init(struct atsc_table_header *t)
> +{
> +	bswap16(t->bitfield);
> +	bswap16(t->id);
> +	return 0;
> +}
> +
> +void atsc_table_header_print(struct dvb_v5_fe_parms *parms, const struct atsc_table_header *t)
> +{
> +	dvb_log("| table_id         %02x", t->table_id);
> +	dvb_log("| section_length   %d", t->section_length);
> +	dvb_log("| syntax           %d", t->syntax);
> +	dvb_log("| priv             %d", t->priv);
> +	dvb_log("| one              %d", t->one);
> +	dvb_log("| id               %d", t->id);
> +	dvb_log("| one2             %d", t->one2);
> +	dvb_log("| version          %d", t->version);
> +	dvb_log("| current_next     %d", t->current_next);
> +	dvb_log("| section_id       %d", t->section_id);
> +	dvb_log("| last_section     %d", t->last_section);
> +	dvb_log("| protocol_version %d", t->protocol_version);
> +}
> +
> diff --git a/lib/libdvbv5/descriptors/eit.c b/lib/libdvbv5/descriptors/eit.c
> index e70cf3b..5ecfc00 100644
> --- a/lib/libdvbv5/descriptors/eit.c
> +++ b/lib/libdvbv5/descriptors/eit.c
> @@ -67,7 +67,7 @@ void dvb_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize
>  		     sizeof(event->service_id);
>  
>  		bswap16(event->event_id);
> -		bswap16(event->bitfield);
> +		bswap16(event->bitfield); // FIXME: needed?

Why not needed?

>  		bswap16(event->bitfield2);
>  		event->descriptor = NULL;
>  		event->next = NULL;
> diff --git a/lib/libdvbv5/descriptors/mgt.c b/lib/libdvbv5/descriptors/mgt.c
> index 272d9d7..b362d51 100644
> --- a/lib/libdvbv5/descriptors/mgt.c
> +++ b/lib/libdvbv5/descriptors/mgt.c
> @@ -22,12 +22,12 @@
>  #include "descriptors/mgt.h"
>  #include "dvb-fe.h"
>  
> -void dvb_table_mgt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length)
> +void atsc_table_mgt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length)
>  {
>  	const uint8_t *p = buf;
> -	struct dvb_table_mgt *mgt = (struct dvb_table_mgt *) table;
> +	struct atsc_table_mgt *mgt = (struct atsc_table_mgt *) table;
>  	struct dvb_desc **head_desc;
> -	struct dvb_table_mgt_table **head;
> +	struct atsc_table_mgt_table **head;
>  	/*int desc_length;*/
>  
>  	if (*table_length > 0) {
> @@ -39,8 +39,8 @@ void dvb_table_mgt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize
>  		while (*head != NULL)
>  			head = &(*head)->next;
>  	} else {
> -		memcpy(table, p, sizeof(struct dvb_table_mgt) - sizeof(mgt->descriptor) - sizeof(mgt->table));
> -		*table_length = sizeof(struct dvb_table_mgt);
> +		memcpy(table, p, sizeof(struct atsc_table_mgt) - sizeof(mgt->descriptor) - sizeof(mgt->table));
> +		*table_length = sizeof(struct atsc_table_mgt);

Please check before copy. Also, use offset_of().
>  
>  		mgt->descriptor = NULL;
>  		mgt->table = NULL;
> @@ -48,16 +48,16 @@ void dvb_table_mgt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize
>  		head = &mgt->table;
>  		bswap16(mgt->tables);
>  	}
> -	p += sizeof(struct dvb_table_mgt) - sizeof(mgt->descriptor) - sizeof(mgt->table);
> +	p += sizeof(struct atsc_table_mgt) - sizeof(mgt->descriptor) - sizeof(mgt->table);
>  

Offset_of()

>  	/*dvb_parse_descriptors(parms, p, desc_length, head_desc);*/
>  	/*p += desc_length;*/
>          int i = 0;
> -	struct dvb_table_mgt_table *last = NULL;
> +	struct atsc_table_mgt_table *last = NULL;

Data declaration at the beginning.

>  	while (i++ < mgt->tables && (uint8_t *) p < buf + buflen - 4) {
> -		struct dvb_table_mgt_table *table = (struct dvb_table_mgt_table *) malloc(sizeof(struct dvb_table_mgt_table));
> -		memcpy(table, p, sizeof(struct dvb_table_mgt_table) - sizeof(table->descriptor) - sizeof(table->next));
> -		p += sizeof(struct dvb_table_mgt_table) - sizeof(table->descriptor) - sizeof(table->next);
> +		struct atsc_table_mgt_table *table = (struct atsc_table_mgt_table *) malloc(sizeof(struct atsc_table_mgt_table));
> +		memcpy(table, p, sizeof(struct atsc_table_mgt_table) - sizeof(table->descriptor) - sizeof(table->next));
> +		p += sizeof(struct atsc_table_mgt_table) - sizeof(table->descriptor) - sizeof(table->next);
>  

Same as above: data declaration at beginning, offset_of() and check before copy.

>  		bswap16(table->type);
>  		bswap16(table->bitfield);
> @@ -80,30 +80,35 @@ void dvb_table_mgt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize
>  	}
>  }
>  
> -void dvb_table_mgt_free(struct dvb_table_mgt *mgt)
> +void atsc_table_mgt_free(struct atsc_table_mgt *mgt)
>  {
> -	struct dvb_table_mgt_table *table = mgt->table;
> +	struct atsc_table_mgt_table *table = mgt->table;
>  	dvb_free_descriptors((struct dvb_desc **) &mgt->descriptor);
>  	while(table) {
>  		dvb_free_descriptors((struct dvb_desc **) &table->descriptor);
> -		struct dvb_table_mgt_table *tmp = table;
> +		struct atsc_table_mgt_table *tmp = table;

Data declaration at the beginning.

>  		table = table->next;
>  		free(tmp);
>  	}
>  	free(mgt);
>  }
>  
> -void dvb_table_mgt_print(struct dvb_v5_fe_parms *parms, struct dvb_table_mgt *mgt)
> +void atsc_table_mgt_print(struct dvb_v5_fe_parms *parms, struct atsc_table_mgt *mgt)
>  {
>  	dvb_log("MGT");
> -	dvb_table_header_print(parms, &mgt->header);
> -	dvb_log("| protocol_version %d", mgt->protocol_version);
> +	atsc_table_header_print(parms, &mgt->header);
>  	dvb_log("| tables           %d", mgt->tables);
>  	/*dvb_print_descriptors(parms, mgt->descriptor);*/
> -	const struct dvb_table_mgt_table *table = mgt->table;
> +	const struct atsc_table_mgt_table *table = mgt->table;
>  	uint16_t tables = 0;
>  	while(table) {
> -                dvb_log("|- type %04x  %d", table->type, table->pid);
> +                dvb_log("|- type %04x    %d", table->type, table->pid);
> +                dvb_log("|  one          %d", table->one);
> +                dvb_log("|  one2         %d", table->one2);
> +                dvb_log("|  type version %d", table->type_version);
> +                dvb_log("|  size         %d", table->size);
> +                dvb_log("|  one3         %d", table->one3);
> +                dvb_log("|  desc_length  %d", table->desc_length);
>  		dvb_print_descriptors(parms, table->descriptor);
>  		table = table->next;
>  		tables++;
> diff --git a/lib/libdvbv5/descriptors/vct.c b/lib/libdvbv5/descriptors/vct.c
> index e567f7a..493f184 100644
> --- a/lib/libdvbv5/descriptors/vct.c
> +++ b/lib/libdvbv5/descriptors/vct.c
> @@ -23,14 +23,14 @@
>  #include "dvb-fe.h"
>  #include "parse_string.h"
>  
> -void dvb_table_vct_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
> +void atsc_table_vct_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
>  			ssize_t buflen, uint8_t *table, ssize_t *table_length)
>  {
>  	const uint8_t *p = buf, *endbuf = buf + buflen - 4;
> -	struct dvb_table_vct *vct = (void *)table;
> -	struct dvb_table_vct_channel **head = &vct->channel;
> +	struct atsc_table_vct *vct = (void *)table;
> +	struct atsc_table_vct_channel **head = &vct->channel;
>  	int i, n;
> -	size_t size = offsetof(struct dvb_table_vct, channel);
> +	size_t size = offsetof(struct atsc_table_vct, channel);
>  
>  	if (p + size > endbuf) {
>  		dvb_logerr("VCT table was truncated. Need %zu bytes, but has only %zu.",
> @@ -45,16 +45,16 @@ void dvb_table_vct_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
>  	} else {
>  		memcpy(vct, p, size);
>  
> -		*table_length = sizeof(struct dvb_table_vct);
> +		*table_length = sizeof(struct atsc_table_vct);
>  
>  		vct->channel = NULL;
>  		vct->descriptor = NULL;
>  	}
>  	p += size;
>  
> -	size = offsetof(struct dvb_table_vct_channel, descriptor);
> +	size = offsetof(struct atsc_table_vct_channel, descriptor);
>  	for (n = 0; n < vct->num_channels_in_section; n++) {
> -		struct dvb_table_vct_channel *channel;
> +		struct atsc_table_vct_channel *channel;
>  
>  		if (p + size > endbuf) {
>  			dvb_logerr("VCT channel table is missing %d elements",
> @@ -63,7 +63,7 @@ void dvb_table_vct_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
>  			break;
>  		}
>  
> -		channel = malloc(sizeof(struct dvb_table_vct_channel));
> +		channel = malloc(sizeof(struct atsc_table_vct_channel));
>  
>  		memcpy(channel, p, size);
>  		p += size;
> @@ -75,7 +75,7 @@ void dvb_table_vct_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
>  		bswap32(channel->carrier_frequency);
>  		bswap16(channel->channel_tsid);
>  		bswap16(channel->program_number);
> -		bswap16(channel->bitfield1);
> +		bswap32(channel->bitfield1);
>  		bswap16(channel->bitfield2);
>  		bswap16(channel->source_id);
>  		bswap16(channel->bitfield3);
> @@ -104,9 +104,9 @@ void dvb_table_vct_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
>  	}
>  
>  	/* Get extra descriptors */
> -	size = sizeof(union dvb_table_vct_descriptor_length);
> +	size = sizeof(union atsc_table_vct_descriptor_length);
>  	while (p + size <= endbuf) {
> -		union dvb_table_vct_descriptor_length *d = (void *)p;
> +		union atsc_table_vct_descriptor_length *d = (void *)p;
>  		bswap16(d->descriptor_length);
>  		p += size;
>  		dvb_parse_descriptors(parms, p, d->descriptor_length,
> @@ -117,12 +117,12 @@ void dvb_table_vct_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf,
>  			   endbuf - p);
>  }
>  
> -void dvb_table_vct_free(struct dvb_table_vct *vct)
> +void atsc_table_vct_free(struct atsc_table_vct *vct)
>  {
> -	struct dvb_table_vct_channel *channel = vct->channel;
> +	struct atsc_table_vct_channel *channel = vct->channel;
>  	while(channel) {
>  		dvb_free_descriptors((struct dvb_desc **) &channel->descriptor);
> -		struct dvb_table_vct_channel *tmp = channel;
> +		struct atsc_table_vct_channel *tmp = channel;
>  		channel = channel->next;
>  		free(tmp);
>  	}
> @@ -131,19 +131,19 @@ void dvb_table_vct_free(struct dvb_table_vct *vct)
>  	free(vct);
>  }
>  
> -void dvb_table_vct_print(struct dvb_v5_fe_parms *parms, struct dvb_table_vct *vct)
> +void atsc_table_vct_print(struct dvb_v5_fe_parms *parms, struct atsc_table_vct *vct)
>  {
> -	if (vct->header.table_id == DVB_TABLE_CVCT)
> +	if (vct->header.table_id == ATSC_TABLE_CVCT)
>  		dvb_log("CVCT");
>  	else
>  		dvb_log("TVCT");
>  
> -	dvb_table_header_print(parms, &vct->header);
> +	atsc_table_header_print(parms, &vct->header);
>  
>  	dvb_log("|- Protocol version %d", vct->ATSC_protocol_version);
>  	dvb_log("|- #channels        %d", vct->num_channels_in_section);
>  	dvb_log("|\\  channel_id");
> -	const struct dvb_table_vct_channel *channel = vct->channel;
> +	const struct atsc_table_vct_channel *channel = vct->channel;
>  	uint16_t channels = 0;
>  	while(channel) {
>  		dvb_log("|- Channel                %d.%d: %s",
> @@ -159,7 +159,7 @@ void dvb_table_vct_print(struct dvb_v5_fe_parms *parms, struct dvb_table_vct *vc
>  		dvb_log("|   access controlled     %d", channel->access_controlled);
>  		dvb_log("|   hidden                %d", channel->hidden);
>  
> -		if (vct->header.table_id == DVB_TABLE_CVCT) {
> +		if (vct->header.table_id == ATSC_TABLE_CVCT) {
>  			dvb_log("|   path select           %d", channel->path_select);
>  			dvb_log("|   out of band           %d", channel->out_of_band);
>  		}
> @@ -173,4 +173,3 @@ void dvb_table_vct_print(struct dvb_v5_fe_parms *parms, struct dvb_table_vct *vc
>  	}
>  	dvb_log("|_  %d channels", channels);
>  }
> -
> diff --git a/lib/libdvbv5/dvb-file.c b/lib/libdvbv5/dvb-file.c
> index b6fdc04..9abb1f7 100644
> --- a/lib/libdvbv5/dvb-file.c
> +++ b/lib/libdvbv5/dvb-file.c
> @@ -1027,7 +1027,7 @@ int store_dvb_channel(struct dvb_file **dvb_file,
>  	}
>  
>  	if (dvb_scan_handler->vct) {
> -		dvb_vct_channel_foreach(d, dvb_scan_handler->vct) {
> +		atsc_vct_channel_foreach(d, dvb_scan_handler->vct) {
>  			char *channel = NULL;
>  			char *vchannel = NULL;
>  
> diff --git a/lib/libdvbv5/dvb-scan.c b/lib/libdvbv5/dvb-scan.c
> index 421434e..bd9d2fb 100644
> --- a/lib/libdvbv5/dvb-scan.c
> +++ b/lib/libdvbv5/dvb-scan.c
> @@ -271,7 +271,7 @@ void dvb_scan_free_handler_table(struct dvb_v5_descriptors *dvb_scan_handler)
>  	if (dvb_scan_handler->pat)
>  		dvb_table_pat_free(dvb_scan_handler->pat);
>  	if (dvb_scan_handler->vct)
> -		dvb_table_vct_free(dvb_scan_handler->vct);
> +		atsc_table_vct_free(dvb_scan_handler->vct);
>  	if (dvb_scan_handler->nit)
>  		dvb_table_nit_free(dvb_scan_handler->nit);
>  	if (dvb_scan_handler->sdt)
> @@ -329,14 +329,14 @@ struct dvb_v5_descriptors *dvb_get_ts_tables(struct dvb_v5_fe_parms *parms,
>  			nit_time = 12;
>  			break;
>  		case SYS_ATSC:
> -			atsc_filter = DVB_TABLE_TVCT;
> +			atsc_filter = ATSC_TABLE_TVCT;
>  			pat_pmt_time = 2;
>  			vct_time = 2;
>  			sdt_time = 5;
>  			nit_time = 5;
>  			break;
>  		case SYS_DVBC_ANNEX_B:
> -			atsc_filter = DVB_TABLE_CVCT;
> +			atsc_filter = ATSC_TABLE_CVCT;
>  			pat_pmt_time = 2;
>  			vct_time = 2;
>  			sdt_time = 5;
> @@ -367,7 +367,7 @@ struct dvb_v5_descriptors *dvb_get_ts_tables(struct dvb_v5_fe_parms *parms,
>  	/* ATSC-specific VCT table */
>  	if (atsc_filter) {
>  		rc = dvb_read_section(parms, dmx_fd,
> -				      atsc_filter, DVB_TABLE_VCT_PID,
> +				      atsc_filter, ATSC_TABLE_VCT_PID,
>  				      (uint8_t **)&dvb_scan_handler->vct,
>  				      vct_time * timeout_multiply);
>  		if (parms->abort)
> @@ -375,7 +375,7 @@ struct dvb_v5_descriptors *dvb_get_ts_tables(struct dvb_v5_fe_parms *parms,
>  		if (rc < 0)
>  			dvb_logerr("error while waiting for VCT table");
>  		else if (parms->verbose)
> -			dvb_table_vct_print(parms, dvb_scan_handler->vct);
> +			atsc_table_vct_print(parms, dvb_scan_handler->vct);
>  	}
>  
>  	/* PMT tables */

The better is to split the data renames on a separate patch.
I don't like to rename it at the library, as others might be using
the library with the old names. So, we may need to add a compat code
for those using the legacy names.

-- 

Cheers,
Mauro
