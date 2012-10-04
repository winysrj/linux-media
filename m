Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.interlinx.bc.ca ([216.58.37.5]:51705 "EHLO
	linux.interlinx.bc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965200Ab2JDOxZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2012 10:53:25 -0400
Message-ID: <506DA2E2.1030509@interlinx.bc.ca>
Date: Thu, 04 Oct 2012 10:53:22 -0400
From: "Brian J. Murrell" <brian@interlinx.bc.ca>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-media@vger.kernel.org
Subject: Re: hvr-1600 fails frequently on multiple recordings
References: <506D79DE.3040403@interlinx.bc.ca> <CAGoCfixs4QEYO+B7JgGYaENzxfAzZ3OXTBxQ+4VyHVjaveu7Gw@mail.gmail.com>
In-Reply-To: <CAGoCfixs4QEYO+B7JgGYaENzxfAzZ3OXTBxQ+4VyHVjaveu7Gw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig40CC5853A10BF0382C1B7FFF"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig40CC5853A10BF0382C1B7FFF
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12-10-04 10:18 AM, Devin Heitmueller wrote:
>=20
> I think the real question at this point is: what version of MythTV are
> you running?

0.25-fixes, specifically 46cab93 from 20120801.  Indeed, not the latest,
but I don't think much if anything has been done in the affected code
paths.  I want to upgrade and even thought about doing it today but
today I also moved the HVR-1600 into secondary duty (and promoted the
HVR-950Q) and didn't want to make another change which would only
confuse the original cause.

I understand that making such a change is not ideal in terms of
debugging, but the grief of having a whole night of television
recordings fail just causes too much strife here.  And most nights it
wouldn't really matter but of course it has to happen on the one night
of the week that people here have to watch a show the same night it's
broadcast or else hear about all of the spoilers at work the next day.  :=
-(

> I've seen so many reports recently of breakage in the
> MythTV codebase related to recording, I am almost inclined to demand
> you reproduce it outside of MythTV before we even spend any time
> talking about it.

That's fair enough I suppose.  The one problem is that this problem is
very intermittent.  It only happens about once a week or so, not really
at the same time every week though so not nearly repeatable.

Is there much more to recording from these devices though than:

# [ tune channel ]
# cat < $device > $file

akin to recording from PVR-x50s?  I guess what I'm driving at is how
much/little code are we talking about in Mythtv to do this?

> Also, has anything changed in your environment?

Nothing other than the HVR-1600 being somewhat new.  It has not really
been worked hard since I got it given that I got it in the "low season".
 Now that fall is here there is lots more on television and the card is
being asked to perform multiplexed recordings way more frequently.

> Was it working
> before,

Yes, but has always been on "light duty" since I got it.

> and then you upgraded the kernel or Myth, and now it's not
> working?

Nope.  No upgrades correlating.

> Or has there been a consistent pattern of failure over some
> extended period of time?

Well, it's happened now 2-3 times since the start of the fall season,
which means when it's being asked to do more.

> The cx18 driver has changed very little as of late - the MythTV
> codebase has changed heavily and people are all over the place
> complaining about breakage.

Which does seem like a fair correlation.  The only other possibility I
am considering is a defective card since it's never really proven itself
yet.

> I'm not trying to get into the finger-pointing game,

No, I completely understand your perspective and these are all very fair
questions.  I hope you will allow me to be devil's advocate in hopes of
getting to the bottom of it.  :-)

> but I just want
> to better understand the history/background before I can make any
> recommendations.

Indeed.  Always a good idea.  There's a reason doctors take patient
histories before diagnosing.  :-)

FWIW, I'd be happy to take this over to the mythtv list if you want to
pursue it being a mythtv problem.  I filed a bug about mythtv's
inability to recover from this situation and it deadlocking until killed
(a KILL signal is typically required, demonstrating how badly mythtv is
handling this situation) when this happens and even posted to the list
about the bug but got zero response.

Cheers,
b.




--------------enig40CC5853A10BF0382C1B7FFF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iEYEARECAAYFAlBtouIACgkQl3EQlGLyuXAykwCZAR9sIIotT+VK8yJNDhuibffL
aXYAmwSTVzitWjY9QyJ+SpOQzQDchH3+
=u+L2
-----END PGP SIGNATURE-----

--------------enig40CC5853A10BF0382C1B7FFF--
