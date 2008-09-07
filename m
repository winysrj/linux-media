Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fk-out-0910.google.com ([209.85.128.189])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crow@linux.org.ba>) id 1KcNmN-0001L4-Bx
	for linux-dvb@linuxtv.org; Sun, 07 Sep 2008 19:10:28 +0200
Received: by fk-out-0910.google.com with SMTP id f40so971730fka.1
	for <linux-dvb@linuxtv.org>; Sun, 07 Sep 2008 10:10:23 -0700 (PDT)
Message-ID: <3c031ccc0809071010s2facf462x33b16433c9663d0d@mail.gmail.com>
Date: Sun, 7 Sep 2008 19:10:23 +0200
From: crow <crow@linux.org.ba>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb]  Re : TT S2-3200 driver
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
I am also tryint to compile multiproto_plus on kernel 2.6.26-3 (sidux
2008-02) but no luck.
Kernel: Linux vdrbox 2.6.26-3.slh.4-sidux-amd64 #1 SMP PREEMPT Wed Sep
3 19:39:11 UTC 2008 x86_64 GNU/Linux
I tryed it this way:
I downloaded dvb driver from:
apt-get update
apt-get install mercurial
cd /usr/src/
hg clone http://jusst.de/hg/multiproto_plus
mv multiproto dvb
ln -vfs /usr/src/linux-headers-`uname -r` linux
cd /usr/src/dvb/linux/include/linux/
ln -s /usr/src/linux/include/linux/compiler.h compiler.h
cd /usr/src/dvb/
and i am trying make and get this problem :
............
  CC [M]  /usr/src/dvb/v4l/ivtv-gpio.o
  CC [M]  /usr/src/dvb/v4l/ivtv-i2c.o
/usr/src/dvb/v4l/ivtv-i2c.c: In function 'ivtv_i2c_register':
/usr/src/dvb/v4l/ivtv-i2c.c:171: error: 'struct i2c_board_info' has no
member named 'driver_name'
make[3]: *** [/usr/src/dvb/v4l/ivtv-i2c.o] Error 1
make[2]: *** [_module_/usr/src/dvb/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-headers-2.6.26-3.slh.4-sidux-amd64'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/usr/src/dvb/v4l'
make: *** [all] Error 2
root@vdrbox:/usr/src/dvb#

I wanna try this patch to as i am also TT S2-3200 user.
Any help welcome.

Quote:
>Hello Ales,
>
>> I've used last one, multiproto-2a911b8f9910.tar.bz2.
>
>Against which kernel version do you compile this multiproto set?
>2.6.24 (fc8), 26.25.11, 2.6.26 all gave build errors...
>
>Kind Regards,
>
>Remy

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
