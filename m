Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx02-sz.bfs.de ([194.94.69.103]:4172 "EHLO mx02-sz.bfs.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754220AbdA0Iek (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jan 2017 03:34:40 -0500
Message-ID: <588B04D0.7020401@bfs.de>
Date: Fri, 27 Jan 2017 09:29:04 +0100
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] mantis_dvb: fix some error codes in mantis_dvb_init()
References: <20170127080622.GA4153@mwanda>
In-Reply-To: <20170127080622.GA4153@mwanda>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Am 27.01.2017 09:06, schrieb Dan Carpenter:
> We should be returning negative error codes here or it leads to a crash.
> This also silences a static checker warning.
> 
> 	drivers/media/pci/mantis/mantis_cards.c:250 mantis_pci_probe()
> 	warn: 'mantis->dmxdev.dvbdev->fops' double freed
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/media/pci/mantis/mantis_dvb.c b/drivers/media/pci/mantis/mantis_dvb.c
> index 5a71e1791cf5..0db4de3a2285 100644
> --- a/drivers/media/pci/mantis/mantis_dvb.c
> +++ b/drivers/media/pci/mantis/mantis_dvb.c
> @@ -226,11 +226,12 @@ int mantis_dvb_init(struct mantis_pci *mantis)
>  			goto err5;
>  		} else {
>  			if (mantis->fe == NULL) {
> +				result = -ENOMEM;
>  				dprintk(MANTIS_ERROR, 1, "FE <NULL>");
>  				goto err5;
>  			}
> -
> -			if (dvb_register_frontend(&mantis->dvb_adapter, mantis->fe)) {
> +			result = dvb_register_frontend(&mantis->dvb_adapter, mantis->fe);
> +			if (result) {
>  				dprintk(MANTIS_ERROR, 1, "ERROR: Frontend registration failed");
>  
>  				if (mantis->fe->ops.release)


hi,
just one remark:
the indent level is deep.
using  if ( !mantis->hwconfig) return 0;
and killing the "else" would help with readability.

just my 2 cents
re,
 wh

