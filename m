Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:33288 "EHLO
	mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbcFLI26 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jun 2016 04:28:58 -0400
Received: by mail-lf0-f68.google.com with SMTP id u74so9014659lff.0
        for <linux-media@vger.kernel.org>; Sun, 12 Jun 2016 01:28:56 -0700 (PDT)
Date: Sun, 12 Jun 2016 10:28:52 +0200
From: Henrik Austad <henrik@austad.us>
To: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Cc: alsa-devel@alsa-project.org, netdev@vger.kernel.org,
	henrk@austad.us, alsa-devel@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [very-RFC 0/8] TSN driver for the kernel
Message-ID: <20160612082852.GA32724@icarus.home.austad.us>
References: <1465686096-22156-1-git-send-email-henrik@austad.us>
 <575CD93C.50006@sakamocchi.jp>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
Content-Disposition: inline
In-Reply-To: <575CD93C.50006@sakamocchi.jp>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 12, 2016 at 12:38:36PM +0900, Takashi Sakamoto wrote:
> Hi,
>=20
> I'm one of maintainers for ALSA firewire stack, which handles IEC
> 61883-1/6 and vendor-unique packets on IEEE 1394 bus for consumer
> recording equipments.
> (I'm not in MAINTAINERS because I'm a shy boy.)
>=20
> IEC 61883-6 describes that one packet can multiplex several types of
> data in its data channels; i.e. Multi Bit Linear Audio data (PCM
> samples), One Bit Audio Data (DSD), MIDI messages and so on.

Hmm, that I did not know, not sure how that applies to AVB, but definately=
=20
something I have to look into.

> If you handles packet payload in 'struct snd_pcm_ops.copy', a process
> context of an ALSA PCM applications performs the work. Thus, no chances
> to multiplex data with the other types.

Hmm, ok, I didn't know that, that is something I need to look into -and=20
incidentally one of the reasons why I posted the series now instead of a=20
few more months down the road - thanks!

The driver is not adhering fully to any standards right now, the amount of=
=20
detail is quite high - but I'm slowly improving as I go through the=20
standards. Getting on top of all the standards and all the different=20
subsystems are definately a work in progress (it's a lot to digest!)

> To prevent this situation, current ALSA firewire stack handles packet
> payload in software interrupt context of isochronous context of OHCI
> 1394. As a result of this, the software stack supports PCM substreams
> and MIDI substreams.
>=20
> In your patcset, there's no actual codes about how to handle any
> interrupt contexts (software / hardware), how to handle packet payload,
> and so on. Especially, for recent sound subsystem, the timing of
> generating interrupts and which context does what works are important to
> reduce playback/capture latency and power consumption.

See reply in other mail :)

> Of source, your intention of this patchset is to show your early concept
> of TSN feature. Nevertheless, both of explaination and codes are
> important to the other developers who have little knowledges about TSN,
> AVB and AES-64 such as me.

Yes, that is one of the things I aimed for, and also getting feedback on=20
the overall thinking

> And, I might cooperate to prepare for common IEC 61883 layer. For actual
> codes of ALSA firewire stack, please see mainline kernel code. For
> actual devices of IEC 61883-1/6 and IEEE 1394 bus, please refer to my
> report in 2014. At least, you can get to know what to consider about
> developing upper drivers near ALSA userspace applications.
> https://github.com/takaswie/alsa-firewire-report

Thanks, I'll dig into that, much appreciated

> (But I confirm that the report includes my misunderstandings in clause
> 3.4 and 6.2. need more time...)

ok, good to know

Thank you for your input, very much appreicated!

--=20
Henrik Austad

--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlddHUQACgkQ6k5VT6v45lkz/QCgv1Kytb0lLnfTKnkXuWq6s/KD
0R8AniOUfPEJN8rcLNQBH3s/HuBD+FUw
=MnV+
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--
