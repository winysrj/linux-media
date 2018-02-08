Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:50748 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752126AbeBHVvE (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Feb 2018 16:51:04 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
        David Airlie <airlied@linux.ie>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Archit Taneja <architt@codeaurora.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        John Stultz <john.stultz@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Inki Dae <inki.dae@samsung.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH 2/2] drm: adv7511: Add support for i2c_new_secondary_device
Date: Thu, 08 Feb 2018 23:51:31 +0200
Message-ID: <3477719.9Iy5Zezpfg@avalon>
In-Reply-To: <5e144334-a747-7abf-4a8c-8f6f9134143b@ideasonboard.com>
References: <1516625389-6362-1-git-send-email-kieran.bingham@ideasonboard.com> <506017617.snhEqs7y0U@avalon> <5e144334-a747-7abf-4a8c-8f6f9134143b@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Thursday, 8 February 2018 01:30:43 EET Kieran Bingham wrote:
> On 07/02/18 21:59, Laurent Pinchart wrote:
> > On Wednesday, 7 February 2018 17:14:09 EET Kieran Bingham wrote:
> >> On 29/01/18 10:26, Laurent Pinchart wrote:
> >>> On Monday, 22 January 2018 14:50:00 EET Kieran Bingham wrote:
> >>>> The ADV7511 has four 256-byte maps that can be accessed via the main
> >>>> I=B2C ports. Each map has it own I=B2C address and acts as a standar=
d slave
> >>>> device on the I=B2C bus.
> >>>>=20
> >>>> Allow a device tree node to override the default addresses so that
> >>>> address conflicts with other devices on the same bus may be resolved=
 at
> >>>> the board description level.
> >>>>=20
> >>>> Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
> >>>> ---
> >>>>=20
> >>>>  .../bindings/display/bridge/adi,adv7511.txt        | 10 +++++-
> >>>=20
> >>> I don't mind personally, but device tree maintainers usually ask for =
DT
> >>> bindings changes to be split to a separate patch.
> >>>=20
> >>>>  drivers/gpu/drm/bridge/adv7511/adv7511.h           |  4 +++
> >>>>  drivers/gpu/drm/bridge/adv7511/adv7511_drv.c       | 36++++++++++--=
=2D--
> >>>>  3 files changed, 37 insertions(+), 13 deletions(-)
> >>>>=20
> >>>> diff --git
> >>>> a/Documentation/devicetree/bindings/display/bridge/adi,adv7511.txt
> >>>> b/Documentation/devicetree/bindings/display/bridge/adi,adv7511.txt
> >>>> index 0047b1394c70..f6bb9f6d3f48 100644
> >>>> --- a/Documentation/devicetree/bindings/display/bridge/adi,adv7511.t=
xt
> >>>> +++ b/Documentation/devicetree/bindings/display/bridge/adi,adv7511.t=
xt
> >>>>=20
> >>>> @@ -70,6 +70,9 @@ Optional properties:
> >>>>    rather than generate its own timings for HDMI output.
> >>>>  - clocks: from common clock binding: reference to the CEC clock.
> >>>>  - clock-names: from common clock binding: must be "cec".
> >>>> +- reg-names : Names of maps with programmable addresses.
> >>>> +	It can contain any map needing a non-default address.
> >>>> +	Possible maps names are : "main", "edid", "cec", "packet"
> >>>=20
> >>> Is the reg-names property (and the additional maps) mandatory or
> >>> optional ? If mandatory you should also update the existing DT sources
> >>> that use those bindings.
> >>=20
> >> They are currently optional. I do prefer it that way - but perhaps due=
 to
> >> an issue mentioned below we might need to make this driver mandatory ?=
>>=20
> >>=20
> >>> If optional you should define which I2C addresses will be used when
> >>> the maps are not specified (and in that case I think we should go for
> >>> the addresses listed as default in the datasheet, which correspond to
> >>> the current driver implementation when the main address is 0x3d/0x7a).
> >>=20
> >> The current addresses do not correspond to the datasheet, even when the
> >> implementation main address is set to 0x3d.
> >=20
> > Don't they ? The driver currently uses the following (8-bit) I2C
> > addresses:
> >=20
> > EDID:   main + 4  =3D 0x7e (0x3f)
> > Packet: main - 10 =3D 0x70 (0x38)
> > CEC:    main - 2  =3D 0x78 (0x3c)
> >=20
> > Those are the default addresses according to section 4.1 of the ADV7511W
> > programming guide (rev. B), and they match the ones you set in this pat=
ch.
>=20
> Sorry - I was clearly subtracting 8bit values from a 7bit address in my
> failed assertion, to both you and Archit.

No worries.

> >> Thus, in my opinion - they are currently 'wrong' - but perhaps changing
> >> them is considered breakage too.
> >>=20
> >> A particular issue will arise here too - as on this device - when the
> >> device is in low-power mode (after probe, before use) - the maps will
> >> respond on their *hardware default* addresses (the ones implemented in
> >> this patch), and thus consume that address on the I2C bus regardless of
> >> their settings in the driver.
> >=20
> > We've discussed this previously and I share you concern. Just to make s=
ure
> > I remember correctly, did all the secondary maps reset to their default
> > addresses, or just the EDID map ?
>=20
> The following responds on the bus when programmed at alternative addresse=
s,
> and in low power mode. The responses are all 0, but that's still going to
> conflict with other hardware if it tries to use the 'un-used' addresses.
>=20
> Packet (0x38),
> Main (0x39),
> Fixed (set to 0 by software, but shows up at 0x3e)
> and EDID (0x3f).
>=20
> So actually it's only the CEC which don't respond when in "low-power-mode=
".
>=20
> As far as I can see, (git grep  -B3 adi,adv75) - The r8a7792-wheat.dts is
> the only instance of a device using 0x3d, which means that Sergei's patch
> changed the behaviour of all the existing devices before that.
>=20
> Thus - this patch could be seen to be a 'correction' back to the original
> behaviour for all devices except the Wheat, and possibly devices added af=
ter
> Sergei's patch went in.
>=20
> However - by my understanding, - any device which has only one ADV75(3,1)+
> should use the hardware defined addresses (the hardware defaults will be
> conflicting on the bus anyway, thus should be assigned to the ADV7511)
>=20
> Any platform which uses *two* ADV7511 devices on the same bus should
> actually set *both* devices to use entirely separate addresses - or they
> will still conflict with each other.

Agreed. No access should be made to the default addresses for the secondary=
=20
I2C clients, otherwise there's a risk of conflict.

When only one ADV7511 is present, but conflicts with another device, we cou=
ld=20
reprogram the other device only (assuming it doesn't lose its configuration=
 in=20
low-power mode), or reprogram both.

> Now - if my understanding is correct - then I believe - that means that a=
ll
> existing devices except Wheat *should* be using the default addresses as
> this patch updates them to.
>=20
> The Wheat - has an invalid configuration - and thus should be updated
> anyway.

I agree.

> >>> You should also update the definition of the reg property that curren=
tly
> >>> just states
> >>>=20
> >>> - reg: I2C slave address
> >>>=20
> >>> And finally you might want to define the term "map" in this context.
> >>> Here's a proposal (if we make all maps mandatory).
> >>>=20
> >>> The ADV7511 internal registers are split into four pages exposed thro=
ugh
> >>> different I2C addresses, creating four register maps. The I2C address=
es
> >>> of all four maps shall be specified by the reg and reg-names property.
> >>>=20
> >>> - reg: I2C slave addresses, one per reg-names entry
> >>> - reg-names: map names, shall be "main", "edid", "cec", "packet"
> >>>=20
> >>>>  Required nodes:
> >>>> @@ -88,7 +91,12 @@ Example
> >>>>=20
> >>>>  	adv7511w: hdmi@39 {
> >>>>  		compatible =3D "adi,adv7511w";
> >>>>=20
> >>>> -		reg =3D <39>;
> >>>> +		/*
> >>>> +		 * The EDID page will be accessible on address 0x66 on the i2c
> >>>> +		 * bus. All other maps continue to use their default addresses.
> >>>> +		 */
> >>>> +		reg =3D <0x39 0x66>;
> >>>> +		reg-names =3D "main", "edid";
> >>>>  		interrupt-parent =3D <&gpio3>;
> >>>>  		interrupts =3D <29 IRQ_TYPE_EDGE_FALLING>;
> >>>>  		clocks =3D <&cec_clock>;

[snip]

=2D-=20
Regards,

Laurent Pinchart
