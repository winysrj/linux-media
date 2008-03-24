Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp2b.orange.fr ([80.12.242.145])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <david.bercot@wanadoo.fr>) id 1Jdhxh-0001ea-Bv
	for linux-dvb@linuxtv.org; Mon, 24 Mar 2008 09:23:22 +0100
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2b13.orange.fr (SMTP Server) with ESMTP id 43603A002DAB
	for <linux-dvb@linuxtv.org>; Mon, 24 Mar 2008 09:22:47 +0100 (CET)
Received: from localhost (LRouen-151-71-134-185.w193-253.abo.wanadoo.fr
	[193.253.252.185])
	by mwinf2b13.orange.fr (SMTP Server) with ESMTP id 0B0BCA002DA1
	for <linux-dvb@linuxtv.org>; Mon, 24 Mar 2008 09:22:47 +0100 (CET)
Date: Mon, 24 Mar 2008 09:22:39 +0100
From: David BERCOT <david.bercot@wanadoo.fr>
To: linux-dvb@linuxtv.org
Message-ID: <20080324092239.7f52a7aa@wanadoo.fr>
Mime-Version: 1.0
Subject: [linux-dvb] Error when compiling MythTV with multiproto
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1162107119=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1162107119==
Content-Type: multipart/signed; boundary="Sig_/RbQO86VTWvO56LEVs1QBJP3";
 protocol="application/pgp-signature"; micalg=PGP-SHA1

--Sig_/RbQO86VTWvO56LEVs1QBJP3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

I have an error with dvbchannel.cpp.

First, when compiling, I have this :
make[2]: entrant dans le r=C3=A9pertoire
=C2=AB /opt/dvb/release-0-21-fixes/mythtv/libs/libmythtv =C2=BB g++ -c -pip=
e -g
-march=3Dk8 -fomit-frame-pointer -O3 -Wall -Wno-switch -Wpointer-arith
-Wredundant-decls -Wno-non-virtual-dtor -D__STDC_CONSTANT_MACROS
-I/usr/include/freetype2 -D_REENTRANT -DPIC -fPIC  -DMMX -D_GNU_SOURCE
-D_FILE_OFFSET_BITS=3D64 -DPREFIX=3D\"/usr/local\"
-DLIBDIR=3D\"/usr/local/lib\" -D_LARGEFILE_SOURCE -DUSING_OSS
-DUSING_H264TOOLS -DUSING_X11 -DUSING_XV -DUSING_OPENGL
-DUSING_FRONTEND -DUSING_FFMPEG_THREADS -DUSING_V4L -DUSING_DBOX2
-DUSING_IPTV -DUSING_HDHOMERUN -DUSING_IVTV -DUSING_DVB -DUSING_BACKEND
-DQT_NO_DEBUG -DQT_THREAD_SUPPORT -DQT_SHARED -DQT_TABLET_SUPPORT
-I/usr/share/qt3/mkspecs/default -I. -I/usr/local/include
-I/usr/include -I../.. -I.. -I. -I../libmyth -I../libavcodec
-I../libavutil -I../libmythmpeg2 -Idvbdev -Impeg -Iiptv
-I../libmythlivemedia/BasicUsageEnvironment/include
-I../libmythlivemedia/groupsock/include
-I../libmythlivemedia/liveMedia/include
-I../libmythlivemedia/UsageEnvironment/include -I/usr/include/qt3
-I/usr/X11R6/include -I/usr/X11R6/include -o dvbchannel.o
dvbchannel.cpp dvbchannel.cpp: In member function =E2=80=98bool
DVBChannel::Open(DVBChannel*)=E2=80=99: dvbchannel.cpp:213: error: =E2=80=
=98dvbfe_info=E2=80=99
was not declared in this scope dvbchannel.cpp:213: error: expected `;'
before =E2=80=98fe_info=E2=80=99 dvbchannel.cpp:214: error: =E2=80=98fe_inf=
o=E2=80=99 was not declared
in this scope dvbchannel.cpp:215: error: =E2=80=98DVBFE_DELSYS_DVBS=E2=80=
=99 was not
declared in this scope dvbchannel.cpp:216: error: =E2=80=98DVBFE_GET_INFO=
=E2=80=99 was
not declared in this scope dvbchannel.cpp: In member function =E2=80=98bool
DVBChannel::Tune(const DTVMultiplex&, uint, bool, bool)=E2=80=99:
dvbchannel.cpp:775: error: aggregate =E2=80=98dvbfe_params fe_params=E2=80=
=99 has
incomplete type and cannot be defined dvbchannel.cpp:776: error:
=E2=80=98DVBFE_DELSYS_DVBS=E2=80=99 was not declared in this scope dvbchann=
el.cpp:786:
error: =E2=80=98DVBFE_DELSYS_DVBS=E2=80=99 cannot appear in a constant-expr=
ession
dvbchannel.cpp:788: error: =E2=80=98DVBFE_FEC_AUTO=E2=80=99 was not declare=
d in this
scope dvbchannel.cpp:789: error: =E2=80=98DVBFE_MOD_AUTO=E2=80=99 was not d=
eclared in
this scope dvbchannel.cpp:791: error: expected unqualified-id before
=E2=80=98.=E2=80=99 token dvbchannel.cpp:794: error: =E2=80=98DVBFE_DELSYS_=
DVBS2=E2=80=99 was not
declared in this scope dvbchannel.cpp:808: error: =E2=80=98DVBFE_SET_PARAMS=
=E2=80=99
was not declared in this scope make[2]: *** [dvbchannel.o] Erreur 1
make[2]: quittant le r=C3=A9pertoire
=C2=AB /opt/dvb/release-0-21-fixes/mythtv/libs/libmythtv =C2=BB make[1]: ***
[sub-libmythtv] Erreur 2 make[1]: quittant le r=C3=A9pertoire
=C2=AB /opt/dvb/release-0-21-fixes/mythtv/libs =C2=BB make: *** [sub-libs] =
Erreur
2

Then, I've added, in 'libs/libmythtv/Makefile', the following code
(in INCPATH) : -I/opt/dvb/multiproto/linux/include [in order to have
multiproto files]
But I still have an error :
make[2]: entrant dans le r=C3=A9pertoire
=C2=AB /opt/dvb/release-0-21-fixes/mythtv/libs/libmythtv =C2=BB g++ -c -pip=
e -g
-march=3Dk8 -fomit-frame-pointer -O3 -Wall -Wno-switch -Wpointer-arith
-Wredundant-decls -Wno-non-virtual-dtor -D__STDC_CONSTANT_MACROS
-I/usr/include/freetype2 -D_REENTRANT -DPIC -fPIC  -DMMX -D_GNU_SOURCE
-D_FILE_OFFSET_BITS=3D64 -DPREFIX=3D\"/usr/local\"
-DLIBDIR=3D\"/usr/local/lib\" -D_LARGEFILE_SOURCE -DUSING_OSS
-DUSING_H264TOOLS -DUSING_X11 -DUSING_XV -DUSING_OPENGL
-DUSING_FRONTEND -DUSING_FFMPEG_THREADS -DUSING_V4L -DUSING_DBOX2
-DUSING_IPTV -DUSING_HDHOMERUN -DUSING_IVTV -DUSING_DVB -DUSING_BACKEND
-DQT_NO_DEBUG -DQT_THREAD_SUPPORT -DQT_SHARED -DQT_TABLET_SUPPORT
-I/usr/share/qt3/mkspecs/default -I. -I/usr/local/include
-I/usr/include -I../.. -I.. -I. -I../libmyth -I../libavcodec
-I../libavutil -I../libmythmpeg2 -Idvbdev -Impeg -Iiptv
-I../libmythlivemedia/BasicUsageEnvironment/include
-I../libmythlivemedia/groupsock/include
-I../libmythlivemedia/liveMedia/include
-I../libmythlivemedia/UsageEnvironment/include -I/usr/include/qt3
-I/usr/X11R6/include -I/usr/X11R6/include
-I/opt/dvb/multiproto/linux/include -o dvbchannel.o dvbchannel.cpp
dvbchannel.cpp: In member function =E2=80=98bool
DVBChannel::Open(DVBChannel*)=E2=80=99: dvbchannel.cpp:215: error: =E2=80=
=98struct
dvbfe_info=E2=80=99 has no member named =E2=80=98delivery=E2=80=99 dvbchann=
el.cpp: In member
function =E2=80=98bool DVBChannel::Tune(const DTVMultiplex&, uint, bool,
bool)=E2=80=99: dvbchannel.cpp:791: error: expected unqualified-id before =
=E2=80=98.=E2=80=99
token make[2]: *** [dvbchannel.o] Erreur 1 make[2]: quittant le
r=C3=A9pertoire =C2=AB /opt/dvb/release-0-21-fixes/mythtv/libs/libmythtv =
=C2=BB
make[1]: *** [sub-libmythtv] Erreur 2 make[1]: quittant le r=C3=A9pertoire
=C2=AB /opt/dvb/release-0-21-fixes/mythtv/libs =C2=BB make: *** [sub-libs] =
Erreur
2

Do you have any idea to solve this ?

Thank you very much.

David.

--Sig_/RbQO86VTWvO56LEVs1QBJP3
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFH52TWvSnthbGI8ygRAvIGAJkBwvXMyignzLtsZB4z08pdqDRdfACgm32n
ENarhn4zXSFIudKHkoEocnA=
=98T5
-----END PGP SIGNATURE-----

--Sig_/RbQO86VTWvO56LEVs1QBJP3--



--===============1162107119==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1162107119==--
