Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:57146 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab3LKIhA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Dec 2013 03:37:00 -0500
Received: by mail-pb0-f54.google.com with SMTP id un15so9434350pbc.41
        for <linux-media@vger.kernel.org>; Wed, 11 Dec 2013 00:37:00 -0800 (PST)
Received: from [128.189.167.230] (host230-167.resnet.ubc.ca. [128.189.167.230])
        by mx.google.com with ESMTPSA id sd3sm30845284pbb.42.2013.12.11.00.36.57
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Wed, 11 Dec 2013 00:36:59 -0800 (PST)
Message-ID: <52A82330.2010802@gmail.com>
Date: Wed, 11 Dec 2013 00:32:48 -0800
From: Connor Behan <connor.behan@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Hauppauge WinTV HVR850 2040:b140 unusable with cx231xx
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="nHroXerUOTuDq8Tbsx7qqmxhP6Bbl9MTq"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--nHroXerUOTuDq8Tbsx7qqmxhP6Bbl9MTq
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I ordered an HVR850 USB TV tuner, planning to use it with an NTSC cable i=
nput. The LinuxTV.org page <http://www.linuxtv.org/wiki/index.php/Hauppau=
ge_WinTV-HVR-850> said that there were three different models, so I check=
ed and mine is 2040:b140... the last one to be supported. A discussion po=
st <http://www.linuxtv.org/wiki/index.php/Talk:Hauppauge_WinTV-HVR-850#Po=
ssibly_Valuable_Information> there said that the card was working as of 2=
013 but my experience has been closer to these ones:

https://mailman.archlinux.org/pipermail/arch-general/2011-September/02196=
2.html
http://www.spinics.net/lists/linux-media/msg49030.html

Since it was my first time using v4l, I didn't know what modules to load.=
 Upon inserting the tuner, I saw 16 new modules autoloaded: media, tuner,=
 videodev, videobuf_core, videobuf_vmalloc, v4l2_common, rc_core, cx25840=
, cx2341x, cx231xx, cx231xx_alsa, cx231xx_dvb, dvb_core, tda18271, tea576=
7, lgdt3305. This creates a few new device nodes:

/dev/dvb/adapter0/demux0*
/dev/dvb/adapter0/dvr0*
/dev/dvb/adapter0/frontend0*
/dev/dvb/adapter0/net0*
/dev/v4l
/dev/vbi0
/dev/video*
/dev/video0

The ones with asterisk are only created sometimes. The dmesg output was q=
uite problematic (first_dmesg <http://paste.ubuntu.com/6555061/>) and I l=
ater found out this was because of lgdt3305_attach() and tda18271_attach(=
). If I explicitly modprobe lgdt3305 and tda18271 before inserting the tu=
ner, I get something better (second_dmesg <http://paste.ubuntu.com/655507=
5/>). However, one troubling thing is __tda18271_write_regs failing with =
-32. This is probably the very first call to __tda18271_write_regs being =
done in tda18271_init_regs(). So the registers on this chip that is essen=
tial to use the analog part of the tuner are not initialized. When I try =
to actually use the tuner, the same error appears again (third_dmesg <htt=
p://paste.ubuntu.com/6555081/>).

I was testing it with the command "mplayer -tv driver=3Dv4l2:device=3D/de=
v/video0:norm=3DNTSC:chanlist=3Dus-cable tv://" and seeing a green screen=
=2E But I also see a black screen when using xawtv and a 0 byte file when=
 using "cat /dev/video0 > foo". I tried a few different machines and kern=
el versions.

Some people have suggested patches. One was a user named Jimbo on http://=
www.kernellabs.com/blog/?p=3D1445 (I'm guessing the polaris4 link is brok=
en because that was merged to mailine?) Anyway he said that HAUPPAUGE_USB=
LIVE2 workarounds for error -71 might need to be there for HAUPPAUGE_EXET=
ER. I tried this and it didn't work. One person who blogged about trouble=
 with the HAUPPAUGE_USBLIVE2 http://csharpnews.wordpress.com/2011/06/15/u=
sb-live-2-on-ubuntu-shows-only-black-screen/ said it was fixed by getting=
 rid of a "value |=3D (1 << 7)". I tried this and it also didn't work.

Before I dangerously try any more patches when I don't know what they do.=
=2E. do you guys know how to fix this?



--nHroXerUOTuDq8Tbsx7qqmxhP6Bbl9MTq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJSqCMxAAoJENU6BEW0eg2rZpQH/2sA8RN5lHRfGPBsTm3qmPVi
v25VzQr7howicmToakUzK1FAq/4YPlsgqBH1XQjoHhL3AiViX6oOusjpSWdNYlL+
KAc8KSTTw3XHy/x03TCI90iCZpbhSjwSW/a2Iz/FMHD1/pJmI9e2PtjeXgR4ufp9
matM9d7qrMWc5UV+tPE0x5T177sr6iPfOaRx+BCEUuWELRgQSqbXHh//CovZ3pE9
SYM0Zd1hGiN1Gkt4VBHj3RONYrSSK3wleY4pKTZESEpjaHiamt8eP3sqdc8ZEFX5
vhJwem/SXkC1lPz+FczXfUNBKNfiqr9PkLm2wX5eYbVAK1Ifidi1LrP6fz++DDI=
=i5Yf
-----END PGP SIGNATURE-----

--nHroXerUOTuDq8Tbsx7qqmxhP6Bbl9MTq--
