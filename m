Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57499 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751628AbdLKPEs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Dec 2017 10:04:48 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: jacopo mondi <jacopo@jmondi.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        magnus.damm@gmail.com, geert@glider.be, mchehab@kernel.org,
        hverkuil@xs4all.nl, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 03/10] v4l: platform: Add Renesas CEU driver
Date: Mon, 11 Dec 2017 17:04:48 +0200
Message-ID: <2367605.Ri8CEFtk7H@avalon>
In-Reply-To: <20171117003651.e7oj362eqivyukcu@valkosipuli.retiisi.org.uk>
References: <1510743363-25798-1-git-send-email-jacopo+renesas@jmondi.org> <20171115142511.GJ19070@w540> <20171117003651.e7oj362eqivyukcu@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Friday, 17 November 2017 02:36:51 EET Sakari Ailus wrote:
> On Wed, Nov 15, 2017 at 03:25:11PM +0100, jacopo mondi wrote:
> > On Wed, Nov 15, 2017 at 02:45:51PM +0200, Sakari Ailus wrote:
> >> Hi Jacopo,
> >> 
> >> Could you remove the original driver and send the patch using git
> >> send-email -C ? That way a single patch would address converting it to a
> >> proper V4L2 driver as well as move it to the correct location. The
> >> changes would be easier to review that way since then, well, it'd be
> >> easier to see the changes. :-)
> > 
> > Actually I prefer not to remove the existing driver at the moment. See
> > the cover letter for reasons why not to do so right now...
> 
> So it's about testing mostly? Does someone (possibly you) have those boards
> to test? I'd like to see this patchset to remove that last remaining SoC
> camera bridge driver. :-)

Unfortunately there's also drivers/media/platform/pxa-camera.c :-(

> > Also, there's not that much code from the old driver in here, surely
> > less than the default 50% -C and -M options of 'git format-patch' use
> > as a threshold for detecting copies iirc..
> 
> Oh, if that's so, then makes sense to review it as a new driver.

Yes, unfortunately the drivers are too different. Jacopo started developing an 
incremental patch series to move the driver away from soc-camera, but in the 
end we decided to stop following that path as it was too painful. It's easier 
to review a new driver in this case.

> > I would prefer this to be reviewed as new driver, I know it's a bit
> > more painful, but irq handler and a couple of other routines apart,
> > there's not that much code shared between the two...
> > 
> >> The same goes for the two V4L2 SoC camera sensor / video decoder drivers
> >> at the end of the set.
> > 
> > Also in this case I prefer not to remove existing code, as long as
> > there are platforms using it..
> 
> Couldn't they use this driver instead?
> 
> >> On Wed, Nov 15, 2017 at 11:55:56AM +0100, Jacopo Mondi wrote:
> >>> Add driver for Renesas Capture Engine Unit (CEU).
> >>> 
> >>> The CEU interface supports capturing 'data' (YUV422) and 'images'
> >>> (NV[12|21|16|61]).
> >>> 
> >>> This driver aims to replace the soc_camera based sh_mobile_ceu one.
> >>> 
> >>> Tested with ov7670 camera sensor, providing YUYV_2X8 data on Renesas
> >>> RZ platform GR-Peach.
> >>> 
> >>> Tested with ov7725 camera sensor on SH4 platform Migo-R.
> >> 
> >> Nice!
> >> 
> >>> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> >>> ---
> >>> +#include <linux/completion.h>
> >> 
> >> Do you need this header? There would seem some that I wouldn't expect to
> >> be needed below, such as linux/init.h.
> > 
> > It's probably a leftover, I'll remove it...
> > 
> > [snip]
> > 
> >>> +#if IS_ENABLED(CONFIG_OF)
> >>> +static const struct of_device_id ceu_of_match[] = {
> >>> +	{ .compatible = "renesas,renesas-ceu" },
> >> 
> >> Even if you add support for new hardware, shouldn't you maintain support
> >> for renesas,sh-mobile-ceu?
> > 
> > As you noticed already, the old driver did not support OF, so there
> > are no compatibility issues here
> 
> Yeah, I realised that only after reviewing this patch.
> 
> It'd be Super-cool if someone did the DT conversion. Perhaps Laurent? ;-)

Or you ? :-)

-- 
Regards,

Laurent Pinchart
