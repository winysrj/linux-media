Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:58380 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753760AbdHWK4f (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Aug 2017 06:56:35 -0400
Subject: Re: [PATCH 1/2] cx23885: Fix use-after-free when unregistering the
 i2c_client for the dvb demod
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, crope@iki.fi
References: <20170802164600.19553-1-zzam@gentoo.org>
 <20170802164600.19553-2-zzam@gentoo.org>
From: Matthias Schwarzott <zzam@gentoo.org>
Message-ID: <0662e33b-439d-3017-52d6-e2f3038c1b67@gentoo.org>
Date: Wed, 23 Aug 2017 12:56:35 +0200
MIME-Version: 1.0
In-Reply-To: <20170802164600.19553-2-zzam@gentoo.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 02.08.2017 um 18:45 schrieb Matthias Schwarzott:
> diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
> index 979b66627f60..e795ddeb7fe2 100644
> --- a/drivers/media/pci/cx23885/cx23885-dvb.c
> +++ b/drivers/media/pci/cx23885/cx23885-dvb.c
> @@ -2637,6 +2637,11 @@ int cx23885_dvb_unregister(struct cx23885_tsport *port)
>  	struct vb2_dvb_frontend *fe0;
>  	struct i2c_client *client;
>  
> +	fe0 = vb2_dvb_get_frontend(&port->frontends, 1);
> +
> +	if (fe0 && fe0->dvb.frontend)
> +		vb2_dvb_unregister_bus(&port->frontends);
> +
>  	/* remove I2C client for CI */
>  	client = port->i2c_client_ci;
>  	if (client) {
> @@ -2665,11 +2670,6 @@ int cx23885_dvb_unregister(struct cx23885_tsport *port)
>  		i2c_unregister_device(client);
>  	}
>  
> -	fe0 = vb2_dvb_get_frontend(&port->frontends, 1);
> -
> -	if (fe0 && fe0->dvb.frontend)
> -		vb2_dvb_unregister_bus(&port->frontends);
> -

The following code is after i2c_unregister_device.
>  	switch (port->dev->board) {
>  	case CX23885_BOARD_NETUP_DUAL_DVBS2_CI:
>  		netup_ci_exit(port);
> 
I wonder if the code above should be moved to before the
i2c_unregister_device block.
Currently these NETUP board drivers do not use "new style/i2c_client
based" frontend drivers. But if in future this switch is extended one
could get in trouble.

Regards
Matthias
