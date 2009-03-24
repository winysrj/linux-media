Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yx-out-2324.google.com ([74.125.44.30])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <poplyra@gmail.com>) id 1LlwqQ-0008Qx-Ng
	for linux-dvb@linuxtv.org; Tue, 24 Mar 2009 03:59:10 +0100
Received: by yx-out-2324.google.com with SMTP id 8so1732105yxm.41
	for <linux-dvb@linuxtv.org>; Mon, 23 Mar 2009 19:58:22 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 23 Mar 2009 23:58:22 -0300
Message-ID: <ff07fffe0903231958o3a9fb617y567e7cdc13dd34df@mail.gmail.com>
From: Christian Lyra <lyra@pop-pr.rnp.br>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] problem with KNC1 DVB-C MK3 and TPs ~300Mhz
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

Hi there,

I=B4m playing with a satelco easywatch card (or should be... ) and it
works very nicely with a lot of channels and transponders. But there
are two transponders (309mhz and 321hz) where the video and sound
skips a lot, or dont work/lock at all. Another person had reported the
same problem on IRC today. Perhaps this issue is somewhat related to
the thread "[linux-dvb] TechnoTrend C-1501 - Locking issues on
388Mhz".

Here is the dmesg:

[    2.819472] Linux video capture interface: v2.00
[    2.830678] saa7146: register extension 'budget_av'.
[    2.830770] budget_av 0000:00:00.0: enabling device (0000 -> 0002)
[    2.831231] saa7146: found saa7146 @ mem ffffc20000024000 (revision
1, irq 16) (0x1894,0x0022).
[    2.831244] saa7146 (0): dma buffer size 192512
[    2.831251] DVB: registering new adapter (KNC1 DVB-C MK3)
[    2.867975] adapter failed MAC signature check
[    2.867986] encoded MAC from EEPROM was
ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff
[    3.071061] budget_av: saa7113_init(): saa7113 not found on KNC card
[    3.131338] KNC1-0: MAC addr =3D 00:09:d6:6d:9f:db
[    3.338376] DVB: registering adapter 0 frontend 0 (Philips TDA10023 DVB-=
C)...
[    3.340258] budget-av: ci interface initialised.

the list of good transponders are: 129, 135, 465, 525, 531, 537, 555,
585, and 591

any hints?

-- =

Christian Lyra
PoP-PR/RNP

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
