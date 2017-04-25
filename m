Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f178.google.com ([209.85.216.178]:35119 "EHLO
        mail-qt0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1432175AbdDYQvP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Apr 2017 12:51:15 -0400
Received: by mail-qt0-f178.google.com with SMTP id y33so144998251qta.2
        for <linux-media@vger.kernel.org>; Tue, 25 Apr 2017 09:51:14 -0700 (PDT)
Message-ID: <1493139071.19105.14.camel@ndufresne.ca>
Subject: Re: support autofocus / autogain in libv4l2
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Pavel Machek <pavel@ucw.cz>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>, sre@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
        patrikbachan@gmail.com, serge@hallyn.com, abcloriens@gmail.com,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Date: Tue, 25 Apr 2017 12:51:11 -0400
In-Reply-To: <20170425080815.GD30553@pali>
References: <1487074823-28274-1-git-send-email-sakari.ailus@linux.intel.com>
         <1487074823-28274-2-git-send-email-sakari.ailus@linux.intel.com>
         <20170414232332.63850d7b@vento.lan>
         <20170416091209.GB7456@valkosipuli.retiisi.org.uk>
         <20170419105118.72b8e284@vento.lan> <20170424093059.GA20427@amd>
         <20170424103802.00d3b554@vento.lan> <20170424212914.GA20780@amd>
         <20170424224724.5bb52382@vento.lan> <20170425080538.GA30380@amd>
         <20170425080815.GD30553@pali>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-ZKqXeLq1wCJOnxNru8jm"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-ZKqXeLq1wCJOnxNru8jm
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mardi 25 avril 2017 =C3=A0 10:08 +0200, Pali Roh=C3=A1r a =C3=A9crit=C2=
=A0:
> On Tuesday 25 April 2017 10:05:38 Pavel Machek wrote:
> > > > It would be nice if more than one application could be
> > > > accessing the
> > > > camera at the same time... (I.e. something graphical running
> > > > preview
> > > > then using command line tool to grab a picture.) This one is
> > > > definitely not solveable inside a library...
> > >=20
> > > Someone once suggested to have something like pulseaudio for V4L.
> > > For such usage, a server would be interesting. Yet, I would code
> > > it
> > > in a way that applications using libv4l will talk with such
> > > daemon
> > > in a transparent way.
> >=20
> > Yes, we need something like pulseaudio for V4L. And yes, we should
> > make it transparent for applications using libv4l.
>=20
> IIRC there is already some effort in writing such "video" server
> which
> would support accessing more application into webcam video, like
> pulseaudio server for accessing more applications to microphone
> input.
>=20

Because references are nice:

https://blogs.gnome.org/uraeus/2015/06/30/introducing-pulse-video/
https://gstconf.ubicast.tv/videos/camera-sharing-and-sandboxing-with-pinos/

And why the internals are not going to be implemented using GStreamer in th=
e end:
https://gstconf.ubicast.tv/videos/keep-calm-and-refactor-about-the-essence-=
of-gstreamer/

regards,
Nicolas
--=-ZKqXeLq1wCJOnxNru8jm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlj/fn8ACgkQcVMCLawGqBxOswCfXZ0cpLIBlcx2T5lVGYMmE3eh
4/oAoMDK6rNBgObMobkvuiHw6AVtZh63
=Z0Fm
-----END PGP SIGNATURE-----

--=-ZKqXeLq1wCJOnxNru8jm--
