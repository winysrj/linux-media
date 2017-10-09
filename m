Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48736 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754375AbdJIMw0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Oct 2017 08:52:26 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Todor Tomov <todor.tomov@linaro.org>, mchehab@kernel.org,
        hansverk@cisco.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>
Subject: Re: [PATCH] [media] ov5645: I2C address change
Date: Mon, 09 Oct 2017 15:52:32 +0300
Message-ID: <2363273.DvfkURjy3A@avalon>
In-Reply-To: <20171009093425.ftxgckycj2nuumle@valkosipuli.retiisi.org.uk>
References: <1506950925-13924-1-git-send-email-todor.tomov@linaro.org> <edc2f078-0896-d9c7-f52a-e5d0604fdeea@linaro.org> <20171009093425.ftxgckycj2nuumle@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Monday, 9 October 2017 12:34:26 EEST Sakari Ailus wrote:
> On Mon, Oct 09, 2017 at 11:36:01AM +0300, Todor Tomov wrote:
> > On  4.10.2017 13:47, Laurent Pinchart wrote:
> >> CC'ing the I2C mainling list and the I2C maintainer.
> >>=20
> >> On Wednesday, 4 October 2017 13:30:08 EEST Sakari Ailus wrote:
> >>> On Mon, Oct 02, 2017 at 04:28:45PM +0300, Todor Tomov wrote:
> >>>> As soon as the sensor is powered on, change the I2C address to the o=
ne
> >>>> specified in DT. This allows to use multiple physical sensors
> >>>> connected to the same I2C bus.
> >>>>=20
> >>>> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
> >>>=20
> >>> The smiapp driver does something similar and I understand Laurent mig=
ht
> >>> be interested in such functionality as well.
> >>>=20
> >>> It'd be nice to handle this through the I=B2C framework instead and to
> >>> define how the information is specified through DT. That way it could
> >>> be made generic, to work with more devices than just this one.
> >>>=20
> >>> What do you think?
> >=20
> > Thank you for this suggestion.
> >=20
> > The way I have done it is to put the new I2C address in the DT and the
> > driver programs the change using the original I2C address. The original
> > I2C address is hardcoded in the driver. So maybe we can extend the DT
> > binding and the I2C framework so that both addresses come from the DT a=
nd
> > avoid hiding the original I2C address in the driver. This sounds good to
> > me.
>=20
> Agreed.
>=20
> In this case the address is known but in general that's not the case it's
> not that simple. There are register compatible devices that have different
> addresses even if they're the same devices.
>=20
> It might be a good idea to make this explicit.

Yes, in the general case we need to specify the original address in DT, as =
the=20
chip could have a non-fixed boot-up I2C address.

In many cases the value of the new I2C address doesn't matter much, as long=
 as=20
it's unique on the bus. I was thinking about implementing a dynamic allocat=
or=20
for I2C addresses, but after discussing it with Wolfram we concluded that i=
t=20
would probably not be a good idea. There could be other I2C devices on the =
bus=20
that Linux isn't aware of, in which case the dynamic allocator could create=
=20
address conflicts. Specifying the new address in DT is likely a better idea=
,=20
even if it could feel a bit more of system configuration information than a=
=20
pure hardware description.

> > Then changing the address could be device specific and also this must be
> > done right after power on so that there are no address conflicts. So I
> > don't think that we can support this through the I2C framework only, the
> > drivers that we want to do that will have to be expanded with this
> > functionality. Or do you have any other idea?
>=20
> Yes, how the address is changed is always hardware specific. This would be
> most conveniently done in driver's probe or PM runtime_resume functions.

This patch modifies client->addr directly, which I don't think is a good id=
ea.=20
I'd prefer making the I2C core aware of the address change through an expli=
cit=20
API call. This would allow catching I2C adress conflicts for instance.

> It could be as simple as providing an adapter specific mutex to serialise
> address changes on the bus so that no two address changes are taking place
> at the same time. Which is essentially the impliementation you had, only
> the mutex would be for the I=B2C adapter, not the driver. An helper funct=
ions
> for acquiring and releasing the mutex.

Why do you need to serialize address changes ?

> I wonder what others think.

=2D-=20
Regards,

Laurent Pinchart
