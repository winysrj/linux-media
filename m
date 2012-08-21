Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.unixsol.org ([193.110.159.2]:41336 "EHLO ns.unixsol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757430Ab2HUUrR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Aug 2012 16:47:17 -0400
Message-ID: <5033F2A3.9020304@unixsol.org>
Date: Tue, 21 Aug 2012 23:42:11 +0300
From: Georgi Chorbadzhiyski <gf@unixsol.org>
MIME-Version: 1.0
To: CrazyCat <crazycat69@yandex.ru>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Antti Palosaari <crope@iki.fi>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] dvb_frontend: Multistream support
References: <53381345139167@web11e.yandex.ru> <502D37CF.7030608@iki.fi> <839331345224097@web14d.yandex.ru> <502E94FA.6080301@redhat.com> <168391345509740@web18h.yandex.ru>
In-Reply-To: <168391345509740@web18h.yandex.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 8/21/12 3:42 AM, CrazyCat wrote:
> Multistream support with all recommendations.
>
> Signed-off-by: Evgeny Plehov <EvgenyPlehov@ukr.net>
> diff --git a/include/linux/dvb/frontend.h b/include/linux/dvb/frontend.h
> index bb51edf..a6a6839 100644
> --- a/include/linux/dvb/frontend.h
> +++ b/include/linux/dvb/frontend.h
> @@ -62,6 +62,7 @@ typedef enum fe_caps {
>   	FE_CAN_8VSB			= 0x200000,
>   	FE_CAN_16VSB			= 0x400000,
>   	FE_HAS_EXTENDED_CAPS		= 0x800000,   /* We need more bitspace for newer APIs, indicate this. */
> +	FE_CAN_MULTISTREAM		= 0x4000000,  /* frontend supports DVB-S2 multistream filtering */
>   	FE_CAN_TURBO_FEC		= 0x8000000,  /* frontend supports "turbo fec modulation" */
>   	FE_CAN_2G_MODULATION		= 0x10000000, /* frontend supports "2nd generation modulation" (DVB-S2) */
>   	FE_NEEDS_BENDING		= 0x20000000, /* not supported anymore, don't use (frontend requires frequency bending) */
> @@ -338,9 +339,9 @@ struct dvb_frontend_event {
>
>   #define DTV_ISDBT_LAYER_ENABLED	41
>
> -#define DTV_ISDBS_TS_ID		42
> -
> -#define DTV_DVBT2_PLP_ID	43
> +#define DTV_STREAM_ID		42
> +#define DTV_ISDBS_TS_ID_LEGACY	DTV_STREAM_ID
> +#define DTV_DVBT2_PLP_ID_LEGACY	43
>
>   #define DTV_ENUM_DELSYS		44
>
> @@ -436,6 +437,7 @@ enum atscmh_rs_code_mode {
>   	ATSCMH_RSCODE_RES        = 3,
>   };
>
> +#define NO_STREAM_ID_FILTER	(~0U)
>
>   struct dtv_cmds_h {
>   	char	*name;		/* A display name for debugging purposes */
> diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
> index db309db..33996a0 100644
> --- a/drivers/media/dvb-core/dvb_frontend.h
> +++ b/drivers/media/dvb-core/dvb_frontend.h
> @@ -370,11 +370,8 @@ struct dtv_frontend_properties {
>   	    u8			interleaving;
>   	} layer[3];
>
> -	/* ISDB-T specifics */
> -	u32			isdbs_ts_id;
> -
> -	/* DVB-T2 specifics */
> -	u32                     dvbt2_plp_id;
> +	/* Multistream specifics */
> +	u32			stream_id;
>
>   	/* ATSC-MH specifics */
>   	u8			atscmh_fic_ver;

Shouldn't DVB_API_VERSION minor be increased or I should check for
defined(DTV_STREAM_ID) when implementing MIS support in dvblast?

-- 
Georgi Chorbadzhiyski
http://georgi.unixsol.org/
