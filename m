Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.ax.ru ([80.247.32.138] helo=rfn.ru)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <huge@ax.ru>) id 1Jp4Cc-0003K6-SH
	for linux-dvb@linuxtv.org; Thu, 24 Apr 2008 18:21:43 +0200
Received: from [194.46.227.1] (HELO hugex2.itwise.net)
	by rfn.ru (CommuniGate Pro SMTP 4.2.8)
	with ESMTP id 81134342 for linux-dvb@linuxtv.org;
	Thu, 24 Apr 2008 20:21:01 +0400
Message-ID: <4810A576.4050105@ax.ru>
Date: Thu, 24 Apr 2008 16:21:26 +0100
From: Pavel Smirnov <huge@ax.ru>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Compilation against 2.6.25 kernel
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

Not sure I was sane to do this, but tried to get hvr4000-dvb working on 
2.6.25 kernel.
Reckon problem is not unique to this branch hence my post:


[huga@boxer hvr4000-build]# make
make -C /huga/hvr4000-build/v4l
make[1]: Entering directory `/huga/hvr4000-build/v4l'
creating symbolic links...
Kernel build directory is /lib/modules/2.6.25/build
make -C /lib/modules/2.6.25/build SUBDIRS=/huga/hvr4000-build/v4l  modules
make[2]: Entering directory `/usr/src/redhat/BUILD/kernel-2.6.25'
  CC [M]  /huga/hvr4000-build/v4l/cx25840-core.o
/huga/hvr4000-build/v4l/cx25840-core.c:69: error: conflicting type 
qualifiers for 'addr_data'
/huga/hvr4000-build/v4l/../linux/include/media/v4l2-i2c-drv-legacy.h:41: 
error: previous declaration of 'addr_data' was here
make[3]: *** [/huga/hvr4000-build/v4l/cx25840-core.o] Error 1
make[2]: *** [_module_/huga/hvr4000-build/v4l] Error 2
make[2]: Leaving directory `/usr/src/redhat/BUILD/kernel-2.6.25'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/huga/hvr4000-build/v4l'
make: *** [all] Error 2
[huga@boxer hvr4000-build]# make
make -C /huga/hvr4000-build/v4l
make[1]: Entering directory `/huga/hvr4000-build/v4l'
creating symbolic links...
Kernel build directory is /lib/modules/2.6.25/build
make -C /lib/modules/2.6.25/build SUBDIRS=/huga/hvr4000-build/v4l  modules
make[2]: Entering directory `/usr/src/redhat/BUILD/kernel-2.6.25'
  CC [M]  /huga/hvr4000-build/v4l/cx25840-core.o
/huga/hvr4000-build/v4l/cx25840-core.c:69: error: conflicting type 
qualifiers for 'addr_data'
/huga/hvr4000-build/v4l/../linux/include/media/v4l2-i2c-drv-legacy.h:41: 
error: previous declaration of 'addr_data' was here
make[3]: *** [/huga/hvr4000-build/v4l/cx25840-core.o] Error 1
make[2]: *** [_module_/huga/hvr4000-build/v4l] Error 2
make[2]: Leaving directory `/usr/src/redhat/BUILD/kernel-2.6.25'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/huga/hvr4000-build/v4l'
make: *** [all] Error 2
[huga@boxer hvr4000-build]# uname -r
2.6.25


Any comments or suggestions - I'll be jumping my brain circuits in 
excitement...

Cheers,

Pav

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
