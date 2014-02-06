Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:59875 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbaBFTZ0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Feb 2014 14:25:26 -0500
Received: by mail-pa0-f41.google.com with SMTP id fa1so2107639pad.0
        for <linux-media@vger.kernel.org>; Thu, 06 Feb 2014 11:25:25 -0800 (PST)
Message-ID: <52F3E06B.5090702@gmail.com>
Date: Thu, 06 Feb 2014 11:20:11 -0800
From: Connor Behan <connor.behan@gmail.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: au0828 errors and mangled video with Hauppauge 950Q
References: <52F1D497.4010509@gmail.com> <CAGoCfiy-EdA4pbcCB6uLBSp7HUBW+=2vRYG8m+Q8V4tQmGTRag@mail.gmail.com>
In-Reply-To: <CAGoCfiy-EdA4pbcCB6uLBSp7HUBW+=2vRYG8m+Q8V4tQmGTRag@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="R1MwgAgcv0kLN1mN8SXRvrETTVFC1Rumg"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--R1MwgAgcv0kLN1mN8SXRvrETTVFC1Rumg
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 05/02/14 01:46 AM, Devin Heitmueller wrote:
> On Wed, Feb 5, 2014 at 1:05 AM, Connor Behan <connor.behan@gmail.com>
> wrote:
>> Ccing Devin. I'm pretty sure the analog side has a problem at the driv=
er
>> level.
>>
>> On most days, one cannot pickup an ATSC signal where I am, so I am
>> trying to capture analog video with a Hauppauge WinTV HVR 950Q. Whethe=
r
>> I use Television, Composite or S-Video, I see the same corrupted video=

>> such as this: http://imgur.com/c398F4v
> Looks like insufficient USB bandwidth available to support the 24
> MB/second required for uncompressed analog video.
>
> Is this on an x86 PC?  Or some embedded target such as ARM?  If the
> latter, then the answer is almost certainly that the USB host
> controller implementation is garbage and cannot handle the throughput.
>
> Devin
>
It's an x86 PC but bandwidth was indeed the problem. I thought I was
having a power issue before. So I started using a Cardbus to USB adapter
that had an external power port. This was a mistake, and I can get the
tuner to work again if I switch back to a built-in port.

Thanks a lot.


--R1MwgAgcv0kLN1mN8SXRvrETTVFC1Rumg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJS8+ByAAoJENU6BEW0eg2rutAH/29Ois0rDWLdgGh+sQ6NxFz2
80Cif00On6kQEkHE1dsMzSN/irr4lA743xHs6AVp9Ab0h4AvCHd8oQluCBxUiKVV
c86cLhvF43tNFBNaffWP/zl9xBszqwfs4tBtNG/ezXAsUVnJV97cKOxEut2cu9et
jdXOF7IwPAYhiQPbFaZPXRSbH6COdnqqUK4LVrRm/wb092AW83xJ1O0uSz9UP9sY
IYTtONd39KuhWCWF/CCvqCxVbhQdeRYeI0oDaGTcG50cNaVbfmjeAmJxU+6of3bx
hBW1Ouvd+W6aTe99/IVcrECXsFsVwFU2fYbaKersOrM5F6kQbT6e7Rr2wUtZT7w=
=cmz/
-----END PGP SIGNATURE-----

--R1MwgAgcv0kLN1mN8SXRvrETTVFC1Rumg--
