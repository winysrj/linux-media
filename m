Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.interlinx.bc.ca ([216.58.37.5]:48820 "EHLO
	linux.interlinx.bc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755090Ab2K2QMJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Nov 2012 11:12:09 -0500
Message-ID: <50B78956.1060101@interlinx.bc.ca>
Date: Thu, 29 Nov 2012 11:12:06 -0500
From: "Brian J. Murrell" <brian@interlinx.bc.ca>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: Ezequiel Garcia <elezegarcia@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: ivtv driver inputs randomly "block"
References: <k93vu3$ffi$1@ger.gmane.org>  <CALF0-+VkANRj+by2n-=UsxZfJwk97ZkNS8R0C-Vt2oX7WN3R0A@mail.gmail.com>  <50B60D54.4010302@interlinx.bc.ca>  <CALF0-+UHOJDh471aa7URKr1-xbggrbDdg_nDijv2FOUpo=3zaw@mail.gmail.com>  <50B69C08.7050401@interlinx.bc.ca>  <CALF0-+X0yyQEw+jJCxuQO18gDagtyX-RZW_kurMPS69RQHNPMA@mail.gmail.com>  <CALF0-+XStqJEiPaQjrBu74of9BYRJZS-9F6F7YzgE3LU6x+TVQ@mail.gmail.com> <1354204218.2505.13.camel@palomino.walls.org>
In-Reply-To: <1354204218.2505.13.camel@palomino.walls.org>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig06643DB9BC1258FAFB2DFB5A"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig06643DB9BC1258FAFB2DFB5A
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 12-11-29 10:50 AM, Andy Walls wrote:
>=20
> Hi Ezequiel,
>=20
> Nope.  IIRC, that's just MythTV timing-out, closing the device node, an=
d
> reopening the device node, in attempt to make things work again.

Seems a very reasonable explanation.

> Hi Brian,

Hi Andy,

> I haven't checked the log you provided yet, but you'll likely need to
> set the module debug flags a little more verbose.

OK.

> /sbin/modinfo ivtv | less
> [...]
> parm:           debug:Debug level (bitmask). Default: 0
> 			   1/0x0001: warning
> 			   2/0x0002: info
> 			   4/0x0004: mailbox
> 			   8/0x0008: ioctl
> 			  16/0x0010: file
> 			  32/0x0020: dma
> 			  64/0x0040: irq
> 			 128/0x0080: decoder
> 			 256/0x0100: yuv
> 			 512/0x0200: i2c
> 			1024/0x0400: high volume
> [..]
>=20
> So maybe as root
>=20
> # echo 0x07f > /sys/module/ivtv/parameters/debug
>=20
> until the problem appears.  Then once you experience the problem change=

> it to high volume

Will waiting for MythTV to report an error, such as:

MPEGRec(/dev/video1): Device error detected

be too late to turn up debugging or should that be sufficient enough timi=
ng?

Although, MythTV seems to report that error at the end of every
recording so I'm not sure how I will filter out the false reports --
unless I write a smarter (i.e. than a single line match) log watcher.
Anyway, that's my problem, not yours.  :-)

> # echo 0x47f > /sys/module/ivtv/parameters/debug
>=20
> You may want to also get a baseline of what a good capture looks like
> using high volume debugging.

Just did that.  Reduced to 0x07f after about a minute and 23 seconds.

> Be aware that high volume debugging will
> fill up your logs and degrade performance a little, so you don't want t=
o
> normally use high volume debugging.

Indeed, it's quite verbose.

> +1
>=20
> The ideas or interest of one individual often spurs that of others.

Indeed, I always keep list replies on list and as I mentioned to
Ezequiel (sorry Ezequiel, I got your name wrong on my previous post.  my
apologies) and I am seeing the copies -- but through gmane.  I don't see
the copies on the spincs.net archive.  I suspect there is a lag at gmane
posting to the list.

In any case, I have CC'd this one directly to the list @vger.kernel.org
and will just hope it has an open posting policy.

Cheers and thanks much!

b.



--------------enig06643DB9BC1258FAFB2DFB5A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iEYEARECAAYFAlC3iVYACgkQl3EQlGLyuXA7MQCdHUFHJLsXXY3/9NtMJ1hHgjeN
0IoAoIY3xAJzR/RoN3Q7vZnZ1lpj35zU
=QHRr
-----END PGP SIGNATURE-----

--------------enig06643DB9BC1258FAFB2DFB5A--
