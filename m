Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n20.bullet.mail.ukl.yahoo.com ([87.248.110.137])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <eallaud@yahoo.fr>) id 1KiYY0-0000He-Rx
	for linux-dvb@linuxtv.org; Wed, 24 Sep 2008 19:53:11 +0200
Date: Wed, 24 Sep 2008 13:52:31 -0400
From: manu <eallaud@yahoo.fr>
To: linux-dvb@linuxtv.org
In-Reply-To: <88eb5e580809240859g3bed70c9x31793fea24cf6285@mail.gmail.com>
	(from ian.ravisky@gmail.com on Wed Sep 24 11:59:15 2008)
Message-Id: <1222278751l.11577l.0l@manu-laptop>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Re :  DVB-S2 and CA
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Le 24.09.2008 11:59:15, Ian Ravisky a =E9crit=A0:
> Hello list,
> =

> We have Technotrend's DVB-S2 TTbudget3200 board with CA CI board.
> While DVB-S2 board does work CA CI slot is not detected.
> We use Multiproto and Debian.
> =

> Was anybody succeed to make CA CI working with any DVB-S2 receiver ?
> We need to make it running urgently.
> =

> Your help will be greatly appreciated.

Several people (me included) succeeded with an AstonCrypt (version is =

2.18) CAM (can decode 2 channels simultaneously).
Some CAM are known to be problematic you might want to check (perhaps =

by posting on the list). So you should post the logs: dmesg, probably =

loading the modules with cam_debug=3D255 (you need to find for which =

module this ie possible).
HTH
Bye
Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
