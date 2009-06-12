Return-path: <linux-media-owner@vger.kernel.org>
Received: from os.inf.tu-dresden.de ([141.76.48.99]:42795 "EHLO
	os.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbZFLAAL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2009 20:00:11 -0400
Date: Fri, 12 Jun 2009 02:00:01 +0200
From: "Udo A. Steinberg" <udo@hypervisor.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: v4l-dvb-maintainer@linuxtv.org, linux-media@vger.kernel.org
Subject: Re: [v4l-dvb-maintainer] 2.6.30: missing audio device in bttv
Message-ID: <20090612020001.440e9ac5@laptop.hypervisor.org>
In-Reply-To: <200906120101.59458.hverkuil@xs4all.nl>
References: <20090611221402.66709817@laptop.hypervisor.org>
	<200906112346.48528.hverkuil@xs4all.nl>
	<20090612003526.24f1213c@laptop.hypervisor.org>
	<200906120101.59458.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/RNfbw88c5HVpYbg6fypZhfc";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/RNfbw88c5HVpYbg6fypZhfc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 12 Jun 2009 01:01:59 +0200 Hans Verkuil (HV) wrote:

HV> I've fixed the problem in my original patch. I've attached the new
HV> version. It works fine with ivtv, the problems with reading the eeprom
HV> are now fixed. Please test and if it still doesn't work then I'll have
HV> to install my bttv card in my PC and test again. But that will be
HV> tomorrow evening.

Reading the eeprom works with your patch.

HV> BTW, it would be nice if you can confirm that everything is working fine
HV> if you compile bttv as a module. Just to make sure that this is related
HV> to the in-kernel build. The other person who had this problem (and who
HV> had a very similar card) said that it was working after moving that line
HV> in the Makefile.

That works, too.

Meanwhile I've figured out that the audio problems are related to ALSA. The
BTTV audio signal is fed via a cable to the line-in of my on-board sound.
I've verified that there is audio going over that cable. So I'll talk to the
ALSA folks about the issue.

Thanks for your help, Hans.

Cheers,

	- Udo

--Sig_/RNfbw88c5HVpYbg6fypZhfc
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkoxmoEACgkQnhRzXSM7nSnEvgCfYaiDm5WWWtlI7Z8jCGm6OMBt
cFcAn2zcuxAok2QY3NGjMdSKfs5oQOl2
=2juK
-----END PGP SIGNATURE-----

--Sig_/RNfbw88c5HVpYbg6fypZhfc--
