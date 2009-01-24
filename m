Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.228]:14580 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625AbZAXBTZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2009 20:19:25 -0500
Received: by rv-out-0506.google.com with SMTP id k40so4979132rvb.1
        for <linux-media@vger.kernel.org>; Fri, 23 Jan 2009 17:19:24 -0800 (PST)
From: Brendon Higgins <blhiggins@gmail.com>
To: linux-media@vger.kernel.org
Subject: Re: Regression since 2.6.25 kernel: Crash of userspace program leaves DVB device unusable
Date: Sat, 24 Jan 2009 11:19:09 +1000
Cc: Andy Walls <awalls@radix.net>
References: <200901031200.56314.blhiggins@gmail.com> <200901191943.06631.blhiggins@gmail.com> <1232418571.22378.4.camel@palomino.walls.org>
In-Reply-To: <1232418571.22378.4.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3662715.jMTxnbimrk";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200901241119.15772.blhiggins@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--nextPart3662715.jMTxnbimrk
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Andy Walls wrote (Tuesday 20 January 2009):
> On Mon, 2009-01-19 at 19:43 +1000, Brendon Higgins wrote:
> > Summary procedure, starting with a working dvb:
> > 1) rmmod cx88_dvb
> > 2) modprobe cx88_dvb
> > Error: No such device.
> > 3) rmmod cx8802
> > 4) modprobe cx88_dvb
> > Success (and cx8802 is pulled in automatically)
> >
> > So it seems there might be some sort of module interdependency not being
> > taken care of.
>
> Yes.  Mauro did some work to decouple these modules in very recent
> changes.  I did some follow-up changes to fix frontend allocations.  You
> may want to try the latest v4l-dvb repository.

Just did that, grabbed v4l-dvb-2ed72b192848, and it seems to be fixed there=
=2E No=20
complaints when rmmoding and modprobing the modules. There's something abou=
t=20
it that xine and mplayer don't seem to like (though I can't be sure they=20
worked previously - FWIW, xine won't change channels and when you try it=20
causes "dvb_demux_feed_del: feed not in list (type=3D0 state=3D0 pid=3Dffff=
)" in=20
syslog, mplayer... well I haven't figured out the interface, anyway), but v=
dr=20
seems just fine with it, which is my primary concern.

It would be my luck that by the time I figure out what's actually going on =
I=20
can't help because it's already fixed. :-)

Peace,
Brendon

--nextPart3662715.jMTxnbimrk
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkl6bI4ACgkQCTfPD0Uw3q+WdgCg1PhhZNrlVGwV69KVEFm7MxxX
r5wAoJyicwEFvMhSDXQYg6QzCxga+4o+
=r5yQ
-----END PGP SIGNATURE-----

--nextPart3662715.jMTxnbimrk--
