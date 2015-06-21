Return-path: <linux-media-owner@vger.kernel.org>
Received: from wp210.webpack.hosteurope.de ([80.237.132.217]:57853 "EHLO
	wp210.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751840AbbFUUC0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Jun 2015 16:02:26 -0400
Date: Sun, 21 Jun 2015 22:02:21 +0200
From: Jan =?iso-8859-1?Q?Kl=F6tzke?= <jan@kloetzke.net>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] [media] mantis: cleanup a warning
Message-ID: <20150621200221.GB28009@debian>
References: <6fe2d69c07864eecf33373b0e4be401737e37fa4.1434648756.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6fe2d69c07864eecf33373b0e4be401737e37fa4.1434648756.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

my bad. 

On Thu, Jun 18, 2015 at 02:32:39PM -0300, Mauro Carvalho Chehab wrote:
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> drivers/media/pci/mantis/mantis_i2c.c: In function 'mantis_i2c_init':
> drivers/media/pci/mantis/mantis_i2c.c:222:15: warning: variable 'intmask' set but not used [-Wunused-but-set-variable]
>   u32 intstat, intmask;
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/drivers/media/pci/mantis/mantis_i2c.c b/drivers/media/pci/mantis/mantis_i2c.c
> index a93823490a43..d72ee47dc6e4 100644
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
> @@ -242,7 +242,7 @@ int mantis_i2c_init(struct mantis_pci *mantis)
>  	dprintk(MANTIS_DEBUG, 1, "Initializing I2C ..");
>  
>  	intstat = mmread(MANTIS_INT_STAT);
> -	intmask = mmread(MANTIS_INT_MASK);
> +	mmread(MANTIS_INT_MASK);

I'm not sure if the mmread() is still needed. But as I don't have any
docs about the chipset I would keep it because that's how it has been
tested. I could re-test without it but I guess nobody cares about the
extra mmread() in the init path anyway.

Acked-by: Jan Klötzke <jan@kloetzke.net>

Regards,
Jan

>  	mmwrite(intstat, MANTIS_INT_STAT);
>  	dprintk(MANTIS_DEBUG, 1, "Disabling I2C interrupt");
>  	mantis_mask_ints(mantis, MANTIS_INT_I2CDONE);
> -- 
> 2.4.3
> 
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
