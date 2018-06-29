Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40387 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751740AbeF2JSk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Jun 2018 05:18:40 -0400
Date: Fri, 29 Jun 2018 11:18:38 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Tomasz Figa <tfiga@google.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        nicolas@ndufresne.ca,
        Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>, mario.limonciello@dell.com
Subject: Re: Software-only image processing for Intel "complex" cameras
Message-ID: <20180629091838.GA31718@amd>
References: <20180620203838.GA13372@amd>
 <CAAFQd5DpX2MbwQ484a1Jsk1Uok6eT=oduTYpqjE7AJcmpEs1UA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
Content-Disposition: inline
In-Reply-To: <CAAFQd5DpX2MbwQ484a1Jsk1Uok6eT=oduTYpqjE7AJcmpEs1UA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > On Nokia N900, I have similar problems as Intel IPU3 hardware.
> >
> > Meeting notes say that pure software implementation is not fast
> > enough, but that it may be useful for debugging. It would be also
> > useful for me on N900, and probably useful for processing "raw" images
> > from digital cameras.
> >
> > There is sensor part, and memory-to-memory part, right? What is
> > the format of data from the sensor part? What operations would be
> > expensive on the CPU? If we did everthing on the CPU, what would be
> > maximum resolution where we could still manage it in real time?
>=20
> We can still use the memory-to-memory part (IMGU), even without 3A. It
> would just do demosaicing at default parameters and give us a YUV
> (NV12) frame. We could use some software component to analyze the YUV
> output and adjust sensor parameters accordingly. Possibly the part we
> already have in libv4l2 could just work?

As soon as you get YUV, yes, libv4l2 should be able to work with that.

OTOH using the memory-to-memory part is going to be tricky. What
format is the data before demosaicing? Something common like BGGR10?

> The expensive operation would be analyzing the frame itself. I suppose
> you need to build some histogram representing brightness and white
> balance of the frame and then infer necessary sensor adjustments from
> that.

That does not really have to be expensive. You can sample ... say
10000 pixels from the image, and get good-enough data for 3A.

> > Would it be possible to get access to machine with IPU3, or would
> > there be someone willing to test libv4l2 patches?
>=20
> I should be able to help with some basic testing, preferably limited
> to command line tools (but I might be able to create a test
> environment for X11 tools if really necessary).

Could you just compile libv4l2 with sdlcam demo on the target, and
then ssh -X there from some sort of reasonable system?

Best regards,
								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAls1+W4ACgkQMOfwapXb+vI2ZwCePBQPl0pbcanHWJUYW3Q0FdLN
EnAAniOqPMtKcn0S8jpo6lqERmeD3zQG
=Mkiy
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--
