Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from widget.gizmolabs.org ([69.55.236.117])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ecronin@gizmolabs.org>) id 1JrJKi-0005Rv-Kt
	for linux-dvb@linuxtv.org; Wed, 30 Apr 2008 22:55:23 +0200
Message-Id: <B3017A65-6616-4FBF-BF82-30B3F69B6CAA@gizmolabs.org>
From: Eric Cronin <ecronin@gizmolabs.org>
To: Michael Krufky <mkrufky@linuxtv.org>
In-Reply-To: <37219a840804301136r71b240afi16dcf75b5442fe1b@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v919.2)
Date: Wed, 30 Apr 2008 16:54:43 -0400
References: <CAB8636B-64E8-40CB-9D6C-0F52E9CD2394@gizmolabs.org>
	<37219a840804301134q68a86301y2373329d2fef5a2f@mail.gmail.com>
	<37219a840804301136r71b240afi16dcf75b5442fe1b@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HVR-1800 failing to detect any QAM256 channels
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1147689063=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--===============1147689063==
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha256; boundary="Apple-Mail-13--646549960"
Content-Transfer-Encoding: 7bit

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-13--646549960
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit


On Apr 30, 2008, at 2:36 PM, Michael Krufky wrote:

>>
>> Eric,
>>
>> When you use the scan command to scan for QAM channels, you must
>> specify -a2, to signify that you are scanning digital cable.
>>
>> Try that -- does that work?
>
>
> My bad -- I meant, "-A 2"  (capitol A, space, 2)
>
> -Mike
>

Sorry, forgot to include that I'd tried -A {1,2,3} also:

~$ scan -v -A 2  test-chan118
scanning test-chan118
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
 >>> tune to: 759000000:QAM_256
 >>> tuning status == 0x00
 >>> tuning status == 0x00
 >>> tuning status == 0x00
 >>> tuning status == 0x00
 >>> tuning status == 0x00
 >>> tuning status == 0x00
 >>> tuning status == 0x00
 >>> tuning status == 0x00
 >>> tuning status == 0x00
 >>> tuning status == 0x00
WARNING: >>> tuning failed!!!
 >>> tune to: 759000000:QAM_256 (tuning failed)
 >>> tuning status == 0x00
 >>> tuning status == 0x00
 >>> tuning status == 0x00
 >>> tuning status == 0x00
 >>> tuning status == 0x00
 >>> tuning status == 0x00
 >>> tuning status == 0x00
 >>> tuning status == 0x00
 >>> tuning status == 0x00
 >>> tuning status == 0x00
WARNING: >>> tuning failed!!!
ERROR: initial tuning failed
dumping lists (0 services)
Done.


Thanks,
Eric

--Apple-Mail-13--646549960
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (Darwin)

iQEbBAEBCAAGBQJIGNyTAAoJEIgz4Q+coYsSNk8H9RvaDT5uGKh6DlHEESMXIDOP
4s9iHOr/ISUpagHwD4kh/n2vykOe4qsY/RiiP1lKsMLhwMrPnkGsUKpQFPuewcPr
bqbODFhaZTKjJiMkjnHScTX1xrz9zGdAaka5Rp3vV4gCuYItYbkBW1O+N4t+WNj0
vUnep1BTLVpYQPWKSHdQm3lQYdb2XN9zORqfGyBMaQV9uqogXIxfbJMJOQhcht+g
DrZDYu9UIz9laEiHX4hbOHDrCd2jA/ox0kDgEEuxs0w49nBMXXpUbwf91+Uxel02
Wg3WLcdGnlVUd8Dp3fj6sKD0jdgPSxiSMXQU7bAlYCr9P8MdEzQO5kNkxPGTDA==
=WyHZ
-----END PGP SIGNATURE-----

--Apple-Mail-13--646549960--


--===============1147689063==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1147689063==--
