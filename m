Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f173.google.com ([209.85.216.173]:35395 "EHLO
        mail-qt0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1948142AbdDYQxb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Apr 2017 12:53:31 -0400
Received: by mail-qt0-f173.google.com with SMTP id y33so145056706qta.2
        for <linux-media@vger.kernel.org>; Tue, 25 Apr 2017 09:53:31 -0700 (PDT)
Message-ID: <1493139207.19105.16.camel@ndufresne.ca>
Subject: Re: support autofocus / autogain in libv4l2
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Pavel Machek <pavel@ucw.cz>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: pali.rohar@gmail.com, sre@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
        patrikbachan@gmail.com, serge@hallyn.com, abcloriens@gmail.com,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Date: Tue, 25 Apr 2017 12:53:27 -0400
In-Reply-To: <20170425080538.GA30380@amd>
References: <1487074823-28274-1-git-send-email-sakari.ailus@linux.intel.com>
         <1487074823-28274-2-git-send-email-sakari.ailus@linux.intel.com>
         <20170414232332.63850d7b@vento.lan>
         <20170416091209.GB7456@valkosipuli.retiisi.org.uk>
         <20170419105118.72b8e284@vento.lan> <20170424093059.GA20427@amd>
         <20170424103802.00d3b554@vento.lan> <20170424212914.GA20780@amd>
         <20170424224724.5bb52382@vento.lan> <20170425080538.GA30380@amd>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-uUBuJLUvjKqsAuLefAlK"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-uUBuJLUvjKqsAuLefAlK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mardi 25 avril 2017 =C3=A0 10:05 +0200, Pavel Machek a =C3=A9crit=C2=A0:
> Well, fd's are hard, because application can do fork() and now
> interesting stuff happens. Threads are tricky, because now you have
> locking etc.
>=20
> libv4l2 is designed to be LD_PRELOADED. That is not really feasible
> with "complex" library.

That is incorrect. The library propose an API where you simply replace
certain low level calls, like ioctl -> v4l2_ioctl, open -> v4l2_open().
You have to do that explicitly in your existing code. It does not
abstract the API itself unlike libdrm.

Nicolas
--=-uUBuJLUvjKqsAuLefAlK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlj/fwcACgkQcVMCLawGqBwWjwCggHGJKIR3hv6WOAR1NUhArSdK
DtQAn1OB95Bio0qArsO40ujhje/XsvnQ
=bFy2
-----END PGP SIGNATURE-----

--=-uUBuJLUvjKqsAuLefAlK--
