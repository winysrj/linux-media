Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729412AbeJAVkJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 Oct 2018 17:40:09 -0400
MIME-Version: 1.0
References: <20180920204751.29117-1-ricardo.ribalda@gmail.com>
 <20180920204751.29117-3-ricardo.ribalda@gmail.com> <20180927182311.GA27227@bogus>
 <CAPybu_0CCco6M6A1JsGUTo2P7rvqN1qPnMmuee7UsXxdkmaNBw@mail.gmail.com>
 <CAL_JsqLM9E45nvSToQV=XDwTmppkYcsPd-Ddzy+AJ8GP==aL+A@mail.gmail.com> <CAPybu_0+F-o03qfg6u3RjgCJaeqzEoma4Niz-H9=0bSHJo+9jg@mail.gmail.com>
In-Reply-To: <CAPybu_0+F-o03qfg6u3RjgCJaeqzEoma4Niz-H9=0bSHJo+9jg@mail.gmail.com>
From: Rob Herring <robh@kernel.org>
Date: Mon, 1 Oct 2018 10:01:42 -0500
Message-ID: <CAL_JsqJ32c3FXrUmCO0N16GcrUJ53tj5rp3VvV0s5H1NybwqKQ@mail.gmail.com>
Subject: Re: [PATCH v4 3/7] [media] ad5820: DT new optional field enable-gpios
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 1, 2018 at 7:40 AM Ricardo Ribalda Delgado
<ricardo.ribalda@gmail.com> wrote:
>
> Hi
> On Mon, Oct 1, 2018 at 2:36 PM Rob Herring <robh@kernel.org> wrote:
> >
> > On Mon, Oct 1, 2018 at 3:20 AM Ricardo Ribalda Delgado
> > <ricardo.ribalda@gmail.com> wrote:
> > >
> > > Hi Rob
> > > On Thu, Sep 27, 2018 at 8:23 PM Rob Herring <robh@kernel.org> wrote:
> > > >
> > > > On Thu, Sep 20, 2018 at 10:47:47PM +0200, Ricardo Ribalda Delgado wrote:
> > > > > Document new enable-gpio field. It can be used to disable the part
> > > >
> > > > enable-gpios
> > > >
> > > > > without turning down its regulator.
> > > > >
> > > > > Cc: devicetree@vger.kernel.org
> > > > > Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> > > > > Acked-by: Pavel Machek <pavel@ucw.cz>
> > > > > ---
> > > > >  Documentation/devicetree/bindings/media/i2c/ad5820.txt | 7 +++++++
> > > > >  1 file changed, 7 insertions(+)
> > > > >
> > > > > diff --git a/Documentation/devicetree/bindings/media/i2c/ad5820.txt b/Documentation/devicetree/bindings/media/i2c/ad5820.txt
> > > > > index 5940ca11c021..9ccd96d3d5f0 100644
> > > > > --- a/Documentation/devicetree/bindings/media/i2c/ad5820.txt
> > > > > +++ b/Documentation/devicetree/bindings/media/i2c/ad5820.txt
> > > > > @@ -8,6 +8,12 @@ Required Properties:
> > > > >
> > > > >    - VANA-supply: supply of voltage for VANA pin
> > > > >
> > > > > +Optional properties:
> > > > > +
> > > > > +   - enable-gpios : GPIO spec for the XSHUTDOWN pin. Note that the polarity of
> > > > > +the enable GPIO is the opposite of the XSHUTDOWN pin (asserting the enable
> > > > > +GPIO deasserts the XSHUTDOWN signal and vice versa).
> > > >
> > > > shutdown-gpios is also standard and seems like it would make more sense
> > > > here. Yes, it is a bit redundant to have both, but things just evolved
> > > > that way and we don't want to totally abandon the hardware names (just
> > > > all the variants).
> > > >
> > >
> > > Sorry to insist
> > >
> > > The pin is called xshutdown, not shutdown and is inverse logic,
> > > Wouldnt it make more sense to use the name
> > > enable-gpios?
> >
> > Inverse of what? shutdown-gpios is the inverse of enable-gpios. By
> > using shutdown-gpios you can just get rid of "Note that the polarity
> > of the enable GPIO is the opposite of the XSHUTDOWN pin (asserting the
> > enable GPIO deasserts the XSHUTDOWN signal and vice versa)."
>
> The pin is called XSHUTDOWN
>
> 0V means shutdown
>
> 3.3V means enable
>
> This is why I think is more clear to use enable as name in the device tree.

Neither enable-gpios nor shutdown-gpios have a defined polarity. The
polarity is part of the flags cell in the specifier.

Rob
