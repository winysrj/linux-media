Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39513 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750810AbeBGV6h (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Feb 2018 16:58:37 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
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
        <devicetree@vger.kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH 2/2] drm: adv7511: Add support for i2c_new_secondary_device
Date: Wed, 07 Feb 2018 23:59:02 +0200
Message-ID: <506017617.snhEqs7y0U@avalon>
In-Reply-To: <22aa9d42-e7df-cbe7-4044-3b120cd242c3@ideasonboard.com>
References: <1516625389-6362-1-git-send-email-kieran.bingham@ideasonboard.com> <1650729.pzuqXiNcLL@avalon> <22aa9d42-e7df-cbe7-4044-3b120cd242c3@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Wednesday, 7 February 2018 17:14:09 EET Kieran Bingham wrote:
> On 29/01/18 10:26, Laurent Pinchart wrote:
> > On Monday, 22 January 2018 14:50:00 EET Kieran Bingham wrote:
> >> The ADV7511 has four 256-byte maps that can be accessed via the main I=
=B2C
> >> ports. Each map has it own I=B2C address and acts as a standard slave
> >> device on the I=B2C bus.
> >>=20
> >> Allow a device tree node to override the default addresses so that
> >> address conflicts with other devices on the same bus may be resolved at
> >> the board description level.
> >>=20
> >> Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
> >> ---
> >>=20
> >>  .../bindings/display/bridge/adi,adv7511.txt        | 10 +++++-
> >=20
> > I don't mind personally, but device tree maintainers usually ask for DT
> > bindings changes to be split to a separate patch.
> >=20
> >>  drivers/gpu/drm/bridge/adv7511/adv7511.h           |  4 +++
> >>  drivers/gpu/drm/bridge/adv7511/adv7511_drv.c       | 36 ++++++++++---=
=2D-
> >>  3 files changed, 37 insertions(+), 13 deletions(-)
> >>=20
> >> diff --git
> >> a/Documentation/devicetree/bindings/display/bridge/adi,adv7511.txt
> >> b/Documentation/devicetree/bindings/display/bridge/adi,adv7511.txt
> >> index 0047b1394c70..f6bb9f6d3f48 100644
> >> --- a/Documentation/devicetree/bindings/display/bridge/adi,adv7511.txt
> >> +++ b/Documentation/devicetree/bindings/display/bridge/adi,adv7511.txt
> >>=20
> >> @@ -70,6 +70,9 @@ Optional properties:
> >>    rather than generate its own timings for HDMI output.
> >> =20
> >>  - clocks: from common clock binding: reference to the CEC clock.
> >>  - clock-names: from common clock binding: must be "cec".
> >>=20
> >> +- reg-names : Names of maps with programmable addresses.
> >> +	It can contain any map needing a non-default address.
> >> +	Possible maps names are : "main", "edid", "cec", "packet"
> >=20
> > Is the reg-names property (and the additional maps) mandatory or option=
al
> > ? If mandatory you should also update the existing DT sources that use
> > those bindings.
>=20
> They are currently optional. I do prefer it that way - but perhaps due to=
 an
> issue mentioned below we might need to make this driver mandatory ?
>=20
> > If optional you should define which I2C addresses will be used when
> > the maps are not specified (and in that case I think we should go for
> > the addresses listed as default in the datasheet, which correspond to t=
he
> > current driver implementation when the main address is 0x3d/0x7a).
>=20
> The current addresses do not correspond to the datasheet, even when the
> implementation main address is set to 0x3d.

Don't they ? The driver currently uses the following (8-bit) I2C addresses:

EDID:   main + 4  =3D 0x7e (0x3f)
Packet: main - 10 =3D 0x70 (0x38)
CEC:    main - 2  =3D 0x78 (0x3c)

Those are the default addresses according to section 4.1 of the ADV7511W=20
programming guide (rev. B), and they match the ones you set in this patch.

> Thus, in my opinion - they are currently 'wrong' - but perhaps changing t=
hem
> is considered breakage too.
>=20
> A particular issue will arise here too - as on this device - when the dev=
ice
> is in low-power mode (after probe, before use) - the maps will respond on
> their *hardware default* addresses (the ones implemented in this patch),
> and thus consume that address on the I2C bus regardless of their settings
> in the driver.

We've discussed this previously and I share you concern. Just to make sure =
I=20
remember correctly, did all the secondary maps reset to their default=20
addresses, or just the EDID map ?

> > You should also update the definition of the reg property that currently
> > just states
> >=20
> > - reg: I2C slave address
> >=20
> > And finally you might want to define the term "map" in this context.
> > Here's a proposal (if we make all maps mandatory).
> >=20
> > The ADV7511 internal registers are split into four pages exposed through
> > different I2C addresses, creating four register maps. The I2C addresses=
 of
> > all four maps shall be specified by the reg and reg-names property.
> >=20
> > - reg: I2C slave addresses, one per reg-names entry
> > - reg-names: map names, shall be "main", "edid", "cec", "packet"
> >=20
> >>  Required nodes:
> >> @@ -88,7 +91,12 @@ Example
> >>=20
> >>  	adv7511w: hdmi@39 {
> >>  		compatible =3D "adi,adv7511w";
> >> -		reg =3D <39>;
> >> +		/*
> >> +		 * The EDID page will be accessible on address 0x66 on the i2c
> >> +		 * bus. All other maps continue to use their default addresses.
> >> +		 */
> >> +		reg =3D <0x39 0x66>;
> >> +		reg-names =3D "main", "edid";
> >>  		interrupt-parent =3D <&gpio3>;
> >>  		interrupts =3D <29 IRQ_TYPE_EDGE_FALLING>;
> >>  		clocks =3D <&cec_clock>;

[snip]

> >> diff --git a/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
> >> b/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
> >> index efa29db5fc2b..7ec33837752b 100644
> >> --- a/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
> >> +++ b/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c

[snip]

> >> @@ -1153,24 +1151,35 @@ static int adv7511_probe(struct i2c_client *i2=
c,
> >> const struct i2c_device_id *id)
> >>  	if (ret)
> >>  		goto uninit_regulators;
> >>=20
> >> -	regmap_write(adv7511->regmap, ADV7511_REG_EDID_I2C_ADDR,
> >> edid_i2c_addr);
> >> -	regmap_write(adv7511->regmap, ADV7511_REG_PACKET_I2C_ADDR,
> >> -		     main_i2c_addr - 0xa);
> >> -	regmap_write(adv7511->regmap, ADV7511_REG_CEC_I2C_ADDR,
> >> -		     main_i2c_addr - 2);
> >> -
> >>  	adv7511_packet_disable(adv7511, 0xffff);
> >> -	adv7511->i2c_edid =3D i2c_new_dummy(i2c->adapter, edid_i2c_addr >> 1=
);
> >> +	adv7511->i2c_edid =3D i2c_new_secondary_device(i2c, "edid",
> >> +					ADV7511_REG_EDID_I2C_ADDR_DEFAULT);
> >>  	if (!adv7511->i2c_edid) {
> >>  		ret =3D -ENOMEM;
> >=20
> > I wonder if this is the right error code. Maybe -EINVAL ? In most cases
> > errors will be caused by invalid addresses (out of memory and
> > device_register() failures can happen too but should be less common).
>=20
> It's arbitrary, as multiple error paths simply return NULL, but I think y=
ou
> are right - the 'most common' fault here is likely to be an in use addres=
s.
>=20
> -ENOMEM was chosen here to mirror the equivalent code returned from the
> adv7604 driver.
>=20
> Either way - -EINVAL does feel better at the moment. Although when mirror=
ed
> back to the ADV7604 that becomes a distinct change there.
>=20
> I don't think that matters though - so I'll apply this fix to both patche=
s.
>=20
> > It would be nice if i2c_new_secondary_device() returned an ERR_PTR, but
> > that's out of scope.
>=20
> I was about to say - well I'll add this, but the reality is it might requ=
ire
> updating all users of i2c_new_device, and i2c_new_dummy. Updating
> i2c_new_secondary_device() on it's own seems a bit pointless otherwise.
>=20
> And that is definitely out of scope for the amount of time I currently ha=
ve
> :D
>=20
> >>  		goto uninit_regulators;
> >>  	}
> >>=20
> >> +	regmap_write(adv7511->regmap, ADV7511_REG_EDID_I2C_ADDR,
> >> +		     adv7511->i2c_edid->addr << 1);
> >> +
> >>  	ret =3D adv7511_init_cec_regmap(adv7511);
> >>  	if (ret)
> >>  		goto err_i2c_unregister_edid;
> >>=20
> >> +	regmap_write(adv7511->regmap, ADV7511_REG_CEC_I2C_ADDR,
> >> +		     adv7511->i2c_cec->addr << 1);
> >> +
> >> +	adv7511->i2c_packet =3D i2c_new_secondary_device(i2c, "packet",
> >> +					ADV7511_REG_PACKET_I2C_ADDR_DEFAULT);
> >> +	if (!adv7511->i2c_packet) {
> >> +		ret =3D -ENOMEM;
> >> +		goto err_unregister_cec;
> >> +	}
> >> +
> >> +	regmap_write(adv7511->regmap, ADV7511_REG_PACKET_I2C_ADDR,
> >> +		     adv7511->i2c_packet->addr << 1);
> >> +
> >>  	INIT_WORK(&adv7511->hpd_work, adv7511_hpd_work);
> >>  =09
> >>  	if (i2c->irq) {

[snip]

=2D-=20
Regards,

Laurent Pinchart
