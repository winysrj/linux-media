Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf1-f66.google.com ([209.85.167.66]:39258 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726128AbeIUCR6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Sep 2018 22:17:58 -0400
MIME-Version: 1.0
References: <20180920161912.17063-2-ricardo.ribalda@gmail.com>
 <20180920184552.4919-1-ricardo.ribalda@gmail.com> <20180920185405.GA26589@amd>
 <CAPybu_2hjrq=r+kpAHKxX59gOXfbqGf9CUPh9CNqv7WGqJsrQQ@mail.gmail.com>
 <20180920190855.GC26589@amd> <CAPybu_2mNE7Jmfm2n60Z9Hk_iO+-zLgtu4xn72pJUSXBitVg=g@mail.gmail.com>
 <20180920201420.GA28766@amd> <20180920202122.GA30748@amd>
In-Reply-To: <20180920202122.GA30748@amd>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Thu, 20 Sep 2018 22:32:23 +0200
Message-ID: <CAPybu_1w+VWkOZDKSyEBHvcdGAF1wzoFDunUgDLTn7tqP8Dhbw@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] [media] ad5820: Add support for enable pin
To: Pavel Machek <pavel@ucw.cz>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi
On Thu, Sep 20, 2018 at 10:21 PM Pavel Machek <pavel@ucw.cz> wrote:
>
> Hi!
>
> > > > > ad5820: dac@0c {
> > > > >    compatible = "adi,ad5820";
> > > > >    reg = <0x0c>;
> > > > >
> > > > >    VANA-supply = <&pm8994_l23>;
> > > > >    enable-gpios = <&msmgpio 26 GPIO_ACTIVE_HIGH>;
> > > > > };
> > > >
> > > > Well, I'm sure you could have gpio-based regulator powered from
> > > > pm8994_l23, and outputting to ad5820.
> > > >
> > > > Does ad5820 chip have a gpio input for enable?
> > >
> > > xshutdown pin:
> > > http://www.analog.com/media/en/technical-documentation/data-sheets/AD5821.pdf
> > >
> > > (AD5820,AD5821, and AD5823 are compatibles, or at least that is waht
> > > the module manufacturer says :)
> >
> > Aha, sorry for the noise.
> >
> > 2,3: Acked-by: Pavel Machek <pavel@ucw.cz>
>
> And I forgot to mention. If ad5821 and ad5823 are compatible, it would
> be good to mention it somewhere where it is easy to find... That can
> save quite a bit of work to someone.
>

For the ad5821 I have the datasheet and I would not mind adding it
For the ad5823 I have no datasheet, just a schematic from a camera
module saying: you can replace ad5823 with ad5821.

I think I will add this as an extra patch

> Thanks,
>                                                                 Pavel
>
>
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html



-- 
Ricardo Ribalda
