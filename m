Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40292 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751173AbdKQAgz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Nov 2017 19:36:55 -0500
Date: Fri, 17 Nov 2017 02:36:51 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: jacopo mondi <jacopo@jmondi.org>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com, magnus.damm@gmail.com,
        geert@glider.be, mchehab@kernel.org, hverkuil@xs4all.nl,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 03/10] v4l: platform: Add Renesas CEU driver
Message-ID: <20171117003651.e7oj362eqivyukcu@valkosipuli.retiisi.org.uk>
References: <1510743363-25798-1-git-send-email-jacopo+renesas@jmondi.org>
 <1510743363-25798-4-git-send-email-jacopo+renesas@jmondi.org>
 <20171115124551.xrmrd34l4u4qgcms@valkosipuli.retiisi.org.uk>
 <20171115142511.GJ19070@w540>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171115142511.GJ19070@w540>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On Wed, Nov 15, 2017 at 03:25:11PM +0100, jacopo mondi wrote:
> Hi Sakari,
>    thanks for review!

You're welcome!

> On Wed, Nov 15, 2017 at 02:45:51PM +0200, Sakari Ailus wrote:
> > Hi Jacopo,
> >
> > Could you remove the original driver and send the patch using git
> > send-email -C ? That way a single patch would address converting it to a
> > proper V4L2 driver as well as move it to the correct location. The changes
> > would be easier to review that way since then, well, it'd be easier to see
> > the changes. :-)
> 
> Actually I prefer not to remove the existing driver at the moment. See
> the cover letter for reasons why not to do so right now...

So it's about testing mostly? Does someone (possibly you) have those boards
to test? I'd like to see this patchset to remove that last remaining SoC
camera bridge driver. :-)

> 
> Also, there's not that much code from the old driver in here, surely
> less than the default 50% -C and -M options of 'git format-patch' use
> as a threshold for detecting copies iirc..

Oh, if that's so, then makes sense to review it as a new driver.

> 
> I would prefer this to be reviewed as new driver, I know it's a bit
> more painful, but irq handler and a couple of other routines apart,
> there's not that much code shared between the two...
> 
> >
> > The same goes for the two V4L2 SoC camera sensor / video decoder drivers at
> > the end of the set.
> >
> 
> Also in this case I prefer not to remove existing code, as long as
> there are platforms using it..

Couldn't they use this driver instead?

> 
> > On Wed, Nov 15, 2017 at 11:55:56AM +0100, Jacopo Mondi wrote:
> > > Add driver for Renesas Capture Engine Unit (CEU).
> > >
> > > The CEU interface supports capturing 'data' (YUV422) and 'images'
> > > (NV[12|21|16|61]).
> > >
> > > This driver aims to replace the soc_camera based sh_mobile_ceu one.
> > >
> > > Tested with ov7670 camera sensor, providing YUYV_2X8 data on Renesas RZ
> > > platform GR-Peach.
> > >
> > > Tested with ov7725 camera sensor on SH4 platform Migo-R.
> >
> > Nice!
> >
> > >
> > > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > > ---
> > > +#include <linux/completion.h>
> >
> > Do you need this header? There would seem some that I wouldn't expect to be
> > needed below, such as linux/init.h.
> 
> It's probably a leftover, I'll remove it...
> 
> [snip]
> >
> > > +#if IS_ENABLED(CONFIG_OF)
> > > +static const struct of_device_id ceu_of_match[] = {
> > > +	{ .compatible = "renesas,renesas-ceu" },
> >
> > Even if you add support for new hardware, shouldn't you maintain support
> > for renesas,sh-mobile-ceu?
> >
> 
> As you noticed already, the old driver did not support OF, so there
> are no compatibility issues here

Yeah, I realised that only after reviewing this patch.

It'd be Super-cool if someone did the DT conversion. Perhaps Laurent? ;-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
