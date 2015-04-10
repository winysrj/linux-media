Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51004 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751560AbbDJWKY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Apr 2015 18:10:24 -0400
Date: Sat, 11 Apr 2015 01:10:18 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	laurent pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v4 4/4] smiapp: Use v4l2_of_alloc_parse_endpoint()
Message-ID: <20150410221017.GJ20756@valkosipuli.retiisi.org.uk>
References: <1428614706-8367-1-git-send-email-sakari.ailus@iki.fi>
 <1428614706-8367-5-git-send-email-sakari.ailus@iki.fi>
 <CA+V-a8uUTTzwP=hOiPAacT33K0cXDoy_gGNB5JAHSsY_LeHL_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+V-a8uUTTzwP=hOiPAacT33K0cXDoy_gGNB5JAHSsY_LeHL_Q@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prabhakar,

Thank you for the review.

On Fri, Apr 10, 2015 at 10:54:08PM +0100, Lad, Prabhakar wrote:
> Hi Sakari,
> 
> Thanks for the patch.
> 
> On Thu, Apr 9, 2015 at 10:25 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> > Instead of parsing the link-frequencies property in the driver, let
> > v4l2_of_alloc_parse_endpoint() do it.
> >
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> >  drivers/media/i2c/smiapp/smiapp-core.c |   40 ++++++++++++++++----------------
> >  1 file changed, 20 insertions(+), 20 deletions(-)
> >
> > diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
> > index 557f25d..4a2e8d3 100644
> > --- a/drivers/media/i2c/smiapp/smiapp-core.c
> > +++ b/drivers/media/i2c/smiapp/smiapp-core.c
> > @@ -2975,9 +2975,9 @@ static int smiapp_resume(struct device *dev)
> >  static struct smiapp_platform_data *smiapp_get_pdata(struct device *dev)
> >  {
> >         struct smiapp_platform_data *pdata;
> > -       struct v4l2_of_endpoint bus_cfg;
> > +       struct v4l2_of_endpoint *bus_cfg;
> >         struct device_node *ep;
> > -       uint32_t asize;
> > +       int i;
> >         int rval;
> >
> >         if (!dev->of_node)
> > @@ -2987,13 +2987,17 @@ static struct smiapp_platform_data *smiapp_get_pdata(struct device *dev)
> >         if (!ep)
> >                 return NULL;
> >
> > +       bus_cfg = v4l2_of_alloc_parse_endpoint(ep);
> > +       if (IS_ERR(bus_cfg)) {
> > +               rval = PTR_ERR(bus_cfg);
> 
> this assignment  is not required.
> 
> Apart from that the patch looks good.
> 
> Reviewed-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Good point. I'll remove it.

There's another case of the same in the function, I'll send a separate patch
on that. I'll send a pull request on these soonish.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
