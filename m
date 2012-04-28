Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx01.sz.bfs.de ([194.94.69.103]:7403 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753737Ab2D1O5i (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Apr 2012 10:57:38 -0400
Message-ID: <4F9C055F.7040601@bfs.de>
Date: Sat, 28 Apr 2012 16:57:35 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Oliver Endriss <o.endriss@gmx.de>,
	Ralph Metzler <rmetzler@digitaldevices.de>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] ngene: remove an unneeded condition
References: <20120420131502.GB26339@elgon.mountain>
In-Reply-To: <20120420131502.GB26339@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Am 20.04.2012 15:15, schrieb Dan Carpenter:
> "stat" is always zero here.  The condition used to be needed, but we
> shifted stuff around in 0f0b270f90 "[media] ngene: CXD2099AR Common
> Interface driver".
> 
> This doesn't change how the code works, it's just a bit tidier.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/media/dvb/ngene/ngene-core.c b/drivers/media/dvb/ngene/ngene-core.c
> index f129a93..3985738 100644
> --- a/drivers/media/dvb/ngene/ngene-core.c
> +++ b/drivers/media/dvb/ngene/ngene-core.c
> @@ -1409,10 +1409,8 @@ static int ngene_start(struct ngene *dev)
>  	if (stat < 0)
>  		goto fail;
>  
> -	if (!stat)
> -		return stat;
> +	return 0;
>  
> -	/* otherwise error: fall through */
>  fail:
>  	ngwritel(0, NGENE_INT_ENABLE);
>  	free_irq(dev->pci_dev->irq, dev);

it seems more logical to use the positive exit in this case like:

  if (stat >=0)
	return 0;

instead of jumping over return 0:

just my 2 cents,

re,
 wh


