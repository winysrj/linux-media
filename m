Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:46304 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756832AbcAYRKC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2016 12:10:02 -0500
Date: Mon, 25 Jan 2016 15:09:56 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: =?UTF-8?B?Sm9zw6k=?= David Moreno =?UTF-8?B?SnXDoXJleg==?=
	<jose.david@morenojuarez.nom.es>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] cx88-dvb: Changed tuner associated with board
 Hauppauge HVR-4000 from TUNER_PHILIPS_FMD1216ME_MK3 to
 TUNER_PHILIPS_FMD1216MEX_MK3
Message-ID: <20160125150956.6d8650ff@recife.lan>
In-Reply-To: <2691391.45DzHjqa9H@sisifo>
References: <2691391.45DzHjqa9H@sisifo>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 29 Dec 2015 17:26:41 +0100
José David Moreno Juárez  <jose.david@morenojuarez.nom.es> escreveu:

> The correct tuner for the board Hauppauge HVR-4000 seems to be FMD1216MEX MK3 
> instead of FMD1216ME MK3. The tuner is identified as such by tveeprom:
> 	Dec 28 23:01:15 [kernel] tveeprom 8-0050: tuner model is Philips 
> FMD1216MEX (idx 133, type 78)
> 
> This patch fixes a longstanding warning message issued by tuner-simple:
> 	Dec 28 23:01:15 [kernel] tuner-simple 8-0061: couldn't set type to 63. 
> Using 78 (Philips FMD1216MEX MK3 Hybrid Tuner) instead
> 
> It has been successfully tested against kernel 4.1.12.
> 
> 
> 
> Signed-off-by: José David Moreno Juárez <jose.david@morenojuarez.nom.es>
> ---
>  drivers/media/pci/cx88/cx88-dvb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/pci/cx88/cx88-dvb.c b/drivers/media/pci/cx88/cx88-
> dvb.c
> index afb2075..ac2ad00 100644
> --- a/drivers/media/pci/cx88/cx88-dvb.c
> +++ b/drivers/media/pci/cx88/cx88-dvb.c
> @@ -1474,7 +1474,7 @@ static int dvb_register(struct cx8802_dev *dev)
>  			if (!dvb_attach(simple_tuner_attach,
>  					fe1->dvb.frontend,
>  					&dev->core->i2c_adap,
> -					0x61, TUNER_PHILIPS_FMD1216ME_MK3))
> +					0x61, TUNER_PHILIPS_FMD1216MEX_MK3))

This will likely break for other Hauppauge devices that use the other
tuner model. The best would be, instead, to use the value returned
by tveeprom here, instead of hardcoding it.


>  				goto frontend_detach;
>  		}
>  		break;
