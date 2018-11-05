Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay10.mail.gandi.net ([217.70.178.230]:39003 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729212AbeKEXmy (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Nov 2018 18:42:54 -0500
Date: Mon, 5 Nov 2018 15:22:52 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Lubomir Rintel <lkundrak@v3.sk>
Cc: Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] [media] ov7670: make "xclk" clock optional
Message-ID: <20181105142252.GM20885@w540>
References: <20181004212903.364064-1-lkundrak@v3.sk>
 <20181105105841.GJ20885@w540>
 <272b2d009e056f36bfb08206772eb40bcdff00b0.camel@v3.sk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="YuJye9aIuN0w6xGV"
Content-Disposition: inline
In-Reply-To: <272b2d009e056f36bfb08206772eb40bcdff00b0.camel@v3.sk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--YuJye9aIuN0w6xGV
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Lubo,

On Mon, Nov 05, 2018 at 02:12:18PM +0100, Lubomir Rintel wrote:
> Hello,
>
> On Mon, 2018-11-05 at 11:58 +0100, jacopo mondi wrote:
> > Hi Lubomir,
> >    +Sakari in Cc
> >
> > I just noticed this, and the patch is now in v4.20, but let me comment
> > anyway on this.
> >
> > On Thu, Oct 04, 2018 at 11:29:03PM +0200, Lubomir Rintel wrote:
> > > When the "xclk" clock was added, it was made mandatory. This broke the
> > > driver on an OLPC plaform which doesn't know such clock. Make it
> > > optional.
> > >
> >
> > I don't think this is correct. The sensor needs a clock to work.
> >
> > With this patch clock_speed which is used to calculate
> > the framerate is defaulted to 30MHz, crippling all the calculations if
> > that default value doesn't match what is actually installed on the
> > board.
>
> How come? I kept this:
>
> +             info->clock_speed = clk_get_rate(info->clk) / 1000000;

Yes, but only if
if (info->clk) { }

if (!info->clk) the 'clock_speed' variable is defaulted to 30 at the
beginning of the probe routine. Am I missing something obvious here?
>
> >
> > If this patch breaks the OLPC, then might it be the DTS for said
> > device needs to be fixed instead of working around the issue here?
>
> No. Device tree is an ABI, and you can't just add mandatory properties.
>

Well, as I read the ov7670 bindings documentation:

Required Properties:
- compatible: should be "ovti,ov7670"
- clocks: reference to the xclk input clock.
- clock-names: should be "xclk".

It was mandatory already since the bindings have been first created:
bba582894a ("[media] ov7670: document device tree bindings")

And yes, bindings establishes an ABI we have not to break or make
incompatible with DTs created for an older version of the same binding,
but the DTs itself is free to change and we need to do so to update
it when required (to fix bugs, add new components, enable/disable them
etc).

> There's no DTS for OLPC XO-1 either; it's an OpenFirmware machine.
>

I thought OLPC was an ARM machine, that's why I mentioned DTS. Sorry
about this.

A quick read of the wikipedia page for "OpenFirmware" gives me back
that it a standardized firmware interface:
"Open Firmware allows the system to load platform-independent drivers
directly from the PCI card, improving compatibility".

I know nothing on this, and that's not the point, so I'll better stop
here and refrain to express how much the "loading platform-independent
(BINARY) drivers from the PCI card" scares me :p

> You'd need to update all machines in the wild which is not realistic.

Machines which have received a kernel update which includes the patch
that makes the clock for the sensor driver mandatory [1], will have their
board files updated by the same kernel update, with the proper clock
provider instantiated for that sensor.

That's what I would expect from a kernel update for those devices (or
any device in general..)

If this didn't happen, blame OLPC kernel maintainers :p

[1] 0a024d634cee ("[media] ov7670: get xclk"); which went in v4.12

> Alternatively, something else than DT could provide the clock. If this
> gets in, then the OLPC would work even without the xclk patch:
> https://lore.kernel.org/lkml/20181105073054.24407-12-lkundrak@v3.sk/

That's what I meant, more or less.

If you don't have a DTS you have a board file, isn't it?
( arch/x86/platform/olpc/ maybe? )

The patch you linked here makes the video interface (the marvel-ccic
one) provide the clock source for the sensor:

+	clkdev_create(mcam->mclk, "xclk", "%d-%04x",
+		i2c_adapter_id(cam->i2c_adapter), ov7670_info.addr);
+

While I would expect the board file to do that, as that's where all
pieces gets put together, and it knows which clock source has to be
fed to the sensor depending on your hardware design. As I don't know
much of x86 or openfirmare, feel free to explain me why it is not
possible ;)

Anyway, my whole point is that the sensor needs a clock to work. With
your patch if it is not provided it gets defaulted (if I'm not
mis-reading the code) to a value that would break frame interval
calculations. This is what concerns me and I would prefer the driver
to fail probing quite nosily to make sure all its users (dts, board
files etc) gets updated.
>
> (I just got a kbuild failure message, so I'll surely be following up
> with a v2.)
>
> > Also, the DT bindings should be updated too if we decide this property
> > can be omitted. At this point, with a follow-up patch.
>
> Yes.
>
This would actually be an ABI change (one that would not break
retro-compatibility probably, but still...)

Thanks
   j

> >
> > Thanks
>
> Cheers
> Lubo
>
> >    j
> >
> > > Tested on a OLPC XO-1 laptop.
> > >
> > > Cc: stable@vger.kernel.org # 4.11+
> > > Fixes: 0a024d634cee ("[media] ov7670: get xclk")
> > > Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
> > > ---
> > >  drivers/media/i2c/ov7670.c | 27 +++++++++++++++++----------
> > >  1 file changed, 17 insertions(+), 10 deletions(-)
> > >
> > > diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
> > > index 31bf577b0bd3..64d1402882c8 100644
> > > --- a/drivers/media/i2c/ov7670.c
> > > +++ b/drivers/media/i2c/ov7670.c
> > > @@ -1808,17 +1808,24 @@ static int ov7670_probe(struct i2c_client *client,
> > >  			info->pclk_hb_disable = true;
> > >  	}
> > >
> > > -	info->clk = devm_clk_get(&client->dev, "xclk");
> > > -	if (IS_ERR(info->clk))
> > > -		return PTR_ERR(info->clk);
> > > -	ret = clk_prepare_enable(info->clk);
> > > -	if (ret)
> > > -		return ret;
> > > +	info->clk = devm_clk_get(&client->dev, "xclk"); /* optional */
> > > +	if (IS_ERR(info->clk)) {
> > > +		ret = PTR_ERR(info->clk);
> > > +		if (ret == -ENOENT)
> > > +			info->clk = NULL;
> > > +		else
> > > +			return ret;
> > > +	}
> > > +	if (info->clk) {
> > > +		ret = clk_prepare_enable(info->clk);
> > > +		if (ret)
> > > +			return ret;
> > >
> > > -	info->clock_speed = clk_get_rate(info->clk) / 1000000;
> > > -	if (info->clock_speed < 10 || info->clock_speed > 48) {
> > > -		ret = -EINVAL;
> > > -		goto clk_disable;
> > > +		info->clock_speed = clk_get_rate(info->clk) / 1000000;
> > > +		if (info->clock_speed < 10 || info->clock_speed > 48) {
> > > +			ret = -EINVAL;
> > > +			goto clk_disable;
> > > +		}
> > >  	}
> > >
> > >  	ret = ov7670_init_gpio(client, info);
> > > --
> > > 2.19.0
> > >
>

--YuJye9aIuN0w6xGV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJb4FI8AAoJEHI0Bo8WoVY8RT8QAKj+/fRaHcA/7KPN9gOsFuYK
baq5BuH5HPlQiNXmX0Vh9vaBWgd1yJLyoUz3sew9hYwYWSz57/hzdZwXlQEHbnkZ
bHcvq8R7gW524LmBZdDh/QhvXNnooqpXU8GuwYBcMMNwt6ieVB/Te4WhVypyH/9t
R+79EqmaCLfjaX72U1G9JhL7Q2AMmujRHY1G8X7xR28WTwW5cwqdJiHiM3id6SHZ
07toaOu9/X5Wb0wE9iUmv5o3mTjftKPH/HB3UOa2GstLilfg/ODmAy8oCBHY7PdV
7hav/uevW0hlQUpWCJJC0/Jy0ZUsZcovzEtpJFELaBxYKFhu+/VIqVvKfMGHX97V
AFUC4YgXHxmMljaXLjcB3/e/Lm1eD1ohg9SE+jAxLKX1tg3GBC/6+y+8+2MnRbhY
AuimgTrNlLgR0csQF7ic+SsRmpY4VAsznnVv+/LUU0K69Vv6Ol9lw5vf4zDnuww0
WVmCwm88QPqK8uyTzcepJuaKNMFkx2B12jOjZXhahVwj6wjZYaMxJSsxDLDWIzyO
9FASYN8r1h/nEAk1ZNS2M3Ir6GCsEoVmNBSo1mrtUABIs0VRUz5YEtnTJEOde/GL
L8T25HmnDWxQbtnixxSNjrd0r3kPBe1Bow9z2/WBAWcomnsH4lZTdoBFjxpwM1EV
NcZz4xEZkc6xsr2W6r0P
=n7n8
-----END PGP SIGNATURE-----

--YuJye9aIuN0w6xGV--
