Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fmmailgate09.web.de ([217.72.192.184])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jowebe@web.de>) id 1KHwtE-0005oG-U9
	for linux-dvb@linuxtv.org; Sun, 13 Jul 2008 10:25:05 +0200
Received: from web.de
	by fmmailgate09.web.de (Postfix) with SMTP id B29282A31669
	for <linux-dvb@linuxtv.org>; Sun, 13 Jul 2008 10:24:31 +0200 (CEST)
Date: Sun, 13 Jul 2008 10:24:31 +0200
Message-Id: <1068982688@web.de>
MIME-Version: 1.0
From: Johannes Weber <jowebe@web.de>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] problems with smscoreapi
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

 CC [M]  /root/v4l-dvb/v4l/smscoreapi.o
/root/v4l-dvb/v4l/smscoreapi.c: In function 'smscore_detect_mode':
/root/v4l-dvb/v4l/smscoreapi.c:689: error: 'uintptr_t' undeclared (first us=
e in this function)
/root/v4l-dvb/v4l/smscoreapi.c:689: error: (Each undeclared identifier is r=
eported only once
/root/v4l-dvb/v4l/smscoreapi.c:689: error: for each function it appears in.)
/root/v4l-dvb/v4l/smscoreapi.c: In function 'smscore_set_device_mode':
/root/v4l-dvb/v4l/smscoreapi.c:820: error: 'uintptr_t' undeclared (first us=
e in this function)
make[5]: *** [/root/v4l-dvb/v4l/smscoreapi.o] Error 1
make[4]: *** [_module_/root/v4l-dvb/v4l] Error 2
make[3]: *** [modules] Error 2
make[2]: *** [modules] Error 2
make[2]: Leaving directory `/usr/src/linux-2.6.22.18-0.2-obj/i386/default'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/root/v4l-dvb/v4l'
make: *** [all] Error 2

_______________________________________________________________________
Jetzt neu! Sch=FCtzen Sie Ihren PC mit McAfee und WEB.DE. 30 Tage
kostenlos testen. http://www.pc-sicherheit.web.de/startseite/?mc=3D022220


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
