Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:37600 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751167AbeACJAh (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 3 Jan 2018 04:00:37 -0500
Date: Wed, 3 Jan 2018 10:00:31 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, magnus.damm@gmail.com,
        geert@glider.be, mchehab@kernel.org, hverkuil@xs4all.nl,
        robh+dt@kernel.org, mark.rutland@arm.com,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/9] include: media: Add Renesas CEU driver interface
Message-ID: <20180103090031.GB9493@w540>
References: <1514469681-15602-1-git-send-email-jacopo+renesas@jmondi.org>
 <1514469681-15602-3-git-send-email-jacopo+renesas@jmondi.org>
 <2922415.TB8nfS0gW1@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2922415.TB8nfS0gW1@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Tue, Jan 02, 2018 at 01:50:07PM +0200, Laurent Pinchart wrote:
> Hi Jacopo,
>
> Thank you for the patch.
>
> On Thursday, 28 December 2017 16:01:14 EET Jacopo Mondi wrote:
> > Add renesas-ceu header file.
> >
> > Do not remove the existing sh_mobile_ceu.h one as long as the original
> > driver does not go away.
> >
> > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > ---
> >  include/media/drv-intf/renesas-ceu.h | 20 ++++++++++++++++++++
> >  1 file changed, 20 insertions(+)
> >  create mode 100644 include/media/drv-intf/renesas-ceu.h
> >
> > diff --git a/include/media/drv-intf/renesas-ceu.h
> > b/include/media/drv-intf/renesas-ceu.h new file mode 100644
> > index 0000000..7470c3f
> > --- /dev/null
> > +++ b/include/media/drv-intf/renesas-ceu.h
> > @@ -0,0 +1,20 @@
> > +// SPDX-License-Identifier: GPL-2.0+
>
> Just out of curiosity, any reason you have picked GPL-2.0+ and not GPL-2.0 ?

Good question. I would mention lazyness in copying the SPDX identifier
from somewhere else and overlooking the license version reported
there. I don't have any personal preference on GPLv3 I was trying to
squeeze in :)

I'll switch it back to GPL-2.0 only

>
> You might want to add a copyright header to state copyright ownership
>
> /**
>  * renesas-ceu.h - Renesas CEU driver interface
>  *
>  * Copyright 2017-2018 Jacopo Mondi <jacopo@jmondi.org>
>  */
>
> That's up to you.
>
> > +#ifndef __ASM_RENESAS_CEU_H__
>
> Maybe __MEDIA_DRV_INTF_RENESAS_CEU_H__ ?
>
> > +#define __ASM_RENESAS_CEU_H__
> > +
> > +#define CEU_MAX_SUBDEVS		2
> > +
> > +struct ceu_async_subdev {
> > +	unsigned long flags;
> > +	unsigned char bus_width;
> > +	unsigned char bus_shift;
> > +	unsigned int i2c_adapter_id;
> > +	unsigned int i2c_address;
> > +};
> > +
> > +struct ceu_info {
>
> This is really platform data, how about calling it ceu_platform_data ?
>
> > +	unsigned int num_subdevs;
> > +	struct ceu_async_subdev subdevs[CEU_MAX_SUBDEVS];
> > +};
> > +
> > +#endif /* __ASM_RENESAS_CEU_H__ */
>
> Don't forget to update the comment here too.
>
> Apart from that,
>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Thanks
   j
>
> --
> Regards,
>
> Laurent Pinchart
>
