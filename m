Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:37146 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371Ab3GBS3x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Jul 2013 14:29:53 -0400
Received: by mail-ea0-f172.google.com with SMTP id q10so2980632eaj.3
        for <linux-media@vger.kernel.org>; Tue, 02 Jul 2013 11:29:52 -0700 (PDT)
Date: Tue, 2 Jul 2013 20:29:45 +0200
From: =?UTF-8?B?QW5kcsOp?= Roth <neolynx@gmail.com>
To: Guy Martin <gmsoft@tuxicoman.be>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 3/6] libdvbv5: Export dvb_fe_is_satellite()
Message-ID: <20130702202945.4591f98d@myon.exnihilo>
In-Reply-To: <8745561db2ff7870ad9feb1ee0c7a32537dee18d.1371561676.git.gmsoft@tuxicoman.be>
References: <cover.1371561676.git.gmsoft@tuxicoman.be>
	<8745561db2ff7870ad9feb1ee0c7a32537dee18d.1371561676.git.gmsoft@tuxicoman.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Acked-by: André Roth <neolynx@gmail.com>


On Tue, 18 Jun 2013 16:19:06 +0200
Guy Martin <gmsoft@tuxicoman.be> wrote:

> This patch makes the function dvb_fe_is_satellite() availble from libdvbv5. This function is simple
> but yet very handful to have around.
> 
> Signed-off-by: Guy Martin <gmsoft@tuxicoman.be>
> ---
>  lib/include/dvb-fe.h  |  1 +
>  lib/libdvbv5/dvb-fe.c | 14 +++++++-------
>  2 files changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/lib/include/dvb-fe.h b/lib/include/dvb-fe.h
> index d725a42..7352218 100644
> --- a/lib/include/dvb-fe.h
> +++ b/lib/include/dvb-fe.h
> @@ -203,6 +203,7 @@ int dvb_fe_diseqc_cmd(struct dvb_v5_fe_parms *parms, const unsigned len,
>  		      const unsigned char *buf);
>  int dvb_fe_diseqc_reply(struct dvb_v5_fe_parms *parms, unsigned *len, char *buf,
>  		       int timeout);
> +int dvb_fe_is_satellite(uint32_t delivery_system);
>  
>  #ifdef __cplusplus
>  }
> diff --git a/lib/libdvbv5/dvb-fe.c b/lib/libdvbv5/dvb-fe.c
> index 550b6e2..b786a85 100644
> --- a/lib/libdvbv5/dvb-fe.c
> +++ b/lib/libdvbv5/dvb-fe.c
> @@ -230,7 +230,7 @@ struct dvb_v5_fe_parms *dvb_fe_open2(int adapter, int frontend, unsigned verbose
>  }
>  
>  
> -static int is_satellite(uint32_t delivery_system)
> +int dvb_fe_is_satellite(uint32_t delivery_system)
>  {
>  	switch (delivery_system) {
>  	case SYS_DVBS:
> @@ -254,7 +254,7 @@ void dvb_fe_close(struct dvb_v5_fe_parms *parms)
>  		return;
>  
>  	/* Disable LNBf power */
> -	if (is_satellite(parms->current_sys))
> +	if (dvb_fe_is_satellite(parms->current_sys))
>  		dvb_fe_sec_voltage(parms, 0, 0);
>  
>  	close(parms->fd);
> @@ -298,8 +298,8 @@ int dvb_set_sys(struct dvb_v5_fe_parms *parms,
>  
>  	if (sys != parms->current_sys) {
>  		/* Disable LNBf power */
> -		if (is_satellite(parms->current_sys) &&
> -		    !is_satellite(sys))
> +		if (dvb_fe_is_satellite(parms->current_sys) &&
> +		    !dvb_fe_is_satellite(sys))
>  			dvb_fe_sec_voltage(parms, 0, 0);
>  
>  		/* Can't change standard with the legacy FE support */
> @@ -594,7 +594,7 @@ int dvb_fe_get_parms(struct dvb_v5_fe_parms *parms)
>  
>  ret:
>  	/* For satellite, need to recover from LNBf IF frequency */
> -	if (is_satellite(parms->current_sys))
> +	if (dvb_fe_is_satellite(parms->current_sys))
>  		return dvb_sat_get_parms(parms);
>  
>  	return 0;
> @@ -609,7 +609,7 @@ int dvb_fe_set_parms(struct dvb_v5_fe_parms *parms)
>  
>  	struct dtv_property fe_prop[DTV_MAX_COMMAND];
>  
> -	if (is_satellite(parms->current_sys)) {
> +	if (dvb_fe_is_satellite(parms->current_sys)) {
>  		dvb_fe_retrieve_parm(parms, DTV_FREQUENCY, &freq);
>  		dvb_sat_set_parms(parms);
>  	}
> @@ -673,7 +673,7 @@ int dvb_fe_set_parms(struct dvb_v5_fe_parms *parms)
>  	}
>  ret:
>  	/* For satellite, need to recover from LNBf IF frequency */
> -	if (is_satellite(parms->current_sys))
> +	if (dvb_fe_is_satellite(parms->current_sys))
>  		dvb_fe_store_parm(parms, DTV_FREQUENCY, freq);
>  
>  	return 0;
