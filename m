Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:25540 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbaAGR1b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jan 2014 12:27:31 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZ100DBDKHVD760@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 07 Jan 2014 12:27:31 -0500 (EST)
Date: Tue, 07 Jan 2014 15:27:26 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: =?UTF-8?B?QW5kcsOp?= Roth <neolynx@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 13/18] libdvbv5: improve TS parsing
Message-id: <20140107152726.26cd368a@samsung.com>
In-reply-to: <1388407731-24369-13-git-send-email-neolynx@gmail.com>
References: <1388407731-24369-1-git-send-email-neolynx@gmail.com>
 <1388407731-24369-13-git-send-email-neolynx@gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 30 Dec 2013 13:48:46 +0100
André Roth <neolynx@gmail.com> escreveu:

description?

> Signed-off-by: André Roth <neolynx@gmail.com>
> ---
>  lib/include/descriptors/mpeg_ts.h  |  4 ++--
>  lib/libdvbv5/descriptors/mpeg_ts.c | 11 ++++++++---
>  2 files changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/lib/include/descriptors/mpeg_ts.h b/lib/include/descriptors/mpeg_ts.h
> index 54fee69..de4fc3f 100644
> --- a/lib/include/descriptors/mpeg_ts.h
> +++ b/lib/include/descriptors/mpeg_ts.h
> @@ -38,7 +38,7 @@ struct dvb_mpeg_ts_adaption {
>  		uint8_t random_access:1;
>  		uint8_t discontinued:1;
>  	} __attribute__((packed));
> -
> +	uint8_t data[];
>  } __attribute__((packed));
>  
>  struct dvb_mpeg_ts {
> @@ -67,7 +67,7 @@ struct dvb_v5_fe_parms;
>  extern "C" {
>  #endif
>  
> -void dvb_mpeg_ts_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length);
> +ssize_t dvb_mpeg_ts_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length);
>  void dvb_mpeg_ts_free(struct dvb_mpeg_ts *ts);
>  void dvb_mpeg_ts_print(struct dvb_v5_fe_parms *parms, struct dvb_mpeg_ts *ts);
>  
> diff --git a/lib/libdvbv5/descriptors/mpeg_ts.c b/lib/libdvbv5/descriptors/mpeg_ts.c
> index d7ec2c4..b06cdf7 100644
> --- a/lib/libdvbv5/descriptors/mpeg_ts.c
> +++ b/lib/libdvbv5/descriptors/mpeg_ts.c
> @@ -22,27 +22,32 @@
>  #include "descriptors.h"
>  #include "dvb-fe.h"
>  
> -void dvb_mpeg_ts_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length)
> +ssize_t dvb_mpeg_ts_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length)
>  {
>  	if (buf[0] != DVB_MPEG_TS) {
>  		dvb_logerr("mpeg ts invalid marker %#02x, sould be %#02x", buf[0], DVB_MPEG_TS);
>  		*table_length = 0;
> -		return;
> +		return 0;
>  	}
> +	ssize_t bytes_read = 0;
>  	struct dvb_mpeg_ts *ts = (struct dvb_mpeg_ts *) table;
>  	const uint8_t *p = buf;

Please move declarations to the begining.

>  	memcpy(table, p, sizeof(struct dvb_mpeg_ts));
>  	p += sizeof(struct dvb_mpeg_ts);
> +	bytes_read += sizeof(struct dvb_mpeg_ts);
>  	*table_length = sizeof(struct dvb_mpeg_ts);
>  
>  	bswap16(ts->bitfield);
>  
>  	if (ts->adaptation_field & 0x2) {
>  		memcpy(table + *table_length, p, sizeof(struct dvb_mpeg_ts_adaption));
> -		p += sizeof(struct dvb_mpeg_ts);
> +		p += sizeof(struct dvb_mpeg_ts_adaption);
> +		bytes_read += sizeof(struct dvb_mpeg_ts_adaption);
>  		*table_length += ts->adaption->length + 1;
> +		/* FIXME: copy adaption->lenght bytes */

typo; length

>  	}
>  	/*hexdump(parms, "TS: ", buf, buflen);*/
> +	return bytes_read;
>  }
>  
>  void dvb_mpeg_ts_free(struct dvb_mpeg_ts *ts)

Doesn't apply yet. Please either merge with the original patch or
resubmit on a next series.

-- 

Cheers,
Mauro
