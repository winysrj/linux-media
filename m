Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.154])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <e9hack@googlemail.com>) id 1LMTSA-0003yv-Ae
	for linux-dvb@linuxtv.org; Mon, 12 Jan 2009 21:32:11 +0100
Received: by fg-out-1718.google.com with SMTP id e21so4167003fga.25
	for <linux-dvb@linuxtv.org>; Mon, 12 Jan 2009 12:32:02 -0800 (PST)
Message-ID: <496BA8BE.4080309@googlemail.com>
Date: Mon, 12 Jan 2009 21:31:58 +0100
From: e9hack <e9hack@googlemail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] compile problems on 2.6.29-rc1
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

I've problems to compile the current hg tree with some modifications on linux 2.6.29-rc1.
 It isn't a problem to compile the current hg tree without any modifications. I've add a
third parameter to saa7146_wait_for_debi_done(). I can compile it on 2.6.28. On
2.6.29-rc1, I get the following error message:

linux-qgjx:/usr/src/v4l-dvb # make
make -C /usr/src/v4l-dvb/v4l
make[1]: Entering directory `/usr/src/v4l-dvb/v4l'
creating symbolic links...
Kernel build directory is /lib/modules/2.6.29-rc1-64-mp-suse-11/build
make -C /lib/modules/2.6.29-rc1-64-mp-suse-11/build SUBDIRS=/usr/src/v4l-dvb/v4l  modules
make[2]: Entering directory `/usr/src/linux-2.6.29-rc1-obj/x86_64/mp-suse-11'
make -C /usr/src/linux-2.6.29-rc1 O=/usr/src/linux-2.6.29-rc1-obj/x86_64/mp-suse-11/. modules
  CC [M]  /usr/src/v4l-dvb/v4l/av7110_hw.o
/usr/src/v4l-dvb/v4l/av7110_hw.c: In function 'av7110_debiwrite':
/usr/src/v4l-dvb/v4l/av7110_hw.c:59: error: too many arguments to function
'saa7146_wait_for_debi_done'
/usr/src/v4l-dvb/v4l/av7110_hw.c: In function 'av7110_debiread':
/usr/src/v4l-dvb/v4l/av7110_hw.c:83: error: too many arguments to function
'saa7146_wait_for_debi_done'
/usr/src/v4l-dvb/v4l/av7110_hw.c:94: error: too many arguments to function
'saa7146_wait_for_debi_done'
/usr/src/v4l-dvb/v4l/av7110_hw.c: In function 'av7110_bootarm':
/usr/src/v4l-dvb/v4l/av7110_hw.c:268: error: too many arguments to function
'saa7146_wait_for_debi_done'
/usr/src/v4l-dvb/v4l/av7110_hw.c:289: error: too many arguments to function
'saa7146_wait_for_debi_done'
make[5]: *** [/usr/src/v4l-dvb/v4l/av7110_hw.o] Error 1
make[4]: *** [_module_/usr/src/v4l-dvb/v4l] Error 2
make[3]: *** [sub-make] Error 2
make[2]: *** [all] Error 2
make[2]: Leaving directory `/usr/src/linux-2.6.29-rc1-obj/x86_64/mp-suse-11'
make[1]: *** [default] Fehler 2
make[1]: Leaving directory `/usr/src/v4l-dvb/v4l'
make: *** [all] Fehler 2
linux-qgjx:/usr/src/v4l-dvb #

It seems, that linux/include/media/saa7146.h is used from the kernel source tree instead
of the v4l-dvb tree.

Regards,
Hartmut

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
