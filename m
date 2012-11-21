Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:51322 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755259Ab2KUQsR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Nov 2012 11:48:17 -0500
Message-ID: <50AD05B9.9040909@ti.com>
Date: Wed, 21 Nov 2012 18:47:53 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
MIME-Version: 1.0
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
CC: <devicetree-discuss@lists.ozlabs.org>,
	Rob Herring <robherring2@gmail.com>,
	<linux-fbdev@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Thierry Reding <thierry.reding@avionic-design.de>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	<linux-media@vger.kernel.org>,
	Stephen Warren <swarren@wwwdotorg.org>,
	<kernel@pengutronix.de>,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	David Airlie <airlied@linux.ie>
Subject: Re: [PATCH v12 4/6] fbmon: add of_videomode helpers
References: <1353426896-6045-1-git-send-email-s.trumtrar@pengutronix.de> <1353426896-6045-5-git-send-email-s.trumtrar@pengutronix.de> <50ACCDDA.2070606@ti.com> <20121121162436.GB12657@pengutronix.de>
In-Reply-To: <20121121162436.GB12657@pengutronix.de>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigC7763C51364F1D39676A556E"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--------------enigC7763C51364F1D39676A556E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2012-11-21 18:24, Steffen Trumtrar wrote:
> On Wed, Nov 21, 2012 at 02:49:30PM +0200, Tomi Valkeinen wrote:

>>> @@ -715,6 +717,11 @@ extern void fb_destroy_modedb(struct fb_videomod=
e *modedb);
>>>  extern int fb_find_mode_cvt(struct fb_videomode *mode, int margins, =
int rb);
>>>  extern unsigned char *fb_ddc_read(struct i2c_adapter *adapter);
>>> =20
>>> +#if IS_ENABLED(CONFIG_OF_VIDEOMODE)
>>> +extern int of_get_fb_videomode(const struct device_node *np,
>>> +			       struct fb_videomode *fb,
>>> +			       unsigned int index);
>>> +#endif
>>>  #if IS_ENABLED(CONFIG_VIDEOMODE)
>>>  extern int fb_videomode_from_videomode(const struct videomode *vm,
>>>  				       struct fb_videomode *fbmode);
>>
>> Do you really need these #ifs in the header files? They do make it loo=
k
>> a bit messy. If somebody uses the functions and CONFIG_VIDEOMODE is no=
t
>> enabled, he'll get a linker error anyway.
>>
>=20
> Well, I don't remember at the moment who requested this, but it was not=
 my
> idea to put them there. So, this is a matter of style I guess.
> But maybe I understood that wrong.

Right, one reviewer says this way, and another says that way =3D).

With the header files I've made I only use #ifs with #else, when I want
to give a static inline empty/no-op implementation for the function in
case the feature is not compiled into the kernel.

As you said, matter of taste. Up to you.

 Tomi



--------------enigC7763C51364F1D39676A556E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iQIcBAEBAgAGBQJQrQW5AAoJEPo9qoy8lh71K8YP/2FV39JzQG+Wr/vQhLzk5Uh/
QaMhCx33KHJ0U/Z0iqxiR9X24IUXex2c4qj2xccmEOs1BKQC/vT5HXMFgIHhHAs/
DO5yB3eVPsMe+ymXeSe0TM6QpfLZLbIgX6GkuZ32w9TtXsO32cZb+ohxRtdOsRpW
NDG0oR5leJAQOhFjuQj+9M4AFjuML4o6/LMorX4zxRpUU0L8FUBDvL9c3MiwqLR5
MZR1rpaELel5aP6TJNqSMshiHW5HZrp2XgoTU4/6GoBZ+nLDzxTmvztDVkoNqXK0
V6Edbe9KraIqnyQfFBtu9rsAR7wPWkAQxYbLOi1l6SbNGGvPGKORfIwXq/IxPwsz
rbfILzcGfTMzL9KUQ13PyZh9ruiGmpcZAPsJ02Zou6qaG+OAl14d1kpyooT0z7El
mQk2a+9q0UsM52VjJd8PhOG1sL7AXNPv25Gq8NZMDWEzR/0O4En2MVYXTzYimYMR
S5e+HONIMkdvqL7i/JMia6ml2hIi9tULUPL1qSAfvgPODFPJA4jCezRriKDXxX35
Z5rdkukuWHPHt89CPmOK2G9if3PB6WjuC6c3YUxQVXnJJkKn8uNkxeVnie0iTYJN
9VugOpfdqODgSD4d+HlCII3gnhrwQi/JeNZP5zft7jvdcC06rqmNFoWF33tUrO+c
GmOu+dfYxA7yYA5CBMHM
=PB4R
-----END PGP SIGNATURE-----

--------------enigC7763C51364F1D39676A556E--
