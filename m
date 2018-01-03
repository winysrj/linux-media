Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:42483 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750831AbeACRNz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 3 Jan 2018 12:13:55 -0500
Date: Wed, 3 Jan 2018 18:13:47 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Fabio Estevam <festevam@gmail.com>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Magnus Damm <magnus.damm@gmail.com>, geert@glider.be,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-renesas-soc@vger.kernel.org,
        linux-media <linux-media@vger.kernel.org>,
        linux-sh@vger.kernel.org,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 9/9] media: i2c: tw9910: Remove soc_camera dependencies
Message-ID: <20180103171347.GF9493@w540>
References: <1514469681-15602-1-git-send-email-jacopo+renesas@jmondi.org>
 <1514469681-15602-10-git-send-email-jacopo+renesas@jmondi.org>
 <CAOMZO5CjrXfzum7JgimGqvnM7kjMyZZdtpEhvYwO-DLnig=uMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAOMZO5CjrXfzum7JgimGqvnM7kjMyZZdtpEhvYwO-DLnig=uMQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Fabio,

On Wed, Jan 03, 2018 at 02:41:20PM -0200, Fabio Estevam wrote:
> Hi Jacopo,
>
> On Thu, Dec 28, 2017 at 12:01 PM, Jacopo Mondi
> <jacopo+renesas@jmondi.org> wrote:
>
> > +       if (priv->rstb_gpio) {
> > +               gpiod_set_value(priv->rstb_gpio, 0);
> > +               usleep_range(500, 1000);
> > +               gpiod_set_value(priv->rstb_gpio, 1);
> > +               usleep_range(500, 1000);
>
> This seems to be inverted.
>
> Consider you have an active low GPIO reset.
>
> In order to reset it:
>
> Put the GPIO to logic level 0
> Wait some time
> Put the GPIO to logic level 1
>
> gpiod_set_value(priv->rstb_gpio, 1), means the GPIO in the active
> state (0 in this example).
>
> , so this should be:
>
> gpiod_set_value(priv->rstb_gpio, 1);
> usleep_range(500, 1000);
> gpiod_set_value(priv->rstb_gpio, 0);

That would be true if I would have declared the GPIO to be ACTIVE_LOW.
See patch [5/9] in this series and search for "rstb". The GPIO (which
is shared between two devices) is said to be active high...

Are you maybe suggesting I should declare it ACTIVE_LOW in board setup
code and invert the set_value() order in the driver as you proposed?
Don't you think it would be more natural for the driver to follow the
current sequence, as the reset GPIO is effectively active low (so
setting it to 0 put the video decoder in reset state and setting it to
1 wakes the video decoder up)?

I can maybe agree with you for the PDN GPIO instead. That's said to be
active high, so setting it to 1 disables the video decoder, and yes,
it feels unnatural in the driver's power up routines to set PDN GPIO
to 0 and set it to 1 when putting the device to sleep...

Thanks
   j
