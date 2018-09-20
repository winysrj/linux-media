Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf1-f65.google.com ([209.85.167.65]:40147 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726781AbeIUCL1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Sep 2018 22:11:27 -0400
MIME-Version: 1.0
References: <20180920161912.17063-1-ricardo.ribalda@gmail.com>
 <20180920161912.17063-3-ricardo.ribalda@gmail.com> <1939782.bRt5jKDIiS@avalon>
 <2983018.WjSXnZMEY4@avalon>
In-Reply-To: <2983018.WjSXnZMEY4@avalon>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Thu, 20 Sep 2018 22:25:54 +0200
Message-ID: <CAPybu_2Ke7qAx=3LRX6aEbGSD56Z+RhWKX=gEXR6WCgyOegxEw@mail.gmail.com>
Subject: Re: [PATCH 3/4] [media] ad5820: DT new optional field enable-gpios
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Pavel Machek <pavel@ucw.cz>, Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi
On Thu, Sep 20, 2018 at 10:23 PM Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>
> On Thursday, 20 September 2018 23:21:28 EEST Laurent Pinchart wrote:
> > Hi Ricardo,
> >
> > Thank you for the patch.
> >
> > On Thursday, 20 September 2018 19:19:11 EEST Ricardo Ribalda Delgado wrote:
> > > Document new enable-gpio field. It can be used to disable the part
> > > without turning down its regulator.
> > >
> > > Cc: devicetree@vger.kernel.org
> > > Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> > > ---
> > >
> > >  Documentation/devicetree/bindings/media/i2c/ad5820.txt | 6 ++++++
> > >  1 file changed, 6 insertions(+)
> > >
> > > diff --git a/Documentation/devicetree/bindings/media/i2c/ad5820.txt
> > > b/Documentation/devicetree/bindings/media/i2c/ad5820.txt index
> > > 5940ca11c021..07d577bb37f7 100644
> > > --- a/Documentation/devicetree/bindings/media/i2c/ad5820.txt
> > > +++ b/Documentation/devicetree/bindings/media/i2c/ad5820.txt
> > >
> > > @@ -8,6 +8,11 @@ Required Properties:
> > >    - VANA-supply: supply of voltage for VANA pin
> > >
> > > +Optional properties:
> > > +
> > > +   - enable-gpios : GPIO spec for the XSHUTDOWN pin.
> >
> > xshutdown is active-low, so enable is active-high. Should this be documented
> > explicitly, to avoid polarity errors ? Maybe something along the lines of
> >
> > - enable-gpios: GPIO spec for the XSHUTDOWN pin. Note that the polarity of
> > the enable GPIO is the opposite of the XSHUTDOWN pin (asserting the enable
> > GPIO deasserts the XSHUTDOWN signal and vice versa).

Agreed

>
> Or alternatively you could name the property xshutdown-gpios, as explained in
> my (incorrect) review of 2/4.

I have double negatives :). If there is no other option I will rename
it xshutdown, but I want to give it a try to enable.

>
> > > If specified, it will be
> > > +     asserted when VANA-supply is enabled.
> >
> > That documents a driver behaviour, is it needed in DT ?
> >
> > >  Example:
> > >         ad5820: coil@c {
> > >
> > > @@ -15,5 +20,6 @@ Example:
> > >                 reg = <0x0c>;
> > >                 VANA-supply = <&vaux4>;
> > >
> > > +               enable-gpios = <&msmgpio 26 GPIO_ACTIVE_HIGH>;
> > >         };
>
>
> --
> Regards,
>
> Laurent Pinchart
>
>
>


-- 
Ricardo Ribalda
