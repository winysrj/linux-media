Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx09.extmail.prod.ext.phx2.redhat.com
	[10.5.110.13])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o091jiks016625
	for <video4linux-list@redhat.com>; Fri, 8 Jan 2010 20:45:44 -0500
Received: from fraxinus.osuosl.org (fraxinus.osuosl.org [140.211.166.137])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o091jWmG020626
	for <video4linux-list@redhat.com>; Fri, 8 Jan 2010 20:45:32 -0500
Received: from localhost (localhost [127.0.0.1])
	by fraxinus.osuosl.org (Postfix) with ESMTP id E17C71C417C
	for <video4linux-list@redhat.com>; Sat,  9 Jan 2010 01:45:31 +0000 (UTC)
Received: from fraxinus.osuosl.org ([127.0.0.1])
	by localhost (.osuosl.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vP7yJbuFgZqg for <video4linux-list@redhat.com>;
	Sat,  9 Jan 2010 01:45:31 +0000 (UTC)
Received: from gazelle.rmt.insightsnow.com
	(c-24-20-161-217.hsd1.or.comcast.net [24.20.161.217])
	by fraxinus.osuosl.org (Postfix) with ESMTPSA id 3E7B31C414E
	for <video4linux-list@redhat.com>; Sat,  9 Jan 2010 01:45:31 +0000 (UTC)
Date: Fri, 8 Jan 2010 17:45:28 -0800
From: Stuart McKim <mckim@lifetime.oregonstate.edu>
To: video4linux-list@redhat.com
Subject: Re: Compiling xawtv - libzvbi.h error
Message-ID: <20100109014528.GF4535@gazelle.rmt.insightsnow.com>
References: <20100108235715.GC4535@gazelle.rmt.insightsnow.com>
MIME-Version: 1.0
In-Reply-To: <20100108235715.GC4535@gazelle.rmt.insightsnow.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7142229512012222603=="
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>


--===============7142229512012222603==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FFoLq8A0u+X9iRU8"
Content-Disposition: inline


--FFoLq8A0u+X9iRU8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 08, 2010 at 03:57:16PM -0800, Stuart McKim wrote:
> I am trying to compile xawtv-3.95, but I have run into an error I can't
> seem to figure out the source of. I'm not sure if it's a mistake in my
> installation of zvbi or xawtv.

I was able to get the install to work. I ended up needing quite a few
tweaks.

First, I reinstalled zvbi-0.2.33:
cd zvbi-02.33
make distclean
=2E/configure
make
sudo make install

This installed  /usr/local/include/libzvbi.h

However, I ended up needing to apply some patches.
To xawtv:
[1]: http://bugs.gentoo.org/attachment.cgi?id=3D82419&action=3Dview
[2]: http://lists.debian.org/debian-qa-packages/2006/08/msg00519.html

To an installed X library:
[3]: http://linux.derkeiler.com/Mailing-Lists/Debian/2006-08/msg01989.html

After doing all three, I was able to build:
cd xawtv-3.95
make distclean
=2E/configure --x-includes=3D/usr/include/X11/ --x-libraries=3D/usr/lib/X11/
make
sudo make install

Is this sort of involved process normal? Although I got it working, I
still don't understand what I did.

Stuart

--=20
Stuart McKim
Corvallis, OR

--FFoLq8A0u+X9iRU8
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (Darwin)

iEYEARECAAYFAktH37gACgkQFIbZ16YHOXYJiwCg6Lheg0GBbmc0JPQbcPiE+0t3
DAMAoOJisT+Beq40RzLPDwlaUMLGgtLo
=7Xb0
-----END PGP SIGNATURE-----

--FFoLq8A0u+X9iRU8--


--===============7142229512012222603==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--===============7142229512012222603==--
