Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:17485 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbaAGRNH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jan 2014 12:13:07 -0500
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZ100KOVJTTCX70@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 07 Jan 2014 12:13:05 -0500 (EST)
Date: Tue, 07 Jan 2014 15:12:59 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: =?UTF-8?B?QW5kcsOp?= Roth <neolynx@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 09/18] libdvbv5: implement ATSC EIT
Message-id: <20140107151259.5da71381@samsung.com>
In-reply-to: <1388407731-24369-9-git-send-email-neolynx@gmail.com>
References: <1388407731-24369-1-git-send-email-neolynx@gmail.com>
 <1388407731-24369-9-git-send-email-neolynx@gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 30 Dec 2013 13:48:42 +0100
André Roth <neolynx@gmail.com> escreveu:

> Signed-off-by: André Roth <neolynx@gmail.com>
> ---
>  lib/include/descriptors/atsc_eit.h     |  90 +++++++++++++++++++++
>  lib/include/descriptors/atsc_header.h  |  63 +++++++++++++++
>  lib/libdvbv5/Makefile.am               |   4 +-
>  lib/libdvbv5/descriptors.c             |   2 +
>  lib/libdvbv5/descriptors/atsc_eit.c    | 142 +++++++++++++++++++++++++++++++++
>  lib/libdvbv5/descriptors/atsc_header.c |  47 +++++++++++
>  6 files changed, 347 insertions(+), 1 deletion(-)
>  create mode 100644 lib/include/descriptors/atsc_eit.h
>  create mode 100644 lib/include/descriptors/atsc_header.h
>  create mode 100644 lib/libdvbv5/descriptors/atsc_eit.c
>  create mode 100644 lib/libdvbv5/descriptors/atsc_header.c
> 
> diff --git a/lib/include/descriptors/atsc_eit.h b/lib/include/descriptors/atsc_eit.h
> new file mode 100644
> index 0000000..3bc5df6
> --- /dev/null
> +++ b/lib/include/descriptors/atsc_eit.h
> @@ -0,0 +1,90 @@
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
> index 0000000..1e7148e
> --- /dev/null
> +++ b/lib/include/descriptors/atsc_header.h
> @@ -0,0 +1,63 @@
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
> diff --git a/lib/libdvbv5/Makefile.am b/lib/libdvbv5/Makefile.am
> index 7755e05..6771d24 100644
> --- a/lib/libdvbv5/Makefile.am
> +++ b/lib/libdvbv5/Makefile.am
> @@ -48,8 +48,10 @@ libdvbv5_la_SOURCES = \
>    descriptors/nit.c  ../include/descriptors/nit.h \
>    descriptors/sdt.c  ../include/descriptors/sdt.h \
>    descriptors/vct.c  ../include/descriptors/vct.h \
> -  descriptors/eit.c  ../include/descriptors/eit.h \
> +  descriptors/atsc_header.c ../include/descriptors/atsc_header.h \
>    descriptors/mgt.c  ../include/descriptors/mgt.h \
> +  descriptors/eit.c  ../include/descriptors/eit.h \
> +  descriptors/atsc_eit.c  ../include/descriptors/atsc_eit.h \
>    descriptors/desc_service_location.c  ../include/descriptors/desc_service_location.h \
>    descriptors/mpeg_ts.c  ../include/descriptors/mpeg_ts.h \
>    descriptors/mpeg_pes.c  ../include/descriptors/mpeg_pes.h \
> diff --git a/lib/libdvbv5/descriptors.c b/lib/libdvbv5/descriptors.c
> index 7b9e9d0..737acfa 100644
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
> @@ -86,6 +87,7 @@ const struct dvb_table_init dvb_table_initializers[] = {
>  	[DVB_TABLE_CVCT] = { dvb_table_vct_init, sizeof(struct dvb_table_vct) },
>  	[DVB_TABLE_EIT_SCHEDULE] = { dvb_table_eit_init, sizeof(struct dvb_table_eit) },
>  	[ATSC_TABLE_MGT]         = { atsc_table_mgt_init, sizeof(struct atsc_table_mgt) },
> +	[ATSC_TABLE_EIT]         = { atsc_table_eit_init, sizeof(struct atsc_table_eit) },
>  };
>  
>  char *default_charset = "iso-8859-1";
> diff --git a/lib/libdvbv5/descriptors/atsc_eit.c b/lib/libdvbv5/descriptors/atsc_eit.c
> new file mode 100644
> index 0000000..4ee38ae
> --- /dev/null
> +++ b/lib/libdvbv5/descriptors/atsc_eit.c
> @@ -0,0 +1,142 @@
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

Hmm... on some patches, when the table already exists, nothing is copied.

Just the pointer 'p' is incremented.

We should standardize this. Not sure what's the better.

> +
> +		/* find end of curent list */
> +		head = &eit->event;
> +		while (*head != NULL)
> +			head = &(*head)->next;
> +	} else {
> +		memcpy(eit, p, sizeof(struct atsc_table_eit) - sizeof(eit->event));
> +		*table_length = sizeof(struct atsc_table_eit);

For both memcpy(): please test before copy, and use offsetof().

> +
> +		eit->event = NULL;
> +		head = &eit->event;
> +	}
> +	p += sizeof(struct atsc_table_eit) - sizeof(eit->event);

Please use offsetof().

> +
> +        hexdump(parms, "eit", p, 64 );
> +
> +        int i = 0;

Use tabs.

> +	struct atsc_table_eit_event *last = NULL;

Please move to the beginning of the function.

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

Use offsetof().
> +
> +		bswap16(event->bitfield);
> +		bswap32(event->start_time);
> +		bswap32(event->bitfield2);
> +		event->descriptor = NULL;
> +		event->next = NULL;
> +                atsc_time(event->start_time, &event->start);

Use tabs.

> +		event->source_id = eit->header.id;
> +
> +                //FIXME: title

Don't use c99 comments. Use tabs.

> +                p += event->title_length - 1;
> +
> +		if(!*head)
> +			*head = event;
> +		if(last)
> +			last->next = event;
> +
> +		/* get the descriptors for each program */
> +		struct dvb_desc **head_desc = &event->descriptor;

Move to the beginning of the function or to the beginning of the braces.

> +                union atsc_table_eit_desc_length dl = *(union atsc_table_eit_desc_length *) p;

Same here: declare 'dl' at the beginning of a block.

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

please add a blank line here.

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

Data declarations first.

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
> index 0000000..ed152ce
> --- /dev/null
> +++ b/lib/libdvbv5/descriptors/atsc_header.c
> @@ -0,0 +1,47 @@
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


-- 

Cheers,
Mauro
