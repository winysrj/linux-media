Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41464 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751519AbdBJTyj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Feb 2017 14:54:39 -0500
Date: Fri, 10 Feb 2017 20:54:35 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Rob Herring <robh@kernel.org>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Sebastian Reichel <sre@kernel.org>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] devicetree: Add video bus switch
Message-ID: <20170210195435.GA1615@amd>
References: <20161119232943.GF13965@valkosipuli.retiisi.org.uk>
 <20161214122451.GB27011@amd>
 <20161222100104.GA30917@amd>
 <20161222133938.GA30259@amd>
 <20161224152031.GA8420@amd>
 <20170203123508.GA10286@amd>
 <20170208213609.lnemfbzitee5iur2@rob-hp-laptop>
 <20170208223017.GA18807@amd>
 <CAL_JsqKSHvg+iB-SRd=YthauGP8mWeVF0j8X-fgLchwtOppH8A@mail.gmail.com>
 <CAL_JsqLfbAxBbXOyK0QOCc=wPe6=a+qyrAwtdbt3DtspK6oiaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
In-Reply-To: <CAL_JsqLfbAxBbXOyK0QOCc=wPe6=a+qyrAwtdbt3DtspK6oiaw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> >>> > diff --git a/Documentation/devicetree/bindings/media/video-bus-swit=
ch.txt b/Documentation/devicetree/bindings/media/video-bus-switch.txt
> >>> > new file mode 100644
> >>> > index 0000000..1b9f8e0
> >>> > --- /dev/null
> >>> > +++ b/Documentation/devicetree/bindings/media/video-bus-switch.txt
> >>> > @@ -0,0 +1,63 @@
> >>> > +Video Bus Switch Binding
> >>> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> >>>
> >>> I'd call it a mux rather than switch.
> >>
> >> It is a switch, not a multiplexor (
> >> https://en.wikipedia.org/wiki/Multiplexing ). Only one camera can
> >> operate at a time.
> >
> > It's no different than an i2c mux. It's one at a time.

Take a look at the wikipedia. If you do "one at a time" at 100Hz, you
can claim it is time-domain multiplex. But we are plain switching the
cameras. It takes second (or so) to setup the pipeline.

This is not multiplex.

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlieGnsACgkQMOfwapXb+vJ//wCgu++YDF6dtxzCb9BqgCeTHma2
WtQAoLwB9F7vIQDN05S5lLTzadyWPBV7
=rdtk
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--
