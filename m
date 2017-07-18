Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:34765 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751399AbdGRNZx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 09:25:53 -0400
Message-ID: <1500384351.9510.3.camel@pengutronix.de>
Subject: Re: [PATCH] [media] platform: video-mux: convert to multiplexer
 framework
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, kernel@pengutronix.de
Date: Tue, 18 Jul 2017 15:25:51 +0200
In-Reply-To: <39517db4-d249-4073-e6cb-b0204474da87@xs4all.nl>
References: <20170717105514.18426-1-p.zabel@pengutronix.de>
         <39517db4-d249-4073-e6cb-b0204474da87@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2017-07-18 at 12:03 +0200, Hans Verkuil wrote:
> On 17/07/17 12:55, Philipp Zabel wrote:
> > Now that the multiplexer framework is merged, drop the temporary
> > mmio-mux implementation from the video-mux driver and convert it to use
> > the multiplexer API.
> > 
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> >  drivers/media/platform/video-mux.c | 53 +++++---------------------------------
> >  1 file changed, 7 insertions(+), 46 deletions(-)
> > 
> > diff --git a/drivers/media/platform/video-mux.c b/drivers/media/platform/video-mux.c
> > index 665744716f73b..ee89ad76bee23 100644
> > --- a/drivers/media/platform/video-mux.c
> > +++ b/drivers/media/platform/video-mux.c
> > @@ -17,8 +17,7 @@
> >  #include <linux/err.h>
> >  #include <linux/module.h>
> >  #include <linux/mutex.h>
> > -#include <linux/regmap.h>
> > -#include <linux/mfd/syscon.h>
> > +#include <linux/mux/consumer.h>
> 
> Shouldn't Kconfig be modified as well to select the multiplexer? Am I missing something?

The mux framework has stubs, so this compiles fine without MULTIPLEXER
enabled.
On the other hand this driver is pretty useless without the multiplexer
framework, and the i2c and iio muxes select it as well.

I'll change it and send a v2.

regards
Philipp
