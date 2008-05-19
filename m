Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ti-out-0910.google.com ([209.85.142.187])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alexanderterhaar@gmail.com>) id 1JyBSq-00005s-Aq
	for linux-dvb@linuxtv.org; Mon, 19 May 2008 21:56:12 +0200
Received: by ti-out-0910.google.com with SMTP id w7so1143493tib.13
	for <linux-dvb@linuxtv.org>; Mon, 19 May 2008 12:56:02 -0700 (PDT)
Message-ID: <d8ba26160805191256h16f5c760md6112dd9612f4bdd@mail.gmail.com>
Date: Mon, 19 May 2008 21:56:00 +0200
From: "Alexander ter Haar" <alexanderterhaar@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] v4l-dvb-hg conflict with zoran
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

I have a questen relating to the v4l-dvb-hg drivers on my gentoo
system with kernel 2.6.25-gentoo-r3. I tried both using portage and
using the drivers from linuxtv.org, same problem however...

After emerge or make compiling stops; There seems to be some conflict
with Zoran; I get an error:

CC [M]  /var/tmp/portage/media-tv/v4l-dvb-hg-0.1-r2/work/v4l-dvb/v4l/zoran_device.o
/var/tmp/portage/media-tv/v4l-dvb-hg-0.1-r2/work/v4l-dvb/v4l/zoran_procfs.c:
In function 'zoran_proc_init':
/var/tmp/portage/media-tv/v4l-dvb-hg-0.1-r2/work/v4l-dvb/v4l/zoran_procfs.c:208:
error: implicit declaration of function 'proc_create_data'
/var/tmp/portage/media-tv/v4l-dvb-hg-0.1-r2/work/v4l-dvb/v4l/zoran_procfs.c:208:
warning: assignment makes pointer from integer without a cast
make[2]: *** [/var/tmp/portage/media-tv/v4l-dvb-hg-0.1-r2/work/v4l-dvb/v4l/zoran_procfs.o]
Error 1
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [_module_/var/tmp/portage/media-tv/v4l-dvb-hg-0.1-r2/work/v4l-dvb/v4l]
Error 2
make[1]: Leaving directory `/usr/src/linux-2.6.25-gentoo-r3'
make: *** [default] Error 2
*

After which installing or emerging stops..

Any idea what i should do?
Thanks in advance for any help !

Alexander.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
