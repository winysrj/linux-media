Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <markus.o.hahn@gmx.de>) id 1KMNuW-0002SF-6v
	for linux-dvb@linuxtv.org; Fri, 25 Jul 2008 16:04:45 +0200
Date: Fri, 25 Jul 2008 16:04:11 +0200
From: "Markus Oliver Hahn" <markus.o.hahn@gmx.de>
Message-ID: <20080725140411.248480@gmx.net>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb]  multipoto frontend.h missmatch
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

are there any documentation or HOWTOS about the =

differences of some funktions declared in frontend.h =

It`s not so clear  how and when to use =

the   fe_xxx   dvbfe_xxx dvb_frontend_xxx =


Is it possilble resp. does it make sense to use all of them? =


I use the multiproto modules and get with patched szap or own application =


`FE_READ_STATUS failed: Invalid argument =


regards markus =


-- =

Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt?
Der kann`s mit allen: http://www.gmx.net/de/go/multimessenger

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
