Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:52501 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753442AbdCTKfO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 06:35:14 -0400
Message-ID: <1490006112.2917.36.camel@pengutronix.de>
Subject: Re: [PATCH v2 03/14] [media] coda: simplify optional reset handling
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org
Date: Mon, 20 Mar 2017 11:35:12 +0100
In-Reply-To: <263faf25-5aac-d68f-362e-0d5df25c6be6@xs4all.nl>
References: <20170315113135.14519-1-p.zabel@pengutronix.de>
         <263faf25-5aac-d68f-362e-0d5df25c6be6@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2017-03-20 at 11:22 +0100, Hans Verkuil wrote:
> Hi Philipp,
> 
> I'm a bit confused: I only see patches 3, 4 and 5 of 14 and no cover letter,
> and I don't think I ever saw a v1 of this patch series on linux-media.
> I assume this is a patch series covering multiple subsystems?
> 
> This patch looks good and I'm happy to take it for 4.12, I just want to make
> sure I didn't miss anything.

Sorry for the confusion, next time I'll do something like this, there'll
be a proper cover letter sent to all mailing lists. These patches are
all completely independent from each other, and unchanged from v1. I've
resent the series (possibly adding a few mailing lists where I
previously forgot) now that commit bb475230b8e5 is in mainline.

regards
Philipp

> Regards,
> 
> 	Hans
> 
> On 03/15/2017 12:31 PM, Philipp Zabel wrote:
> > As of commit bb475230b8e5 ("reset: make optional functions really
> > optional"), the reset framework API calls use NULL pointers to
> > describe optional, non-present reset controls.
> > 
> > This allows to return errors from devm_reset_control_get_optional
> > without special cases and to call reset_control_reset unconditionally.
> > 
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> >  drivers/media/platform/coda/coda-common.c | 12 +++---------
> >  1 file changed, 3 insertions(+), 9 deletions(-)
> > 
> > diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
> > index eb6548f46cbac..0cf667ab44bfb 100644
> > --- a/drivers/media/platform/coda/coda-common.c
> > +++ b/drivers/media/platform/coda/coda-common.c
> > @@ -1982,8 +1982,7 @@ static int coda_hw_init(struct coda_dev *dev)
> >  	if (ret)
> >  		goto err_clk_ahb;
> >  
> > -	if (dev->rstc)
> > -		reset_control_reset(dev->rstc);
> > +	reset_control_reset(dev->rstc);
> >  
> >  	/*
> >  	 * Copy the first CODA_ISRAM_SIZE in the internal SRAM.
> > @@ -2362,13 +2361,8 @@ static int coda_probe(struct platform_device *pdev)
> >  	dev->rstc = devm_reset_control_get_optional(&pdev->dev, NULL);
> >  	if (IS_ERR(dev->rstc)) {
> >  		ret = PTR_ERR(dev->rstc);
> > -		if (ret == -ENOENT || ret == -ENOTSUPP) {
> > -			dev->rstc = NULL;
> > -		} else {
> > -			dev_err(&pdev->dev, "failed get reset control: %d\n",
> > -				ret);
> > -			return ret;
> > -		}
> > +		dev_err(&pdev->dev, "failed get reset control: %d\n", ret);
> > +		return ret;
> >  	}
> >  
> >  	/* Get IRAM pool from device tree or platform data */
> > 
> 
> 
