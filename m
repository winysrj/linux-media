Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:17353 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbaIYQ2R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Sep 2014 12:28:17 -0400
Date: Thu, 25 Sep 2014 13:28:10 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] em28xx-input: NULL dereference on error
Message-id: <20140925132810.28572100.m.chehab@samsung.com>
In-reply-to: <alpine.DEB.2.10.1409251736480.2766@hadrien>
References: <20140925113941.GB3708@mwanda> <542421DF.9060000@googlemail.com>
 <alpine.DEB.2.10.1409251736480.2766@hadrien>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 25 Sep 2014 17:37:46 +0200
Julia Lawall <julia.lawall@lip6.fr> escreveu:

> On Thu, 25 Sep 2014, Frank Schäfer wrote:
> 
> > Hi Dan,
> >
> > Am 25.09.2014 um 13:39 schrieb Dan Carpenter:
> > > We call "kfree(ir->i2c_client);" in the error handling and that doesn't
> > > work if "ir" is NULL.
> > >
> > > Fixes: 78e719a5f30b ('[media] em28xx-input: i2c IR decoders: improve i2c_client handling')
> > > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > >
> > > diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
> > > index 581f6da..23f8f6a 100644
> > > --- a/drivers/media/usb/em28xx/em28xx-input.c
> > > +++ b/drivers/media/usb/em28xx/em28xx-input.c
> > > @@ -712,8 +712,10 @@ static int em28xx_ir_init(struct em28xx *dev)
> > >  	em28xx_info("Registering input extension\n");
> > >
> > >  	ir = kzalloc(sizeof(*ir), GFP_KERNEL);
> > > +	if (!ir)
> > > +		return -ENOMEM;
> > >  	rc = rc_allocate_device();
> > > -	if (!ir || !rc)
> > > +	if (!rc)
> > >  		goto error;
> 
> I have never understood this kind of code.  If the kmalloc fails, why not
> give up immediately (as in Dan's patch)?


I agree. In this specific place, it can just return an error, as there's
nothing yet used, just like the previous clauses.

Regards,
Mauro
