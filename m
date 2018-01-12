Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:54107 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933478AbeALNjE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Jan 2018 08:39:04 -0500
Date: Fri, 12 Jan 2018 14:38:57 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Philippe Ombredanne <pombredanne@nexb.com>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Magnus Damm <magnus.damm@gmail.com>, geert@glider.be,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Fabio Estevam <festevam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-renesas-soc@vger.kernel.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-sh@vger.kernel.org,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 3/9] v4l: platform: Add Renesas CEU driver
Message-ID: <20180112133857.GE24794@w540>
References: <1515515131-13760-1-git-send-email-jacopo+renesas@jmondi.org>
 <1515515131-13760-4-git-send-email-jacopo+renesas@jmondi.org>
 <CAOFm3uGxm3bAHPryMV8+MAFy+45-3Ld7RbKqo1saigzPUZ8mqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAOFm3uGxm3bAHPryMV8+MAFy+45-3Ld7RbKqo1saigzPUZ8mqg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philippe, Laurent, Geert,

On Fri, Jan 12, 2018 at 11:36:31AM +0100, Philippe Ombredanne wrote:
> On Tue, Jan 9, 2018 at 5:25 PM, Jacopo Mondi <jacopo+renesas@jmondi.org> wrote:
> > Add driver for Renesas Capture Engine Unit (CEU).
>
> <snip>
>
> > --- /dev/null
> > +++ b/drivers/media/platform/renesas-ceu.c
> > @@ -0,0 +1,1648 @@
> > +// SPDX-License-Identifier: GPL-2.0
>
> <snip>
>
> > +MODULE_DESCRIPTION("Renesas CEU camera driver");
> > +MODULE_AUTHOR("Jacopo Mondi <jacopo+renesas@jmondi.org>");
> > +MODULE_LICENSE("GPL");
>
> Jacopo,
> the MODULE_LICENSE does not match the SPDX tag. Per module.h "GPL"
> means GPL-2.0 or later ;)
>
> It should be instead:
>
> > +MODULE_LICENSE("GPL v2");
>
> ... to match your
>
> > +// SPDX-License-Identifier: GPL-2.0

I will update this in next v5.
Laurent, Geert: I'll keep SPDX identifier to "GPL-2.0" until kernel
doc does not get updated.

Thanks
   j

>
> I know this can be confusing, but updating the MODULE_LICENSE tags
> definitions in module.h to match SPDX tags is unlikely to happen as it
> would create mayhem for everyone and every module loader relying on
> this established convention.
>
> --
> Cordially
> Philippe Ombredanne
