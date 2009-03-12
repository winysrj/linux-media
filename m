Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rolfschumacher.eu ([195.8.233.65] helo=august.de ident=postfix)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mailinglist@august.de>) id 1LhsjJ-0007He-On
	for linux-dvb@linuxtv.org; Thu, 12 Mar 2009 22:46:18 +0100
Received: from [192.168.1.109]
	(HSI-KBW-078-043-156-228.hsi4.kabel-badenwuerttemberg.de
	[78.43.156.228]) (Authenticated sender: rolf)
	by august.de (Postfix) with ESMTPA id 2D2D91FE22
	for <linux-dvb@linuxtv.org>; Thu, 12 Mar 2009 22:46:14 +0100 (CET)
Message-ID: <49B982A5.7010103@august.de>
Date: Thu, 12 Mar 2009 22:46:13 +0100
From: Rolf Schumacher <mailinglist@august.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] getting started
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

I once had my TechnoTrend DVB-C driver working with linux, looking tv.
However, completely forgot how I managed that.

I think I was following the wiki

How to Obtain, Build and Install V4L-DVB Device Driver

I checked out the v4l-dvb sources using Mercurial.
However, a make failed immediately:

------------
make -C /home/rsc/src/v4l-dvb/v4l
make[1]: Entering directory `/home/rsc/src/v4l-dvb/v4l'
Updating/Creating .config
Preparing to compile for kernel version 2.6.28
File not found: /lib/modules/2.6.28-7.slh.3-sidux-686/build/.config at
./scripts/make_kconfig.pl line 32, <IN> line 4.
make[1]: *** Keine Regel vorhanden, um das Target =BB.myconfig=AB,
  ben=F6tigt von =BBconfig-compat.h=AB, zu erstellen.  Schluss.
make[1]: Leaving directory `/home/rsc/src/v4l-dvb/v4l'
make: *** [all] Fehler 2
-----------

Am I on the right track?
If so, what is missing?

ngong

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
