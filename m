Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mout1.freenet.de ([195.4.92.91])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ruediger.dohmhardt@freenet.de>) id 1LL2lS-0004Vx-C4
	for linux-dvb@linuxtv.org; Thu, 08 Jan 2009 22:50:07 +0100
Received: from [195.4.92.19] (helo=9.mx.freenet.de)
	by mout1.freenet.de with esmtpa (ID ruedigerDohmhardt@freenet.de) (port
	25) (Exim 4.69 #76) id 1LL2lO-0000vw-Pj
	for linux-dvb@linuxtv.org; Thu, 08 Jan 2009 22:50:02 +0100
Received: from 91-64-66-95-dynip.superkabel.de ([91.64.66.95]:60003
	helo=[192.168.2.112])
	by 9.mx.freenet.de with esmtpa (ID ruedigerDohmhardt@freenet.de) (port
	25) (Exim 4.69 #76) id 1LL2lO-0005q2-LU
	for linux-dvb@linuxtv.org; Thu, 08 Jan 2009 22:50:02 +0100
Message-ID: <496674FA.8070603@freenet.de>
Date: Thu, 08 Jan 2009 22:49:46 +0100
From: Ruediger Dohmhardt <ruediger.dohmhardt@freenet.de>
MIME-Version: 1.0
To: "linux-dvb: linuxtv.org" <linux-dvb@linuxtv.org>
Subject: [linux-dvb] s2-liplianin compiles and works for Mantis 2033 (DVB-C)
 on SUSE 11.1 kernel 2.6.27.7-9-default
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Dear list members,

just some feedback:
The s2-liplianin driver works here for the DVB-C Mantis-2033 chip
(Twinhan AD-CP300 card).
I compiled and installed it on a SUSE 11.1 system.

HD-TV works, too.

By applying the 2 patches

   
vdr-1.7.0-h264-syncearly-framespersec-audioindexer-fielddetection-speedup.diff

and

    vdr-1.7.0-s2api-07102008-h264-clean.patch

to "vdr-1.7.0", then installing

    vdr-xineliboutput-1.0.0-1.tgz
  
the channel "Anixe" (1080i) works, too.


Ciao Ruediger





_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
