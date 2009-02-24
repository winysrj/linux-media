Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:44357 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271AbZBXKEg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Feb 2009 05:04:36 -0500
Date: Tue, 24 Feb 2009 11:04:02 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Updated patch for firedtv: dvb_frontend_info for FireDTV S2, fix
 "frequency limits undefined" error
To: Beat Michel Liechti <bml303@gmail.com>
cc: linux1394-devel@lists.sourceforge.net, linux-media@vger.kernel.org,
	Ben Backx <ben@bbackx.com>, Henrik Kurelid <henrik@kurelid.se>
In-Reply-To: <3e03d4060902231447r1df9f8d0pe65a50773af7fa67@mail.gmail.com>
Message-ID: <tkrat.8a312fdd39ad20b6@s5r6.in-berlin.de>
References: <3e03d4060902231447r1df9f8d0pe65a50773af7fa67@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 23 Feb, Beat Michel Liechti wrote at linux1394-devel:
> --- linux-2.6.28.5-firebranch/drivers/media/dvb/firewire/firedtv-fe.c.orig	2009-02-23 22:25:53.000000000 +0100
> +++ linux-2.6.28.5-firebranch/drivers/media/dvb/firewire/firedtv-fe.c	2009-02-23 22:29:10.000000000 +0100
> @@ -203,6 +203,24 @@ void fdtv_frontend_init(struct firedtv *
>  					  FE_CAN_QPSK;
>  		break;
>  
> +	case FIREDTV_DVB_S2:
> +		fi->type		= FE_QPSK;
> +
> +		fi->frequency_min	= 950000;
> +		fi->frequency_max	= 2150000;
> +		fi->frequency_stepsize	= 125;
> +		fi->symbol_rate_min	= 1000000;
> +		fi->symbol_rate_max	= 40000000;
> +
> +		fi->caps 		= FE_CAN_INVERSION_AUTO	|
> +					  FE_CAN_FEC_1_2	|
> +					  FE_CAN_FEC_2_3	|
> +					  FE_CAN_FEC_3_4	|
> +					  FE_CAN_FEC_5_6	|
> +					  FE_CAN_FEC_7_8	|					  
> +					  FE_CAN_QPSK;
> +		break;
> +
>  	case FIREDTV_DVB_C:
>  		fi->type		= FE_QAM;
>  

I would prefer to make case FIREDTV_DVB_S2 the same as case
FIREDTV_DVB_S --- i.e. switch FE_CAN_FEC_AUTO on too since the S2
firmwares are said to support it for standard definition channels.
We can revisit this issue when S2API is going to be implemented in the
driver.

Or does leaving this flag off make an actual difference for you?

*If* it really does something, then we can still combine the two case
blocks into one, remove the flag from fi->caps = ..., and add

		if (fdtv->type =  FIREDTV_DVB_S)
			fi->caps |= FE_CAN_FEC_AUTO;

before the break.  But only if there really is a necessity for having
the flag off for FireDTV-S2 boxes in DVB-S usage.
-- 
Stefan Richter
-=====-==--= --=- ==---
http://arcgraph.de/sr/


