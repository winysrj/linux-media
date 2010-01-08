Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx05.extmail.prod.ext.phx2.redhat.com
	[10.5.110.9])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o08NvZNC032138
	for <video4linux-list@redhat.com>; Fri, 8 Jan 2010 18:57:35 -0500
Received: from whitealder.osuosl.org (whitealder.osuosl.org [140.211.166.138])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o08NvKdk023035
	for <video4linux-list@redhat.com>; Fri, 8 Jan 2010 18:57:20 -0500
Received: from localhost (localhost [127.0.0.1])
	by whitealder.osuosl.org (Postfix) with ESMTP id D39391C8107
	for <video4linux-list@redhat.com>; Fri,  8 Jan 2010 23:57:19 +0000 (UTC)
Received: from whitealder.osuosl.org ([127.0.0.1])
	by localhost (.osuosl.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 026yd8r7xUZh for <video4linux-list@redhat.com>;
	Fri,  8 Jan 2010 23:57:18 +0000 (UTC)
Received: from gazelle.rmt.insightsnow.com
	(c-24-20-161-217.hsd1.or.comcast.net [24.20.161.217])
	by whitealder.osuosl.org (Postfix) with ESMTPSA id 76D4D1C80DE
	for <video4linux-list@redhat.com>; Fri,  8 Jan 2010 23:57:18 +0000 (UTC)
Date: Fri, 8 Jan 2010 15:57:16 -0800
From: Stuart McKim <mckim@lifetime.oregonstate.edu>
To: video4linux-list@redhat.com
Subject: Compiling xawtv - libzvbi.h error
Message-ID: <20100108235715.GC4535@gazelle.rmt.insightsnow.com>
MIME-Version: 1.0
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3187983810077677872=="
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>


--===============3187983810077677872==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YiEDa0DAkWCtVeE4"
Content-Disposition: inline


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I am trying to compile xawtv-3.95, but I have run into an error I can't
seem to figure out the source of. I'm not sure if it's a mistake in my
installation of zvbi or xawtv.

In order, I installed:
tv-fonts-1.1 (successful)
zvbi-0.2.33  (successful)
xawtv-3.95   (failed)

My procedure for building xawtv is:
=2E/configure
make

The output from make is:
mckim@eckleburg ~/builds/xawtv-3.95 $ make
  CC      console/dump-mixers.o
  LD      console/dump-mixers
  CC      console/record.o
  LD      console/record
  CC      console/showriff.o
  LD      console/showriff
  CC      console/showqt.o
  LD      console/showqt
  CC      console/streamer.o
In file included from ./common/commands.h:1,
                 from console/streamer.c:32:
=2E/common/vbi-data.h:5:21: error: libzvbi.h: No such file or directory
In file included from ./common/commands.h:1,
                 from console/streamer.c:32:
=2E/common/vbi-data.h:10: error: expected specifier-qualifier-list before '=
vbi_decoder'
=2E/common/vbi-data.h:36: warning: 'struct vbi_event' declared inside param=
eter list
=2E/common/vbi-data.h:36: warning: its scope is only this definition or dec=
laration, which is probably not what you want
=2E/common/vbi-data.h:37: warning: 'struct vbi_char' declared inside parame=
ter list
=2E/common/vbi-data.h:39: warning: 'struct vbi_decoder' declared inside par=
ameter list
=2E/common/vbi-data.h:42: warning: 'struct vbi_page' declared inside parame=
ter list
=2E/common/vbi-data.h:43: warning: 'struct vbi_page' declared inside parame=
ter list
In file included from console/streamer.c:32:
=2E/common/commands.h:28: warning: 'struct vbi_page' declared inside parame=
ter list
make: *** [console/streamer.o] Error 1


When I tried to locate libzvbi.h, the only copy I found is in the build
directory for zvbi-0.2.33.

Can somebody please help me get pointed in the right direction? I am
running Slackware64-13.0 on a 2.6.29.6 kernel.

Thanks,
Stuart

--=20
Stuart McKim
Corvallis, OR

--YiEDa0DAkWCtVeE4
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (Darwin)

iEYEARECAAYFAktHxlsACgkQFIbZ16YHOXYZ7gCfURWduxlY1l5AteM/e8U4LTRj
8eoAn1jZz1eS/l8RTxV1nCWP9u3lmuWG
=CLsX
-----END PGP SIGNATURE-----

--YiEDa0DAkWCtVeE4--


--===============3187983810077677872==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--===============3187983810077677872==--
