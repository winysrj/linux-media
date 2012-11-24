Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:55375 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160Ab2KXHQW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Nov 2012 02:16:22 -0500
Message-ID: <50B07427.1010605@ti.com>
Date: Sat, 24 Nov 2012 09:15:51 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	<linux-fbdev@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Tom Gall <tom.gall@linaro.org>,
	Ragesh Radhakrishnan <ragesh.r@linaro.org>,
	Rob Clark <rob.clark@linaro.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Bryan Wu <bryan.wu@canonical.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Vikas Sajjan <vikas.sajjan@linaro.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	<linux-media@vger.kernel.org>
Subject: Re: [RFC v2 0/5] Common Display Framework
References: <1353620736-6517-1-git-send-email-laurent.pinchart@ideasonboard.com> <20121123195607.GA20990@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20121123195607.GA20990@avionic-0098.adnet.avionic-design.de>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigE32ACE99085A2D4F4123C18C"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--------------enigE32ACE99085A2D4F4123C18C
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2012-11-23 21:56, Thierry Reding wrote:
> On Thu, Nov 22, 2012 at 10:45:31PM +0100, Laurent Pinchart wrote:
> [...]
>> Display entities are accessed by driver using notifiers. Any driver ca=
n
>> register a display entity notifier with the CDF, which then calls the =
notifier
>> when a matching display entity is registered. The reason for this asyn=
chronous
>> mode of operation, compared to how drivers acquire regulator or clock
>> resources, is that the display entities can use resources provided by =
the
>> display driver. For instance a panel can be a child of the DBI or DSI =
bus
>> controlled by the display device, or use a clock provided by that devi=
ce. We
>> can't defer the display device probe until the panel is registered and=
 also
>> defer the panel device probe until the display is registered. As most =
display
>> drivers need to handle output devices hotplug (HDMI monitors for insta=
nce),
>> handling other display entities through a notification system seemed t=
o be the
>> easiest solution.
>>
>> Note that this brings a different issue after registration, as display=

>> controller and display entity drivers would take a reference to each o=
ther.
>> Those circular references would make driver unloading impossible. One =
possible
>> solution to this problem would be to simulate an unplug event for the =
display
>> entity, to force the display driver to release the dislay entities it =
uses. We
>> would need a userspace API for that though. Better solutions would of =
course
>> be welcome.
>=20
> Maybe I don't understand all of the underlying issues correctly, but a
> parent/child model would seem like a better solution to me. We discusse=
d
> this back when designing the DT bindings for Tegra DRM and came to the
> conclusion that the output resource of the display controller (RGB,
> HDMI, DSI or TVO) was the most suitable candidate to be the parent of
> the panel or display attached to it. The reason for that decision was
> that it keeps the flow of data or addressing of nodes consistent. So th=
e
> chain would look something like this (on Tegra):
>=20
> 	CPU
> 	+-host1x
> 	  +-dc
> 	    +-rgb
> 	    | +-panel
> 	    +-hdmi
> 	      +-monitor
>=20
> In a natural way this makes the output resource the master of the panel=

> or display. From a programming point of view this becomes quite easy to=

> implement and is very similar to how other busses like I2C or SPI are
> modelled. In device tree these would be represented as subnodes, while
> with platform data some kind of lookup could be done like for regulator=
s
> or alternatively a board setup registration mechanism like what's in
> place for I2C or SPI.

You didn't explicitly say it, but I presume you are talking about the
device model for panels, not just how to refer to the outputs.

How would you deal with a, say, DPI panel that is controlled via I2C or
SPI? You can have the panel device be both a panel device, child of a
RGB output, and an i2c device.

The model you propose is currently used in omapdss, and while it seems
simple and logical, it's not that simple with panels/chips with separate
control and data busses.

I think it makes more sense to consider the device as a child of the
control bus. So a DPI panel controlled via I2C is an I2C device, and it
just happens to use a DPI video output as a resource (like it could use
a regulator, gpio, etc).

 Tomi



--------------enigE32ACE99085A2D4F4123C18C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJQsHQqAAoJEPo9qoy8lh71JDgQAI0yQcQMvDJj9TesIGM4Mfeh
XRvwDUgRlk8GEUs+hc1cslzNi/D1jvlas2GP7E60+yHDvrPYa/p/vTMh6VaO4S1n
2vxCIRieVSCsg9SEOmf1JT39SeJb/rhBJgfRkuP1oKlM+n6rMhUXwYgwOqJ9Oop+
+01Gs2Hbln8P/hGUK80GlW+o2O14vvEAJe5WkhA/MsQYx1vE/8KmHT9TKlOFo9Q6
FiKqeIfNseHJ58x4X59+cb/HXRb80/I5S7YVxhAjKEtu+m/PXyB/e/1bu/rcDnyb
tnXjpEtcFk5OCV3oWU6LiRmKcwJXzw35uvYFrQHy7S2KyHmxF2RF6kcQcTKZpRoB
yIYXoKR2R/fCSQlX6ibhK5GjC8ovcUKtzIIQ0Qo9w0usA7/BXPUpyU814uWlOM1g
CelufHVA2AZ/pBkGHULuvN3I4bRr52iTZFf+RT3KaeibJ0sNvnyRhHghpG2jZ9Xa
7rvvu9+VkpzdOEwtzq4yJoj/0utGnvm/ejPOf/CZ61g8J3SVB+DzLrbx+UJZP+AB
Fnk61IwYQi8rwxfD2RK8n4Xus+JBNuLWCLQRnOIgMmRVu5zMC3nS6X9mHP8A4+M9
Nu5g2hlIhoOBEfBspzh/vPPlI9SroBdy6dR5qkWWqA3+CCmgSJJN/4wCBQjlWBcv
jd4Daz23XWJ2LGFAlhe5
=5OsQ
-----END PGP SIGNATURE-----

--------------enigE32ACE99085A2D4F4123C18C--
