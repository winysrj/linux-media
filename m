Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:44996 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759635AbeD1NbS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 28 Apr 2018 09:31:18 -0400
Received: by mail-lf0-f66.google.com with SMTP id h197-v6so6505133lfg.11
        for <linux-media@vger.kernel.org>; Sat, 28 Apr 2018 06:31:17 -0700 (PDT)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Sat, 28 Apr 2018 15:31:14 +0200
To: jacopo mondi <jacopo@jmondi.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v14 2/2] rcar-csi2: add Renesas R-Car MIPI CSI-2 receiver
 driver
Message-ID: <20180428133114.GE14242@bigcity.dyn.berto.se>
References: <20180426202121.27243-1-niklas.soderlund+renesas@ragnatech.se>
 <20180426202121.27243-3-niklas.soderlund+renesas@ragnatech.se>
 <20180428112827.GF18201@w540>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180428112827.GF18201@w540>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thanks for your feedback.

On 2018-04-28 13:28:27 +0200, Jacopo Mondi wrote:
> Hi Niklas,
>    apart from a small comment, as my comments on v13 have been
>    clarified
> 
> Reviewed-by: Jacopo Mondi <jacopo@jmondi.org>

Thanks!

[snip]

> > diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c 
> > b/drivers/media/platform/rcar-vin/rcar-csi2.c
> > new file mode 100644
> > index 0000000000000000..49b29d5680f9d80b
> > --- /dev/null
> > +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
> > @@ -0,0 +1,883 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Driver for Renesas R-Car MIPI CSI-2 Receiver
> > + *
> > + * Copyright (C) 2018 Renesas Electronics Corp.
> > + */

[snip]

> > +MODULE_AUTHOR("Niklas Söderlund <niklas.soderlund@ragnatech.se>");
> > +MODULE_DESCRIPTION("Renesas R-Car MIPI CSI-2 receiver");
> > +MODULE_LICENSE("GPL");
> 
> This doesn't match the SPDX header that reports GPL-2.0

I'm now officially more confused then normal :-) I really tried to get 
this right and the combination I use here

    // SPDX-License-Identifier: GPL-2.0
    MODULE_LICENSE("GPL");

Seems to be used all over the kernel, did some digging on the master 
branch of the media tree from a few days ago and found 265 files with 
this combination using this script:

    count=0
    for f in $(git grep -l "SPDX-License-Identifier: GPL-2.0$"); do
	    if grep -q 'MODULE_LICENSE("GPL")' $f; then
                echo $f
                grep SPDX-License-Identifier $f
                grep MODULE_LICENSE $f;
                count=$(($count + 1))
	    fi
    done
    echo "Count: $count"

I'm happy to post a new version of this series to make this right but 
I'm afraid that I at this point know what right is. My intention is to 
replace a licence text found in an old Renesas BSP which this work is 
loosely based on:

    * This program is free software; you can redistribute it and/or modify
    * it under the terms of the GNU General Public License version 2 as
    * published by the Free Software Foundation.

So it's quiet clear it's GPL-2.0 and not GPL-2.0+ and AFIK what I have done 
here is correct, please tell me why I'm wrong and how I can correct it :-)

-- 
Regards,
Niklas Söderlund
