Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lj1-f194.google.com ([209.85.208.194]:33879 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727153AbeJBRkX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2018 13:40:23 -0400
MIME-Version: 1.0
References: <20181002073222.11368-1-ricardo.ribalda@gmail.com>
 <20181002073222.11368-2-ricardo.ribalda@gmail.com> <2128166.ZAkUExjJHM@avalon>
In-Reply-To: <2128166.ZAkUExjJHM@avalon>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Tue, 2 Oct 2018 12:57:22 +0200
Message-ID: <CAPybu_1xmsuQVx94Lx+5UyX_+aerPdGVsgVkoNy=XkS98nmAmw@mail.gmail.com>
Subject: Re: [PATCH v5 2/6] [media] ad5820: DT new optional field enable-gpios
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

Hi Laurent
On Tue, Oct 2, 2018 at 12:35 PM Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>
> Hi Ricardo,
>
> Thank you for the patch.
>
> On Tuesday, 2 October 2018 10:32:18 EEST Ricardo Ribalda Delgado wrote:
> > Document new enable-gpio field. It can be used to disable the part
> > without turning down its regulator.
> >
> > Cc: devicetree@vger.kernel.org
> > Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> > Acked-by: Pavel Machek <pavel@ucw.cz>
> > ---
> >  Documentation/devicetree/bindings/media/i2c/ad5820.txt | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/Documentation/devicetree/bindings/media/i2c/ad5820.txt
> > b/Documentation/devicetree/bindings/media/i2c/ad5820.txt index
> > 5940ca11c021..9ccd96d3d5f0 100644
> > --- a/Documentation/devicetree/bindings/media/i2c/ad5820.txt
> > +++ b/Documentation/devicetree/bindings/media/i2c/ad5820.txt
> > @@ -8,6 +8,12 @@ Required Properties:
> >
> >    - VANA-supply: supply of voltage for VANA pin
> >
> > +Optional properties:
> > +
> > +   - enable-gpios : GPIO spec for the XSHUTDOWN pin. Note that the polarity
> > of +the enable GPIO is the opposite of the XSHUTDOWN pin (asserting the
> > enable +GPIO deasserts the XSHUTDOWN signal and vice versa).
>
> After reading this one more time, I think the text is at the very least
> confusing. The logic level of the enable GPIO is the same as the logic level
> of the XSHUTDOWN pin. The latter being active low, asserting "enable" will
> deassert "shutdown", but talking about "desserting XSHUTDOWN" is confusing.
>

what about:

- enable-gpios : GPIO spec for the XSHUTDOWN pin. When the XSHUTDOWN pin
is asserted the device is enabled.

> > of +the enable GPIO is the opposite of the XSHUTDOWN pin (asserting the
> > enable +GPIO deasserts the XSHUTDOWN signal and vice versa).

> >  Example:
> >
> >         ad5820: coil@c {
> > @@ -15,5 +21,6 @@ Example:
> >                 reg = <0x0c>;
> >
> >                 VANA-supply = <&vaux4>;
> > +               enable-gpios = <&msmgpio 26 GPIO_ACTIVE_HIGH>;
> >         };
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
