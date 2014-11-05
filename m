Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:50973 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753888AbaKEMV4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Nov 2014 07:21:56 -0500
Message-ID: <545A164B.2010908@xs4all.nl>
Date: Wed, 05 Nov 2014 13:21:31 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 2/5] [media] cx24110: Fix a spatch warning
References: <667c952e7191ffb0a2703c8e173b0d5f0231a764.1415188985.git.mchehab@osg.samsung.com> <b8e64df00231a4c4d59b68d8eda9f8db1adc1ea4.1415188985.git.mchehab@osg.samsung.com>
In-Reply-To: <b8e64df00231a4c4d59b68d8eda9f8db1adc1ea4.1415188985.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

spatch or smatch? I assume smatch :-)

BTW, I've just added smatch support to the daily build.

Regards,

	Hans

On 11/05/14 13:03, Mauro Carvalho Chehab wrote:
> This is actually a false positive:
> 	drivers/media/dvb-frontends/cx24110.c:210 cx24110_set_fec() error: buffer overflow 'rate' 7 <= 8
> 
> But fixing it is easy: just ensure that the table size will be
> limited to FEC_AUTO.
> 
> While here, fix spacing on the affected lines.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/drivers/media/dvb-frontends/cx24110.c b/drivers/media/dvb-frontends/cx24110.c
> index 95b981cd7115..e78e7893e8aa 100644
> --- a/drivers/media/dvb-frontends/cx24110.c
> +++ b/drivers/media/dvb-frontends/cx24110.c
> @@ -181,16 +181,16 @@ static int cx24110_set_fec (struct cx24110_state* state, fe_code_rate_t fec)
>  {
>  /* fixme (low): error handling */
>  
> -	static const int rate[]={-1,1,2,3,5,7,-1};
> -	static const int g1[]={-1,0x01,0x02,0x05,0x15,0x45,-1};
> -	static const int g2[]={-1,0x01,0x03,0x06,0x1a,0x7a,-1};
> +	static const int rate[FEC_AUTO] = {-1,    1,    2,    3,    5,    7, -1};
> +	static const int g1[FEC_AUTO]   = {-1, 0x01, 0x02, 0x05, 0x15, 0x45, -1};
> +	static const int g2[FEC_AUTO]   = {-1, 0x01, 0x03, 0x06, 0x1a, 0x7a, -1};
>  
>  	/* Well, the AutoAcq engine of the cx24106 and 24110 automatically
>  	   searches all enabled viterbi rates, and can handle non-standard
>  	   rates as well. */
>  
> -	if (fec>FEC_AUTO)
> -		fec=FEC_AUTO;
> +	if (fec > FEC_AUTO)
> +		fec = FEC_AUTO;
>  
>  	if (fec==FEC_AUTO) { /* (re-)establish AutoAcq behaviour */
>  		cx24110_writereg(state,0x37,cx24110_readreg(state,0x37)&0xdf);
> 

