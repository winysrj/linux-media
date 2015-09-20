Return-path: <linux-media-owner@vger.kernel.org>
Received: from kronos.mailus.de ([217.172.179.146]:49754 "EHLO
	kronos.mailus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529AbbITJFx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Sep 2015 05:05:53 -0400
Message-ID: <55FE76EB.9050604@vontaene.de>
Date: Sun, 20 Sep 2015 11:05:47 +0200
From: Erik Andresen <erik@vontaene.de>
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Roger_M=E5rtensson?= <roger.martensson@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: Terratec H7 Rev. 4 is DVBSky
References: <55F2ED67.3030306@vontaene.de> <55FDD604.1040003@gmail.com> <55FDD817.6090904@gmail.com>
In-Reply-To: <55FDD817.6090904@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="J6QhKcl9j4h7Ta2nNsVUIRTuwAPRC4TTJ"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--J6QhKcl9j4h7Ta2nNsVUIRTuwAPRC4TTJ
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: quoted-printable

Hi Roger,

> I'm not able to enable any protocols. Nothing happens when running ir-k=
eytable with "-p rc-5". Nothing shows in the row "Enabled protocols" and =
nothing happens when testing with "ir-keytable -t".=20
try to give it the device, e.g.

ir-keytable -d /dev/input/event14 -t

I was able to get output from it. The device is now running for a week un=
der mythbackend.

greetings,
Erik


Am 19.09.2015 um 23:48 schrieb Roger M=E5rtensson:
> Den 2015-09-19 kl. 23:39, skrev Roger M=E5rtensson:
>> Den 2015-09-11 kl. 17:04, skrev Erik Andresen:
>>> Hi,
>>>
>>> I recently got a Terratec H7 in Revision 4 and turned out that it is =
not
>>> just a new revision, but a new product with USB ProductID 0x10a5.
>>> Previous revisions have been AZ6007, but this revision does not work
>>> with this driver [1].
>>>
>>> Output of lsusb (extended output attached):
>>> Bus 001 Device 011: ID 0ccd:10a5 TerraTec Electronic GmbH
>>>
>>> The revision 4 seems to a DVBSky variant, adding its Product ID to
>>> dvbsky.c with the attached patch enabled me to scan for channels and
>>> watch DVB-C and DVB-T.
>>>
>>> greetings,
>>> Erik
>>>
>>> [1] https://www.mail-archive.com/linux-media@vger.kernel.org/msg70934=
=2Ehtml
>> Do I feel lucky or what..
>> Just got my H7 devices delivered and noticed the lack of supported dri=
ver and some quick searches gave me this e-mail.
>> Maybe should take a trip to the race track. :)
>>
>> I have tried this driver and it works wonderfully. I have noticed a fr=
eeze or two when handling the device (powering off, ripping USB etc) but =
I'm not sure it is the driver that is causing this.
>>
>> I do notice something weird. The remote doesn't seem to work.
>> Found /sys/class/rc/rc0/ (/dev/input/event14) with:
>>         Driver dvb_usb_dvbsky, table rc-tt-1500
>>         Supported protocols: RC-5
>>         Enabled protocols:
>>         Name: Terratec H7 Rev.4
>>         bus: 3, vendor/product: 0ccd:10a5, version: 0x0000
>>         Repeat delay =3D 500 ms, repeat period =3D 125 ms
>>
>> I'm not able to enable any protocols. Nothing happens when running ir-=
keytable with "-p rc-5". Nothing shows in the row "Enabled protocols" and=
 nothing happens when testing with "ir-keytable -t".
>>
>> I've tested on a Ubuntu 14.04 (Mythbuntu) with Linux Kernel 4.2 that I=
 have to compile myself. (Don't know in which kernel dvbsky was released)=

>> Tested using both Kaffeine and MythTV and it works like a charm (with =
the exception of missing IR).
>> I tested using DVB-C with CI for encrypted channels
> One more this..
> Is there a possibility that Signal strength support could be added to t=
he driver?
> MythTV uses this and I think Kaffeine also uses it (not sure). Currentl=
y the logs are filling up with "Operation not supported".



--J6QhKcl9j4h7Ta2nNsVUIRTuwAPRC4TTJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlX+dusACgkQ8NqlQQxmej6v0wCgv7XWrRjVaV1Gr0Fw1CROsAYN
lQ0AoKE5DpHGAszY141E1PiqOVqnDFSt
=O8fO
-----END PGP SIGNATURE-----

--J6QhKcl9j4h7Ta2nNsVUIRTuwAPRC4TTJ--
