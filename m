Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mout.perfora.net ([74.208.4.196])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <james@nigmatech.com>) id 1JnuEO-0005j6-0u
	for linux-dvb@linuxtv.org; Mon, 21 Apr 2008 13:30:50 +0200
From: James Middendorff <james@nigmatech.com>
To: linux-dvb@linuxtv.org
Date: Mon, 21 Apr 2008 06:30:31 -0500
Message-Id: <1208777431.2538.1.camel@localhost.localdomain>
Mime-Version: 1.0
Subject: [linux-dvb] issues compiling tip.tar.bz2
Reply-To: james@nigmatech.com
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

Hello all,
I am having issues compiling the tip.tar.bz2 file on linuxtv.org
http://linuxtv.org/hg/v4l-dvb/archive/tip.tar.bz2

the error I get is,
creating symbolic links...
Kernel build directory is /lib/modules/2.6.18-chw-13/build
make -C /lib/modules/2.6.18-chw-13/build
SUBDIRS=/home/james/v4l-dvb-862ffcf962f0/v4l  modules
make[2]: Entering directory `/usr/src/linux-headers-2.6.18-chw-13'
  CC [M]  /home/james/v4l-dvb-862ffcf962f0/v4l/videodev.o
/home/james/v4l-dvb-862ffcf962f0/v4l/videodev.c:498: error: unknown
field 'dev_attrs' specified in initializer
/home/james/v4l-dvb-862ffcf962f0/v4l/videodev.c:498: warning:
initialization from incompatible pointer type
/home/james/v4l-dvb-862ffcf962f0/v4l/videodev.c:499: error: unknown
field 'dev_release' specified in initializer
/home/james/v4l-dvb-862ffcf962f0/v4l/videodev.c:499: warning: missing
braces around initializer
/home/james/v4l-dvb-862ffcf962f0/v4l/videodev.c:499: warning: (near
initialization for 'video_class.subsys')
/home/james/v4l-dvb-862ffcf962f0/v4l/videodev.c:499: warning:
initialization from incompatible pointer type
make[3]: *** [/home/james/v4l-dvb-862ffcf962f0/v4l/videodev.o] Error 1
make[2]: *** [_module_/home/james/v4l-dvb-862ffcf962f0/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-headers-2.6.18-chw-13'
make[1]: *** [default] Error 2



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
