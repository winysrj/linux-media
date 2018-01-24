Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:58290 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752351AbeAXIOD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 Jan 2018 03:14:03 -0500
Date: Wed, 24 Jan 2018 11:13:16 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Sylwester Nawrocki <snawrocki@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] [media] s3c-camif: array underflow in
 __camif_subdev_try_format()
Message-ID: <20180124081316.r75cr7yrcg3xhpw3@mwanda>
References: <20180122103714.GA25044@mwanda>
 <5b3b7195-930c-58c3-d52f-b2738c3fde1e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b3b7195-930c-58c3-d52f-b2738c3fde1e@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 22, 2018 at 09:50:04PM +0100, Sylwester Nawrocki wrote:
> On 01/22/2018 11:37 AM, Dan Carpenter wrote:
> > --- a/drivers/media/platform/s3c-camif/camif-capture.c
> > +++ b/drivers/media/platform/s3c-camif/camif-capture.c
> > @@ -1261,11 +1261,11 @@ static void __camif_subdev_try_format(struct camif_dev *camif,
> >   	/* FIXME: constraints against codec or preview path ? */
> >   	pix_lim = &variant->vp_pix_limits[VP_CODEC];
> >   
> > -	while (i-- >= 0)
> > +	while (--i >= 0)
> >   		if (camif_mbus_formats[i] == mf->code)
> >   			break;
> > -
> > -	mf->code = camif_mbus_formats[i];
> > +	if (i < 0)
> > +		return;
> 
> Thanks for the patch Dan. mf->width needs to be aligned by this try_format
> function so we shouldn't return here. Also it needs to be ensured mf->code 
> is set to one of the supported values when this function returns. Sorry,
> the current code really doesn't give a clue what was intended.
> 
> There is already queued a patch from Arnd [1] addressing the issues you 
> have found.
>  
> >   	if (pad == CAMIF_SD_PAD_SINK) {
> >   		v4l_bound_align_image(&mf->width, 8, CAMIF_MAX_PIX_WIDTH,
> > 
> 
> [1] https://patchwork.linuxtv.org/patch/46508
> 

Hey Arnd,

I happened to be looking at the same bugs but using Smatch.  Did you get
these two bugs as well?

drivers/scsi/sym53c8xx_2/sym_hipd.c:549 sym_getsync() error: iterator underflow 'div_10M' (-1)-255
drivers/media/i2c/sr030pc30.c:522 try_fmt() error: iterator underflow 'sr030pc30_formats' (-1)-4

regards,
dan carpenter
