Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54581 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637Ab2D1SIw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Apr 2012 14:08:52 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1SOC4f-0006Ie-9Z
	for linux-media@vger.kernel.org; Sat, 28 Apr 2012 20:08:49 +0200
Received: from d67-193-214-242.home3.cgocable.net ([67.193.214.242])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sat, 28 Apr 2012 20:08:49 +0200
Received: from brian by d67-193-214-242.home3.cgocable.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sat, 28 Apr 2012 20:08:49 +0200
To: linux-media@vger.kernel.org
From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: Re: HVR-1600 QAM recordings with slight glitches in them
Date: Sat, 28 Apr 2012 14:08:35 -0400
Message-ID: <4F9C3223.10501@interlinx.bc.ca>
References: <jn2ibp$pot$1@dough.gmane.org>  <1335307344.8218.11.camel@palomino.walls.org>  <jn7pph$qed$1@dough.gmane.org> <1335624964.2665.37.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8E9229CCA8FDACAC533E31A9"
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	stoth@kernellabs.com
In-Reply-To: <1335624964.2665.37.camel@palomino.walls.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8E9229CCA8FDACAC533E31A9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 12-04-28 10:56 AM, Andy Walls wrote:
>=20
> grepping out the 0 lines doesn't let one see the trends in Signal to
> Noise Ratio (SNR) before and after the uncorrectable (unc) block counts=
=2E

OK.  I have completely reworked the way I use femon.  I now start/stop
femon along with recordings so I should have a separate femon output for
each recording (using Mythtv system events and a couple of recording
start/stop scripts, fwiw).

> So I see SNR values from 0x138 to 0x13c ( 31.2 dB to 31.6 dB ) when you=

> have problems.  For 256-QAM cable signals, I think that is considered
> marginal. =20

OK.  Good to know.

> (Can someone else with 256-QAM North American cable please confirm? I
> only have OTA)

Would be great if somebody can.  Thanks in advance.

> When you have no errors, what is the SNR?  I'm guessing there are no
> large swings.

=46rom what I recall of the data, no, the SNR was pretty much the same
throughout good and bad periods of the recordings.  But with my
configuration here, we will know for sure soon enough.

> Hard to tell, given that one of the other digital sub-channels may have=

> been effected and not visible on the channel you were recording.

Ahhh.  I see.

> I normally watch DTV live with mplayer, and also have femon open in
> another window, when performing this sort of test.

That's effectively what I am doing with my recordings.  When a recording
starts, an femon starts and logs.  When the recording is done I use
mplayer (-nosound -vo null -benchmark, just to make it run as fast as
possible) and prune out the per frame counters so that what I am left
with is the bits that mplayer complains about in the stream along with
the frame count it happened at.  The femon output is also included for
cross reference.

> A video or audio
> glitch, 1 or 2 seconds after a non-zero uncorrectable block count, is
> usually a good indicator of correlation.

That's what I will look for.

> Well, not the best performer from what I hear.

Indeed.  I don't have any of these problems with my HVR-950Q.  This
HVR-1600 was a really good deal though, so I can't totally complain.  :-)=


Speaking of the HVR-950Q, does femon not work with it?  I seem to always
get "zero" values across the board trying.

> But certainly works just
> fine for many people in many contexts.

Yes, and indeed, it works here for the most part even with small
glitches some of the time.  But some other times, the glitching is bad
enough to make a recording more or less useless.

> OK.  There are two ways to go here:
>=20
> 1. We assume your signal is marginal.  Take a look here for things to
> check and fix if needed:
>=20
> http://ivtvdriver.org/index.php/Howto:Improve_signal_quality

I will see what I can do with those.

> As a test, you you might also want to temporarily change your coax
> wiring setup to reduce the number of splits and connectors before the
> signal goes into the HVR-1600, and see if things are better.

Indeed.  That was at the top of my list also, so isolate the rest of the
cable plant in here.

> Every
> 2-way splitter will drop 3-5 dB of signal.

OK.  So about splitters.  Given that I'm in a house with 4 cable
television runs to different rooms, plus a cable modem, plus 4 PVR tuner
inputs (so yeah, 9 consumers), what is my best splitter plan/options.
Probably ideally I want to split the incoming signal into two, one for
the cable modem and one to feed the television consumers.

Once I have the feed off to the televisions though, am I best trying to
split that into 8, (i.e. equally with an 8-way splitter -- if that's
even possible) or would I be better served with some more smaller splits
in somewhat of a tree formation?

I'm also assuming that all splitters are not of the same quality and
that the "dollar store" ones are likely of inferior quality.  But
"dollar store" aside, even amongst reasonable retailers, how can I tell
(without having to get all electronics geeky with an oscilliscope and
whatnot) what's good and what's bad?

Also, splitting 8 ways, am I into amplification/boosting territory or am
I likely to just boost noise along with the signal?

> 2. We assume your signal is too strong, and that it is overdriving the
> MXL5005s digital tuner of the HVR-1600, causing problems for the CX2422=
7
> demodulator.

Heh.  I wonder if that could be possible given my description above.  :-)=


> Your corrective action here would be to attenuate the incoming RF signa=
l
> with either an inline attenuator, or with additional, properly
> terminated, splitters.

Indeed.

Thanks sooooo much for all of the input here.

Cheers,
b.


--------------enig8E9229CCA8FDACAC533E31A9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk+cMiMACgkQl3EQlGLyuXCgvQCglORlhXLdCRurcz4liIgOXIpG
qCQAn3MBD9nAyTOoazwB2qG5WAFzoB/I
=YPLN
-----END PGP SIGNATURE-----

--------------enig8E9229CCA8FDACAC533E31A9--

