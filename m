Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-14.arcor-online.net ([151.189.21.54]:51943 "EHLO
	mail-in-14.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933423AbZHWB4f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2009 21:56:35 -0400
Received: from mail-in-06-z2.arcor-online.net (mail-in-06-z2.arcor-online.net [151.189.8.18])
	by mx.arcor.de (Postfix) with ESMTP id 76C2E28ACB3
	for <linux-media@vger.kernel.org>; Sun, 23 Aug 2009 03:56:35 +0200 (CEST)
Received: from mail-in-13.arcor-online.net (mail-in-13.arcor-online.net [151.189.21.53])
	by mail-in-06-z2.arcor-online.net (Postfix) with ESMTP id 6D39A5BE50
	for <linux-media@vger.kernel.org>; Sun, 23 Aug 2009 03:56:35 +0200 (CEST)
Received: from [192.168.178.24] (pD9E12FAC.dip0.t-ipconnect.de [217.225.47.172])
	(Authenticated sender: hermann-pitton@arcor.de)
	by mail-in-13.arcor-online.net (Postfix) with ESMTPSA id 438D42BAA99
	for <linux-media@vger.kernel.org>; Sun, 23 Aug 2009 03:56:35 +0200 (CEST)
Subject: Re: [PATCH] saa7134: start to investigate the LNA mess on 310i and
	hvr1110 products
From: hermann pitton <hermann-pitton@arcor.de>
To: linux-media@vger.kernel.org
In-Reply-To: <1250812164.3249.18.camel@pc07.localdom.local>
References: <1250812164.3249.18.camel@pc07.localdom.local>
Content-Type: text/plain
Date: Sun, 23 Aug 2009 03:54:08 +0200
Message-Id: <1250992448.3262.11.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Freitag, den 21.08.2009, 01:49 +0200 schrieb hermann pitton:
> There is a great maintenance mess for those devices currently.
> 
> All attempts, to get some further information out of those assumed to be
> closest to the above manufactures, failed.
> 
> Against any previous advice, newer products with an additional LNA,
> which needs to be configured correctly, have been added and we can't
> make any difference to previous products without LNA.
> 
> Even more, the type of LNA configuration, either over tuner gain or some
> on the analog IF demodulator, conflicts within this two devices itself.
> 
> Since we never had a chance, to see such devices with all details
> reported to our lists, but might still be able to make eventually a
> difference, to get out of that mess, we should prefer to start exactly
> where it started.

Mauro, Douglas,

just mark it as an RFC.

Seems i lose any interest to follow up such further.

Never allow any guys to go out into the wild, ending up with that I have
to read their personal web blogs ..., out of lists.

Cheers,
Hermann


> Signed-off-by: hermann pitton <hermann-pitton@arcor.de>iff -r d0ec20a376fe linux/drivers/media/video/saa7134/saa7134-cards.c
> --- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Thu Aug 20
> 01:30:58 2009 +0000
> +++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Fri Aug 21
> 01:28:37 2009 +0200
> @@ -3242,7 +3242,7 @@
>  		.radio_type     = UNSET,
>  		.tuner_addr     = ADDR_UNSET,
>  		.radio_addr     = ADDR_UNSET,
> -		.tuner_config   = 1,
> +		.tuner_config   = 0,
>  		.mpeg           = SAA7134_MPEG_DVB,
>  		.gpiomask       = 0x000200000,
>  		.inputs         = {{
> @@ -3346,7 +3346,7 @@
>  		.radio_type     = UNSET,
>  		.tuner_addr     = ADDR_UNSET,
>  		.radio_addr     = ADDR_UNSET,
> -		.tuner_config   = 1,
> +		.tuner_config   = 0,
>  		.mpeg           = SAA7134_MPEG_DVB,
>  		.gpiomask       = 0x0200100,
>  		.inputs         = {{
> diff -r d0ec20a376fe linux/drivers/media/video/saa7134/saa7134-dvb.c
> --- a/linux/drivers/media/video/saa7134/saa7134-dvb.c	Thu Aug 20
> 01:30:58 2009 +0000
> +++ b/linux/drivers/media/video/saa7134/saa7134-dvb.c	Fri Aug 21
> 01:28:37 2009 +0200
> @@ -1144,12 +1144,12 @@
>  		break;
>  	case SAA7134_BOARD_PINNACLE_PCTV_310i:
>  		if (configure_tda827x_fe(dev, &pinnacle_pctv_310i_config,
> -					 &tda827x_cfg_1) < 0)
> +					 &tda827x_cfg_0) < 0)
>  			goto dettach_frontend;
>  		break;
>  	case SAA7134_BOARD_HAUPPAUGE_HVR1110:
>  		if (configure_tda827x_fe(dev, &hauppauge_hvr_1110_config,
> -					 &tda827x_cfg_1) < 0)
> +					 &tda827x_cfg_0) < 0)
>  			goto dettach_frontend;
>  		break;
>  	case SAA7134_BOARD_HAUPPAUGE_HVR1150:
> 

