Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mx03.lb01.inode.at ([62.99.145.3] helo=mx.inode.at)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <philipp@kolmann.at>) id 1JukuB-0000YA-33
	for linux-dvb@linuxtv.org; Sat, 10 May 2008 10:58:11 +0200
Received: from [62.178.45.207] (port=15368 helo=p2k.at)
	by smartmx-03.inode.at with esmtpsa (TLS-1.0:RSA_AES_256_CBC_SHA:32)
	(Exim 4.50) id 1Juku3-0006bk-TN
	for linux-dvb@linuxtv.org; Sat, 10 May 2008 10:58:03 +0200
Received: from philipp by p2k.at with local (Exim 4.63)
	(envelope-from <philipp@kolmann.at>) id 1Juku3-00089m-51
	for linux-dvb@linuxtv.org; Sat, 10 May 2008 10:58:03 +0200
Date: Sat, 10 May 2008 10:58:03 +0200
From: Philipp Kolmann <philipp@kolmann.at>
To: linux-dvb@linuxtv.org
Message-ID: <20080510085803.GA30598@kolmann.at>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Mantis-08f27ef99d74: Compile error with 2.6.25
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

I have a Terratec Cinergy C which worked with the mantis driver and 2.6.24
fine. Now I have updated to 2.6.25 and can't compile the mantis driver
anymore:

[...]
  CC [M]  /home/philipp/test/deb/dvb/mantis-08f27ef99d74/v4l/cx23885-dvb.o
  CC [M]  /home/philipp/test/deb/dvb/mantis-08f27ef99d74/v4l/cx25840-core.o
/home/philipp/test/deb/dvb/mantis-08f27ef99d74/v4l/cx25840-core.c:71: error: conflicting type qualifiers for 'addr_data'
/home/philipp/test/deb/dvb/mantis-08f27ef99d74/v4l/../linux/include/media/v4l2-i2c-drv-legacy.h:41: error: previous declaration of 'addr_data' was here
make[3]: *** [/home/philipp/test/deb/dvb/mantis-08f27ef99d74/v4l/cx25840-core.o] Error 1
make[2]: *** [_module_/home/philipp/test/deb/dvb/mantis-08f27ef99d74/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-headers-2.6.25-1-686'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/home/philipp/test/deb/dvb/mantis-08f27ef99d74/v4l'
make: *** [all] Error 2

Any ideas how to solve this.

Thanks
Philipp

PS: Anyone know, if and when mantis will be merged with v4l-dvb tree?

-- 
The more I learn about people, the more I like my dog!

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
