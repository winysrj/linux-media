Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:37616 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754151Ab2DSXuk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Apr 2012 19:50:40 -0400
Subject: Re: [PATCH] TDA9887 PAL-Nc fix
From: Andy Walls <awalls@md.metrocast.net>
To: Gonzalo de la Vega <gadelavega@gmail.com>
Cc: linux-media@vger.kernel.org
Date: Thu, 19 Apr 2012 19:50:36 -0400
In-Reply-To: <4F8EB1F1.1030801@gmail.com>
References: <4F8EB1F1.1030801@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1334879437.14608.22.camel@palomino.walls.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2012-04-18 at 09:22 -0300, Gonzalo de la Vega wrote:
> The tunner IF for PAL-Nc norm, which AFAIK is used only in Argentina, was being defined as equal to PAL-M but it is not. It actually uses the same video IF as PAL-BG (and unlike PAL-M) but the audio is at 4.5MHz (same as PAL-M). A separate structure member was added for PAL-Nc.
> 
> Signed-off-by: Gonzalo A. de la Vega <gadelavega@gmail.com>

Hmmm.

The Video IF for N systems is 45.75 MHz according to this popular book
(see page 29 of the PDF):
http://www.deetc.isel.ipl.pt/Analisedesinai/sm/downloads/doc/ch08.pdf

The Video IF is really determined by the IF SAW filter used in your
tuner assembly, and how the tuner data sheet says to program the
mixer/oscillator chip to mix down from RF to IF.

What model analog tuner assembly are you using?  It could be that the
linux tuner-simple module is setting up the mixer/oscillator chip wrong.

Regards,
Andy

> 
> diff --git a/drivers/media/common/tuners/tda9887.c b/drivers/media/common/tuners/tda9887.c
> index cdb645d..b560b5d 100644
> --- a/drivers/media/common/tuners/tda9887.c
> +++ b/drivers/media/common/tuners/tda9887.c
> @@ -168,8 +168,8 @@ static struct tvnorm tvnorms[] = {
>  			   cAudioIF_6_5   |
>  			   cVideoIF_38_90 ),
>  	},{
> -		.std   = V4L2_STD_PAL_M | V4L2_STD_PAL_Nc,
> -		.name  = "PAL-M/Nc",
> +		.std   = V4L2_STD_PAL_M,
> +		.name  = "PAL-M",
>  		.b     = ( cNegativeFmTV  |
>  			   cQSS           ),
>  		.c     = ( cDeemphasisON  |
> @@ -179,6 +179,17 @@ static struct tvnorm tvnorms[] = {
>  			   cAudioIF_4_5   |
>  			   cVideoIF_45_75 ),
>  	},{
> +		.std   = V4L2_STD_PAL_Nc,
> +		.name  = "PAL-Nc",
> +		.b     = ( cNegativeFmTV  |
> +			   cQSS           ),
> +		.c     = ( cDeemphasisON  |
> +			   cDeemphasis75  |
> +			   cTopDefault),
> +		.e     = ( cGating_36     |
> +			   cAudioIF_4_5   |
> +			   cVideoIF_38_90 ),
> +	},{
>  		.std   = V4L2_STD_SECAM_B | V4L2_STD_SECAM_G | V4L2_STD_SECAM_H,
>  		.name  = "SECAM-BGH",
>  		.b     = ( cNegativeFmTV  |
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


