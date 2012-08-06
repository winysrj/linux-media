Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55907 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756055Ab2HFL6o (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2012 07:58:44 -0400
Received: by eaac11 with SMTP id c11so795989eaa.19
        for <linux-media@vger.kernel.org>; Mon, 06 Aug 2012 04:58:42 -0700 (PDT)
From: Michal Nazarewicz <mina86@mina86.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Rob Clark <rob.clark@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	patches@linaro.org, linux@arm.linux.org.uk, arnd@arndb.de,
	jesse.barker@linaro.org, m.szyprowski@samsung.com, daniel@ffwll.ch,
	sumit.semwal@ti.com, maarten.lankhorst@canonical.com,
	Rob Clark <rob@ti.com>
Subject: Re: [PATCH 2/2] dma-buf: add helpers for attacher dma-parms
In-Reply-To: <501F9C8E.4080002@samsung.com>
References: <1342715014-5316-1-git-send-email-rob.clark@linaro.org> <1342715014-5316-3-git-send-email-rob.clark@linaro.org> <501F9C8E.4080002@samsung.com>
Date: Mon, 06 Aug 2012 13:58:32 +0200
Message-ID: <xa1tobmoxmdz.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


Tomasz Stanislawski <t.stanislaws@samsung.com> writes:
> I recommend to change the semantics for unlimited number of segments
> from 'value 0' to:
>
> #define DMA_SEGMENTS_COUNT_UNLIMITED ((unsigned long)INT_MAX)
>
> Using INT_MAX will allow using safe conversions between signed and
> unsigned integers.

LONG_MAX seems cleaner regardless.

--=20
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=3D./ `o
..o | Computer Science,  Micha=C5=82 =E2=80=9Cmina86=E2=80=9D Nazarewicz   =
 (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
--=-=-=
Content-Type: multipart/signed; boundary="==-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--==-=-=
Content-Type: text/plain


--==-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJQH7FoAAoJECBgQBJQdR/0Bp8P/1JRasCO7JTR74Tp7r6IRZsh
EX2hh1vYKHtXIvD/inKsnOdnm6NFO+kzwnSS3ozkQZkIuhvTYkZyKcXJ7tHYHOZb
Y9x/4VaG8bPi4AzPs2a5WuCnyP6ex5MwZTfPYir2CmWFicTNwYCtveNwcxIiI8w5
D24UmHDwi2C23rCP57vepsyMDQk6NpukgqCe5u2FW+ep2Uu2ai6tW/GgP7V6xD2j
jdLKcA0H5YMjzYLuWX3HYGLRbpOWV7KBp4O4bYn+7RlrSUQNRv92Erse+zitFLxt
8l6ULsb64gsixV1YpKte6ofhWf9Y8Zk+fmXkA0WQnaaRTskTN5XIgAvohnjZX9cT
G68NVPa/XhXt9YmWvHave1BOMNFMcfcmBXNwtQDfB6v8UNQoUqeGFBhDye7vmJXx
yu41FUrFAh4JrYTt4dpSWqG4mU50YM17BF7JIq+F8bVuH4asIXlM+rcdid0t+slt
ujotZ6ElWxqaGB5KCsanofSuNd8KgNjGLpgYR7z89VlSrgTocafZjZgTAnR9GU3h
kqszsTuUg+Gr98Gf7rSiqhVRSSAwi6TazZVD+DuWnuhPtzKpBhj0tTidfDufClgM
V99Zmu6Oc+qRKdv0M3kaA8xYZWk+TpNSQsHSGqmzeDAwicLej5qP/5EEklKEz6RO
IS4s+j0jiXCjVTxtXhTm
=l0/5
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
