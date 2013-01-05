Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp25.services.sfr.fr ([93.17.128.118]:6212 "EHLO
	smtp25.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755346Ab3AEJj4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Jan 2013 04:39:56 -0500
Message-ID: <50E7F4C9.6050607@sfr.fr>
Date: Sat, 05 Jan 2013 10:39:21 +0100
From: Patrice Chotard <patrice.chotard@sfr.fr>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Patrice Chotard <patricechotard@free.fr>,
	Antti Palosaari <crope@iki.fi>
Subject: Re: [PATCH] ngene: fix commit
 36a495a336c3fbbb2f4eeed2a94ab6d5be19d186
References: <1357358802-17296-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <1357358802-17296-1-git-send-email-mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Yes, i confirm that without this patch, tuner_attach_dtt7520x() callback
was never called, so no tuning was possible.

Patrice

Le 05/01/2013 05:06, Mauro Carvalho Chehab a écrit :
> The above commit were applied only partially; it broke tuner and
> demod attach, but the part that added it to ngene_info was missing.
> 
> Not sure what happened there, but, without this patch, a regression
> would be happening.
> 
> Also, gcc complains about a defined but not used symbol.
> 
> So, apply manually the missing part.
> 
> Cc: Patrice Chotard <patricechotard@free.fr>
> Cc: Antti Palosaari <crope@iki.fi>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  drivers/media/pci/ngene/ngene-cards.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/pci/ngene/ngene-cards.c b/drivers/media/pci/ngene/ngene-cards.c
> index 2a4895b..82318d1 100644
> --- a/drivers/media/pci/ngene/ngene-cards.c
> +++ b/drivers/media/pci/ngene/ngene-cards.c
> @@ -732,6 +732,7 @@ static struct ngene_info ngene_info_terratec = {
>  	.name           = "Terratec Integra/Cinergy2400i Dual DVB-T",
>  	.io_type        = {NGENE_IO_TSIN, NGENE_IO_TSIN},
>  	.demod_attach   = {demod_attach_drxd, demod_attach_drxd},
> +	.tuner_attach	= {tuner_attach_dtt7520x, tuner_attach_dtt7520x},
>  	.fe_config      = {&fe_terratec_dvbt_0, &fe_terratec_dvbt_1},
>  	.i2c_access     = 1,
>  };
> 
