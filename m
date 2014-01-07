Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:25141 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbaAGQc6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jan 2014 11:32:58 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZ100384HYVHO50@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 07 Jan 2014 11:32:55 -0500 (EST)
Date: Tue, 07 Jan 2014 14:32:50 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: =?UTF-8?B?QW5kcsOp?= Roth <neolynx@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 01/18] libdvbv5: fix reading multisection tables
Message-id: <20140107143250.77c0f5df@samsung.com>
In-reply-to: <1388407731-24369-1-git-send-email-neolynx@gmail.com>
References: <1388407731-24369-1-git-send-email-neolynx@gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 30 Dec 2013 13:48:34 +0100
André Roth <neolynx@gmail.com> escreveu:

description?

What bug are you trying to fix?

> Signed-off-by: André Roth <neolynx@gmail.com>
> ---
>  lib/libdvbv5/dvb-scan.c | 36 +++++++++++++++++++++++-------------
>  1 file changed, 23 insertions(+), 13 deletions(-)
> 
> diff --git a/lib/libdvbv5/dvb-scan.c b/lib/libdvbv5/dvb-scan.c
> index e9ccc72..520bf9c 100644
> --- a/lib/libdvbv5/dvb-scan.c
> +++ b/lib/libdvbv5/dvb-scan.c
> @@ -96,9 +96,13 @@ int dvb_read_section_with_id(struct dvb_v5_fe_parms *parms, int dmx_fd,
>  	uint8_t *buf = NULL;
>  	uint8_t *tbl = NULL;
>  	ssize_t table_length = 0;
> +
> +	// handle sections

No C99 comments.

> +	int start_id = -1;
> +	int start_section = -1;
>  	int first_section = -1;
>  	int last_section = -1;
> -	int table_id = -1;
> +	/*int table_id = -1;*/

Why to comment? If it is buggy, just remove it.

>  	int sections = 0;
>  	struct dmx_sct_filter_params f;
>  	struct dvb_table_header *h;
> @@ -108,7 +112,6 @@ int dvb_read_section_with_id(struct dvb_v5_fe_parms *parms, int dmx_fd,
>  	*table = NULL;
>  
>  	// FIXME: verify known table
> -
>  	memset(&f, 0, sizeof(f));
>  	f.pid = pid;
>  	f.filter.filter[0] = tid;
> @@ -185,24 +188,27 @@ int dvb_read_section_with_id(struct dvb_v5_fe_parms *parms, int dmx_fd,
>  
>  		h = (struct dvb_table_header *)buf;
>  		dvb_table_header_init(h);
> +
> +		/* dvb_logdbg( "dvb_read_section: id %d, section %d/%d, current: %d", h->id, h->section_id, h->last_section, h->current_next ); */
> +		if (start_id == h->id && start_section == h->section_id) {
> +			dvb_logdbg( "dvb_read_section: section repeated, reading done" );
> +			break;
> +		}
> +		if (start_id == -1) start_id = h->id;
> +		if (start_section == -1) start_section = h->section_id;

One statement per line, please.

> +
>  		if (id != -1 && h->id != id) { /* search for a specific table id */
>  			continue;
> -		} else {
> -			if (table_id == -1)
> -				table_id = h->id;
> -			else if (h->id != table_id) {
> -				dvb_logwarn("dvb_read_section: table ID mismatch reading multi section table: %d != %d", h->id, table_id);
> -				continue;
> -			}
>  		}
>  
> +		/*dvb_logerr("dvb_read_section: got section %d, last %d, filter %d", h->section_id, h->last_section, id );*/

Why are you adding a commented line?

>  		/* handle the sections */
>  		if (first_section == -1)
>  			first_section = h->section_id;
> -		else if (h->section_id == first_section)
> +		else if (start_id == h->id && h->section_id == first_section)
>  			break;
>  
> -		if (last_section == -1)
> +		if (last_section == -1 || h->last_section > last_section)
>  			last_section = h->last_section;
>  
>  		if (!tbl) {
> @@ -228,10 +234,14 @@ int dvb_read_section_with_id(struct dvb_v5_fe_parms *parms, int dmx_fd,
>  		else
>  			dvb_logerr("dvb_read_section: no initializer for table %d", tid);
>  
> -		if (++sections == last_section + 1)
> +		if (id != -1 && ++sections == last_section + 1) {
> +			dvb_logerr("dvb_read_section: ++sections == last_section + 1");
>  			break;
> +		}
>  	}
> -	free(buf);
> +
> +	if (buf)
> +		free(buf);

Buffer is always allocated at this point. No need to test before free.

>  
>  	dvb_dmx_stop(dmx_fd);
>  


-- 

Cheers,
Mauro
