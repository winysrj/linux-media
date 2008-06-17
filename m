Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from eazy.amigager.de ([213.239.192.238])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tino@tikei.de>) id 1K8Xyq-0008CN-1z
	for linux-dvb@linuxtv.org; Tue, 17 Jun 2008 12:00:00 +0200
Received: from dose.home.local (port-212-202-169-83.dynamic.qsc.de
	[212.202.169.83])
	by eazy.amigager.de (Postfix) with ESMTP id 7669AC8C05A
	for <linux-dvb@linuxtv.org>; Tue, 17 Jun 2008 11:59:56 +0200 (CEST)
Received: from scorpion by dose.home.local with local (Exim 4.69)
	(envelope-from <tino.keitel@tikei.de>) id 1K8Xzd-0001p8-7u
	for linux-dvb@linuxtv.org; Tue, 17 Jun 2008 12:00:49 +0200
Date: Tue, 17 Jun 2008 12:00:49 +0200
From: Tino Keitel <tino.keitel@tikei.de>
To: linux-dvb@linuxtv.org
Message-ID: <20080617100049.GA6880@dose.home.local>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] What source for the CinergyT2-V8.patch
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

Hi,

what v4l source should I use for the CinergyT2-V8.patch patch? I tried
the current v4l hg tree. The first problem was that the last line of
the patch missed a trailing line feed. Then I got this failure:

$ patch -p1 < ../CinergyT2-V8.patch
patching file linux/drivers/media/dvb/Kconfig
patching file linux/drivers/media/dvb/cinergyT2/Kconfig
patching file linux/drivers/media/dvb/cinergyT2/Makefile
patching file linux/drivers/media/dvb/cinergyT2/cinergyT2.c
Reversed (or previously applied) patch detected!  Assume -R? [n] 
Apply anyway? [n] 
Skipping patch.
1 out of 1 hunk ignored -- saving rejects to file
linux/drivers/media/dvb/cinergyT2/cinergyT2.c.rej
patching file linux/drivers/media/dvb/dvb-usb/Kconfig
Hunk #1 FAILED at 241.
1 out of 1 hunk FAILED -- saving rejects to file
linux/drivers/media/dvb/dvb-usb/Kconfig.rej
patching file linux/drivers/media/dvb/dvb-usb/Makefile
Hunk #1 succeeded at 64 with fuzz 2 (offset 3 lines).
patching file linux/drivers/media/dvb/dvb-usb/cinergyT2-core.c
patching file linux/drivers/media/dvb/dvb-usb/cinergyT2-fe.c
patching file linux/drivers/media/dvb/dvb-usb/cinergyT2.h

Regards,
Tino

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
