Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52182 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727099AbeH2PDp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Aug 2018 11:03:45 -0400
Date: Wed, 29 Aug 2018 14:07:21 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Philippe De Muyter <phdm@macq.eu>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Luca Ceresoli <luca@lucaceresoli.net>,
        linux-media@vger.kernel.org, Leon Luo <leonl@leopardimaging.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-kernel@vger.kernel.org, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH 3/7] media: imx274: don't hard-code the subdev name to
 DRIVER_NAME
Message-ID: <20180829110721.zlpqfmusaw4nh7et@valkosipuli.retiisi.org.uk>
References: <20180824163525.12694-1-luca@lucaceresoli.net>
 <20180824163525.12694-4-luca@lucaceresoli.net>
 <20180825144915.tq7m5jlikwndndzq@valkosipuli.retiisi.org.uk>
 <799f4d1a-b91d-0404-7ef0-965d123319da@lucaceresoli.net>
 <113d3e05-9331-bd54-0e49-46c5e132339f@xs4all.nl>
 <20180828160255.GA9763@frolo.macqel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180828160255.GA9763@frolo.macqel>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philippe,

On Tue, Aug 28, 2018 at 06:02:55PM +0200, Philippe De Muyter wrote:
> Hi Hans, Sakari and Luca
> 
> On Tue, Aug 28, 2018 at 11:22:28AM +0200, Hans Verkuil wrote:
> > On 26/08/18 22:41, Luca Ceresoli wrote:
> > > Hi Sakari,
> > > 
> > > On 25/08/2018 16:49, Sakari Ailus wrote:
> > >> Hi Luca,
> > >>
> > >> On Fri, Aug 24, 2018 at 06:35:21PM +0200, Luca Ceresoli wrote:
> > >>> Forcibly setting the subdev name to DRIVER_NAME (i.e. "IMX274") makes
> > >>> it non-unique and less informative.
> > >>>
> > >>> Let the driver use the default name from i2c, e.g. "IMX274 2-001a".
> > >>>
> > >>> Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
> > >>> ---
> > >>>  drivers/media/i2c/imx274.c | 1 -
> > >>>  1 file changed, 1 deletion(-)
> > >>>
> > >>> diff --git a/drivers/media/i2c/imx274.c b/drivers/media/i2c/imx274.c
> > >>> index 9b524de08470..570706695ca7 100644
> > >>> --- a/drivers/media/i2c/imx274.c
> > >>> +++ b/drivers/media/i2c/imx274.c
> > >>> @@ -1885,7 +1885,6 @@ static int imx274_probe(struct i2c_client *client,
> > >>>  	imx274->client = client;
> > >>>  	sd = &imx274->sd;
> > >>>  	v4l2_i2c_subdev_init(sd, client, &imx274_subdev_ops);
> > >>> -	strlcpy(sd->name, DRIVER_NAME, sizeof(sd->name));
> > >>>  	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;
> > >>>  
> > >>>  	/* initialize subdev media pad */
> > >>
> > >> This ends up changing the entity as well as the sub-device name which may
> > >> well break applications.
> > > 
> > > Right, unfortunately.
> > > 
> > >> On the other hand, you currently can't have more
> > >> than one of these devices on a media device complex due to the name being
> > >> specific to a driver, not the device.
> > >>
> > >> An option avoiding that would be to let the user choose by e.g. through a
> > >> Kconfig option would avoid having to address that, but I really hate adding
> > >> such options.
> > > 
> > > I agree adding a Kconfig option just for this would be very annoying.
> > > However I think the issue affects a few other drivers (sr030pc30.c and
> > > s5c73m3-core.c apparently), thus maybe one option could serve them all.
> > > 
> > >> I wonder what others think. If anyone ever needs to add another on a board
> > >> so that it ends up being the part of the same media device complex
> > >> (likely), then changing the name now rather than later would be the least
> > >> pain. In this case I'd be leaning (slightly) towards accepting the patch
> > >> and hoping there wouldn't be any fallout... I don't see any board (DT)
> > >> containing imx274, at least not in the upstream kernel.
> > > 
> > > I'll be OK with either decision. Should we keep it as is, then I think a
> > > comment before that line would be appropriate to clarify it's not
> > > correct but it is kept for backward userspace compatibility. This would
> > > help avoid new driver writers doing the same mistake, and prevent other
> > > people to send another patch like mine.
> > 
> > In this end, this is a driver bug. I would just fix this, but add a comment
> > that states the old name and why it was changed. No need for a dev_info
> > IMHO.
> > 
> > It would be nice if you can check if the same mistake is made in other drivers,
> > and update those as well. It's easier if this is all done at the same time.
> > 
> 
> Then we should probably also apply the following patch I submitted :
> 
> "media: v4l2-common: v4l2_spi_subdev_init : generate unique name"
> 	https://patchwork.kernel.org/patch/10553035/
> 
> and perhaps
> 
> "media: v4l2-common: simplify v4l2_i2c_subdev_init name generation"
> 	https://patchwork.kernel.org/patch/10553037/

The problem with this patch is that the existing naming scheme is very
similar while the new one offers no tangible benefits apart from being in
line with the rest of the kernel. That's still not a benefit for uAPI:
changing the name is certain to break user space applications.

I posted another patch on which I'm somewhat uncertain applying it would be
only a good thing:

<URL:https://patchwork.linuxtv.org/patch/51791/>

But it would fix an actual bug.

I maintain that the information (device name as it's seen by the rest of
the system) would be good to have in device properties; Hans posted a
patchset on that some time ago.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
