Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <biribi@free.fr>) id 1ON6GY-0005BM-IN
	for linux-dvb@linuxtv.org; Fri, 11 Jun 2010 17:35:31 +0200
Received: from smtp19.orange.fr ([80.12.242.17])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-a) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1ON6GX-0005YL-Cr; Fri, 11 Jun 2010 17:35:30 +0200
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf1907.orange.fr (SMTP Server) with ESMTP id 2AAEA20002A3
	for <linux-dvb@linuxtv.org>; Fri, 11 Jun 2010 17:35:29 +0200 (CEST)
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf1907.orange.fr (SMTP Server) with ESMTP id 1BB4A2000254
	for <linux-dvb@linuxtv.org>; Fri, 11 Jun 2010 17:35:29 +0200 (CEST)
Received: from [192.168.1.102] (ANantes-156-1-29-102.w90-12.abo.wanadoo.fr
	[90.12.20.102])
	by mwinf1907.orange.fr (SMTP Server) with ESMTP id DEE2D2000212
	for <linux-dvb@linuxtv.org>; Fri, 11 Jun 2010 17:35:28 +0200 (CEST)
Message-ID: <4C1257C0.9010602@free.fr>
Date: Fri, 11 Jun 2010 17:35:28 +0200
From: Damien Bally <biribi@free.fr>
MIME-Version: 1.0
To: "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>
Subject: [linux-dvb] AverTV volar Black HD femon values
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
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

Hi all

Though this usb stick works fine with the last mercurial sources,
vdr-femon doesn't output any usable values (str snr ber unc)

On the other hand, I can't compile dvb-apps to try the original femon app :

CC diseqc.o
In file included from diseqc.c:3:
/usr/include/time.h:105: erreur: conflicting types for 'timer_t'
/usr/include/linux/types.h:22: erreur: previous declaration of 'timer_t'
was here

Any tip ?

Thanks

Damien



_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
