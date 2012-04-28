Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:46809 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088Ab2D1PNw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Apr 2012 11:13:52 -0400
Date: Sat, 28 Apr 2012 18:16:38 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: walter harms <wharms@bfs.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Oliver Endriss <o.endriss@gmx.de>,
	Ralph Metzler <rmetzler@digitaldevices.de>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] ngene: remove an unneeded condition
Message-ID: <20120428151638.GB13883@mwanda>
References: <20120420131502.GB26339@elgon.mountain>
 <4F9C055F.7040601@bfs.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F9C055F.7040601@bfs.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Apr 28, 2012 at 04:57:35PM +0200, walter harms wrote:
> 
> 
> Am 20.04.2012 15:15, schrieb Dan Carpenter:
> > "stat" is always zero here.  The condition used to be needed, but we
> > shifted stuff around in 0f0b270f90 "[media] ngene: CXD2099AR Common
> > Interface driver".
> > 
> > This doesn't change how the code works, it's just a bit tidier.
> > 
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > 
> > diff --git a/drivers/media/dvb/ngene/ngene-core.c b/drivers/media/dvb/ngene/ngene-core.c
> > index f129a93..3985738 100644
> > --- a/drivers/media/dvb/ngene/ngene-core.c
> > +++ b/drivers/media/dvb/ngene/ngene-core.c
> > @@ -1409,10 +1409,8 @@ static int ngene_start(struct ngene *dev)
> >  	if (stat < 0)
> >  		goto fail;
> >  
> > -	if (!stat)
> > -		return stat;
> > +	return 0;
> >  
> > -	/* otherwise error: fall through */
> >  fail:
> >  	ngwritel(0, NGENE_INT_ENABLE);
> >  	free_irq(dev->pci_dev->irq, dev);
> 
> it seems more logical to use the positive exit in this case like:
> 
>   if (stat >=0)
> 	return 0;
> 
> instead of jumping over return 0:
> 

I would say it's more readable to handle the error condition as
a special case instead of handling the normal success case as
special.  It's better to be consistent instead of changing back and
forth:

	if (error condition)
		return ret;
	if (error condition)
		return ret;
	if (success conditi)
		return ret;
	if (error condition)
		return ret;


regards,
dan carpenter
