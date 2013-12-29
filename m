Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:40930 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab3L2EMi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Dec 2013 23:12:38 -0500
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MYJ00EQ5VP1I850@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Sat, 28 Dec 2013 23:12:37 -0500 (EST)
Date: Sun, 29 Dec 2013 01:49:57 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: =?UTF-8?B?QW5kcsOp?= Roth <neolynx@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 07/13] libdvbv5: MGT parser
Message-id: <20131229014957.11a839a1.m.chehab@samsung.com>
In-reply-to: <1388245561-8751-7-git-send-email-neolynx@gmail.com>
References: <1388245561-8751-1-git-send-email-neolynx@gmail.com>
 <1388245561-8751-7-git-send-email-neolynx@gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 28 Dec 2013 16:45:55 +0100
André Roth <neolynx@gmail.com> escreveu:

> Signed-off-by: André Roth <neolynx@gmail.com>
> ---
>  lib/include/descriptors/mgt.h  |  82 ++++++++++++++++++++++++++++++
>  lib/libdvbv5/Makefile.am       |   1 +
>  lib/libdvbv5/descriptors.c     |   1 +
>  lib/libdvbv5/descriptors/mgt.c | 113 +++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 197 insertions(+)
>  create mode 100644 lib/include/descriptors/mgt.h
>  create mode 100644 lib/libdvbv5/descriptors/mgt.c
> 
> diff --git a/lib/include/descriptors/mgt.h b/lib/include/descriptors/mgt.h
> new file mode 100644
> index 0000000..4a68f2c
> --- /dev/null
> +++ b/lib/include/descriptors/mgt.h
> @@ -0,0 +1,82 @@
> +/*
> + * Copyright (c) 2011-2012 - Mauro Carvalho Chehab <mchehab@redhat.com>

I'm not the author.

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
> +#include "descriptors/header.h"
> +#include "descriptors.h"
> +
> +#define DVB_TABLE_MGT      0xC7
> +
> +struct dvb_table_mgt_table {
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
> +	struct dvb_table_mgt_table *next;
> +} __attribute__((packed));
> +
> +struct dvb_table_mgt {
> +	struct dvb_table_header header;
> +        uint8_t  protocol_version;
> +        uint16_t tables;
> +        struct dvb_table_mgt_table *table;
> +	struct dvb_desc *descriptor;
> +} __attribute__((packed));
> +
> +
> +#define dvb_mgt_transport_foreach( tran, mgt ) \
> +  for( struct dvb_table_mgt_transport *tran = mgt->transport; tran; tran = tran->next ) \
> +
> +struct dvb_v5_fe_parms;
> +
> +#ifdef __cplusplus
> +extern "C" {
> +#endif
> +
> +void dvb_table_mgt_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length);
> +void dvb_table_mgt_free(struct dvb_table_mgt *mgt);
> +void dvb_table_mgt_print(struct dvb_v5_fe_parms *parms, struct dvb_table_mgt *mgt);
> +
> +#ifdef __cplusplus
> +}
> +#endif
> +
> +#endif
> diff --git a/lib/libdvbv5/Makefile.am b/lib/libdvbv5/Makefile.am
> index 795f30c..9d4b6b9 100644
> --- a/lib/libdvbv5/Makefile.am
> +++ b/lib/libdvbv5/Makefile.am
> @@ -49,6 +49,7 @@ libdvbv5_la_SOURCES = \
>    descriptors/sdt.c  ../include/descriptors/sdt.h \
>    descriptors/vct.c  ../include/descriptors/vct.h \
>    descriptors/vct.c  ../include/descriptors/vct.h \
> +  descriptors/mgt.c  ../include/descriptors/mgt.h \
>    descriptors/desc_service_location.c  ../include/descriptors/desc_service_location.h \
>    descriptors/mpeg_ts.c  ../include/descriptors/mpeg_ts.h \
>    descriptors/mpeg_pes.c  ../include/descriptors/mpeg_pes.h \
> diff --git a/lib/libdvbv5/descriptors.c b/lib/libdvbv5/descriptors.c
> index 18884b0..bd1bc03 100644
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
> diff --git a/lib/libdvbv5/descriptors/mgt.c b/lib/libdvbv5/descriptors/mgt.c
> new file mode 100644
> index 0000000..272d9d7
> --- /dev/null
> +++ b/lib/libdvbv5/descriptors/mgt.c
> @@ -0,0 +1,113 @@
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
> +#include "descriptors/mgt.h"
> +#include "dvb-fe.h"
> +
> +void dvb_table_mgt_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length)
> +{
> +	const uint8_t *p = buf;
> +	struct dvb_table_mgt *mgt = (struct dvb_table_mgt *) table;
> +	struct dvb_desc **head_desc;
> +	struct dvb_table_mgt_table **head;
> +	/*int desc_length;*/
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
> +		memcpy(table, p, sizeof(struct dvb_table_mgt) - sizeof(mgt->descriptor) - sizeof(mgt->table));

Check before copy. Use offset_of().

> +		*table_length = sizeof(struct dvb_table_mgt);
> +
> +		mgt->descriptor = NULL;
> +		mgt->table = NULL;
> +		head_desc = &mgt->descriptor;
> +		head = &mgt->table;
> +		bswap16(mgt->tables);
> +	}
> +	p += sizeof(struct dvb_table_mgt) - sizeof(mgt->descriptor) - sizeof(mgt->table);
> +
> +	/*dvb_parse_descriptors(parms, p, desc_length, head_desc);*/
> +	/*p += desc_length;*/
> +        int i = 0;
> +	struct dvb_table_mgt_table *last = NULL;

Data at beginning of the function.

> +	while (i++ < mgt->tables && (uint8_t *) p < buf + buflen - 4) {
> +		struct dvb_table_mgt_table *table = (struct dvb_table_mgt_table *) malloc(sizeof(struct dvb_table_mgt_table));
> +		memcpy(table, p, sizeof(struct dvb_table_mgt_table) - sizeof(table->descriptor) - sizeof(table->next));
> +		p += sizeof(struct dvb_table_mgt_table) - sizeof(table->descriptor) - sizeof(table->next);
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
> +void dvb_table_mgt_free(struct dvb_table_mgt *mgt)
> +{
> +	struct dvb_table_mgt_table *table = mgt->table;
> +	dvb_free_descriptors((struct dvb_desc **) &mgt->descriptor);
> +	while(table) {
> +		dvb_free_descriptors((struct dvb_desc **) &table->descriptor);
> +		struct dvb_table_mgt_table *tmp = table;
> +		table = table->next;
> +		free(tmp);
> +	}
> +	free(mgt);
> +}
> +
> +void dvb_table_mgt_print(struct dvb_v5_fe_parms *parms, struct dvb_table_mgt *mgt)
> +{
> +	dvb_log("MGT");
> +	dvb_table_header_print(parms, &mgt->header);
> +	dvb_log("| protocol_version %d", mgt->protocol_version);
> +	dvb_log("| tables           %d", mgt->tables);
> +	/*dvb_print_descriptors(parms, mgt->descriptor);*/
> +	const struct dvb_table_mgt_table *table = mgt->table;
> +	uint16_t tables = 0;
> +	while(table) {
> +                dvb_log("|- type %04x  %d", table->type, table->pid);
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
