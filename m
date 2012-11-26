Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:36303 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752850Ab2KZQ44 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Nov 2012 11:56:56 -0500
Message-ID: <50B39F46.7050808@ti.com>
Date: Mon, 26 Nov 2012 18:56:38 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
MIME-Version: 1.0
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
CC: <linux-fbdev@vger.kernel.org>, <kernel@pengutronix.de>,
	David Airlie <airlied@linux.ie>,
	<devicetree-discuss@lists.ozlabs.org>,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	<dri-devel@lists.freedesktop.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	<linux-media@vger.kernel.org>
Subject: Re: [PATCHv15 3/7] video: add of helper for display timings/videomode
References: <1353920848-1705-1-git-send-email-s.trumtrar@pengutronix.de> <1353920848-1705-4-git-send-email-s.trumtrar@pengutronix.de> <50B37EEC.6090808@ti.com> <20121126161055.GB30791@pengutronix.de>
In-Reply-To: <20121126161055.GB30791@pengutronix.de>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig5AF54A52467687FFCEF6CB34"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--------------enig5AF54A52467687FFCEF6CB34
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2012-11-26 18:10, Steffen Trumtrar wrote:
> Hi,
>=20
> On Mon, Nov 26, 2012 at 04:38:36PM +0200, Tomi Valkeinen wrote:

>>> +optional properties:
>>> + - hsync-active: hsync pulse is active low/high/ignored
>>> + - vsync-active: vsync pulse is active low/high/ignored
>>> + - de-active: data-enable pulse is active low/high/ignored
>>> + - pixelclk-inverted: pixelclock is inverted (active on falling edge=
)/
>>> +				non-inverted (active on rising edge)/
>>> +				     ignored (ignore property)
>>
>> I think hsync-active and vsync-active are clear, and commonly used, an=
d
>> they are used for both drm and fb mode conversions in later patches.
>>
>> de-active is not used in drm and fb mode conversions, but I think it's=

>> also clear.
>>
>> pixelclk-inverted is not used in the mode conversions. It's also a bit=

>> unclear to me. What does it mean that pix clock is "active on rising
>> edge"? The pixel data is driven on rising edge? How about the sync
>> signals and DE, when are they driven? Does your HW have any settings
>> related to those?
>>
>=20
> Those are properties commonly found in display specs. That is why they =
are here.
> If the GPU does not support the property it can be omitted.

So what does the pixelclk-inverted mean? Normally the SoC drives pixel
data on rising edge, and the panel samples it at falling edge? And
vice-versa for inverted? Or the other way around?

When is hsync/vsync set? On rising or falling edge of pclk?

My point here is that the pixelclk-inverted is not crystal clear thing,
like the hsync/vsync/de-active values are.

And while thinking about this, I realized that the meaning of
pixelclk-inverted depends on what component is it applied to. Presuming
normal pixclk means "pixel data on rising edge", the meaning of that
depends on do we consider the SoC or the panel. The panel needs to
sample the data on the other edge from the one the SoC uses to drive the
data.

Does the videomode describe the panel, or does it describe the settings
programmed to the SoC?

>> OMAP has the invert pclk setting, but it also has a setting to define
>> when the sync signals are driven. The options are:
>> - syncs are driven on rising edge of pclk
>> - syncs are driven on falling edge of pclk
>> - syncs are driven on the opposite edge of pclk compared to the pixel =
data
>>
>> For DE there's no setting, except the active high/low.
>>
>> And if I'm not mistaken, if the optional properties are not defined,
>> they are not ignored, but left to the default 0. Which means active lo=
w,
>> or active on rising edge(?). I think it would be good to have a
>> "undefined" value for the properties.
>>
>=20
> Yes. As mentioned in my other mail, the intention of the omitted proper=
ties do
> not propagate properly. Omitted must be a value < 0, so it is clear in =
a later
> stage, that this property shall not be used. And isn't unintentionally =
considered
> to be active low.

Ok. Just note that the values are currently stored into u32, and I don't
think using negative error values with u32 is a good idea.

>> I have some of the same concerns for this series than with the
>> interpreted power sequences (on fbdev): when you publish the DT
>> bindings, it's somewhat final version then, and fixing it later will b=
e
>> difficult. Of course, video modes are much clearer than the power
>> sequences, so it's possible there won't be any problems with the DT
>> bindings.
>>
>=20
> The binding is pretty much at the bare minimum after a lot of discussio=
n about
> the properties. Even if the binding changes, I think it will rather gro=
w than
> shrink. Take the doubleclock property for example. It got here mistakin=
gly,
> because we had a display that has this feature.

Right. That's why I would leave the pixelclock-inverted out for now, if
we're not totally sure how it's defined. Of course, it could be just me
who is not understanding the pixclk-inverted =3D).

>> However, I'd still feel safer if the series would be split to non-DT a=
nd
>> DT parts. The non-DT parts could be merged quite easily, and people
>> could start using them in their kernels. This should expose
>> bugs/problems related to the code.
>>
>> The DT part could be merged later, when there's confidence that the
>> timings are good for all platforms.
>>
>> Or, alternatively, all the non-common bindings (de-active, pck
>> invert,...) that are not used for fbdev or drm currently could be left=

>> out for now. But I'd stil prefer merging it in two parts.
>=20
> I don't say that I'm against it, but the whole reason for the series wa=
s
> getting the display timings from a DT into a graphics driver. And I thi=
nk
> I remember seeing some other attempts at achieving this, but all specif=
ic
> to one special case. There is even already a mainline driver that uses =
an older
> version of the DT bindings (vt8500-fb).

I think it'd be very useful even without DT bindings. But yes, I
understand your need for it.

You're now in v15 of the series. Are you sure v16 will be good enough to
freeze the DT bindings, if 15 previous versions weren't? =3D). Perhaps I'=
m
just overly cautious with DT bindings. APIs that are exposed outside the
kernel scare me, as they should be just and not almost right.

However, I want to also point out that where ever you're going to use
the videomode DT bindings, when the common display framework is merged
and presuming you'll use it, you may need to change the DT stuff again
(for the SoC/gfx card, not the videomode bindings).

 Tomi



--------------enig5AF54A52467687FFCEF6CB34
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJQs59GAAoJEPo9qoy8lh71xCoP/j0xctzrFMp01pR7G4pLEaPO
ZE/nphePZF9yiz3ZpiBj573JA90uP2pa/UsqfmivPsDCR+qSXXYTZHQC/6q7LmTq
XQJ0MQgdv4CpkkCmRByKZGvdOh/R8Mpk6Tyvwq6oApeFtDbJNmYCRarMtFpuer4h
G8PaukpRHr8RbHlIwgP0rtQGCHuc83kWYwPtmO3hKa6My0fNevb4Sxb3ryeD5zkD
f5mwE96I5VwIrT4t10sBjYxXqCe3FFBo3Ws3Pi4VBlC2fFRleECo1kgZ5UwJ8TFg
lUHnDOjzcqdzbcs1z8Zop/Qu28+ZZSCL6omoeEdhuNRoH+5iG3/Rg0lBbQ/7+D4t
pZzzotDXMNDAVg8VL3Yxao+m/Xmd07kQL/yrweM05/YzNCs718ri9UfVNCuY+Xvb
5WG55CYx6LWQUvvO6TgbK3xGe+tXzEm5cdCodoH6EOZY02AD+BwrypKHdjG2mEWL
z8A0WQv7o70e8KoOdSHemNjNP/7cS1NseqQYCUSucgce2zxTL8UU4fB186yF1k+O
7sVS4AUjJn57IBag/4HoPvWVOJHEwhAdObC4FPOUzhaKxHhVkDnltWjHl8KopyX4
LrmuLOem9eoDH8vaO4D/LOFzViU3jJ+2BxLLzCBBDgx96NWxCWO8ghZVKqlMHEGC
R1E7n9TK7hEJOOK6kSQO
=l9KD
-----END PGP SIGNATURE-----

--------------enig5AF54A52467687FFCEF6CB34--
