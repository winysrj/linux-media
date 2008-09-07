Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1KcROO-0006oG-KH
	for linux-dvb@linuxtv.org; Sun, 07 Sep 2008 23:01:58 +0200
Message-ID: <48C44137.2090106@gmail.com>
Date: Mon, 08 Sep 2008 01:01:43 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: crow <crow@linux.org.ba>
References: <3c031ccc0809071010s2facf462x33b16433c9663d0d@mail.gmail.com>
In-Reply-To: <3c031ccc0809071010s2facf462x33b16433c9663d0d@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Re : TT S2-3200 driver
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

crow wrote:
> Hi,
> I am also tryint to compile multiproto_plus on kernel 2.6.26-3 (sidux
> 2008-02) but no luck.
> Kernel: Linux vdrbox 2.6.26-3.slh.4-sidux-amd64 #1 SMP PREEMPT Wed Sep
> 3 19:39:11 UTC 2008 x86_64 GNU/Linux
> I tryed it this way:
> I downloaded dvb driver from:
> apt-get update
> apt-get install mercurial
> cd /usr/src/
> hg clone http://jusst.de/hg/multiproto_plus
> mv multiproto dvb
> ln -vfs /usr/src/linux-headers-`uname -r` linux
> cd /usr/src/dvb/linux/include/linux/
> ln -s /usr/src/linux/include/linux/compiler.h compiler.h
> cd /usr/src/dvb/
> and i am trying make and get this problem :
> ............
>   CC [M]  /usr/src/dvb/v4l/ivtv-gpio.o
>   CC [M]  /usr/src/dvb/v4l/ivtv-i2c.o
> /usr/src/dvb/v4l/ivtv-i2c.c: In function 'ivtv_i2c_register':
> /usr/src/dvb/v4l/ivtv-i2c.c:171: error: 'struct i2c_board_info' has no
> member named 'driver_name'
> make[3]: *** [/usr/src/dvb/v4l/ivtv-i2c.o] Error 1
> make[2]: *** [_module_/usr/src/dvb/v4l] Error 2
> make[2]: Leaving directory `/usr/src/linux-headers-2.6.26-3.slh.4-sidux-amd64'
> make[1]: *** [default] Error 2
> make[1]: Leaving directory `/usr/src/dvb/v4l'
> make: *** [all] Error 2
> root@vdrbox:/usr/src/dvb#
> 
> I wanna try this patch to as i am also TT S2-3200 user.
> Any help welcome.


That tree is being updated and being pushed, you can either wait for a
little while till that tree is populated, or you can pull the multiproto
tree as well.

Regards,
Manu

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
