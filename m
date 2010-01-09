Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <peter@usr-local.com>) id 1NThZ8-0004Kj-GY
	for linux-dvb@linuxtv.org; Sat, 09 Jan 2010 21:05:43 +0100
Received: from einhorn.in-berlin.de ([192.109.42.8])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-b) with esmtps
	[TLSv1:AES256-SHA:256] for <linux-dvb@linuxtv.org>
	id 1NThZ8-00076E-1V; Sat, 09 Jan 2010 21:05:42 +0100
Received: from rabbit.usr-local.com (e176085253.adsl.alicedsl.de
	[85.176.85.253]) (authenticated bits=0)
	by einhorn.in-berlin.de (8.13.6/8.13.6/Debian-1) with ESMTP id
	o09K5fkZ018955
	(version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-dvb@linuxtv.org>; Sat, 9 Jan 2010 21:05:41 +0100
Received: from peter (helo=localhost)
	by rabbit.usr-local.com with local-esmtp (Exim 4.63)
	(envelope-from <peter@usr-local.com>) id 1NThZ6-0003MX-Sz
	for linux-dvb@linuxtv.org; Sat, 09 Jan 2010 21:05:40 +0100
Date: Sat, 9 Jan 2010 20:59:13 +0100 (CET)
From: "Peter J. W." <peter.99@gmx.de>
To: linux-dvb@linuxtv.org
Message-ID: <alpine.DEB.2.00.1001092043110.28066@rabbit.pooh.home>
MIME-Version: 1.0
ReSent-Message-ID: <alpine.DEB.2.00.1001092105360.28066@rabbit.pooh.home>
Subject: [linux-dvb] Trouble with Terratec Cinergy C DVB-C - need help for
	compile
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi everybody,

after struggeling for a while, I decided to ask the list:

I am experiencing some glitches with my Linux HTPC running on kernel 
2.6.27.6 with mantis-303b1d29d735 equipped with two Terratec Cinergy C 
DVB-C cards.

In advance to going into detail about my problems, I'd like to try out 
most recent drivers with most recent stable kernel.

Hoewever, when downloading kernel 2.6.32.3 and 
mantis-5292a47772ad.tar.bz2, compiling the kernel, rebooting into it (to 
have the build link to point to the proper kernel sources) and running 
a "make all" on Manuss mantis sources, the following happens:

(peter@owl) /tmp/src/mantis-5292a47772ad $ make all
make -C /tmp/src/mantis-5292a47772ad/v4l all
make[1]: Entering directory `/tmp/src/mantis-5292a47772ad/v4l'
scripts/make_makefile.pl
./scripts/make_myconfig.pl
make[1]: Leaving directory `/tmp/src/mantis-5292a47772ad/v4l'
make[1]: Entering directory `/tmp/src/mantis-5292a47772ad/v4l'
perl scripts/make_config_compat.pl /lib/modules/2.6.32.3-pjw-owl-2/source ./.myconfig ./config-compat.h
creating symbolic links...
ln -sf . oss
Kernel build directory is /lib/modules/2.6.32.3-pjw-owl-2/build
make -C /lib/modules/2.6.32.3-pjw-owl-2/build SUBDIRS=/tmp/src/mantis-5292a47772ad/v4l  modules
make[2]: Entering directory `/data/scratch/kernel/linux-2.6.32.3-2'
   CC [M]  /tmp/src/mantis-5292a47772ad/v4l/tuner-xc2028.o
In file included from /tmp/src/mantis-5292a47772ad/v4l/tuner-xc2028.h:10,
                  from /tmp/src/mantis-5292a47772ad/v4l/tuner-xc2028.c:21:
/tmp/src/mantis-5292a47772ad/v4l/dvb_frontend.h:52: error: field 'fe_params' has incomplete type
/tmp/src/mantis-5292a47772ad/v4l/dvb_frontend.h:297: warning: 'struct dvbfe_info' declared inside parameter list
/tmp/src/mantis-5292a47772ad/v4l/dvb_frontend.h:297: warning: its scope is only this definition or declaration, which is probably not what you want
/tmp/src/mantis-5292a47772ad/v4l/dvb_frontend.h:298: warning: 'enum dvbfe_delsys' declared inside parameter list
/tmp/src/mantis-5292a47772ad/v4l/dvb_frontend.h:299: warning: 'enum dvbfe_delsys' declared inside parameter list
/tmp/src/mantis-5292a47772ad/v4l/dvb_frontend.h:316: error: field 'fe_events' has incomplete type
/tmp/src/mantis-5292a47772ad/v4l/dvb_frontend.h:317: error: field 'fe_params' has incomplete type
/tmp/src/mantis-5292a47772ad/v4l/dvb_frontend.h:354: warning: 'enum dvbfe_fec' declared inside parameter list
/tmp/src/mantis-5292a47772ad/v4l/dvb_frontend.h:354: warning: 'enum dvbfe_modulation' declared inside parameter list
/tmp/src/mantis-5292a47772ad/v4l/dvb_frontend.h:359: warning: 'enum dvbfe_delsys' declared inside parameter list
/tmp/src/mantis-5292a47772ad/v4l/tuner-xc2028.c:49: error: 'FIRMWARE_NAME_MAX' undeclared here (not in a function)
make[3]: *** [/tmp/src/mantis-5292a47772ad/v4l/tuner-xc2028.o] Error 1
make[2]: *** [_module_/tmp/src/mantis-5292a47772ad/v4l] Error 2
make[2]: Leaving directory `/data/scratch/kernel/linux-2.6.32.3-2'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/tmp/src/mantis-5292a47772ad/v4l'
make: *** [all] Error 2
(peter@owl) /tmp/src/mantis-5292a47772ad $

Do I something wrong? Or is just the mantis tree out-of-sync with current 
kernels?

It worked fine for kernel 2.6.27.6 and mantis-303b1d29d735.

Any hints are appreciated.

Cheers,

Peter



_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
