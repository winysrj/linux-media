Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:25673 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbaAGR3k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jan 2014 12:29:40 -0500
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZ100CEQKLFJA60@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 07 Jan 2014 12:29:39 -0500 (EST)
Date: Tue, 07 Jan 2014 15:29:34 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: =?UTF-8?B?QW5kcsOp?= Roth <neolynx@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 15/18] libdvbv5: remove c99 comments
Message-id: <20140107152934.3e39af3d@samsung.com>
In-reply-to: <1388407731-24369-15-git-send-email-neolynx@gmail.com>
References: <1388407731-24369-1-git-send-email-neolynx@gmail.com>
 <1388407731-24369-15-git-send-email-neolynx@gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 30 Dec 2013 13:48:48 +0100
André Roth <neolynx@gmail.com> escreveu:

> Signed-off-by: André Roth <neolynx@gmail.com>
> ---
>  lib/libdvbv5/descriptors/atsc_eit.c              |  2 +-
>  lib/libdvbv5/descriptors/desc_service_list.c     |  4 +++-
>  lib/libdvbv5/descriptors/desc_service_location.c |  2 +-
>  lib/libdvbv5/dvb-file.c                          | 21 +++++++++++----------
>  lib/libdvbv5/dvb-log.c                           |  2 +-
>  lib/libdvbv5/dvb-sat.c                           |  2 --
>  lib/libdvbv5/dvb-scan.c                          |  4 ++--
>  7 files changed, 19 insertions(+), 18 deletions(-)
> 
> diff --git a/lib/libdvbv5/descriptors/atsc_eit.c b/lib/libdvbv5/descriptors/atsc_eit.c
> index 4ee38ae..8d3791d 100644
> --- a/lib/libdvbv5/descriptors/atsc_eit.c
> +++ b/lib/libdvbv5/descriptors/atsc_eit.c
> @@ -68,7 +68,7 @@ void atsc_table_eit_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssiz
>                  atsc_time(event->start_time, &event->start);
>  		event->source_id = eit->header.id;
>  
> -                //FIXME: title
> +                /* FIXME: title */
>                  p += event->title_length - 1;
>  
>  		if(!*head)
> diff --git a/lib/libdvbv5/descriptors/desc_service_list.c b/lib/libdvbv5/descriptors/desc_service_list.c
> index ab91622..18aa313 100644
> --- a/lib/libdvbv5/descriptors/desc_service_list.c
> +++ b/lib/libdvbv5/descriptors/desc_service_list.c
> @@ -23,6 +23,8 @@
>  #include "descriptors.h"
>  #include "dvb-fe.h"
>  
> +/* FIXME: implement */
> +
>  void dvb_desc_service_list_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, struct dvb_desc *desc)
>  {
>  	/*struct dvb_desc_service_list *slist = (struct dvb_desc_service_list *) desc;*/
> @@ -38,7 +40,7 @@ void dvb_desc_service_list_init(struct dvb_v5_fe_parms *parms, const uint8_t *bu
>  	/*}*/
>  
>  	/*return sizeof(struct dvb_desc_service_list) + slist->length + sizeof(struct dvb_desc_service_list_table);*/
> -	//FIXME: make linked list
> +	/* FIXME: make linked list */
>  }
>  
>  void dvb_desc_service_list_print(struct dvb_v5_fe_parms *parms, const struct dvb_desc *desc)
> diff --git a/lib/libdvbv5/descriptors/desc_service_location.c b/lib/libdvbv5/descriptors/desc_service_location.c
> index 3759665..b205428 100644
> --- a/lib/libdvbv5/descriptors/desc_service_location.c
> +++ b/lib/libdvbv5/descriptors/desc_service_location.c
> @@ -36,7 +36,7 @@ void dvb_desc_service_location_init(struct dvb_v5_fe_parms *parms, const uint8_t
>  
>  	bswap16(service_location->bitfield);
>  
> -	// FIXME: handle elements == 0
> +	 /* FIXME: handle elements == 0 */
>  	service_location->element = malloc(service_location->elements * sizeof(struct dvb_desc_service_location_element));
>  	int i;
>  	struct dvb_desc_service_location_element *element = service_location->element;
> diff --git a/lib/libdvbv5/dvb-file.c b/lib/libdvbv5/dvb-file.c
> index 1e41fbb..de19dc5 100644
> --- a/lib/libdvbv5/dvb-file.c
> +++ b/lib/libdvbv5/dvb-file.c
> @@ -784,20 +784,21 @@ static char *dvb_vchannel(struct dvb_table_nit *nit, uint16_t service_id)
>  	if (!nit)
>  		return NULL;
>  
> -for( struct dvb_desc_logical_channel *desc = (struct dvb_desc_logical_channel *) nit->descriptor; desc; desc = (struct dvb_desc_logical_channel *) desc->next ) \
> +	/* FIXME: use dvb_desc_find(struct dvb_desc_logical_channel, desc, nit, logical_channel_number_descriptor) { */
> +	for( struct dvb_desc_logical_channel *desc = (struct dvb_desc_logical_channel *) nit->descriptor; desc; desc = (struct dvb_desc_logical_channel *) desc->next ) {
>  		if(desc->type == logical_channel_number_descriptor) {
> -//	dvb_desc_find(struct dvb_desc_logical_channel, desc, nit, logical_channel_number_descriptor) {
> -		struct dvb_desc_logical_channel *d = (void *)desc;
> +			struct dvb_desc_logical_channel *d = (void *)desc;
>  
> -		size_t len;
> +			size_t len;
>  
> -		len = d->length / sizeof(d->lcn);
> +			len = d->length / sizeof(d->lcn);
>  
> -		for (i = 0; i < len; i++) {
> -			if (service_id == d->lcn[i].service_id) {
> -				asprintf(&buf, "%d.%d",
> -					d->lcn[i].logical_channel_number, i);
> -				return buf;
> +			for (i = 0; i < len; i++) {
> +				if (service_id == d->lcn[i].service_id) {
> +					asprintf(&buf, "%d.%d",
> +						d->lcn[i].logical_channel_number, i);
> +					return buf;
> +				}
>  			}
>  		}
>  	}
> diff --git a/lib/libdvbv5/dvb-log.c b/lib/libdvbv5/dvb-log.c
> index 7fa811f..2be056a 100644
> --- a/lib/libdvbv5/dvb-log.c
> +++ b/lib/libdvbv5/dvb-log.c
> @@ -44,7 +44,7 @@ static const struct loglevel {
>  
>  void dvb_default_log(int level, const char *fmt, ...)
>  {
> -	if(level > sizeof(loglevels) / sizeof(struct loglevel) - 2) // ignore LOG_COLOROFF as well
> +	if(level > sizeof(loglevels) / sizeof(struct loglevel) - 2) /* ignore LOG_COLOROFF as well */
>  		level = LOG_INFO;
>  	va_list ap;
>  	va_start(ap, fmt);
> diff --git a/lib/libdvbv5/dvb-sat.c b/lib/libdvbv5/dvb-sat.c
> index 09eb4d1..ea3e2c1 100644
> --- a/lib/libdvbv5/dvb-sat.c
> +++ b/lib/libdvbv5/dvb-sat.c
> @@ -214,8 +214,6 @@ static void dvbsat_diseqc_prep_frame_addr(struct diseqc_cmd *cmd,
>  	cmd->address = diseqc_addr[type];
>  }
>  
> -//struct dvb_v5_fe_parms *parms; // legacy code, used for parms->fd, FIXME anyway
> -
>  /* Inputs are numbered from 1 to 16, according with the spec */
>  static int dvbsat_diseqc_write_to_port_group(struct dvb_v5_fe_parms *parms, struct diseqc_cmd *cmd,
>  					     int high_band,
> diff --git a/lib/libdvbv5/dvb-scan.c b/lib/libdvbv5/dvb-scan.c
> index d0f0b39..5f8596e 100644
> --- a/lib/libdvbv5/dvb-scan.c
> +++ b/lib/libdvbv5/dvb-scan.c
> @@ -98,7 +98,7 @@ int dvb_read_section_with_id(struct dvb_v5_fe_parms *parms, int dmx_fd,
>  	uint8_t *tbl = NULL;
>  	ssize_t table_length = 0;
>  
> -	// handle sections
> +	/* handle sections */
>  	int start_id = -1;
>  	int start_section = -1;
>  	int first_section = -1;
> @@ -112,7 +112,7 @@ int dvb_read_section_with_id(struct dvb_v5_fe_parms *parms, int dmx_fd,
>  		return -4;
>  	*table = NULL;
>  
> -	// FIXME: verify known table
> +	 /* FIXME: verify known table */
>  	memset(&f, 0, sizeof(f));
>  	f.pid = pid;
>  	f.filter.filter[0] = tid;

Only partially applies (as some patches introducing those comments weren't applied).

-- 

Cheers,
Mauro
