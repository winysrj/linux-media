Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-17.arcor-online.net ([151.189.21.57])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <debalance@arcor.de>) id 1KFpPg-0003Yd-Fh
	for linux-dvb@linuxtv.org; Mon, 07 Jul 2008 14:01:49 +0200
Message-ID: <487205A0.9060103@arcor.de>
Date: Mon, 07 Jul 2008 14:01:36 +0200
From: =?ISO-8859-1?Q?Philipp_H=FCbner?= <debalance@arcor.de>
MIME-Version: 1.0
To: free_beer_for_all@yahoo.com
References: <892875.74920.qm@web46103.mail.sp1.yahoo.com>
In-Reply-To: <892875.74920.qm@web46103.mail.sp1.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TerraTec Cinergy S2 PCI HD
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

barry bouwsma schrieb:
>> zapping to 1 'ASTRA SDT':
>> sat 0, frequency = 12551 MHz V, symbolrate 22000000, vpid =
>> 0x1fff, apid
>> = 0x1fff sid = 0x000c
>>
>> But mplayer /dev/dvb/adapter0/dvr0 doesn't work:
> 
> You should try tuning to a Real Channel[TM]
> 
> There is no audio or video on Astra SDT, as you see above --
> V+APID == 0x1FFF
> 
> I'm sure that later in your .conf file, there are real channels
> with real video and audio PIDs just waiting to be tuned into
You're right, I didn't notice.

> versuch's mal mit ZDF, u.A...
Klappt, danke ;)

Regards,
Philipp
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIcgWfFhl05MJZ4OgRAk0gAJ4k5mOHnIFLVDCXpJXAZiDGHduzkwCeKSIJ
dTGXDY8ES19CA9VnaZkD1/U=
=WY7d
-----END PGP SIGNATURE-----

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
