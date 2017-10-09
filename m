Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49360 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754098AbdJITNr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Oct 2017 15:13:47 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Todor Tomov <todor.tomov@linaro.org>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, mchehab@kernel.org,
        hansverk@cisco.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>
Subject: Re: [PATCH] [media] ov5645: I2C address change
Date: Mon, 09 Oct 2017 22:13:54 +0300
Message-ID: <3727465.YVOP6uGIbU@avalon>
In-Reply-To: <c28fa305-1725-5faa-3246-3609cf9e391e@linaro.org>
References: <1506950925-13924-1-git-send-email-todor.tomov@linaro.org> <2363273.DvfkURjy3A@avalon> <c28fa305-1725-5faa-3246-3609cf9e391e@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Todor,

On Monday, 9 October 2017 19:18:17 EEST Todor Tomov wrote:
> On  9.10.2017 15:52, Laurent Pinchart wrote:
> > On Monday, 9 October 2017 12:34:26 EEST Sakari Ailus wrote:
> >> On Mon, Oct 09, 2017 at 11:36:01AM +0300, Todor Tomov wrote:
> >>> On  4.10.2017 13:47, Laurent Pinchart wrote:
> >>>> CC'ing the I2C mainling list and the I2C maintainer.
> >>>>=20
> >>>> On Wednesday, 4 October 2017 13:30:08 EEST Sakari Ailus wrote:
> >>>>> On Mon, Oct 02, 2017 at 04:28:45PM +0300, Todor Tomov wrote:
> >>>>>> As soon as the sensor is powered on, change the I2C address to the
> >>>>>> one specified in DT. This allows to use multiple physical sensors
> >>>>>> connected to the same I2C bus.
> >>>>>>=20
> >>>>>> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
> >>>>>=20
> >>>>> The smiapp driver does something similar and I understand Laurent
> >>>>> might be interested in such functionality as well.
> >>>>>=20
> >>>>> It'd be nice to handle this through the I=B2C framework instead and=
 to
> >>>>> define how the information is specified through DT. That way it cou=
ld
> >>>>> be made generic, to work with more devices than just this one.
> >>>>>=20
> >>>>> What do you think?
> >>>=20
> >>> Thank you for this suggestion.
> >>>=20
> >>> The way I have done it is to put the new I2C address in the DT and the
> >>> driver programs the change using the original I2C address. The origin=
al
> >>> I2C address is hardcoded in the driver. So maybe we can extend the DT
> >>> binding and the I2C framework so that both addresses come from the DT
> >>> and avoid hiding the original I2C address in the driver. This sounds
> >>> good to me.
> >>=20
> >> Agreed.
> >>=20
> >> In this case the address is known but in general that's not the case i=
t's
> >> not that simple. There are register compatible devices that have
> >> different addresses even if they're the same devices.
> >>=20
> >> It might be a good idea to make this explicit.
> >=20
> > Yes, in the general case we need to specify the original address in DT,=
 as
> > the chip could have a non-fixed boot-up I2C address.
> >=20
> > In many cases the value of the new I2C address doesn't matter much, as
> > long as it's unique on the bus. I was thinking about implementing a
> > dynamic allocator for I2C addresses, but after discussing it with Wolfr=
am
> > we concluded that it would probably not be a good idea. There could be
> > other I2C devices on the bus that Linux isn't aware of, in which case t=
he
> > dynamic allocator could create address conflicts. Specifying the new
> > address in DT is likely a better idea, even if it could feel a bit more
> > of system configuration information than a pure hardware description.
> >=20
> >>> Then changing the address could be device specific and also this must=
 be
> >>> done right after power on so that there are no address conflicts. So I
> >>> don't think that we can support this through the I2C framework only, =
the
> >>> drivers that we want to do that will have to be expanded with this
> >>> functionality. Or do you have any other idea?
> >>=20
> >> Yes, how the address is changed is always hardware specific. This would
> >> be most conveniently done in driver's probe or PM runtime_resume
> >> functions.
> >=20
> > This patch modifies client->addr directly, which I don't think is a good
> > idea. I'd prefer making the I2C core aware of the address change through
> > an explicit API call. This would allow catching I2C adress conflicts for
> > instance.
> >=20
> >> It could be as simple as providing an adapter specific mutex to serial=
ise
> >> address changes on the bus so that no two address changes are taking
> >> place at the same time. Which is essentially the impliementation you h=
ad,
> >> only the mutex would be for the I=B2C adapter, not the driver. An help=
er
> >> functions for acquiring and releasing the mutex.
> >=20
> > Why do you need to serialize address changes ?
>=20
> Correct me if I'm wrong, but if you power on more than one device with the
> same I2C address and issue a command to change it, then all devices will
> recognize this command as addressed to them. The only solution (which I k=
now
> about) to avoid this is to serialize the power on and address change (as a
> whole!) for these devices.

Yes, that's correct. It can be even worse than that, sometimes only one of =
the=20
two devices with the same address can be reconfigured, which means that=20
powering that device requires powering up the other device and changing its=
=20
address first, otherwise the second device can't be used as long as the fir=
st=20
one is power on (this happened for real in a Nokia platform).

> I think it would be better to move the mutex out of the driver - to avoid
> all client drivers which will change I2C address to add a global variable
> mutex for this. We just have to find a better place for it :)

The biggest issue I see is that there's no C code that has knowledge of the=
=20
whole platform. It's hard to describe this in DT in a generic way, board fi=
les=20
were clearly useful for this kind of situations.

> >> I wonder what others think.

=2D-=20
Regards,

Laurent Pinchart
