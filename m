Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:59710 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754326AbaCEXy0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Mar 2014 18:54:26 -0500
Received: by mail-wg0-f49.google.com with SMTP id b13so2211774wgh.20
        for <linux-media@vger.kernel.org>; Wed, 05 Mar 2014 15:54:24 -0800 (PST)
From: James Hogan <james.hogan@imgtec.com>
To: Antti =?ISO-8859-1?Q?Sepp=E4l=E4?= <a.seppala@gmail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org,
	Bruno =?ISO-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Sean Young <sean@mess.org>,
	David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 0/5] rc: scancode filtering improvements
Date: Wed, 05 Mar 2014 23:17:48 +0000
Message-ID: <8608633.KYrQeh4qc7@radagast>
In-Reply-To: <CAKv9HNZ7CG85J0B_xqO_QUH+FWafXZ8oB11V92P6+tOjARLhNw@mail.gmail.com>
References: <1393629426-31341-1-git-send-email-james.hogan@imgtec.com> <CAKv9HNZ7CG85J0B_xqO_QUH+FWafXZ8oB11V92P6+tOjARLhNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2431994.iRJYWN5qzl"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nextPart2431994.iRJYWN5qzl
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

Hi Antti,

On Wednesday 05 March 2014 20:12:15 Antti Sepp=E4l=E4 wrote:
> After reviewing the series and porting my nuvoton changes to it I
> haven't noticed any errors worth mentioning.
> In fact I think this series is very well written and should be merged=
.

Thanks for reviewing!

> James, I hope you also have the time to submit the ir encoder series
> for inclusion. :)

I did a little work on it the other day, including adding encode+loopba=
ck on=20
filter change to loopback driver, fixing a few bugs and adding RC-5/RC-=
5X=20
encode. I'll probably see what I can do to add partial encode to be sur=
e the=20
API doesn't fall short and then send a combined patchset.

Cheers
James
--nextPart2431994.iRJYWN5qzl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABAgAGBQJTF7CoAAoJEKHZs+irPybf3qYQAKyUoSFQ0827mma6LzR2W5nT
Ka8s14A9QO2Klt5Bm3LzDebAbRsqlec0S8BlExNS/qULNVovjsAw5rGvJVdsqlJx
0m7ie4DwGa7tkmv6g4GC0zWY2QbmF0RB5ksP1S2px+vdXfeZlyCAgnqYzlUU6J/W
jxBGaJrjjNV1WjSj4cX89WOlVuJAy1RMecpTW8MZkT8sQU1x5A5EVUjA35/yLwk1
6GkpK6lQ5mgx0FkUic/IRtBpyA7S7e91u3cXnnH8WZdtDGgSs1Puy5hBX/RHs3sQ
M8DbZ99/AL2dPGPESbCYemoEumh+/L5TyjMVGW7ee2oeRKroQP8cwb1B9j1gPqPJ
SA2dLts3E/h2YOewmYSDasRGMV6IK02MFbjJSJXBvBVq+cRGUAkcTST1J+8P3tVl
yzsN1gLw0++vJQ4arJRd0QrItxBMoy19hbs1Tn7vo1eZ5c9BWQUhbIZ9LMkQyQ+b
Mp3dTPGDEduvvOKd5gOipKF/ElDVsUnmVyD3YK0+elNxnnLsqO8cvCYxpfA3GtZx
IHvqsw9kuAhW4WBBYhHJLaglNykRlqUPAgs92vGWO6qTsWjMJAg9w9aNnhr/VjcY
2x76VJLMlL6/oSvM7DbeBYk4ACfvzaFRGu/yQqn0jjGU5D2spKUfMBoD+SyoMezQ
QgZ5H1+PTz8Z3/kOY/i0
=5A62
-----END PGP SIGNATURE-----

--nextPart2431994.iRJYWN5qzl--

