Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf1-f68.google.com ([209.85.167.68]:35893 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726783AbeJBOAT (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2018 10:00:19 -0400
MIME-Version: 1.0
References: <20180920204751.29117-1-ricardo.ribalda@gmail.com>
 <CAPybu_0+F-o03qfg6u3RjgCJaeqzEoma4Niz-H9=0bSHJo+9jg@mail.gmail.com>
 <CAL_JsqJ32c3FXrUmCO0N16GcrUJ53tj5rp3VvV0s5H1NybwqKQ@mail.gmail.com> <1740213.b4QuNDOMfZ@avalon>
In-Reply-To: <1740213.b4QuNDOMfZ@avalon>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Tue, 2 Oct 2018 09:18:12 +0200
Message-ID: <CAPybu_3t6psN6si+btpG3f=zE7QqNoL2DatdT504N_DGdVqFVw@mail.gmail.com>
Subject: Re: [PATCH v4 3/7] [media] ad5820: DT new optional field enable-gpios
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Rob Herring <robh@kernel.org>, Pavel Machek <pavel@ucw.cz>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent
On Mon, Oct 1, 2018 at 5:55 PM Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>
> Hello,
>
> On Monday, 1 October 2018 18:01:42 EEST Rob Herring wrote:
> > On Mon, Oct 1, 2018 at 7:40 AM Ricardo Ribalda Delgado wrote:
> > > On Mon, Oct 1, 2018 at 2:36 PM Rob Herring wrote:
> > >> On Mon, Oct 1, 2018 at 3:20 AM Ricardo Ribalda Delgado wrote:
> > >>> On Thu, Sep 27, 2018 at 8:23 PM Rob Herring wrote:
> > >>>> On Thu, Sep 20, 2018 at 10:47:47PM +0200, Ricardo Ribalda Delgado
> wrote:
> > >>>>> Document new enable-gpio field. It can be used to disable the part
> > >>>>> enable-gpios without turning down its regulator.
> > >>>>>
> > >>>>> Cc: devicetree@vger.kernel.org
> > >>>>> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> > >>>>> Acked-by: Pavel Machek <pavel@ucw.cz>
> > >>>>> ---
> > >>>>>
> > >>>>>  Documentation/devicetree/bindings/media/i2c/ad5820.txt | 7
> > >>>>>  +++++++
> > >>>>>  1 file changed, 7 insertions(+)
> > >>>>>
> > >>>>> diff --git
> > >>>>> a/Documentation/devicetree/bindings/media/i2c/ad5820.txt
> > >>>>> b/Documentation/devicetree/bindings/media/i2c/ad5820.txt index
> > >>>>> 5940ca11c021..9ccd96d3d5f0 100644
> > >>>>> --- a/Documentation/devicetree/bindings/media/i2c/ad5820.txt
> > >>>>> +++ b/Documentation/devicetree/bindings/media/i2c/ad5820.txt
> > >>>>>
> > >>>>> @@ -8,6 +8,12 @@ Required Properties:
> > >>>>>    - VANA-supply: supply of voltage for VANA pin
> > >>>>>
> > >>>>> +Optional properties:
> > >>>>> +
> > >>>>> +   - enable-gpios : GPIO spec for the XSHUTDOWN pin. Note that
> > >>>>> the polarity of +the enable GPIO is the opposite of the XSHUTDOWN
> > >>>>> pin (asserting the enable +GPIO deasserts the XSHUTDOWN signal
> > >>>>> and vice versa).
> > >>>>
> > >>>> shutdown-gpios is also standard and seems like it would make more
> > >>>> sense here. Yes, it is a bit redundant to have both, but things just
> > >>>> evolved that way and we don't want to totally abandon the hardware
> > >>>> names (just all the variants).
> > >>>
> > >>> Sorry to insist
> > >>>
> > >>> The pin is called xshutdown, not shutdown and is inverse logic,
> > >>> Wouldnt it make more sense to use the name enable-gpios?
> > >>
> > >> Inverse of what? shutdown-gpios is the inverse of enable-gpios. By
> > >> using shutdown-gpios you can just get rid of "Note that the polarity
> > >> of the enable GPIO is the opposite of the XSHUTDOWN pin (asserting the
> > >> enable GPIO deasserts the XSHUTDOWN signal and vice versa)."
> > >
> > > The pin is called XSHUTDOWN
> > >
> > > 0V means shutdown
> > >
> > > 3.3V means enable
> > >
> > > This is why I think is more clear to use enable as name in the device
> > > tree.
> >
> > Neither enable-gpios nor shutdown-gpios have a defined polarity. The
> > polarity is part of the flags cell in the specifier.
>
> To be precise, the polarity is the relationship between the logical level (low
> or high) *on the GPIO side* and the logical state (asserted or deasserted) of
> the signal *on the device side*. This is important in order to take all
> components on the signal path into account, such as inverters on the board.
> The polarity does tell what level to output on the GPIO in order to achieve a
> given effect.
>
> The polarity, however, doesn't dictate what effect is expected. This is
> defined by the DT bindings (together with the documentation of the device).
> For instance an enable-gpios property in DT implies that an asserted logical
> state will enable the device. The GPIO polarity flags thus take into account a
> possible inverter at the device input (as in the difference between the ENABLE
> and nENABLE signals), but stops there.
>
> In this case, we have an XSHUTDOWN pin that will shut the device down when
> driven to 0V. If we call the related DT property shutdown, its logical level
> will be the inverse of XSHUTDOWN: the signal will need to be driven low to
> assert the shutdown effect. The GPIO flags will thus need to take this into
> account, and documenting it in DT could be useful to avoid errors.
>
> On the other hand, if we call the related DT property enable its logical level
> will the the same as XSHUTDOWN: the signal will need to be driven high to
> assert the enable effect.
>
> On the driver side we would have to deassert shutdown or assert enable to
> enable the device.
>
> I don't mind which option is selected, as long as the DT bindings are clear
> (without any inverter in the signal path beside the one inside the ad5820, the
> polarity would need to be high for the enable case and low for the shutdown
> case).

Thanks for the clarification. I definitely prefer the name enable, so
if there is no strong opposition against it I will
send it with that name.

Best regards!

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
