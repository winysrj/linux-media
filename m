Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:42363 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752642AbdCHMVm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 8 Mar 2017 07:21:42 -0500
Message-ID: <1488975663.2467.21.camel@pengutronix.de>
Subject: Re: [PATCH] [media] coda: restore original firmware locations
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        linux-media@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        Baruch Siach <baruch@tkos.co.il>
Date: Wed, 08 Mar 2017 13:21:03 +0100
In-Reply-To: <39366381-61a4-ec56-e94d-e60173d3b5f9@xs4all.nl>
References: <20170301153625.16249-1-p.zabel@pengutronix.de>
         <39366381-61a4-ec56-e94d-e60173d3b5f9@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2017-03-08 at 11:38 +0100, Hans Verkuil wrote:
> On 01/03/17 16:36, Philipp Zabel wrote:
> > Recently, an unfinished patch was merged that added a third entry to the
> > beginning of the array of firmware locations without changing the code
> > to also look at the third element, thus pushing an old firmware location
> > off the list.
> >
> > Fixes: 8af7779f3cbc ("[media] coda: add Freescale firmware compatibility location")
> > Cc: Baruch Siach <baruch@tkos.co.il>
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> >  drivers/media/platform/coda/coda-common.c | 17 ++++++++++-------
> >  1 file changed, 10 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
> > index eb6548f46cbac..e1a2e8c70db01 100644
> > --- a/drivers/media/platform/coda/coda-common.c
> > +++ b/drivers/media/platform/coda/coda-common.c
> > @@ -2128,6 +2128,9 @@ static int coda_firmware_request(struct coda_dev *dev)
> >  {
> >  	char *fw = dev->devtype->firmware[dev->firmware];
> >
> > +	if (dev->firmware >= ARRAY_SIZE(dev->devtype->firmware))
> > +		return -EINVAL;
> > +
> 
> Move the fw assignment after this 'if'. Otherwise it's reading from undefined memory
> if dev->firmware >= ARRAY_SIZE(dev->devtype->firmware).
> 
> Regards,
> 
> 	Hans

Will do, thanks for the review.

regards
Philipp
