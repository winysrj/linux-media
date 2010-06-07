Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <epek@gmx.net>) id 1OLXjd-0005D6-6o
	for linux-dvb@linuxtv.org; Mon, 07 Jun 2010 10:31:06 +0200
Received: from mail.gmx.net ([213.165.64.20])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-c) with smtp
	for <linux-dvb@linuxtv.org>
	id 1OLXja-0000X4-5E; Mon, 07 Jun 2010 10:31:04 +0200
Message-ID: <4C0CAE38.8050806@gmx.net>
Date: Mon, 07 Jun 2010 10:30:48 +0200
From: "Erich N. Pekarek" <epek@gmx.net>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Terratec Cinergy Piranha tuning (again)
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hello,

my DVB-T Stick, that formerly worked fine under previous kernel versions =

now does not tune to any channel unter 2.6.32+.
The old repositories siano-dev and sms1xxx won=B4t compile without manual =

changes to the code.

Symptoms: Stick gets recognized, firmware gets loaded, frontend gets =

loaded. While tuning, signal an snr levels are always 0 (zero) with =

actual modules from mainstream kernels. I already tried to look at the =

source, but this specific model seems to run with basic initialisation, =

while Hauppauge sticks and others have a specific initialization array. =

I don't have any specification datasheets.

Do you have any idea, where to look for the bug? Could it be a =

misinitialization of the stick's tuner?

Thanks in advance

Regards
Erich

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
