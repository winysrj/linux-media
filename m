Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37484 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758654Ab2DYDHn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Apr 2012 23:07:43 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1SMsZv-00018M-51
	for linux-media@vger.kernel.org; Wed, 25 Apr 2012 05:07:39 +0200
Received: from d67-193-214-242.home3.cgocable.net ([67.193.214.242])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 25 Apr 2012 05:07:39 +0200
Received: from brian by d67-193-214-242.home3.cgocable.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 25 Apr 2012 05:07:39 +0200
To: linux-media@vger.kernel.org
From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: Re: HVR-1600 QAM recordings with slight glitches in them
Date: Tue, 24 Apr 2012 23:07:29 -0400
Message-ID: <jn7pph$qed$1@dough.gmane.org>
References: <jn2ibp$pot$1@dough.gmane.org> <1335307344.8218.11.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigAD42B2B7A357E30900119374"
In-Reply-To: <1335307344.8218.11.camel@palomino.walls.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigAD42B2B7A357E30900119374
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 12-04-24 06:42 PM, Andy Walls wrote:
>=20
> Signal level varaition coupled with the HVR-1600's, at times, mediocre
> digital tuning side:

Ahh.  Pity.
=20
> Run 'femon' on the cx18's dvb frontend when you have a live QAM capture=

> ongoing.

OK.  Ran it all evening during the evening capture window.  Started it
at 20:30, sharp to coincide with the evening's recording from that card
also starting at 20:30 sharp.  Here's where it found anomalies:

$ nl /var/tmp/femon.out | grep -v "| ber 00000000 | unc 00000000 |"

So you can see, since femon prints an output line each second, the
number on the left is the seconds since 20:30 and we are looking
for any line showing a ber or unc that is non-zero:

     1	FE: Samsung S5H1409 QAM/8VSB Frontend (ATSC)
    67	status SCVYL | signal 013a | snr 013a | ber 00000198 | unc 0000019=
8 | FE_HAS_LOCK
   313	status SCVYL | signal 013c | snr 013c | ber 0000026b | unc 0000026=
b | FE_HAS_LOCK
   457	status SCVYL | signal 013a | snr 013a | ber 0000026e | unc 0000026=
e | FE_HAS_LOCK
   802	status SCVYL | signal 013c | snr 013c | ber 00000265 | unc 0000026=
5 | FE_HAS_LOCK
  1093	status SCVYL | signal 013a | snr 013a | ber 0000014b | unc 0000014=
b | FE_HAS_LOCK
  1184	status SCVYL | signal 013a | snr 013a | ber 000001ca | unc 000001c=
a | FE_HAS_LOCK
  1192	status SCVYL | signal 013a | snr 013a | ber 00000267 | unc 0000026=
7 | FE_HAS_LOCK
  1385	status SCVYL | signal 013c | snr 013c | ber 0000025d | unc 0000025=
d | FE_HAS_LOCK
  1435	status SCVYL | signal 013c | snr 013c | ber 00000268 | unc 0000026=
8 | FE_HAS_LOCK
  1511	status SCVYL | signal 013c | snr 013c | ber 0000026c | unc 0000026=
c | FE_HAS_LOCK
  1657	status SCVYL | signal 013a | snr 013a | ber 0000026a | unc 0000026=
a | FE_HAS_LOCK
  1693	status SCVYL | signal 013a | snr 013c | ber 0000026f | unc 0000026=
f | FE_HAS_LOCK
  1749	status SCVYL | signal 013c | snr 013c | ber 00000184 | unc 0000018=
4 | FE_HAS_LOCK
  1796	status SCVYL | signal 013a | snr 013a | ber 00001a8b | unc 00001a8=
b | FE_HAS_LOCK
  1814	status SCVYL | signal 013c | snr 013c | ber 0000026d | unc 0000026=
d | FE_HAS_LOCK
  2028	status SCVYL | signal 013c | snr 013c | ber 00000275 | unc 0000027=
5 | FE_HAS_LOCK
  2081	status SCVYL | signal 013c | snr 013c | ber 0000023a | unc 0000023=
a | FE_HAS_LOCK
  2261	status SCVYL | signal 013c | snr 013c | ber 00000264 | unc 0000026=
4 | FE_HAS_LOCK
  2307	status SCVYL | signal 013c | snr 013c | ber 00000279 | unc 0000027=
9 | FE_HAS_LOCK
  2318	status SCVYL | signal 013c | snr 013c | ber 0000026b | unc 0000026=
b | FE_HAS_LOCK
  2474	status SCVYL | signal 013a | snr 013a | ber 0000026f | unc 0000026=
f | FE_HAS_LOCK
  2533	status SCVYL | signal 013c | snr 013c | ber 00000098 | unc 0000009=
8 | FE_HAS_LOCK
  2612	status SCVYL | signal 013a | snr 013a | ber 0000026a | unc 0000026=
a | FE_HAS_LOCK
  2627	status SCVYL | signal 013c | snr 013c | ber 00000108 | unc 0000010=
8 | FE_HAS_LOCK
  2671	status SCVYL | signal 013c | snr 013c | ber 00000196 | unc 0000019=
6 | FE_HAS_LOCK
  2870	status SCVYL | signal 013c | snr 013c | ber 00000264 | unc 0000026=
4 | FE_HAS_LOCK
  3084	status SCVYL | signal 013c | snr 013c | ber 00000274 | unc 0000027=
4 | FE_HAS_LOCK
  3220	status SCVYL | signal 013c | snr 013c | ber 00000275 | unc 0000027=
5 | FE_HAS_LOCK
  3323	status SCVYL | signal 013c | snr 013c | ber 0000026b | unc 0000026=
b | FE_HAS_LOCK
  3406	status SCVYL | signal 013c | snr 013c | ber 0000024f | unc 0000024=
f | FE_HAS_LOCK
  3433	status SCVYL | signal 013c | snr 013a | ber 0000022a | unc 0000022=
a | FE_HAS_LOCK
  3946	status SCVYL | signal 013c | snr 013c | ber 00000270 | unc 0000027=
0 | FE_HAS_LOCK
  4129	status SCVYL | signal 013c | snr 013c | ber 0000026d | unc 0000026=
d | FE_HAS_LOCK
  4275	status SCVYL | signal 013c | snr 013c | ber 00000273 | unc 0000027=
3 | FE_HAS_LOCK
  4284	status SCVYL | signal 013c | snr 013c | ber 00000267 | unc 0000026=
7 | FE_HAS_LOCK
  4411	status SCVYL | signal 013c | snr 013c | ber 00000270 | unc 0000027=
0 | FE_HAS_LOCK
  4718	status SCVYL | signal 013c | snr 013c | ber 00000204 | unc 0000020=
4 | FE_HAS_LOCK
  4779	status SCVYL | signal 013c | snr 013c | ber 00000181 | unc 0000018=
1 | FE_HAS_LOCK
  4927	status SCVYL | signal 013c | snr 013c | ber 0000025e | unc 0000025=
e | FE_HAS_LOCK
  4973	status SCVYL | signal 013c | snr 013c | ber 00000157 | unc 0000015=
7 | FE_HAS_LOCK
  5024	status SCVYL | signal 013c | snr 013c | ber 0000024c | unc 0000024=
c | FE_HAS_LOCK
  5310	status SCVYL | signal 013c | snr 013c | ber 00000190 | unc 0000019=
0 | FE_HAS_LOCK
  5328	status SCVYL | signal 013c | snr 013c | ber 00000277 | unc 0000027=
7 | FE_HAS_LOCK
  5439	status SCVYL | signal 013a | snr 013a | ber 0000026a | unc 0000026=
a | FE_HAS_LOCK
  5441	status SCVYL | signal 0138 | snr 0138 | ber 0000024f | unc 0000024=
f | FE_HAS_LOCK
  5447	status SCVYL | signal 0138 | snr 0138 | ber 00000266 | unc 0000026=
6 | FE_HAS_LOCK
  5885	status SCVYL | signal 013a | snr 013a | ber 000000b3 | unc 000000b=
3 | FE_HAS_LOCK
  5928	status SCVYL | signal 013a | snr 013a | ber 0000020b | unc 0000020=
b | FE_HAS_LOCK
  5942	status SCVYL | signal 013a | snr 013a | ber 0000026b | unc 0000026=
b | FE_HAS_LOCK
  5966	status SCVYL | signal 013a | snr 013a | ber 000004d4 | unc 000004d=
4 | FE_HAS_LOCK
  6178	status SCVYL | signal 013a | snr 013a | ber 0000026c | unc 0000026=
c | FE_HAS_LOCK
  6657	status SCVYL | signal 0138 | snr 013a | ber 0000026e | unc 0000026=
e | FE_HAS_LOCK
  6761	status SCVYL | signal 013a | snr 013a | ber 00000268 | unc 0000026=
8 | FE_HAS_LOCK
  6769	status SCVYL | signal 013a | snr 013a | ber 00000276 | unc 0000027=
6 | FE_HAS_LOCK
  6777	status SCVYL | signal 013a | snr 013a | ber 00000277 | unc 0000027=
7 | FE_HAS_LOCK
  6814	status SCVYL | signal 013a | snr 013a | ber 00000267 | unc 0000026=
7 | FE_HAS_LOCK
  6868	status SCVYL | signal 0138 | snr 0138 | ber 00000171 | unc 0000017=
1 | FE_HAS_LOCK
  6881	status SCVYL | signal 0138 | snr 0138 | ber 00000198 | unc 0000019=
8 | FE_HAS_LOCK
  6891	status SCVYL | signal 0136 | snr 0138 | ber 00000249 | unc 0000024=
9 | FE_HAS_LOCK
  6924	status SCVYL | signal 0138 | snr 0138 | ber 0000026b | unc 0000026=
b | FE_HAS_LOCK
  7116	status SCVYL | signal 0138 | snr 0138 | ber 00000150 | unc 0000015=
0 | FE_HAS_LOCK
  7119	status SCVYL | signal 0138 | snr 0138 | ber 00000197 | unc 0000019=
7 | FE_HAS_LOCK
  7140	status SCVYL | signal 0138 | snr 0138 | ber 00000270 | unc 0000027=
0 | FE_HAS_LOCK
  7602	status SCVYL | signal 0138 | snr 0138 | ber 00000264 | unc 0000026=
4 | FE_HAS_LOCK
  7716	status SCVYL | signal 0138 | snr 0138 | ber 00000194 | unc 0000019=
4 | FE_HAS_LOCK
  7732	status SCVYL | signal 0138 | snr 0138 | ber 00000272 | unc 0000027=
2 | FE_HAS_LOCK
  7751	status SCVYL | signal 013a | snr 0138 | ber 00000181 | unc 0000018=
1 | FE_HAS_LOCK
  7770	status SCVYL | signal 013a | snr 013a | ber 00000270 | unc 0000027=
0 | FE_HAS_LOCK
  7781	status SCVYL | signal 0138 | snr 0138 | ber 0000026f | unc 0000026=
f | FE_HAS_LOCK
  7796	status SCVYL | signal 0138 | snr 0138 | ber 00000275 | unc 0000027=
5 | FE_HAS_LOCK
  7808	status SCVYL | signal 0138 | snr 0138 | ber 0000022f | unc 0000022=
f | FE_HAS_LOCK
  7816	status SCVYL | signal 013a | snr 0138 | ber 0000024e | unc 0000024=
e | FE_HAS_LOCK
  7822	status SCVYL | signal 013a | snr 013a | ber 00000270 | unc 0000027=
0 | FE_HAS_LOCK
  7956	status SCVYL | signal 0138 | snr 0138 | ber 00000268 | unc 0000026=
8 | FE_HAS_LOCK
  8008	status SCVYL | signal 0138 | snr 0138 | ber 0000026d | unc 0000026=
d | FE_HAS_LOCK
  8011	status SCVYL | signal 0138 | snr 0138 | ber 00000260 | unc 0000026=
0 | FE_HAS_LOCK
  8232	status SCVYL | signal 013a | snr 013a | ber 0000024b | unc 0000024=
b | FE_HAS_LOCK
  8235	status SCVYL | signal 013a | snr 013a | ber 00000073 | unc 0000007=
3 | FE_HAS_LOCK
  8255	status SCVYL | signal 0138 | snr 0138 | ber 00000254 | unc 0000025=
4 | FE_HAS_LOCK
  8274	status SCVYL | signal 0138 | snr 0138 | ber 0000024e | unc 0000024=
e | FE_HAS_LOCK
  8303	status SCVYL | signal 0138 | snr 0138 | ber 0000017f | unc 0000017=
f | FE_HAS_LOCK
  8305	status SCVYL | signal 0138 | snr 0138 | ber 00000184 | unc 0000018=
4 | FE_HAS_LOCK
  8354	status SCVYL | signal 013a | snr 0138 | ber 00000270 | unc 0000027=
0 | FE_HAS_LOCK
  8442	status SCVYL | signal 0138 | snr 0138 | ber 0000024b | unc 0000024=
b | FE_HAS_LOCK
  8473	status SCVYL | signal 0138 | snr 0138 | ber 0000014b | unc 0000014=
b | FE_HAS_LOCK
  8510	status SCVYL | signal 0138 | snr 0138 | ber 00000253 | unc 0000025=
3 | FE_HAS_LOCK
  8557	status SCVYL | signal 013a | snr 013a | ber 00000260 | unc 0000026=
0 | FE_HAS_LOCK
  8578	status SCVYL | signal 013a | snr 013a | ber 00000259 | unc 0000025=
9 | FE_HAS_LOCK
  8639	status SCVYL | signal 0138 | snr 0138 | ber 00000151 | unc 0000015=
1 | FE_HAS_LOCK
  8742	status SCVYL | signal 013a | snr 0138 | ber 0000018c | unc 0000018=
c | FE_HAS_LOCK
  8820	status SCVYL | signal 0138 | snr 0138 | ber 00000265 | unc 0000026=
5 | FE_HAS_LOCK

First recording of the evening shows "glitches" at the following
intervals:

4
130
157
396
742
790
1035
1035
1035
1071
1134
1146
1203
1256
1328
1338
1378
1602
1638
1694

Not sure if that's a close enough correlation or not.  Not even sure
what those ber and unc values even mean.
=20
> Watch for the BER or UNCorrectable block count to increase at about the=

> same time you view a glitch in the video.  If this is the case, there i=
s
> something about the signal the HVR-1600 is having trouble with.  (The
> older models don't have the best digital tuner and digital demod
> combination out there.)

So just sucky hardware in general?

> If the signal shown in femon is at a relatively high level most of the
> time, then the cable signal probably has an instantaneous signal that
> sometimes overdrives the frontend.  An inline attenuator might make the=

> problem go away.
> If the signal is at a low level, it may drop below threshold
> occasionally.  An in line amplifier, installed as close to where the
> signal comes into you home as possible, might help.

Not sure if those signal and snr values represent normal, low or high
levels.  The values displayed above are fairly representative of the
rest of the samples for the period in terms of signal and snr.
=20
> If it's not signal level related and not DMA related, then it is a
> problem with the cx18 driver feeding things to the DVB core, or a
> problem with the DVB core itself.

I guess I will have to leave that up to the expert(s).  :-)

b.



--------------enigAD42B2B7A357E30900119374
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk+XanEACgkQl3EQlGLyuXDL1ACePSF51aRysy3L/XaHiRqLAuQ4
6jQAoM+7zNyty36sXhvgKv0LnPl+jHEq
=8ifA
-----END PGP SIGNATURE-----

--------------enigAD42B2B7A357E30900119374--

