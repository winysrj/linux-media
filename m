Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <nickpetrik@gmx.net>) id 1JrVS0-00085p-PL
	for linux-dvb@linuxtv.org; Thu, 01 May 2008 11:51:41 +0200
Date: Thu, 01 May 2008 11:51:07 +0200
From: "Nick Petrik" <nickpetrik@gmx.net>
In-Reply-To: <mailman.0.1209634192.28257.linux-dvb@linuxtv.org>
Message-ID: <20080501095107.11680@gmx.net>
MIME-Version: 1.0
References: <mailman.0.1209634192.28257.linux-dvb@linuxtv.org>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Terratec Cinergy C PCI - channel scan stops after
	trasnponder is found
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

Hi all,

I am using a Terretec Cinergy C PCI DVB card together with the latest MANTI=
S driver.

Driver loads without any issues and Card is detected correctly.
However when I start scanning for channels using w_scan or Kaffeine
the scanning process stops after it finds a transponder:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
Using DVB device 0:0 "Philips TDA10023 DVB-C"
tuning DVB-C to 738000000
inv:2 sr:6875000 fecH:0 mod:3
. LOCKED.
Transponders: 2/4
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
Am I missing anything? Your help is very much appreciated. Thanks Nick



-- =

Der GMX SmartSurfer hilft bis zu 70% Ihrer Onlinekosten zu sparen! =

Ideal f=FCr Modem und ISDN: http://www.gmx.net/de/go/smartsurfer

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
