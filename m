Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57370 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751729AbdLKOcD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Dec 2017 09:32:03 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, magnus.damm@gmail.com,
        geert@glider.be, mchehab@kernel.org, hverkuil@xs4all.nl,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 02/10] include: media: Add Renesas CEU driver interface
Date: Mon, 11 Dec 2017 16:32:04 +0200
Message-ID: <2289038.W10jS6Ac5K@avalon>
In-Reply-To: <1534914.aSna2J79oD@avalon>
References: <1510743363-25798-1-git-send-email-jacopo+renesas@jmondi.org> <20171115123633.zvkokelhwwyro42y@valkosipuli.retiisi.org.uk> <1534914.aSna2J79oD@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On Monday, 11 December 2017 16:26:27 EET Laurent Pinchart wrote:
> On Wednesday, 15 November 2017 14:36:33 EET Sakari Ailus wrote:
> > On Wed, Nov 15, 2017 at 11:55:55AM +0100, Jacopo Mondi wrote:
> >> Add renesas-ceu header file.
> >> 
> >> Do not remove the existing sh_mobile_ceu.h one as long as the original
> >> driver does not go away.
> > 
> > Hmm. This isn't really not about not removing a file but adding a new one.
> > Do you really need it outside the driver's own directory?
> 
> The file defines platform data structures that are needed for arch/sh/.
> 
> >> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> >> ---
> >> 
> >>  include/media/drv-intf/renesas-ceu.h | 23 +++++++++++++++++++++++
> >>  1 file changed, 23 insertions(+)
> >>  create mode 100644 include/media/drv-intf/renesas-ceu.h
> >> 
> >> diff --git a/include/media/drv-intf/renesas-ceu.h
> >> b/include/media/drv-intf/renesas-ceu.h new file mode 100644
> >> index 0000000..f2da78c
> >> --- /dev/null
> >> +++ b/include/media/drv-intf/renesas-ceu.h
> >> @@ -0,0 +1,23 @@
> >> +// SPDX-License-Identifier: GPL-2.0+
> >> +#ifndef __ASM_RENESAS_CEU_H__
> >> +#define __ASM_RENESAS_CEU_H__
> >> +
> >> +#include <media/v4l2-mediabus.h>
> 
> I don't think you need this.
> 
> > > +#define CEU_FLAG_PRIMARY_SENS	BIT(0)

I forgot to mention that this flag should be renamed as well, but couldn't we 
get rid of it completely by mandating that the first subdev in the subdevs 
array should be the primary one ?

> > > +#define CEU_MAX_SENS		2
> 
> I assume SENS stands for sensor. As other sources than sensors can be
> supported (video decoders for instance), I would name this CEU_MAX_SUBDEVS,
> CEU_MAX_INPUTS or something similar.
> 
> >> +
> >> +struct ceu_async_subdev {
> >> +	unsigned long flags;
> >> +	unsigned char bus_width;
> >> +	unsigned char bus_shift;
> >> +	unsigned int i2c_adapter_id;
> >> +	unsigned int i2c_address;
> >> +};
> >> +
> >> +struct ceu_info {
> >> +	unsigned int num_subdevs;
> >> +	struct ceu_async_subdev subdevs[CEU_MAX_SENS];
> >> +};
> >> +
> >> +#endif /* __ASM_RENESAS_CEU_H__ */

-- 
Regards,

Laurent Pinchart
