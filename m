Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by mail.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <markus.o.hahn@gmx.de>) id 1LyTS4-00006H-A0
	for linux-dvb@linuxtv.org; Mon, 27 Apr 2009 18:13:04 +0200
Date: Mon, 27 Apr 2009 18:12:28 +0200
From: "Markus Oliver Hahn" <markus.o.hahn@gmx.de>
Message-ID: <20090427161228.17140@gmx.net>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb]  stv090x and i2c
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

I want to access the registers of stv090x via I2C (/dev/i2c-x) =


the i2c address of the stv090x is 0x68

the register adress is e.g. STV090x _SYNTCTRL  0xf1b6 =

how can I access this register with functions defined in <linux/i2c-dev.h>

I have seen there is unforutnatly a restriction in i2c-dev.h =



/* Note: 10-bit addresses are NOT supported! */

Do I have a problem now to access 16bit registers? =


regards markus


-- =

Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt? Der kann`s mit allen: =
http://www.gmx.net/de/go/multimessenger01

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
