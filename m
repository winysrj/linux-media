Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:25403 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbaAGQiZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jan 2014 11:38:25 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZ1003D1I801X50@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 07 Jan 2014 11:38:24 -0500 (EST)
Date: Tue, 07 Jan 2014 14:38:18 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: =?UTF-8?B?QW5kcsOp?= Roth <neolynx@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 02/18] libdvbv5: service location descriptor support
Message-id: <20140107143818.7d2e3b27@samsung.com>
In-reply-to: <1388407731-24369-2-git-send-email-neolynx@gmail.com>
References: <1388407731-24369-1-git-send-email-neolynx@gmail.com>
 <1388407731-24369-2-git-send-email-neolynx@gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 30 Dec 2013 13:48:35 +0100
André Roth <neolynx@gmail.com> escreveu:

> Implement the service location descriptor (0xa1), and small cleanups.
> 
> Signed-off-by: André Roth <neolynx@gmail.com>
> ---
>  lib/include/descriptors.h                        |  4 +-
>  lib/include/descriptors/desc_service_location.h  | 69 +++++++++++++++++++++++
>  lib/libdvbv5/Makefile.am                         |  3 +-
>  lib/libdvbv5/descriptors.c                       |  2 +-
>  lib/libdvbv5/descriptors/desc_service_location.c | 70 ++++++++++++++++++++++++
>  5 files changed, 145 insertions(+), 3 deletions(-)
>  create mode 100644 lib/include/descriptors/desc_service_location.h
>  create mode 100644 lib/libdvbv5/descriptors/desc_service_location.c
> 
> diff --git a/lib/include/descriptors.h b/lib/include/descriptors.h
> index 2e614f0..5ab29a0 100644
> --- a/lib/include/descriptors.h
> +++ b/lib/include/descriptors.h
> @@ -1,4 +1,4 @@
> -  /*
> +/*
>   * Copyright (c) 2011-2012 - Mauro Carvalho Chehab <mchehab@redhat.com>
>   *
>   * This program is free software; you can redistribute it and/or
> @@ -216,6 +216,8 @@ enum descriptors {
>  	/* SCTE 35 2004 */
>  	CUE_identifier_descriptor			= 0x8a,
>  
> +	extended_channel_name				= 0xa0,
> +	service_location				= 0xa1,
>  	/* From http://www.etherguidesystems.com/Help/SDOs/ATSC/Semantics/Descriptors/Default.aspx */
>  	component_name_descriptor			= 0xa3,
>  
> diff --git a/lib/include/descriptors/desc_service_location.h b/lib/include/descriptors/desc_service_location.h
> new file mode 100644
> index 0000000..89ed055
> --- /dev/null
> +++ b/lib/include/descriptors/desc_service_location.h
> @@ -0,0 +1,69 @@
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
> +#ifndef _SERVICE_LOCATION_H
> +#define _SERVICE_LOCATION_H
> +
> +#include <stdint.h>
> +#include <unistd.h> /* ssize_t */
> +
> +struct dvb_desc_service_location_element {
> +	uint8_t stream_type;
> +	union {
> +		uint16_t bitfield;
> +		struct {
> +			uint16_t elementary_pid:13;
> +			uint16_t reserved:3;
> +		};
> +	};
> +	uint8_t language[4];
> +} __attribute__((packed));
> +
> +struct dvb_desc_service_location {
> +	uint8_t type;
> +	uint8_t length;
> +	struct dvb_desc *next;
> +
> +	union {
> +		uint16_t bitfield;
> +		struct {
> +			uint16_t pcr_pid:13;
> +			uint16_t reserved:3;
> +		};
> +	};
> +	uint8_t elements;
> +	struct dvb_desc_service_location_element *element;
> +} __attribute__((packed));
> +
> +struct dvb_v5_fe_parms;
> +
> +#ifdef __cplusplus
> +extern "C" {
> +#endif
> +
> +void dvb_desc_service_location_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc);
> +void dvb_desc_service_location_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc);
> +void dvb_desc_service_location_free (struct dvb_desc *desc);
> +
> +#ifdef __cplusplus
> +}
> +#endif
> +
> +#endif
> diff --git a/lib/libdvbv5/Makefile.am b/lib/libdvbv5/Makefile.am
> index 2ad5902..80e8adb 100644
> --- a/lib/libdvbv5/Makefile.am
> +++ b/lib/libdvbv5/Makefile.am
> @@ -48,7 +48,8 @@ libdvbv5_la_SOURCES = \
>    descriptors/nit.c  ../include/descriptors/nit.h \
>    descriptors/sdt.c  ../include/descriptors/sdt.h \
>    descriptors/vct.c  ../include/descriptors/vct.h \
> -  descriptors/eit.c  ../include/descriptors/eit.h
> +  descriptors/eit.c  ../include/descriptors/eit.h \
> +  descriptors/desc_service_location.c  ../include/descriptors/desc_service_location.h
>  
>  libdvbv5_la_CPPFLAGS = $(ENFORCE_LIBDVBV5_STATIC)
>  libdvbv5_la_LDFLAGS = $(LIBDVBV5_VERSION) $(ENFORCE_LIBDVBV5_STATIC) -lm
> diff --git a/lib/libdvbv5/descriptors.c b/lib/libdvbv5/descriptors.c
> index 5ce9241..437b2f4 100644
> --- a/lib/libdvbv5/descriptors.c
> +++ b/lib/libdvbv5/descriptors.c
> @@ -69,7 +69,7 @@ void dvb_desc_default_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, st
>  
>  void dvb_desc_default_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
>  {
> -	dvb_log("|                   %s (0x%02x)", dvb_descriptors[desc->type].name, desc->type);
> +	dvb_log("|                   %s (%#02x)", dvb_descriptors[desc->type].name, desc->type);
>  	hexdump(parms, "|                       ", desc->data, desc->length);
>  }
>  
> diff --git a/lib/libdvbv5/descriptors/desc_service_location.c b/lib/libdvbv5/descriptors/desc_service_location.c
> new file mode 100644
> index 0000000..3759665
> --- /dev/null
> +++ b/lib/libdvbv5/descriptors/desc_service_location.c
> @@ -0,0 +1,70 @@
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
> +#include "descriptors/desc_service_location.h"
> +#include "descriptors.h"
> +#include "dvb-fe.h"
> +
> +void dvb_desc_service_location_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
> +{
> +	struct dvb_desc_service_location *service_location = (struct dvb_desc_service_location *) desc;

please add a blank line here.

> +	/* copy from .next */
> +	memcpy(((uint8_t *) service_location )
> +			+ sizeof(service_location->type)
> +			+ sizeof(service_location->length)
> +			+ sizeof(service_location->next),
> +		buf,
> +		sizeof(service_location->bitfield) + sizeof(service_location->elements));
> +	buf +=  sizeof(service_location->bitfield) + sizeof(service_location->elements);

Use offsetof().

> +
> +	bswap16(service_location->bitfield);
> +
> +	// FIXME: handle elements == 0

no C99 comments

> +	service_location->element = malloc(service_location->elements * sizeof(struct dvb_desc_service_location_element));
> +	int i;
> +	struct dvb_desc_service_location_element *element = service_location->element;
> +	for(i = 0; i < service_location->elements; i++) {
> +		memcpy(element, buf, sizeof(struct dvb_desc_service_location_element) - 1); /* no \0 in lang */

Please test before copy.

> +		buf += sizeof(struct dvb_desc_service_location_element) - 1;
> +		element->language[3] = '\0';
> +		bswap16(element->bitfield);
> +		element++;
> +	}
> +}
> +
> +void dvb_desc_service_location_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
> +{
> +	const struct dvb_desc_service_location *service_location = (const struct dvb_desc_service_location *) desc;
> +	dvb_log("|    pcr pid      %d", service_location->pcr_pid);
> +	dvb_log("|    streams:");
> +	int i;

blank line.

> +	struct dvb_desc_service_location_element *element = service_location->element;

Please reorder: variable declarations should come before the dvb_log() calls.

> +	for(i = 0; i < service_location->elements; i++) {

Space after "for". No need for {}, as there's just one statement on this for.

> +		dvb_log("|      pid %d, type %d: %s", element[i].elementary_pid, element[i].stream_type, element[i].language);
> +	}
> +	dvb_log("| 	%d elements", service_location->elements);
> +}
> +
> +void dvb_desc_service_location_free(struct dvb_desc *desc)
> +{
> +	const struct dvb_desc_service_location *service_location = (const struct dvb_desc_service_location *) desc;

Please add a blank line.

> +	free(service_location->element);
> +}
> +


-- 

Cheers,
Mauro
