Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by mail.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <markus.o.hahn@gmx.de>) id 1M9GrB-0000gM-9z
	for linux-dvb@linuxtv.org; Wed, 27 May 2009 12:59:39 +0200
Date: Wed, 27 May 2009 12:59:02 +0200
From: "Markus Oliver Hahn" <markus.o.hahn@gmx.de>
Message-ID: <20090527105902.203620@gmx.net>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb]  fe status values
Reply-To: linux-media@vger.kernel.org
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

Hi there, =

I was just going throug the dvbapi 5.0 =

but I couldn`t find ow to interpret the =

values which I get by =




int ioctl( int fd, int request =3D FE_READ_SIGNAL_STRENGTH, int16_t *streng=
th); =


and =


int ioctl(int fd, int request =3D FE_READ_SNR, int16_t *snr)

strengt should be (signed) dBm =

and
    0.snr dB

is this right ?


regards markus =



-- =

Neu: GMX FreeDSL Komplettanschluss mit DSL 6.000 Flatrate + Telefonanschlus=
s f=FCr nur 17,95 Euro/mtl.!* http://portal.gmx.net/de/go/dsl02

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
