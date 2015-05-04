Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-3.cisco.com ([173.38.203.53]:38415 "EHLO
	aer-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbbEDJ50 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 May 2015 05:57:26 -0400
Message-ID: <5547427D.3000702@cisco.com>
Date: Mon, 04 May 2015 11:57:17 +0200
From: Hans Verkuil <hansverk@cisco.com>
MIME-Version: 1.0
To: Prashant Laddha <prladdha@cisco.com>, linux-media@vger.kernel.org
CC: Hans Verkuil <hans.verkuil@cisco.com>,
	Martin Bugge <marbugge@cisco.com>
Subject: Re: [PATCH] v4l2-dv-timings: fix overflow in gtf timings calculation
References: <1430587386-28409-1-git-send-email-prladdha@cisco.com>
In-Reply-To: <1430587386-28409-1-git-send-email-prladdha@cisco.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/02/2015 07:23 PM, Prashant Laddha wrote:
> The intermediate calculation in the expression for hblank can exceed
> 32 bit signed range. This overflow can lead to negative values for
> hblank. Typecasting intermediate variable to higher precision.
> 
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Martin Bugge <marbugge@cisco.com>
> Signed-off-by: Prashant Laddha <prladdha@cisco.com>
> ---
>  drivers/media/v4l2-core/v4l2-dv-timings.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
> index 86e11d1..9d27f05 100644
> --- a/drivers/media/v4l2-core/v4l2-dv-timings.c
> +++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
> @@ -573,15 +573,15 @@ bool v4l2_detect_gtf(unsigned frame_height,
>  
>  	/* Horizontal */
>  	if (default_gtf)
> -		h_blank = ((image_width * GTF_D_C_PRIME * hfreq) -
> -					(image_width * GTF_D_M_PRIME * 1000) +
> -			(hfreq * (100 - GTF_D_C_PRIME) + GTF_D_M_PRIME * 1000) / 2) /
> -			(hfreq * (100 - GTF_D_C_PRIME) + GTF_D_M_PRIME * 1000);
> +		h_blank = ((image_width * GTF_D_C_PRIME * (long long)hfreq) -
> +			  ((long long)image_width * GTF_D_M_PRIME * 1000) +
> +			  ((long long)hfreq * (100 - GTF_D_C_PRIME) + GTF_D_M_PRIME * 1000) / 2) /
> +			  ((long long)hfreq * (100 - GTF_D_C_PRIME) + GTF_D_M_PRIME * 1000);

This will not work on systems that cannot divide 64 bit numbers. Use the do_div
function for this. It's a common mistake to make when developing on Intel CPUs.
Been there, done that :-) Multiple times, in fact...

And I think it will help a lot if some additional variables are introduced since
this calculation is getting complex.

Also replace "/ 2" by ">> 1". That will guarantee that you do not need do_div for
that. Probably unnecessary since I would expect gcc to be smart enough to replace
/ 2 by >> 1 anyway, but it doesn't hurt.

Regards,

	Hans

>  	else
> -		h_blank = ((image_width * GTF_S_C_PRIME * hfreq) -
> -					(image_width * GTF_S_M_PRIME * 1000) +
> -			(hfreq * (100 - GTF_S_C_PRIME) + GTF_S_M_PRIME * 1000) / 2) /
> -			(hfreq * (100 - GTF_S_C_PRIME) + GTF_S_M_PRIME * 1000);
> +		h_blank = ((image_width * GTF_S_C_PRIME * (long long)hfreq) -
> +			  ((long long)image_width * GTF_S_M_PRIME * 1000) +
> +			  ((long long)hfreq * (100 - GTF_S_C_PRIME) + GTF_S_M_PRIME * 1000) / 2) /
> +			  ((long long)hfreq * (100 - GTF_S_C_PRIME) + GTF_S_M_PRIME * 1000);
>  
>  	h_blank = ((h_blank + GTF_CELL_GRAN) / (2 * GTF_CELL_GRAN)) *
>  		  (2 * GTF_CELL_GRAN);
> 

