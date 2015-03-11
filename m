Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39320 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703AbbCKS3o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2015 14:29:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] v4l: mt9p031: Convert to the gpiod API
Date: Wed, 11 Mar 2015 20:29:47 +0200
Message-ID: <3867034.1AdnyGUIFs@avalon>
In-Reply-To: <CA+V-a8uvEfiTAsL826udM8r0aFT3ZYXkMoT1UXgCOeq=pTbw0Q@mail.gmail.com>
References: <1425822043-18733-1-git-send-email-laurent.pinchart@ideasonboard.com> <CA+V-a8uvEfiTAsL826udM8r0aFT3ZYXkMoT1UXgCOeq=pTbw0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prabhakar,

On Tuesday 10 March 2015 18:29:22 Lad, Prabhakar wrote:
> On Sun, Mar 8, 2015 at 1:40 PM, Laurent Pinchart wrote:
> > This simplifies platform data and DT integration.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> > 
> >  drivers/media/i2c/mt9p031.c | 31 +++++++++++--------------------
> >  include/media/mt9p031.h     |  2 --
> >  2 files changed, 11 insertions(+), 22 deletions(-)
> > 
> > diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
> > index 89ae2b4..1757ef6 100644
> > --- a/drivers/media/i2c/mt9p031.c
> > +++ b/drivers/media/i2c/mt9p031.c

[snip]

> > @@ -332,8 +331,8 @@ static int mt9p031_power_on(struct mt9p031 *mt9p031)
> >         }
> >         
> >         /* Now RESET_BAR must be high */
> > -       if (gpio_is_valid(mt9p031->reset)) {
> > -               gpio_set_value(mt9p031->reset, 1);
> > +       if (mt9p031->reset) {
> > +               gpiod_set_value(mt9p031->reset, 0);
> >                 usleep_range(1000, 2000);
> >         }
> 
> As per the data sheet reset needs to be low initially and then high,
> you just reversed it.

The gpiod_ API will take the GPIO active-low flag into account, so the above 
gpiod_set_value(0) call will set the GPIO level to 1.

-- 
Regards,

Laurent Pinchart

