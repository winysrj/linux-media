Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:52619 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489AbbFRU6C (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jun 2015 16:58:02 -0400
Date: Thu, 18 Jun 2015 17:57:57 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] mantis: fix unused variable compiler warning
Message-ID: <20150618175757.0cbc3551@recife.lan>
In-Reply-To: <55792525.9030003@xs4all.nl>
References: <55792525.9030003@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 11 Jun 2015 08:05:25 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> mantis_i2c.c:222:15: warning: variable 'intmask' set but not used [-Wunused-but-set-variable]
>   u32 intstat, intmask;
>                ^
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> diff --git a/drivers/media/pci/mantis/mantis_i2c.c b/drivers/media/pci/mantis/mantis_i2c.c
> index a938234..9abe1c7 100644
> --- a/drivers/media/pci/mantis/mantis_i2c.c
> +++ b/drivers/media/pci/mantis/mantis_i2c.c
> @@ -219,7 +219,7 @@ static struct i2c_algorithm mantis_algo = {
>  
>  int mantis_i2c_init(struct mantis_pci *mantis)
>  {
> -	u32 intstat, intmask;
> +	u32 intstat;
>  	struct i2c_adapter *i2c_adapter = &mantis->adapter;
>  	struct pci_dev *pdev		= mantis->pdev;
>  
> @@ -242,7 +242,6 @@ int mantis_i2c_init(struct mantis_pci *mantis)
>  	dprintk(MANTIS_DEBUG, 1, "Initializing I2C ..");
>  
>  	intstat = mmread(MANTIS_INT_STAT);
> -	intmask = mmread(MANTIS_INT_MASK);

Doing this sounds too risky for me without enough info from this
device, as reading the mask could be needed in order to reset the
IRQ.

I added earlier today a patch that keeps the mmread() there, just
removing the temporary unused var.

>  	mmwrite(intstat, MANTIS_INT_STAT);
>  	dprintk(MANTIS_DEBUG, 1, "Disabling I2C interrupt");
>  	mantis_mask_ints(mantis, MANTIS_INT_I2CDONE);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
