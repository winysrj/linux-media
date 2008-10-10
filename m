Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <HWerner4@gmx.de>) id 1KoIk8-0007HC-He
	for linux-dvb@linuxtv.org; Fri, 10 Oct 2008 16:13:26 +0200
Date: Fri, 10 Oct 2008 16:12:52 +0200
From: "Hans Werner" <HWerner4@gmx.de>
In-Reply-To: <48EF3BC3.4050802@hemmail.se>
Message-ID: <20081010141252.107560@gmx.net>
MIME-Version: 1.0
References: <48EF3BC3.4050802@hemmail.se>
To: sacha <sacha@hemmail.se>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Twinhan 1041 (SP 400) and S2API
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


> Hello
> =

> I tried my card with I.Liplianin sources without any luck. Have I missed =

> something?
> Driver for my card seems not to be there
> KR
> =


I believe the driver code for the mantis PCI bridge chip is missing from Ig=
or's
STB0899 S2API patch. That code is available here
http://jusst.de/hg/mantis
and here
http://www.twinhan.com/files/AW/Linux/AZLinux_v1.4.2_CI_FC6.tar.gz

so it ought to be possible to add it.

Regards,
Hans
 =

-- =

Release early, release often.

GMX Kostenlose Spiele: Einfach online spielen und Spa=DF haben mit Pastry P=
assion!
http://games.entertainment.gmx.net/de/entertainment/games/free/puzzle/61691=
96

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
