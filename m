Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:33077 "EHLO
	mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755188AbcHCVfa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Aug 2016 17:35:30 -0400
Received: by mail-oi0-f65.google.com with SMTP id l9so21040615oih.0
        for <linux-media@vger.kernel.org>; Wed, 03 Aug 2016 14:35:30 -0700 (PDT)
Received: from [192.168.1.7] (cpe-72-176-73-111.stx.res.rr.com. [72.176.73.111])
        by smtp.gmail.com with ESMTPSA id r65sm4733929oif.0.2016.08.03.14.35.28
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Aug 2016 14:35:28 -0700 (PDT)
Subject: Re: TW2866 i2c driver and solo6x10
References: <25e70ffb-147a-33f4-76cf-3435ab555520@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
From: Marty Plummer <netz.kernel@gmail.com>
Message-ID: <75985f71-e1d6-cf22-91c0-6429955156e6@gmail.com>
Date: Wed, 3 Aug 2016 16:35:22 -0500
MIME-Version: 1.0
In-Reply-To: <25e70ffb-147a-33f4-76cf-3435ab555520@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="w2QV937anJDeUTo89rBSFj7jfVWlpjFIM"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--w2QV937anJDeUTo89rBSFj7jfVWlpjFIM
Content-Type: multipart/mixed; boundary="SB9T5IqdS0nfM67pVMaqmuKmB5SsDWifQ"
From: Marty Plummer <netz.kernel@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Message-ID: <75985f71-e1d6-cf22-91c0-6429955156e6@gmail.com>
Subject: Re: TW2866 i2c driver and solo6x10
References: <25e70ffb-147a-33f4-76cf-3435ab555520@gmail.com>
In-Reply-To: <25e70ffb-147a-33f4-76cf-3435ab555520@gmail.com>

--SB9T5IqdS0nfM67pVMaqmuKmB5SsDWifQ
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 08/03/2016 04:01 PM, Andrey Utkin wrote:
> On Wed, Aug 03, 2016 at 03:26:39PM -0500, Marty Plummer wrote:
>> An understanable sentement, but its not just about me (though I actual=
ly own two
>> of the same dvr's). There is a large number, if reports are to be beli=
eved, of
>> more or less identical dvr systems with the same security holes and ha=
rd-coded
>> credentials, with no vendor firmware updates. In addition, I am also i=
n possesion
>> of the chip vendor sdk with full source code for the kernel and module=
s and a
>> host of pertenant datasheets. My end goal is something along the line =
of openwrt
>> or lede for these systems in the interest of the community at large.
>>
>> I'm not averse to the concept of hard work, and while I'm very experie=
nced when
>> it comes to kernel hacking I think I can manage well enough with relev=
ant source
>> and examples, of which there is a large amount.
>>
>> One concern I have is dealing with devicetree, but I think I can manag=
e.
>>
>=20
> That's intriguing. I'm interested to know what this model is and where
> it can be bought, and also to see all the sdk. BTW have you got sdk fro=
m
> manufacturer after asking for it, or otherwise? Are manufacturers keen
> to answer technical questions?
>=20
The particular device in question was sold by an american company called
Night Owl (nightowlsp.com) and is the zeus-dvr5/10 (otherwise identical
except for the installed hdd size). The main board bears the markings
"rs-dm-77a" and the main webserver type binary is called 'raysharp_dvr',
and only operates in IE using activex and reduced security settings.

I'm not certain if you can outright buy it new anymore, as it is very
old and out of warranty, but a million new clones pop up each day, all
based on the same hi35xx chipset (mine is hi3520 in particular).

I've uploaded most of the source files to https://github.com/Hi-Spy/hi352=
0
with exception to the PDFs and binary blobs. The sdk is based around
kernel version 2.6.24, so it's quite old, but only has around 10k lines
of diff files between it and stock.

No, I was in communication with a few people with @hisilicon.com emails
that I managed to find on the kernel mailing list (see arch/arm/mach-hisi=
)
who eventually pointed me at mobile@huawei.com, but I've yet to recieve
a response. In the meanwhile I was trawling the chinese internet for
data, and managed to come across someone selling it for 5yuan, which is
too cheap to pass up. I don't know how cooperative they are going to be,
considering they've been using linux, u-boot, and a host of other GPL'd
software without mention or license for at least 5 years, the release
date of my particular SoC.




--SB9T5IqdS0nfM67pVMaqmuKmB5SsDWifQ--

--w2QV937anJDeUTo89rBSFj7jfVWlpjFIM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXomOaAAoJEHWEtN3AMJGN3AEP/iwz9veYOFHCBftm+2mk/7TN
/m2G2MfLTA72hn/cRYlBddG6Pu00NjWZDrby3cHnDF2mvocplMnlk2biuq4/PgXQ
6/H/GV34hRidgaqxe4RUzecEZGsPFh+HmPGccTdNDMxRMxrhNsl8quD/rf1/vUki
ne3vj/HGBYre/rP0C8kM2I61err2a+CzKubGDigPSrcDbyjrPsiQY9IRBti11FHq
kFHXTIy0CXnUJ0msAet4LJf7CVJck4LIQt89Qux0Kpl2m3fvwbZDOgYC0mOfLtWC
1zIqd8HPNANCs5qWZRA4jxfboGAIMbo1w5cojUjqaj5KbqC+AAJi980djdJ5crba
kaAZ/hAEZDe4qcI/PtQiQ1u24HR49l//iMh0BYWUQ3ufaLt8REqtUO4I6HEbShiA
O0QEPMm5dfKkkJLyrnvwtXqW8uXz2PkYw32ngmSNVJNqKBTpkVKgRlL/cpdI1R2u
MJ783O8fltDLxKr2hSkzwetwioRMqVVbrmeSmSAJLgT/lOMQqDB0x5nuZrqNN1ax
iRDHYrElcb5Vxh67oO1ia8emDCcqNkGs35KlHl4ByyFG0fuva08McC2tRKVHT24b
MSv1AAE02UuMEnyyUW4uqK4M5abyEXOpESmVPBnwJ8vBDK3aQDiVxf9rtHDM8DXQ
1aS/IRrhtmUPA7zOcujt
=Iskf
-----END PGP SIGNATURE-----

--w2QV937anJDeUTo89rBSFj7jfVWlpjFIM--
