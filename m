Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm10-vm2.bullet.mail.ne1.yahoo.com ([98.138.90.158]:48793 "HELO
	nm10-vm2.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755050Ab1IGErm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Sep 2011 00:47:42 -0400
Message-ID: <1315370468.62946.YahooMailNeo@web31707.mail.mud.yahoo.com>
Date: Tue, 6 Sep 2011 21:41:08 -0700 (PDT)
From: Lothsahn <lothsahn@yahoo.com>
Reply-To: Lothsahn <lothsahn@yahoo.com>
Subject: Compiling on 2.6.32-31-generic fails (nightly build server has same problem)
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm using Mythbuntu 10.04 LTS with the 2.6.32-31-generic kernel.  I 
tried to compile the latest v4l code, and I'm getting the following 
compile error:

/home/lowmanator/media_build/v4l/tda18271-common.c: In function '_tda_printk':
/home/lowmanator/media_build/v4l/tda18271-common.c:682: error: storage size of 'vaf' isn't known
/home/lowmanator/media_build/v4l/tda18271-common.c:682: warning: unused variable 'vaf'
make[3]: *** [/home/lowmanator/media_build/v4l/tda18271-common.o] Error 1
make[2]: ***
[_module_/home/lowmanator/media_build/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-headers-2.6.32-31-generic'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/home/lowmanator/media_build/v4l'
make: *** [all] Error
2



Just to try to workaround the error for now (and just because I'm a sadist for failure), I've 
removed the entire tda_printk method from that module, hoping that my 
hd-pvr isn't using the tda18271 chip :)  When I do this and recontinue 
the make, I then fail on the following error:
  CC [M]  /home/lowmanator/media_build/v4l/imon.o
/home/lowmanator/media_build/v4l/imon.c: In function 'send_packet':
/home/lowmanator/media_build/v4l/imon.c:521: error: implicit declaration of function 'pr_err_ratelimited'
make[3]: *** [/home/lowmanator/media_build/v4l/imon.o] Error 1
make[2]: *** [_module_/home/lowmanator/media_build/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-headers-2.6.32-31-generic'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/home/lowmanator/media_build/v4l'
make: *** [all] Error
2


imon.c sounds a little more 
centralized than tda18271, so I didn't feel like ripping out the 
"send_packet" method :)  I've stopped for now.

I've also noticed that these errors are reported in the nightly builds 
for the last week or so (I don't have nightly logs from before that).



Any idea how I can workaround these two errors (without changing out my 
entire kernel)?  I have a brand new shiny F2 revision HD-PVR and I'd 
really like to use it...

Thanks,
Lothsahn
