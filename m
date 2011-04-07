Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46450 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756719Ab1DGT4h (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Apr 2011 15:56:37 -0400
Subject: Re: [PATCH][media] DVB, USB, lmedm04: Fix firmware mem leak in
 lme_firmware_switch()
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	Jarod Wilson <jarod@redhat.com>, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
In-Reply-To: <alpine.LNX.2.00.1104072142540.1538@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1104072142540.1538@swampdragon.chaosbits.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Apr 2011 20:56:25 +0100
Message-ID: <1302206185.2846.2.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, 2011-04-07 at 21:46 +0200, Jesper Juhl wrote:
> Don't leak 'fw' in 
> drivers/media/dvb/dvb-usb/lmedm04.c::lme_firmware_switch() by failing to 
> call release_firmware().
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  lmedm04.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
>  compile tested only
> 
> diff --git a/drivers/media/dvb/dvb-usb/lmedm04.c b/drivers/media/dvb/dvb-usb/lmedm04.c
> index cd26e7c..d7cc625 100644
> --- a/drivers/media/dvb/dvb-usb/lmedm04.c
> +++ b/drivers/media/dvb/dvb-usb/lmedm04.c
> @@ -799,7 +799,7 @@ static int lme_firmware_switch(struct usb_device *udev, int cold)
>  	if (cold) {
>  		info("FRM Changing to %s firmware", fw_lme);
>  		lme_coldreset(udev);
> -		return -ENODEV;
> +		ret = -ENODEV;
>  	}
>  
>  	release_firmware(fw);

This has already been fixed in this commit

http://git.linuxtv.org/media_tree.git?a=commit;h=b328817a2a391d1e879c4252cd3f11a352d3f3bc


