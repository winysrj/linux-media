Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36182 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754081Ab2ECQHH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 May 2012 12:07:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1SPyYW-0007dY-Aa
	for linux-media@vger.kernel.org; Thu, 03 May 2012 18:07:00 +0200
Received: from d67-193-214-242.home3.cgocable.net ([67.193.214.242])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 03 May 2012 18:07:00 +0200
Received: from brian by d67-193-214-242.home3.cgocable.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 03 May 2012 18:07:00 +0200
To: linux-media@vger.kernel.org
From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: Re: HVR-1600 QAM recordings with slight glitches in them
Date: Thu, 03 May 2012 12:06:46 -0400
Message-ID: <4FA2AD16.6080807@interlinx.bc.ca>
References: <jn2ibp$pot$1@dough.gmane.org> <1335307344.8218.11.camel@palomino.walls.org> <jn7pph$qed$1@dough.gmane.org> <1335624964.2665.37.camel@palomino.walls.org> <4F9C38BE.3010301@interlinx.bc.ca> <4F9C559E.6010208@interlinx.bc.ca> <4F9C6D68.3090202@interlinx.bc.ca> <CAAMvbhH2o6SZVBU4D2dvUUVuOhtzLdO-R=TCuug7Y9hgZq2gmg@mail.gmail.com> <CAGoCfiwB2jZfeZ2aSQ7FSG-k5XDGJY_ykLPSD3Y3rbrUXmuOdg@mail.gmail.com> <4FA1FBB5.8050106@interlinx.bc.ca> <CAGoCfixTLjnW=q+SHiiRzXaFtqp56Ng5nRMn-u1YfZ1f-zmtwA@mail.gmail.com> <e2d13409-d6fc-47aa-9597-727dd6f7c3ec@email.android.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE304EA8C3DC31B5EBEA4FD1B"
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	stoth@kernellabs.com
In-Reply-To: <e2d13409-d6fc-47aa-9597-727dd6f7c3ec@email.android.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE304EA8C3DC31B5EBEA4FD1B
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 12-05-03 11:37 AM, Andy Walls wrote:
> Devin Heitmueller <dheitmueller@kernellabs.com> wrote:
>>
>> Also, which version of the HVR-1600 is this?  The one with the
>> mxl5005s or the tda18271?  You can check the dmesg output to tell (and=

>> if you cannot tell, please pastebin the dmesg output so I can look).

http://brian.interlinx.bc.ca/hvr-1600-dmesg

> IIRC, Brian had a MXL5005s/S5H1409 variant.

The latter part sounds familiar from femon and gnutv.


> I think Brian might have a bad cable or connector or splitter in the ru=
n feeding the hvr1600.


The same 4-way splitter fed the HVR-950Q and the HVR-1600 and cables
were swapped just about every way they could be to try to get the
HVR-1600's SNR up.

But as I mentioned before, it's now completely non-functional due to the
coax connector on the card having become loose enough to turn (with some
effort, so screwing an female F-connector on/off was still quite
doable).  Perhaps it was marginal before due to that same problem.  I
guess I will never know... unless I try cracking this thing open and
reconnecting whatever has gotten disconnected -- if Hauppage won't RMA
it for me.  They seem to be pretty silent about that now though after an
initial e-mail exchange.

If not, I've got my eye on a KWorld UB435-Q if I can determine that it's
a hardware rev. 1 unit somehow since the store doesn't want to take it
out of the box to check for me.  It's less than half the price of an
HVR-950Q at $40, as much as I would love to stay loyal with Hauppage --
this coax connector on my HVR-1600 coming loose, aside.

Cheers,
b.


--------------enigE304EA8C3DC31B5EBEA4FD1B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk+irRgACgkQl3EQlGLyuXCKnACeJP4RPdqDn7KczyLHXX2+k3BR
xloAoJhtO+1AewbN/hHmO+8uPH7KBu0j
=Bgiu
-----END PGP SIGNATURE-----

--------------enigE304EA8C3DC31B5EBEA4FD1B--

