Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42428 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941611AbcLVUxV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Dec 2016 15:53:21 -0500
Date: Thu, 22 Dec 2016 21:53:17 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sebastian Reichel <sre@kernel.org>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, ivo.g.dimitrov.75@gmail.com,
        pali.rohar@gmail.com, linux-media@vger.kernel.org,
        galak@codeaurora.org, mchehab@osg.samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] media: Add video bus switch
Message-ID: <20161222205317.GA31151@amd>
References: <20161023200355.GA5391@amd>
 <20161119232943.GF13965@valkosipuli.retiisi.org.uk>
 <20161214122451.GB27011@amd>
 <20161222100104.GA30917@amd>
 <20161222133938.GA30259@amd>
 <20161222143244.ykza4wdxmop2t7bg@earth>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="3MwIy2ne0vdjdPXF"
Content-Disposition: inline
In-Reply-To: <20161222143244.ykza4wdxmop2t7bg@earth>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > I see this needs dts documentation, anything else than needs to be
> > done?
>=20
> Yes. This driver takes care of the switch gpio, but the cameras also
> use different bus settings. Currently omap3isp gets the bus-settings
> from the link connected to the CCP2 port in DT at probe time (*).
>=20
> So there are two general problems:
>=20
> 1. Settings must be applied before the streaming starts instead of
> at probe time, since the settings may change (based one the selected
> camera). That should be fairly easy to implement by just moving the
> code to the s_stream callback as far as I can see.

Ok, I see, where "the code" is basically in vbs_link_setup, right?

> 2. omap3isp should try to get the bus settings from using a callback
> in the connected driver instead of loading it from DT. Then the
> video-bus-switch can load the bus-settings from its downstream links
> in DT and propagate the correct ones to omap3isp based on the
> selected port. The DT loading part should actually remain in omap3isp
> as fallback, in case it does not find a callback in the connected driver.
> That way everything is backward compatible and the DT variant is
> nice for 1-on-1 scenarios.

So basically... (struct isp_bus_cfg *) isd->bus would change in
isp_pipeline_enable()...?=20

> Apart from that Sakari told me at ELCE, that the port numbers
> should be reversed to match the order of other drivers. That's
> obviously very easy to do :)

Ok, I guess that can come later :-).

> Regarding the binding document. I actually did write one:
> https://git.kernel.org/cgit/linux/kernel/git/sre/linux-n900.git/commit/?h=
=3Dn900-camera&id=3D81e74af53fe6d180616b05792f78badc615e871f

Thanks, got it.

> So all in all it shouldn't be that hard to implement the remaining
> bits.

:-).

> (*) Actually it does not for CCP2, but there are some old patches
> from Sakari adding it for CCP2. It is implemented for parallel port
> and CSI in this way.

I think I got the patches in my tree. Camera currently works for me.

Thanks,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--3MwIy2ne0vdjdPXF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlhcPT0ACgkQMOfwapXb+vKdLACaAo+1MADdCpuo1Ve5cPqB/9h0
FisAn10qk3OJeERbP4V7VXsilfws77rt
=c8ff
-----END PGP SIGNATURE-----

--3MwIy2ne0vdjdPXF--
