Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web23204.mail.ird.yahoo.com ([217.146.189.59])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <newspaperman_germany@yahoo.com>) id 1KbEtZ-0000mT-3F
	for linux-dvb@linuxtv.org; Thu, 04 Sep 2008 15:29:12 +0200
Date: Thu, 4 Sep 2008 13:27:49 +0000 (GMT)
From: Newsy Paper <newspaperman_germany@yahoo.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Message-ID: <772209.85557.qm@web23204.mail.ird.yahoo.com>
Subject: [linux-dvb]  Drivers for TT S2-3200
Reply-To: newspaperman_germany@yahoo.com
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

@Igor: I tried your new driver. My first impression is that it works stable=
 with me TT S2-3200 so thx for providing a driver that's uptodate.

I found 3 bugs:
1) When I switch to Nilesat (this is the weakest satellite; I get a weak si=
gnal, but still no dropouts and pixelation). When I switch from one transpo=
nder to another on that satellite I get no more signal lock on the chosen t=
ransponder. I have to kill and restart vdr to get signal again. It doesn't =
depend on the transponder frequency it occours with all transponders on nil=
esat (while for others it could be another satellite that is so weak to cau=
se such switching problems). The problem already occoured with multiproto +=
 channel lock patch.

2) There's still this bug with DVB-S2 SR 30000 3/4 I don't know if you alre=
ady expierenced this bug but it only occours with linux drivers. In Windows=
 it's working.

3) no signal strengh on femon, but I think you already know this.

kind regards


Newsy

__________________________________________________
Do You Yahoo!?
Sie sind Spam leid? Yahoo! Mail verf=FCgt =FCber einen herausragenden Schut=
z gegen Massenmails. =

http://mail.yahoo.com =


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
