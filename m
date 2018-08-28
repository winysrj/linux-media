Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.macqel.be ([109.135.2.61]:49861 "EHLO smtp2.macqel.be"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726806AbeH1MCE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Aug 2018 08:02:04 -0400
Date: Tue, 28 Aug 2018 10:11:32 +0200
From: Philippe De Muyter <phdm@macq.eu>
To: Luca Ceresoli <luca@lucaceresoli.net>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
        Leon Luo <leonl@leopardimaging.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-kernel@vger.kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH 3/7] media: imx274: don't hard-code the subdev name to
        DRIVER_NAME
Message-ID: <20180828081132.GA17946@frolo.macqel>
References: <20180824163525.12694-1-luca@lucaceresoli.net> <20180824163525.12694-4-luca@lucaceresoli.net> <20180825144915.tq7m5jlikwndndzq@valkosipuli.retiisi.org.uk> <799f4d1a-b91d-0404-7ef0-965d123319da@lucaceresoli.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <799f4d1a-b91d-0404-7ef0-965d123319da@lucaceresoli.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari and Luca,
On Sun, Aug 26, 2018 at 10:41:13PM +0200, Luca Ceresoli wrote:
> Hi Sakari,
> 
> On 25/08/2018 16:49, Sakari Ailus wrote:
> > Hi Luca,
> > 
> > On Fri, Aug 24, 2018 at 06:35:21PM +0200, Luca Ceresoli wrote:
> >> Forcibly setting the subdev name to DRIVER_NAME (i.e. "IMX274") makes
> >> it non-unique and less informative.
> >>
> >> Let the driver use the default name from i2c, e.g. "IMX274 2-001a".
> >>
...
> > 
> > This ends up changing the entity as well as the sub-device name which may
> > well break applications.
> 
> Right, unfortunately.
> 
> > On the other hand, you currently can't have more
> > than one of these devices on a media device complex due to the name being
> > specific to a driver, not the device.
> >
> > An option avoiding that would be to let the user choose by e.g. through a
> > Kconfig option would avoid having to address that, but I really hate adding
> > such options.
> 
> I agree adding a Kconfig option just for this would be very annoying.
> However I think the issue affects a few other drivers (sr030pc30.c and
> s5c73m3-core.c apparently), thus maybe one option could serve them all.
> 
> > I wonder what others think. If anyone ever needs to add another on a board
> > so that it ends up being the part of the same media device complex
> > (likely), then changing the name now rather than later would be the least
> > pain. In this case I'd be leaning (slightly) towards accepting the patch
> > and hoping there wouldn't be any fallout... I don't see any board (DT)
> > containing imx274, at least not in the upstream kernel.
> 
> I'll be OK with either decision. Should we keep it as is, then I think a
> comment before that line would be appropriate to clarify it's not
> correct but it is kept for backward userspace compatibility. This would
> help avoid new driver writers doing the same mistake, and prevent other
> people to send another patch like mine.

Would it be acceptable to accept Luca's patch but add a dev_info message
indicating the old and the new name, so that at least if the user notices
a problem he'll find an informative message helping him to fix his config ?
This dev_info message could even be standardized to be usable for other
drivers with only the names changed.

Philippe
-- 
Philippe De Muyter +32 2 6101532 Macq SA rue de l'Aeronef 2 B-1140 Bruxelles
