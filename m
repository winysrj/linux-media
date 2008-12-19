Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rayleigh.systella.fr ([213.41.184.253])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bertrand@systella.fr>) id 1LDdOS-0002Nx-7x
	for linux-dvb@linuxtv.org; Fri, 19 Dec 2008 12:19:45 +0100
Message-ID: <494B8316.7000904@systella.fr>
Date: Fri, 19 Dec 2008 12:18:46 +0100
From: =?ISO-8859-1?Q?BERTRAND_Jo=EBl?= <bertrand@systella.fr>
MIME-Version: 1.0
To: Alan_beaven <nullsleep247@googlemail.com>
References: <1225828400.21939.4.camel@Nulltop>
In-Reply-To: <1225828400.21939.4.camel@Nulltop>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] a577 and a306,
	willing to run tests to get it working
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Alan_beaven a =E9crit :
> Well i have an AVerMedia AVerTV Hybrid Express (A577) ( wiki link
> http://www.linuxtv.org/wiki/index.php/AVerMedia_AVerTV_Hybrid_Express_(A5=
77) ) or does this all ready work?
> =

> i am all so getting a avermedia a306
> ( http://www.avermedia.com/avertv/Product/ProductDetail.aspx?Id=3D376&SI=
=3Dtrue ) this doesnt seem like it will work under linux, i will post detal=
s about it when i get the card to help people.

	Are there any news about A577 support ? I have made some tests with
2.6.27.9 kernel without any result. cx23885 is seen by system :

cx23885[0]: i2c bus 0 registered
cx23885[0]: i2c bus 1 registered
cx23885[0]: i2c bus 2 registered
cx23885_dev_checkrevision() Hardware revision =3D 0xb0
cx23885[0]/0: found at 0000:02:00.0, rev: 2, irq: 16, latency: 0, mmio:
0xf0000000
cx23885 0000:02:00.0: setting latency timer to 64

but no other chip. I have made some tests with card option, but the obly
one that load a demodulator is card=3D4. I don't know if I have made a
mistake, but dvbscan does not work.

	I have some time to test now, but I only have a RTC internet connection.

	Regards,

	JKB


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
