Return-path: <linux-media-owner@vger.kernel.org>
Received: from rolfschumacher.eu ([195.8.233.65]:40009 "EHLO august.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146AbZCLWlI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2009 18:41:08 -0400
Received: from [192.168.1.109] (HSI-KBW-078-043-156-228.hsi4.kabel-badenwuerttemberg.de [78.43.156.228])
	(Authenticated sender: rolf)
	by august.de (Postfix) with ESMTPA id DA3AA1FE22
	for <linux-media@vger.kernel.org>; Thu, 12 Mar 2009 23:32:58 +0100 (CET)
Message-ID: <49B98D9A.5000609@august.de>
Date: Thu, 12 Mar 2009 23:32:58 +0100
From: Rolf Schumacher <mailinglist@august.de>
Reply-To: linux-media@vger.kernel.org
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [linux-dvb] getting started
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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
make[1]: *** Keine Regel vorhanden, um das Target ».myconfig«,
  benötigt von »config-compat.h«, zu erstellen.  Schluss.
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

