Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:56126 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395Ab3GBSbw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Jul 2013 14:31:52 -0400
Received: by mail-ee0-f42.google.com with SMTP id c4so2881435eek.15
        for <linux-media@vger.kernel.org>; Tue, 02 Jul 2013 11:31:51 -0700 (PDT)
Received: from myon.exnihilo (51-213.60-188.cust.bluewin.ch. [188.60.213.51])
        by mx.google.com with ESMTPSA id w43sm38148232eez.6.2013.07.02.11.31.50
        for <linux-media@vger.kernel.org>
        (version=SSLv3 cipher=RC4-SHA bits=128/128);
        Tue, 02 Jul 2013 11:31:51 -0700 (PDT)
Date: Tue, 2 Jul 2013 20:31:48 +0200
From: =?UTF-8?B?QW5kcsOp?= Roth <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Subject: Re: [PATCH 6/6] dvbv5-zap: Parse the LNB from the channel file
Message-ID: <20130702203148.70ca39a5@myon.exnihilo>
In-Reply-To: <0fa749428b7762956fd7e19fec6ea306f1d23eec.1371561676.git.gmsoft@tuxicoman.be>
References: <cover.1371561676.git.gmsoft@tuxicoman.be>
	<0fa749428b7762956fd7e19fec6ea306f1d23eec.1371561676.git.gmsoft@tuxicoman.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Acked-by: André Roth <neolynx@gmail.com>

On Tue, 18 Jun 2013 16:19:09 +0200
Guy Martin <gmsoft@tuxicoman.be> wrote:

> Parsing the LNB needs to be done for proper tuning.
> 
> Signed-off-by: Guy Martin <gmsoft@tuxicoman.be>
> ---
>  utils/dvb/dvbv5-zap.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/utils/dvb/dvbv5-zap.c b/utils/dvb/dvbv5-zap.c
> index c84cf70..d6c1152 100644
> --- a/utils/dvb/dvbv5-zap.c
> +++ b/utils/dvb/dvbv5-zap.c
> @@ -165,6 +165,15 @@ static int parse(struct arguments *args,
>  		return -3;
>  	}
>  
> +	if (entry->lnb) {
> +		int lnb = dvb_sat_search_lnb(entry->lnb);
> +		if (lnb == -1) {
> +			PERROR("unknown LNB %s\n", entry->lnb);
> +			return -1;
> +		}
> +		parms->lnb = dvb_sat_get_lnb(lnb);
> +	}
> +
>  	if (entry->video_pid) {
>  		if (args->n_vpid < entry->video_pid_len)
>  			*vpid = entry->video_pid[args->n_vpid];
