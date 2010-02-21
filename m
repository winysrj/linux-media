Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2b.orange.fr ([80.12.242.145]:6129 "EHLO smtp2b.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754007Ab0BUIQT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Feb 2010 03:16:19 -0500
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2b09.orange.fr (SMTP Server) with ESMTP id 312DC700028E
	for <linux-media@vger.kernel.org>; Sun, 21 Feb 2010 09:16:17 +0100 (CET)
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2b09.orange.fr (SMTP Server) with ESMTP id 227C4700028F
	for <linux-media@vger.kernel.org>; Sun, 21 Feb 2010 09:16:17 +0100 (CET)
Received: from [192.168.0.1] (AVelizy-151-1-71-97.w81-249.abo.wanadoo.fr [81.249.125.97])
	by mwinf2b09.orange.fr (SMTP Server) with ESMTP id E8B09700028E
	for <linux-media@vger.kernel.org>; Sun, 21 Feb 2010 09:16:16 +0100 (CET)
Message-ID: <4B80EBEB.4010005@orange.fr>
Date: Sun, 21 Feb 2010 09:16:43 +0100
From: Catimimi <catimimi@orange.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [git:v4l-dvb/master] V4L/DVB: em28xx : Terratec Cinergy Hybrid
 T USB XS FR is working
References: <E1NiJbR-0002DD-UB@www.linuxtv.org>
In-Reply-To: <E1NiJbR-0002DD-UB@www.linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le 19/02/2010 04:32, Patch from Catimimi a écrit :
> From: Catimimi<catimimi@orange.fr>
>
> I succeeded in running Cinergy Hybrid T USB XS FR in both modes.
>
> Signed-off-by: Mauro Carvalho Chehab<mchehab@redhat.com>
>
>   drivers/media/video/em28xx/em28xx-cards.c |    3 ++-
>   drivers/media/video/em28xx/em28xx-dvb.c   |    1 +
>   2 files changed, 3 insertions(+), 1 deletions(-)
>
> ---
>
> http://git.linuxtv.org/v4l-dvb.git?a=commitdiff;h=a6e03bf56cb824507fff424eac193eca7a2fe17f
>
> diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
> index 77870a6..ecbcefb 100644
> --- a/drivers/media/video/em28xx/em28xx-cards.c
> +++ b/drivers/media/video/em28xx/em28xx-cards.c
> @@ -745,11 +745,12 @@ struct em28xx_board em28xx_boards[] = {
>
>   	[EM2880_BOARD_TERRATEC_HYBRID_XS_FR] = {
>   		.name         = "Terratec Hybrid XS Secam",
> -		.valid        = EM28XX_BOARD_NOT_VALIDATED,
>   		.has_msp34xx  = 1,
>   		.tuner_type   = TUNER_XC2028,
>   		.tuner_gpio   = default_tuner_gpio,
>   		.decoder      = EM28XX_TVP5150,
> +		.has_dvb      = 1,
> +		.dvb_gpio     = default_digital,
>   		.input        = { {
>   			.type     = EM28XX_VMUX_TELEVISION,
>   			.vmux     = TVP5150_COMPOSITE0,
> diff --git a/drivers/media/video/em28xx/em28xx-dvb.c b/drivers/media/video/em28xx/em28xx-dvb.c
> index fcf8c10..1b96356 100644
> --- a/drivers/media/video/em28xx/em28xx-dvb.c
> +++ b/drivers/media/video/em28xx/em28xx-dvb.c
> @@ -502,6 +502,7 @@ static int dvb_init(struct em28xx *dev)
>   		}
>   		break;
>   	case EM2880_BOARD_TERRATEC_HYBRID_XS:
> +	case EM2880_BOARD_TERRATEC_HYBRID_XS_FR:
>   	case EM2881_BOARD_PINNACLE_HYBRID_PRO:
>   	case EM2882_BOARD_DIKOM_DK300:
>   		dvb->frontend = dvb_attach(zl10353_attach,
>
>
>    
Hi,

This patch works well on a 32bits kernel but not on a 64 bits one. 
(openSUSE 11.2)
I'm working on that problem.
Sorry.
Michel alias Catimimi.



