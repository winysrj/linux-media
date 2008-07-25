Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <markus.o.hahn@gmx.de>) id 1KMJKz-0006rx-Pl
	for linux-dvb@linuxtv.org; Fri, 25 Jul 2008 11:11:46 +0200
Date: Fri, 25 Jul 2008 11:11:12 +0200
From: "Markus Oliver Hahn" <markus.o.hahn@gmx.de>
Message-ID: <20080725091112.257600@gmx.net>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb]  stb6100,stb0899 issues with TT-S2 3200
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


Hi there,  =

getting the newest multiproto drivers with Mercurial. =

So I` trying to get  szap better working (I can`t get any S2 transponders ).
At the first step, I keep hanging on 'FE_GET_INFO': =

Infos capabilities returns only =


 --- schnipp ----
 fe name:  STB0899 Multistandard =

 type  is QPSK -> DVB-S =

 f min 950000 =

 f max 2150000 =

 f stepsize 0 =

 f tolerance 0 =

 symbol rate min  0 =

 symbol rate max  0 =

 symbol rate tolerance  0 =


 frontend capabilities 0x1 =

 FE_CAN_INVERSION_AUTO

 --- schnapp ----

So there infos about symbol rate and capabilities very less. =

Howto enhance this in the kernel modules? =


regards moviemax =



-- =

Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt?
Der kann`s mit allen: http://www.gmx.net/de/go/multimessenger

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
