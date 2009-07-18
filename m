Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fmmailgate02.web.de ([217.72.192.227])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <emagick@magic.ms>) id 1MSD1P-0008Os-RM
	for linux-dvb@linuxtv.org; Sat, 18 Jul 2009 18:44:28 +0200
Received: from smtp07.web.de (fmsmtp07.dlan.cinetic.de [172.20.5.215])
	by fmmailgate02.web.de (Postfix) with ESMTP id A981E10B582BC
	for <linux-dvb@linuxtv.org>; Sat, 18 Jul 2009 18:43:54 +0200 (CEST)
Received: from [217.228.192.251] (helo=[172.16.99.2])
	by smtp07.web.de with asmtp (TLSv1:AES256-SHA:256)
	(WEB.DE 4.110 #277) id 1MSD0s-00024a-00
	for linux-dvb@linuxtv.org; Sat, 18 Jul 2009 18:43:54 +0200
Message-ID: <4A61FBC7.3050006@magic.ms>
Date: Sat, 18 Jul 2009 18:43:51 +0200
From: emagick@magic.ms
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Cinergy T2 stopped working with kernel 2.6.30
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

My Cinergy T2 (T=B2) doesn't work with kernels 2.6.30, 2.6.30.1, and 2.6.31=
-rc3,
but it works with kernel 2.6.29. The kernel logs

   dvb-usb: recv bulk message failed: -110

and the application (I've tried mythtv and mplayer) trying to access the DV=
B receiver
times out when trying to tune to a channel.

Is there anyone for whom dvb_usb_cinergyT2 works with kernel 2.6.30 or late=
r?



_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
