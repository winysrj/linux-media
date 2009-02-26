Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ares.dnshighspeed.com ([213.92.85.196])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <marco@absence.it>) id 1Lckp4-00020X-FS
	for linux-dvb@linuxtv.org; Thu, 26 Feb 2009 19:19:04 +0100
Received: from 213-140-11-132.fastres.net ([213.140.11.132] helo=[5.255.56.38])
	by ares.dnshighspeed.com with esmtpa (Exim 4.69)
	(envelope-from <marco@absence.it>) id 1Lckmh-0001gj-GO
	for linux-dvb@linuxtv.org; Thu, 26 Feb 2009 19:16:35 +0100
Message-ID: <49A6DCEA.1020606@absence.it>
Date: Thu, 26 Feb 2009 19:18:18 +0100
From: Marco Chiappero <marco@absence.it>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Strange load when using Pinnacle PCTV 73e and kernel
	2.6.28.5
Reply-To: linux-media@vger.kernel.org
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

Hi everybody,

I have been using this USB dongle for almost a year, but recently, 
switching from 2.6.27 to 2.6.28.5, I noticed that my small video server 
now runs continuosly[1] with an average load of 0.50 about. Load average 
returns within the 0.0x range when unloading all the dvb related 
modules, so this issue is definitely caused by the dongle stuff (can't 
say exactely what). By the way, same behaveour with both 
dvb-usb-dib0700-1.20.fw and dvb-usb-dib0700-1.10.fw. Any suggestions?


Well, I'd like to ask one more question about this tiny dongle (although 
it would probably be better to move it in a second mail): is it possible 
to put the USB stick a low power state when not used? I'm not sure 
whether this feature is already present or not, but I know that under 
windows the light in the dongle turns on only when watching TV, while 
with linux it is always on. I'm a little bit afraid this persistent full 
power state will shorten its life. Is this nonsense?


Regards,
Marco Chiappero


[1] I use to plot system informations.

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
