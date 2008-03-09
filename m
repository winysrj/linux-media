Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n3a.bullet.mail.ac4.yahoo.com ([76.13.13.66])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <aldebx@yahoo.fr>) id 1JYUCI-0003Yz-1G
	for linux-dvb@linuxtv.org; Sun, 09 Mar 2008 23:40:53 +0100
Message-ID: <47D4674B.6010603@yahoo.fr>
Date: Sun, 09 Mar 2008 23:40:11 +0100
From: aldebaran <aldebx@yahoo.fr>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] ~stoth/cx23885-video compile failure
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

Hi to everybody!

I own an HP/Hauppauge WinTv885 mod 77001 with cx23885 and xc3028 chipsets.

Following the threads on this mailing list I understood these chipsets were supported by 
http://linuxtv.org/hg/~stoth/cx23885-video code, however I cannot even get past the 'make all'.

here is what I get:
> CC [M] /home/user/cx23885-video-85708d2698cd/v4l/em28xx-audio.o In 
> file included from 
> /home/user/cx23885-video-85708d2698cd/v4l/em28xx-audio.c:39: 
> include/sound/core.h:281: error: 'SNDRV_CARDS' undeclared here (not in 
> a function) 
> /home/user/cx23885-video-85708d2698cd/v4l/em28xx-audio.c:58: error: 
> array index in initializer not of integer type 
> /home/user/cx23885-video-85708d2698cd/v4l/em28xx-audio.c:58: error: 
> (near initialization for 'index') make[3]: *** 
> [/home/user/cx23885-video-85708d2698cd/v4l/em28xx-audio.o] Error 1 
> make[2]: *** [_module_/home/user/cx23885-video-85708d2698cd/v4l] Error 
> 2 make[2]: Leaving directory 
> `/usr/src/linux-headers-2.6.24-11-generic' make[1]: *** [default] Error 2 

Is it a bug?
Were I supposed to do something?
Thank you.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
