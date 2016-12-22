Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:54620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932875AbcLVXLR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Dec 2016 18:11:17 -0500
Date: Fri, 23 Dec 2016 00:11:10 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, ivo.g.dimitrov.75@gmail.com,
        pali.rohar@gmail.com, linux-media@vger.kernel.org,
        galak@codeaurora.org, mchehab@osg.samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] media: Add video bus switch
Message-ID: <20161222231109.p2vc35pafk7s4arv@earth>
References: <20161023200355.GA5391@amd>
 <20161119232943.GF13965@valkosipuli.retiisi.org.uk>
 <20161214122451.GB27011@amd>
 <20161222100104.GA30917@amd>
 <20161222133938.GA30259@amd>
 <20161222143244.ykza4wdxmop2t7bg@earth>
 <20161222205317.GA31151@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="a2hvqgaug272bmc4"
Content-Disposition: inline
In-Reply-To: <20161222205317.GA31151@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--a2hvqgaug272bmc4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Dec 22, 2016 at 09:53:17PM +0100, Pavel Machek wrote:
> > 1. Settings must be applied before the streaming starts instead of
> > at probe time, since the settings may change (based one the selected
> > camera). That should be fairly easy to implement by just moving the
> > code to the s_stream callback as far as I can see.
>=20
> Ok, I see, where "the code" is basically in vbs_link_setup, right?

I'm not talking about the video bus switch, but about omap3isp.
omap3isp must update the buscfg registers when it starts streaming
instead of at probe time. I just checked and it actually seems to do
so already. So the problem is only updating the buscfg inside of
ccp2_s_stream() before writing the device registers. See next
paragraph for more details.

> > 2. omap3isp should try to get the bus settings from using a callback
> > in the connected driver instead of loading it from DT. Then the
> > video-bus-switch can load the bus-settings from its downstream links
> > in DT and propagate the correct ones to omap3isp based on the
> > selected port. The DT loading part should actually remain in omap3isp
> > as fallback, in case it does not find a callback in the connected drive=
r.
> > That way everything is backward compatible and the DT variant is
> > nice for 1-on-1 scenarios.
>=20
> So basically... (struct isp_bus_cfg *) isd->bus would change in
> isp_pipeline_enable()...?=20

isp_of_parse_node_csi1(), which is called by isp_of_parse_node()
inits buscfg using DT information. This does not work for N900,
which needs two different buscfg settings based on the selected
camera. I suggest to add a callback to the subdevice instead.

So something like pseudocode is needed in ccp2_s_stream():

/* get current buscfg */
if (subdevice->get_buscfg)
    buscfg =3D subdevice->get_buscfg();
else
    buscfg =3D isp_of_parse_node_csi1();

/* configure device registers */
ccp2_if_configure(buscfg);

This new callback must be implemented in the video-bus-switch,
so that it returns the buscfg based upon the selected camera.

> > Apart from that Sakari told me at ELCE, that the port numbers
> > should be reversed to match the order of other drivers. That's
> > obviously very easy to do :)
>=20
> Ok, I guess that can come later :-).
>=20
> > Regarding the binding document. I actually did write one:
> > https://git.kernel.org/cgit/linux/kernel/git/sre/linux-n900.git/commit/=
?h=3Dn900-camera&id=3D81e74af53fe6d180616b05792f78badc615e871f
>=20
> Thanks, got it.
>=20
> > So all in all it shouldn't be that hard to implement the remaining
> > bits.
>=20
> :-).
>=20
> > (*) Actually it does not for CCP2, but there are some old patches
> > from Sakari adding it for CCP2. It is implemented for parallel port
> > and CSI in this way.
>=20
> I think I got the patches in my tree. Camera currently works for me.

If you have working camera you have the CCP2 DT patches in your tree.
They are not yet mainline, though. As far as I can see.

-- Sebastian

--a2hvqgaug272bmc4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlhcXYoACgkQ2O7X88g7
+pp4fQ/9F5xRtApJ6iIqn90kw+kA2UngH+k5T8tiYhPepPxPgOMA/A/ZvcCGru7n
vzoJEb8r0TzFWseEbMPSD9NSNiUn/KnFeEO8Xbb7UhKWdx1pkFZ85cmzC9wz2RF4
jmLXIiCaeKUwzS08ZlY58+eRqreMcxrc792SwiZ7B3MTOdG3uSV7lkD1Jl+M0pH9
eCOmR779jFWSHQhBSj6vpkAiLcrjh70uvZT1PSEykecP7JRw8bBQQQnVubvEuI+3
i9f7o+NMelCw6d3fT7Bcz67XozMr85Kjlupk5YySpvMwG/5AIef8+X8mU0KnFfsM
kzSwufSaJwo3CDwZua3T0KxGxsvc0j5yvMU9dO5Q2MoBIJaYnWEH+98YP6gWXwmO
CMYg+s/aGY8PsFBZGYJccZGYn2BPEps7rSRvv110nLWtq2uKqPda+EDY/LU0E2Rv
Ja8RgrI6QjeNNxUh+tU43mO94X6SXJ0hA/v/qM0Et8zAslpO85DNTeT1a3Df0cIg
hNVyFnfnpdO1pePIvv9IorXcV0palv97NIAACpw+CaX5eQmv7K9PmJxpQlTOYGB8
w9ykWV16Zl2Qr2K/zPKSoozIOImEv1nsg/Ji/rZCa4GKaYj6POfG/A/JYHHfODs/
d7tzHjilTxIJx1F9gzzhj9MNrWqmNLr9LxKWSjR9CzzZwIJ0k/g=
=6BXG
-----END PGP SIGNATURE-----

--a2hvqgaug272bmc4--
