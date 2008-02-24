Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from main.gmane.org ([80.91.229.2] helo=ciao.gmane.org)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gldd-linux-dvb@m.gmane.org>) id 1JTNAm-0001Rn-Rq
	for linux-dvb@linuxtv.org; Sun, 24 Feb 2008 21:10:08 +0100
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1JTNAg-0002Mb-S7
	for linux-dvb@linuxtv.org; Sun, 24 Feb 2008 20:10:02 +0000
Received: from pop9-633.catv.wtnet.de ([213.209.74.122])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Sun, 24 Feb 2008 20:10:02 +0000
Received: from Fritsche.Markus by pop9-633.catv.wtnet.de with local (Gmexim
	0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Sun, 24 Feb 2008 20:10:02 +0000
To: linux-dvb@linuxtv.org
From: Markus Fritsche <Fritsche.Markus@gmx.net>
Date: Sun, 24 Feb 2008 20:59:58 +0100
Message-ID: <fpsibu$4ea$1@ger.gmane.org>
Mime-Version: 1.0
Subject: [linux-dvb] ADS Tech Mini Dual TV USB
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

searching in the internet I found that the USB stick is (maybe)
experimentally supported by the tm6000 driver. The wiki page
http://www.linuxtv.org/wiki/index.php/Xceive_XC3028/XC2028 gives an
advice how to extract the firmware out of the driver; however, the
driver for my stick (PTV339 WHQL Driver 1.0.0.36.exe) doesn't install a
file named hcw85bda.sys, but a file named "PTV339.SYS", being 283kb big.

It also installs serveral files in C:\WINDOWS\PTV339\XCEIVE (*.I2C) with
names like "XC3028_*.I2C").

Does anyone know a trick how to extract an fw from there or if some
other firmware might work with the above mentioned stick?

Regards, Markus


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
