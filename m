Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:20874 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756586Ab3L2Cxu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Dec 2013 21:53:50 -0500
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MYJ005NNS1P0G60@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Sat, 28 Dec 2013 21:53:49 -0500 (EST)
Date: Sun, 29 Dec 2013 00:53:35 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: =?UTF-8?B?QW5kcsOp?= Roth <neolynx@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 01/13] libdvbv5: fix reading multisection tables
Message-id: <20131229005335.049c4b67.m.chehab@samsung.com>
In-reply-to: <1388245561-8751-1-git-send-email-neolynx@gmail.com>
References: <1388245561-8751-1-git-send-email-neolynx@gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 28 Dec 2013 16:45:49 +0100
André Roth <neolynx@gmail.com> escreveu:

> Signed-off-by: André Roth <neolynx@gmail.com>
> ---
>  lib/libdvbv5/dvb-scan.c | 18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/lib/libdvbv5/dvb-scan.c b/lib/libdvbv5/dvb-scan.c
> index e9ccc72..af3a052 100644
> --- a/lib/libdvbv5/dvb-scan.c
> +++ b/lib/libdvbv5/dvb-scan.c
> @@ -187,15 +187,19 @@ int dvb_read_section_with_id(struct dvb_v5_fe_parms *parms, int dmx_fd,
>  		dvb_table_header_init(h);
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
> +		/*if (id != -1) {*/
> +			/*if (table_id == -1)*/
> +				/*table_id = h->id;*/
> +			/*else if (h->id != table_id) {*/
> +				/*dvb_logwarn("dvb_read_section: table ID mismatch reading multi section table: %d != %d", h->id, table_id);*/
> +				/*free(buf);*/
> +				/*continue;*/
> +			/*}*/
> +		/*}*/
> +

Could you please better describe this patch? What but is it supposed to
fix?

If this is a bug fix, why are you commenting all lines instead of dropping?

> +		dvb_logerr("dvb_read_section: got section %d, last %di, filter %d", h->section_id, h->last_section, id );
>  		/* handle the sections */
>  		if (first_section == -1)
>  			first_section = h->section_id;


-- 

Cheers,
Mauro
