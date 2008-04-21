Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-17.arcor-online.net ([151.189.21.57])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1Jnvzi-0002lh-4l
	for linux-dvb@linuxtv.org; Mon, 21 Apr 2008 15:23:44 +0200
From: hermann pitton <hermann-pitton@arcor.de>
To: james@nigmatech.com
In-Reply-To: <1208777431.2538.1.camel@localhost.localdomain>
References: <1208777431.2538.1.camel@localhost.localdomain>
Date: Mon, 21 Apr 2008 15:23:35 +0200
Message-Id: <1208784215.3294.28.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] issues compiling tip.tar.bz2
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

Am Montag, den 21.04.2008, 06:30 -0500 schrieb James Middendorff:
> Hello all,
> I am having issues compiling the tip.tar.bz2 file on linuxtv.org
> http://linuxtv.org/hg/v4l-dvb/archive/tip.tar.bz2
> 
> the error I get is,
> creating symbolic links...
> Kernel build directory is /lib/modules/2.6.18-chw-13/build
> make -C /lib/modules/2.6.18-chw-13/build
> SUBDIRS=/home/james/v4l-dvb-862ffcf962f0/v4l  modules
> make[2]: Entering directory `/usr/src/linux-headers-2.6.18-chw-13'
>   CC [M]  /home/james/v4l-dvb-862ffcf962f0/v4l/videodev.o
> /home/james/v4l-dvb-862ffcf962f0/v4l/videodev.c:498: error: unknown
> field 'dev_attrs' specified in initializer
> /home/james/v4l-dvb-862ffcf962f0/v4l/videodev.c:498: warning:
> initialization from incompatible pointer type
> /home/james/v4l-dvb-862ffcf962f0/v4l/videodev.c:499: error: unknown
> field 'dev_release' specified in initializer
> /home/james/v4l-dvb-862ffcf962f0/v4l/videodev.c:499: warning: missing
> braces around initializer
> /home/james/v4l-dvb-862ffcf962f0/v4l/videodev.c:499: warning: (near
> initialization for 'video_class.subsys')
> /home/james/v4l-dvb-862ffcf962f0/v4l/videodev.c:499: warning:
> initialization from incompatible pointer type
> make[3]: *** [/home/james/v4l-dvb-862ffcf962f0/v4l/videodev.o] Error 1
> make[2]: *** [_module_/home/james/v4l-dvb-862ffcf962f0/v4l] Error 2
> make[2]: Leaving directory `/usr/src/linux-headers-2.6.18-chw-13'
> make[1]: *** [default] Error 2
> 
> 

sysfs compat for 2.6.18 and below is broken.

In theory 2.6.19 should be OK, but didn't test.
2.6.20 was good enough until now.

Cheers,
Hermann



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
