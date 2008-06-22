Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <daniel.isenmann@gmx.de>) id 1KAQL8-0000Nn-3o
	for linux-dvb@linuxtv.org; Sun, 22 Jun 2008 16:14:47 +0200
Date: Sun, 22 Jun 2008 16:14:11 +0200
From: Daniel Isenmann <daniel.isenmann@gmx.de>
To: linux-dvb@linuxtv.org
Message-ID: <20080622161411.722de7a7@fuckup-ng.localdomain>
Mime-Version: 1.0
Subject: [linux-dvb] Afatech 9015 problems on i686
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

I have some problems to get the module af9015 to run under i686. I
checked out the afatech9015 development repo from here:
http://linuxtv.org/hg/~anttip/af9015/

Compiling the source on my x86_64 box, everything runs fine and smooth.
But under i686 there is following warning, which prevents the module
from loading:
----------
WARNING:
"__fixdfsi" [/home/ise/downloads/eee/eee/afatech-eee/src/af9015/v4l/af9013.ko]
undefined! 
WARNING:
"__divdf3" [/home/ise/downloads/eee/eee/afatech-eee/src/af9015/v4l/af9013.ko]
undefined! 
WARNING:
"__adddf3" [/home/ise/downloads/eee/eee/afatech-eee/src/af9015/v4l/af9013.ko]
undefined! 
WARNING:
"__muldf3" [/home/ise/downloads/eee/eee/afatech-eee/src/af9015/v4l/af9013.ko]
undefined! 
WARNING:
"__floatsidf" [/home/ise/downloads/eee/eee/afatech-eee/src/af9015/v4l/af9013.ko]
undefined!
----------
The compilation runs until the end. But loading the module fails with
errors, that it can't find the functions listed above. Loading the
firmware works on both boxes without problems.

GCC: 4.3.1
Kernel: 2.6.25.6 
Distribution: ArchLinux

Has anyone a hint or know something more, why the compiler warnings
appears? Complete build log with V=1 can be found here: 
http://dev.archlinux.org/~daniel/afatech9015-eee-hg-8102-1-i686.log

Thanks, Daniel




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
