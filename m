Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35577 "EHLO
	mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758358AbcHCWFK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Aug 2016 18:05:10 -0400
Received: by mail-oi0-f67.google.com with SMTP id w143so21190030oiw.2
        for <linux-media@vger.kernel.org>; Wed, 03 Aug 2016 15:05:09 -0700 (PDT)
Received: from [192.168.1.7] (cpe-72-176-73-111.stx.res.rr.com. [72.176.73.111])
        by smtp.gmail.com with ESMTPSA id a38sm3930431oic.16.2016.08.03.15.05.08
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Aug 2016 15:05:08 -0700 (PDT)
Subject: Re: TW2866 i2c driver and solo6x10
To: linux-media <linux-media@vger.kernel.org>
References: <25e70ffb-147a-33f4-76cf-3435ab555520@gmail.com>
 <75985f71-e1d6-cf22-91c0-6429955156e6@gmail.com>
From: Marty Plummer <netz.kernel@gmail.com>
Message-ID: <59f51702-cbc6-deda-c64e-56938b4c33e6@gmail.com>
Date: Wed, 3 Aug 2016 17:05:01 -0500
MIME-Version: 1.0
In-Reply-To: <75985f71-e1d6-cf22-91c0-6429955156e6@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="hDBMN32a1FJIvQbFJkvE3Cc8jH7k7X9uH"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--hDBMN32a1FJIvQbFJkvE3Cc8jH7k7X9uH
Content-Type: multipart/mixed; boundary="mVqDpuVCl6dsnFNHRqTIPEW35sxqsugeE"
From: Marty Plummer <netz.kernel@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Message-ID: <59f51702-cbc6-deda-c64e-56938b4c33e6@gmail.com>
Subject: Re: TW2866 i2c driver and solo6x10
References: <25e70ffb-147a-33f4-76cf-3435ab555520@gmail.com>
 <75985f71-e1d6-cf22-91c0-6429955156e6@gmail.com>
In-Reply-To: <75985f71-e1d6-cf22-91c0-6429955156e6@gmail.com>

--mVqDpuVCl6dsnFNHRqTIPEW35sxqsugeE
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 08/03/2016 04:35 PM, Marty Plummer wrote:
> On 08/03/2016 04:01 PM, Andrey Utkin wrote:
>> On Wed, Aug 03, 2016 at 03:26:39PM -0500, Marty Plummer wrote:
>>> An understanable sentement, but its not just about me (though I actua=
lly own two
>>> of the same dvr's). There is a large number, if reports are to be bel=
ieved, of
>>> more or less identical dvr systems with the same security holes and h=
ard-coded
>>> credentials, with no vendor firmware updates. In addition, I am also =
in possesion
>>> of the chip vendor sdk with full source code for the kernel and modul=
es and a
>>> host of pertenant datasheets. My end goal is something along the line=
 of openwrt
>>> or lede for these systems in the interest of the community at large.
>>>
>>> I'm not averse to the concept of hard work, and while I'm very experi=
enced when
>>> it comes to kernel hacking I think I can manage well enough with rele=
vant source
>>> and examples, of which there is a large amount.
>>>
>>> One concern I have is dealing with devicetree, but I think I can mana=
ge.
>>>
>>
>> That's intriguing. I'm interested to know what this model is and where=

>> it can be bought, and also to see all the sdk. BTW have you got sdk fr=
om
>> manufacturer after asking for it, or otherwise? Are manufacturers keen=

>> to answer technical questions?
>>
> The particular device in question was sold by an american company calle=
d
> Night Owl (nightowlsp.com) and is the zeus-dvr5/10 (otherwise identical=

> except for the installed hdd size). The main board bears the markings
> "rs-dm-77a" and the main webserver type binary is called 'raysharp_dvr'=
,
> and only operates in IE using activex and reduced security settings.
>=20
> I'm not certain if you can outright buy it new anymore, as it is very
> old and out of warranty, but a million new clones pop up each day, all
> based on the same hi35xx chipset (mine is hi3520 in particular).
>=20
> I've uploaded most of the source files to https://github.com/Hi-Spy/hi3=
520
> with exception to the PDFs and binary blobs. The sdk is based around
> kernel version 2.6.24, so it's quite old, but only has around 10k lines=

> of diff files between it and stock.
>=20
> No, I was in communication with a few people with @hisilicon.com emails=

> that I managed to find on the kernel mailing list (see arch/arm/mach-hi=
si)
> who eventually pointed me at mobile@huawei.com, but I've yet to recieve=

> a response. In the meanwhile I was trawling the chinese internet for
> data, and managed to come across someone selling it for 5yuan, which is=

> too cheap to pass up. I don't know how cooperative they are going to be=
,
> considering they've been using linux, u-boot, and a host of other GPL'd=

> software without mention or license for at least 5 years, the release
> date of my particular SoC.
>=20
>=20
>=20
Ah crap. I meant to include a 'not' or 'in' in the "While I'm very experi=
enced"
sentence. Brain not working.


--mVqDpuVCl6dsnFNHRqTIPEW35sxqsugeE--

--hDBMN32a1FJIvQbFJkvE3Cc8jH7k7X9uH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIbBAEBCAAGBQJXomqNAAoJEHWEtN3AMJGNexIP93uGeTtvQ5qqC0RN54YOjTUf
uDUmhUkChoh5COSasUscZlUKCl2tFj7nexsEcuROgU0UK4SmApKJo8ke0Ixxv3Ol
8WQawQ//2EPMBCNermvLkVIecumkT+onDoFu4v4vauNMSwmbYcBsblV34f3b0wB+
CwZ5EO+QXPWJo91HnA45p2szlP+AI11Gq68SaQ8fDjyXpaozWMN5fl5EK2B37ZZt
5jczkfeJhtxkw1/ulD6Vs2/aibBfRFPdbgJyEmHWGcKvJGUq6gi+NB70c3efahMw
j7xeudYoAGws/vZ0YWawKEhV9aG+2niFM7PY05HtGw8/HPsJtm6wJEGINhbZvTcr
bK/z63uvgLVJsxeQhDZ+mbyFRLWCzDJ0B9Tk1699C+Un01b/iWzTibZPcyARCQUr
OjlAnWt6b9OrE8SxUwk0hfxy5SWp1+yLzXLMbcWQqH94VAaFjhVOSWCAtA9EAvXE
McsEFJhTNOzPK8pzAKlTPxpCZroVyZ2OHpt9XNWW4efrFCFvWWs2Dw0YHL1KXLT8
uZWJb9/1l+rewRhNOLQnPrZv/n7JvNLfr0+BpejSJhdpwqy7z6hMovolInp3rm9F
k33V0LQaPy4orREKcnsLnCH4ND9eKwfE0jOGMFZpwfoqR18gtF00goU+Kr4PXX+k
qLHPwHeUWhlfYroT5U8=
=uMho
-----END PGP SIGNATURE-----

--hDBMN32a1FJIvQbFJkvE3Cc8jH7k7X9uH--
