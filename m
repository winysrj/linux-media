Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:48787 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753096AbZCXUE0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2009 16:04:26 -0400
Date: Tue, 24 Mar 2009 21:04:19 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: "Uri Shkolnik" <uris@siano-ms.com>
Cc: "Mauro Carvalho Chehab" <mchehab@infradead.org>,
	"Linux Media Mailing List" <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/1 re-submit 1] sdio: add low level i/o functions for
 workarounds
Message-ID: <20090324210419.6992ee34@mjolnir.ossman.eu>
In-Reply-To: <3E442BA883529143B4AB72530285FC5D01B9E6DD@s-mail.siano-ms.ent>
References: <20090314074201.5c4a1ce1@pedra.chehab.org>
	<20090322153534.0c64de1e@mjolnir.ossman.eu>
	<3E442BA883529143B4AB72530285FC5D01B9E6DD@s-mail.siano-ms.ent>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-18705-1237925060-0001-2"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-18705-1237925060-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 22 Mar 2009 16:48:39 +0200
"Uri Shkolnik" <uris@siano-ms.com> wrote:

> Hi Pierre,
>=20
> The USB separation patches are ready, and will be committed for review
> shortly (SDIO stack workaround + Siano SDIO driver were the first to be
> re-re-re-committed, SPI will be next, and after them the "core" which
> includes the 'separation' code). You can view one (of many) older commit
> operations @
> http://patchwork.kernel.org/project/linux-media/list/?submitter=3DUri&stat
> e=3D*
>=20

I see. Could you hold off on the SDIO patches and allow me to do a
final cleanup once you have the separation patches done? Then I can
send them directly to Mauro and we can have this merged quickly.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-18705-1237925060-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAknJPMYACgkQ7b8eESbyJLi/dgCfYnYvuAB7MpKpujXaXzc4eBJh
ur0AoKhze/12r+cE2irExsZnWiZabcV6
=SmUA
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-18705-1237925060-0001-2--
