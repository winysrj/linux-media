Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:39070
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751203AbcJJJhn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Oct 2016 05:37:43 -0400
Date: Mon, 10 Oct 2016 06:30:35 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Nicholas Mc Guire <hofrat@osadl.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alejandro Torrado <aletorrado@gmail.com>,
        Nicolas Sugino <nsugino@3way.com.ar>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Patrick Boettcher <patrick.boettcher@posteo.de>
Subject: Re: [PATCH RFC] [media] dib0700: remove redundant else
Message-ID: <20161010063035.7b766b79@vento.lan>
In-Reply-To: <1475928199-20315-1-git-send-email-hofrat@osadl.org>
References: <1475928199-20315-1-git-send-email-hofrat@osadl.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat,  8 Oct 2016 14:03:19 +0200
Nicholas Mc Guire <hofrat@osadl.org> escreveu:

> The if and else are identical and can be consolidated here.
> 
> Fixes: commit 91be260faaf8 ("[media] dib8000: Add support for Mygica/Geniatech S2870")
> 
> Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
> ---
> 
> Problem found by coccinelle script
> 
> Based only on reviewing this driver it seems that the dib0090_config
> is not an array and thus this is a cut&past bug - but not having access
> to the driver I can not say.  Other cases that have the
> conditioning on (adap->id == 0) e.g. dib7070p_dib0070 actually have
> a config array (dib7070p_dib0070_config[]). So the if/else here most
> likely is unnecessary.
> 
> The patch is actually a partial revert of commit 91be260faaf8 ("[media]
> dib8000: Add support for Mygica/Geniatech S2870") where this if/else
> was deliberately introduced but without any specific comments.
> 
> This needs a review by someone that has access to the details of the driver.
> 
> Patch was compile tested with: x86_64_defconfig + CONFIG_MEDIA_SUPPORT=m,
> CONFIG_MEDIA_USB_SUPPORT=y, CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y,
> CONFIG_DVB_USB=m, CONFIG_DVB_USB_V2=m, CONFIG_MEDIA_RC_SUPPORT=y,
> CONFIG_DVB_USB_DIB0700=m
> 
> Patch is against 4.8.0 (localversion-next is -next-20161006)
> 
>  drivers/media/usb/dvb-usb/dib0700_devices.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/media/usb/dvb-usb/dib0700_devices.c b/drivers/media/usb/dvb-usb/dib0700_devices.c
> index 0857b56..3cd8566 100644
> --- a/drivers/media/usb/dvb-usb/dib0700_devices.c
> +++ b/drivers/media/usb/dvb-usb/dib0700_devices.c
> @@ -1736,13 +1736,9 @@ static int dib809x_tuner_attach(struct dvb_usb_adapter *adap)
>  	struct dib0700_adapter_state *st = adap->priv;
>  	struct i2c_adapter *tun_i2c = st->dib8000_ops.get_i2c_master(adap->fe_adap[0].fe, DIBX000_I2C_INTERFACE_TUNER, 1);
>  
> -	if (adap->id == 0) {
> -		if (dvb_attach(dib0090_register, adap->fe_adap[0].fe, tun_i2c, &dib809x_dib0090_config) == NULL)
> -			return -ENODEV;
> -	} else {
> -		if (dvb_attach(dib0090_register, adap->fe_adap[0].fe, tun_i2c, &dib809x_dib0090_config) == NULL)
> -			return -ENODEV;
> -	}
> +	if (dvb_attach(dib0090_register, adap->fe_adap[0].fe,
> +		       tun_i2c, &dib809x_dib0090_config) == NULL)
> +		return -ENODEV;


I suspect that this patch is wrong. It should be, instead, using
fe_adap[1] on the else.

Patrick,

Could you please take a look?

Regards,

Thanks,
Mauro
