Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:17251 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbaAGRFl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jan 2014 12:05:41 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZ100KIZJHG2Y70@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 07 Jan 2014 12:05:40 -0500 (EST)
Date: Tue, 07 Jan 2014 15:05:35 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: =?UTF-8?B?QW5kcsOp?= Roth <neolynx@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 08/18] libdvbv5: implement MGT parser
Message-id: <20140107150535.70a0e9d2@samsung.com>
In-reply-to: <1388407731-24369-8-git-send-email-neolynx@gmail.com>
References: <1388407731-24369-1-git-send-email-neolynx@gmail.com>
 <1388407731-24369-8-git-send-email-neolynx@gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 30 Dec 2013 13:48:41 +0100
André Roth <neolynx@gmail.com> escreveu:

> Signed-off-by: André Roth <neolynx@gmail.com>
> ---
>  lib/include/descriptors/mgt.h  |  80 ++++++++++++++++++++++++++++
>  lib/libdvbv5/Makefile.am       |   1 +
>  lib/libdvbv5/descriptors.c     |   2 +
>  lib/libdvbv5/descriptors/mgt.c | 117 +++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 200 insertions(+)
>  create mode 100644 lib/include/descriptors/mgt.h
>  create mode 100644 lib/libdvbv5/descriptors/mgt.c
> 
> diff --git a/lib/include/descriptors/mgt.h b/lib/include/descriptors/mgt.h
> new file mode 100644
> index 0000000..9eaac02
> --- /dev/null
> +++ b/lib/include/descriptors/mgt.h
> @@ -0,0 +1,80 @@
> +/*
> + * Copyright (c) 2013 - Andre Roth <neolynx@gmail.com>
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
> +#ifndef _MGT_H
> +#define _MGT_H
> +
> +#include <stdint.h>
> +#include <unistd.h> /* ssize_t */
> +
> +#include "descriptors/atsc_header.h"
> +#include "descriptors.h"
> +
> +#define ATSC_TABLE_MGT 0xC7
> +
> +struct atsc_table_mgt_table {
> +	uint16_t type;
> +	union {
> +		uint16_t bitfield;
> +		struct {
> +			uint16_t pid:13;
> +			uint16_t one:3;
> +		} __attribute__((packed));
> +	} __attribute__((packed));
> +        uint8_t type_version:5;
> +        uint8_t one2:3;
> +        uint32_t size;
> +	union {
> +		uint16_t bitfield2;
> +		struct {
> +			uint16_t desc_length:12;
> +			uint16_t one3:4;
> +		} __attribute__((packed));
> +	} __attribute__((packed));
> +	struct dvb_desc *descriptor;
> +	struct atsc_table_mgt_table *next;
> +} __attribute__((packed));
> +
> +struct atsc_table_mgt {
> +	struct atsc_table_header header;
> +        uint16_t tables;
> +        struct atsc_table_mgt_table *table;
> +	struct dvb_desc *descriptor;
> +} __attribute__((packed));
> +
> +
> +#define atsc_mgt_table_foreach( _tran, _mgt ) \
> +  for( struct atsc_table_mgt_table *_tran = _mgt->table; _tran; _tran = _tran->next ) \
> +
> +struct dvb_v5_fe_parms;
> +
> +#ifdef __cplusplus
> +extern "C" {
> +#endif
> +
> +void atsc_table_mgt_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length);
> +void atsc_table_mgt_free(struct atsc_table_mgt *mgt);
> +void atsc_table_mgt_print(struct dvb_v5_fe_parms *parms, struct atsc_table_mgt *mgt);
> +
> +#ifdef __cplusplus
> +}
> +#endif
> +
> +#endif
> diff --git a/lib/libdvbv5/Makefile.am b/lib/libdvbv5/Makefile.am
> index 33693cc..7755e05 100644
> --- a/lib/libdvbv5/Makefile.am
> +++ b/lib/libdvbv5/Makefile.am
> @@ -49,6 +49,7 @@ libdvbv5_la_SOURCES = \
>    descriptors/sdt.c  ../include/descriptors/sdt.h \
>    descriptors/vct.c  ../include/descriptors/vct.h \
>    descriptors/eit.c  ../include/descriptors/eit.h \
> +  descriptors/mgt.c  ../include/descriptors/mgt.h \
>    descriptors/desc_service_location.c  ../include/descriptors/desc_service_location.h \
>    descriptors/mpeg_ts.c  ../include/descriptors/mpeg_ts.h \
>    descriptors/mpeg_pes.c  ../include/descriptors/mpeg_pes.h \
> diff --git a/lib/libdvbv5/descriptors.c b/lib/libdvbv5/descriptors.c
> index bc3d51a..7b9e9d0 100644
> --- a/lib/libdvbv5/descriptors.c
> +++ b/lib/libdvbv5/descriptors.c
> @@ -36,6 +36,7 @@
>  #include "descriptors/sdt.h"
>  #include "descriptors/eit.h"
>  #include "descriptors/vct.h"
> +#include "descriptors/mgt.h"
>  #include "descriptors/desc_language.h"
>  #include "descriptors/desc_network_name.h"
>  #include "descriptors/desc_cable_delivery.h"
> @@ -84,6 +85,7 @@ const struct dvb_table_init dvb_table_initializers[] = {
>  	[DVB_TABLE_TVCT] = { dvb_table_vct_init, sizeof(struct dvb_table_vct) },
>  	[DVB_TABLE_CVCT] = { dvb_table_vct_init, sizeof(struct dvb_table_vct) },
>  	[DVB_TABLE_EIT_SCHEDULE] = { dvb_table_eit_init, sizeof(struct dvb_table_eit) },
> +	[ATSC_TABLE_MGT]         = { atsc_table_mgt_init, sizeof(struct atsc_table_mgt) },
>  };
>  
>  char *default_charset = "iso-8859-1";
> diff --git a/lib/libdvbv5/descriptors/mgt.c b/lib/libdvbv5/descriptors/mgt.c
> new file mode 100644
> index 0000000..09d1cf2
> --- /dev/null
> +++ b/lib/libdvbv5/descriptors/mgt.c
> @@ -0,0 +1,117 @@
> +/*
> + * Copyright (c) 2013 - Andre Roth <neolynx@gmail.com>
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
> +#include "descriptors/mgt.h"
> +#include "dvb-fe.h"
> +
> +void atsc_table_mgt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length)
> +{
> +	const uint8_t *p = buf;
> +	struct atsc_table_mgt *mgt = (struct atsc_table_mgt *) table;
> +	struct dvb_desc **head_desc;
> +	struct atsc_table_mgt_table **head;
> +	/*int desc_length;*/

If you don't need a line, just don't add it, instead of adding it
commented.

> +
> +	if (*table_length > 0) {
> +		/* find end of curent lists */
> +		head_desc = &mgt->descriptor;
> +		while (*head_desc != NULL)
> +			head_desc = &(*head_desc)->next;
> +		head = &mgt->table;
> +		while (*head != NULL)
> +			head = &(*head)->next;
> +	} else {
> +		memcpy(table, p, sizeof(struct atsc_table_mgt) - sizeof(mgt->descriptor) - sizeof(mgt->table));

Test before copy and use offsetof().

> +		*table_length = sizeof(struct atsc_table_mgt);
> +
> +		mgt->descriptor = NULL;
> +		mgt->table = NULL;
> +		head_desc = &mgt->descriptor;
> +		head = &mgt->table;
> +		bswap16(mgt->tables);
> +	}
> +	p += sizeof(struct atsc_table_mgt) - sizeof(mgt->descriptor) - sizeof(mgt->table);

Use offsetof().

> +
> +	/*dvb_parse_descriptors(parms, p, desc_length, head_desc);*/
> +	/*p += desc_length;*/

If not needed, don't add.

> +        int i = 0;

Please use tab, not spaces.

> +	struct atsc_table_mgt_table *last = NULL;

Please put data declaration at the beginning of the function.

> +	while (i++ < mgt->tables && (uint8_t *) p < buf + buflen - 4) {
> +		struct atsc_table_mgt_table *table = (struct atsc_table_mgt_table *) malloc(sizeof(struct atsc_table_mgt_table));

Please add a blank line.

> +		memcpy(table, p, sizeof(struct atsc_table_mgt_table) - sizeof(table->descriptor) - sizeof(table->next));
> +		p += sizeof(struct atsc_table_mgt_table) - sizeof(table->descriptor) - sizeof(table->next);

Please use offsetof().

> +
> +		bswap16(table->type);
> +		bswap16(table->bitfield);
> +		bswap16(table->bitfield2);
> +		bswap32(table->size);
> +		table->descriptor = NULL;
> +		table->next = NULL;
> +
> +		if(!*head)
> +			*head = table;
> +		if(last)
> +			last->next = table;
> +
> +		/* get the descriptors for each table */
> +		struct dvb_desc **head_desc = &table->descriptor;
> +		dvb_parse_descriptors(parms, p, table->desc_length, head_desc);
> +
> +		p += table->desc_length;
> +		last = table;
> +	}
> +}
> +
> +void atsc_table_mgt_free(struct atsc_table_mgt *mgt)
> +{
> +	struct atsc_table_mgt_table *table = mgt->table;

blank line.

> +	dvb_free_descriptors((struct dvb_desc **) &mgt->descriptor);
> +	while(table) {
> +		dvb_free_descriptors((struct dvb_desc **) &table->descriptor);
> +		struct atsc_table_mgt_table *tmp = table;
> +		table = table->next;
> +		free(tmp);
> +	}
> +	free(mgt);
> +}
> +
> +void atsc_table_mgt_print(struct dvb_v5_fe_parms *parms, struct atsc_table_mgt *mgt)
> +{
> +	dvb_log("MGT");
> +	atsc_table_header_print(parms, &mgt->header);
> +	dvb_log("| tables           %d", mgt->tables);
> +	/*dvb_print_descriptors(parms, mgt->descriptor);*/
> +	const struct atsc_table_mgt_table *table = mgt->table;
> +	uint16_t tables = 0;

data declarations at the beginning of the function.

> +	while(table) {

space after while.

> +                dvb_log("|- type %04x    %d", table->type, table->pid);
> +                dvb_log("|  one          %d", table->one);
> +                dvb_log("|  one2         %d", table->one2);
> +                dvb_log("|  type version %d", table->type_version);
> +                dvb_log("|  size         %d", table->size);
> +                dvb_log("|  one3         %d", table->one3);
> +                dvb_log("|  desc_length  %d", table->desc_length);
> +		dvb_print_descriptors(parms, table->descriptor);
> +		table = table->next;
> +		tables++;
> +	}
> +	dvb_log("|_  %d tables", tables);
> +}
> +


-- 

Cheers,
Mauro
