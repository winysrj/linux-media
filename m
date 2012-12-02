Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45640 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017Ab2LBTwB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 2 Dec 2012 14:52:01 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1TfFZB-0003fy-4c
	for linux-media@vger.kernel.org; Sun, 02 Dec 2012 20:51:05 +0100
Received: from d67-193-214-242.home3.cgocable.net ([67.193.214.242])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sun, 02 Dec 2012 20:51:05 +0100
Received: from brian by d67-193-214-242.home3.cgocable.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sun, 02 Dec 2012 20:51:05 +0100
To: linux-media@vger.kernel.org
From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: Re: ivtv driver inputs randomly "block"
Date: Sun, 02 Dec 2012 14:50:35 -0500
Message-ID: <50BBB10B.2020306@interlinx.bc.ca>
References: <k93vu3$ffi$1@ger.gmane.org>  <CALF0-+VkANRj+by2n-=UsxZfJwk97ZkNS8R0C-Vt2oX7WN3R0A@mail.gmail.com>  <50B60D54.4010302@interlinx.bc.ca>  <CALF0-+UHOJDh471aa7URKr1-xbggrbDdg_nDijv2FOUpo=3zaw@mail.gmail.com>  <50B69C08.7050401@interlinx.bc.ca>  <CALF0-+X0yyQEw+jJCxuQO18gDagtyX-RZW_kurMPS69RQHNPMA@mail.gmail.com>  <CALF0-+XStqJEiPaQjrBu74of9BYRJZS-9F6F7YzgE3LU6x+TVQ@mail.gmail.com> <1354204218.2505.13.camel@palomino.walls.org> <50B7BBDB.9040508@interlinx.bc.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig56CB1380EF4B692CDE58BBD8"
In-Reply-To: <50B7BBDB.9040508@interlinx.bc.ca>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig56CB1380EF4B692CDE58BBD8
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 12-11-29 02:47 PM, Brian J. Murrell wrote:
>=20
> I'm afraid I didn't notice the problem until about 40m into the
> recording bug given that MythTV is in a loop repeatedly opening the
> card and trying to use it perhaps the high volume even 40 minutes into
> the recording is useful.
>=20
>> Then once you experience the problem change
>> it to high volume
>>
>> # echo 0x47f > /sys/module/ivtv/parameters/debug
>=20
> It seems to be a loop of:
> ...

Was this information helpful?  If not, please let me know what else I
can provide to give you something you can diagnose with.

Cheers and much thanks,
b.



--------------enig56CB1380EF4B692CDE58BBD8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iEYEARECAAYFAlC7sQsACgkQl3EQlGLyuXBSkgCgjUUdDhi8ddcyebYd8p1F2xnJ
B9QAoLyWqqEPaRGZgcZVlX+QqncJk07L
=R+7A
-----END PGP SIGNATURE-----

--------------enig56CB1380EF4B692CDE58BBD8--

