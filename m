Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:49131 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbaC1XR1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Mar 2014 19:17:27 -0400
Received: by mail-wi0-f177.google.com with SMTP id cc10so1319743wib.16
        for <linux-media@vger.kernel.org>; Fri, 28 Mar 2014 16:17:25 -0700 (PDT)
From: James Hogan <james.hogan@imgtec.com>
To: David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, m.chehab@samsung.com
Subject: Re: [PATCH] rc-core: do not change 32bit NEC scancode format for now
Date: Fri, 28 Mar 2014 23:17:09 +0000
Message-ID: <22162617.bKffkdqYH7@radagast>
In-Reply-To: <20140328000856.GB22491@hardeman.nu>
References: <20140327210037.20406.93136.stgit@zeus.muc.hardeman.nu> <7983411.lVWEDlBWc6@radagast> <20140328000856.GB22491@hardeman.nu>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2341554.GHSDE9AZv6"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nextPart2341554.GHSDE9AZv6
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

On Friday 28 March 2014 01:08:56 David H=E4rdeman wrote:
> On Thu, Mar 27, 2014 at 11:21:23PM +0000, James Hogan wrote:
> >Hi David,
> >
> >On Thursday 27 March 2014 22:00:37 David H=E4rdeman wrote:
> >> This reverts 18bc17448147e93f31cc9b1a83be49f1224657b2
> >>=20
> >> The patch ignores the fact that NEC32 scancodes are generated not =
only in
> >> the NEC raw decoder but also directly in some drivers. Whichever a=
pproach
> >> is chosen it should be consistent across drivers and this patch ne=
eds
> >> more
> >> discussion.
> >
> >Fair enough. For reference which drivers are you referring to?
>=20
> The ones I'm aware of right now are:

Thanks, I hadn't looked properly outside of drivers/media/rc/ :(

> drivers/media/usb/dvb-usb/dib0700_core.c

AFAICT this only seems to support 16bit and 24bit NEC, so NEC-32 doesn'=
t affect=20
it. I may have missed something subtle.

> drivers/media/usb/dvb-usb-v2/az6007.c
> drivers/media/usb/dvb-usb-v2/af9035.c
> drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> drivers/media/usb/dvb-usb-v2/af9015.c
> drivers/media/usb/em28xx/em28xx-input.c

Note, it appears none of these do any bit reversing for the 32bit case=20=

compared to 16/24 bit, so they're already different to the NEC32 scanco=
de=20
encoding that the raw nec decoder and tivo keymap were using, which use=
d a=20
different bitorder (!!) between the 32-bit and the 24/16-bit cases.

>=20
> >> Furthermore, I'm convinced that we have to stop playing games tryi=
ng to
> >> decipher the "meaning" of NEC scancodes (what's the
> >> customer/vendor/address, which byte is the MSB, etc).
> >
> >Well when all the buttons on a remote have the same address, and the=

> >numeric buttons are sequential commands only in a certain bit/byte o=
rder,
> >then I think the word "decipher" is probably a bit of a stretch.
>=20
> I think you misunderstood me. "decipher" is a bit of a stretch when
> talking of one remote control (I'm guessing you're referring to the T=
ivo
> remote). It's not that much of a stretch if we're referring to trying=
 to
> derive a common meaning from the encoding used for *all* remote contr=
ols
> out there.
>=20
> The discussion about the 24-bit version of NEC and whether the addres=
s
> bytes were in MSB or LSB order was a good example. Andy Walls cited a=

> NEC manual which stated one thing and people also referred to
> http://www.sbprojects.com/knowledge/ir/nec.php which stated the oppos=
ite
> (while referring to an unnamed VCR service manual).
>=20
> As a third example...I've read a Samsung service manual which happily=

> stated that the remote (which used the NEC protocol) sent IR commands=

> starting with the address x 2 (and looking at the raw NEC command, it=

> did start with something like 0x07 0x07).
>=20
> So don't get me wrong, I wasn't referring to your analysis of the Tiv=
o
> remote but more the general approach that has been taken until now wr=
t.
> the NEC protocol in the kernel drivers.

Okay, thanks for the clarification.

>=20
> >Nevertheless I don't have any attachment to 32-bit NEC. If it's like=
ly to
> >change again I'd prefer img-ir-nec just not support it for now, so p=
lease
> >could you add the following hunks to your patch (or if the original =
patch
> >is
> >to be dropped this could be squashed into the img-ir-nec patch):
> I'd rather show you my complete proposal first before doing something=

> radical with your driver. But it was a good reminder that I need to k=
eep
> the NEC32 parsing in your driver in mind as well.

Okay no problem. I had assumed you were aiming for a short term fix to =
prevent=20
the encoding change hitting mainline or an actual release (v3.15).

Cheers
James

>=20
> >> I'll post separate proposals to that effect later.
> >
> >Great, please do Cc me
> >
> >(I have a work in progress branch to unify NEC scancodes, but I'm no=
t sure
> >I'd have time to complete it any time soon anyway)
>=20
> That is what I'm working on as well at the moment. It's actually to
> solve two problems...both to unify NEC scancodes (by simply using 32 =
bit
> scancodes everywhere and some fallback code...I'm not 100% sure it's
> doable but I hope so since it's the only sane solution I can think of=
 in
> the long run)...and to make sure that protocol information actually g=
ets
> used in keymaps, etc.
>=20
> I hope to post patches soon that'll make it clearer.
>=20
> Regards,
> David
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--nextPart2341554.GHSDE9AZv6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABAgAGBQJTNgL+AAoJEKHZs+irPybf970P/ieoOeNVdsZ9scJYwZCvvEyl
yTkYdqIUtCtO/6XncoxF5vL7LKObNTIApq1tnWZULdIHbjpZ+kDXfmarICnfkpy1
E+OUV1NzQjKxk9OYZQ5YGIkWyH0tvcmX75OZ4u0m87i8p5DfQM94QZFsHX5UXjfX
3KUKUHjjahsN1FJEHWnECEZc0S2g2vG2PjqXKM0pLM64X1Clz7MyU0ad2rpskjAP
0nsXyOcxQgDyoYAfnNh6gT46I6UKbZ55PQlPZZeIvafeKg0jU5KzCZ/6+eRi87+M
Wwju3NKQBYaRRbkWHSb1lPxdULfcGa+u4JmksLIm2BOXMTwsIAxh3e4BYsYgDGs4
ZlCJ7D7PNuAQmgLNwlYqDmJcCybTvadTc0lOhB9fhkrTIi4szEHDNT5ufmZQiRrS
rhxwQqfvBojmhr9XDRlViKnWBGJmT5ls/zc4tmq2N4uTUfakySPt9/G3qbhrMF+B
E6QkPCiqnX+G1+DIkhzcs74c21mAnoRz+f4zBQgZVwUCoUYvryslMaSoBrCRKln/
ZAAI6DnWpTGnQKnfxbaotYoSelnYPThIS1VvqNxht36/rc0C0mSj4GE+CE3yadug
8hJNs2hqRSj5XzVgu8ANGdDlV+mkB2YYRZaC012MKg6Gxd25H6nT9n8vPhdNFoda
oEAdLBUAsRc3smkM384l
=1IhJ
-----END PGP SIGNATURE-----

--nextPart2341554.GHSDE9AZv6--

