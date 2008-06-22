Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from dyn60-31.dsl.spy.dnainternet.fi ([83.102.60.31]
	helo=shogun.pilppa.org) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lamikr@pilppa.org>) id 1KAPRv-0005Gv-1E
	for linux-dvb@linuxtv.org; Sun, 22 Jun 2008 15:17:43 +0200
Date: Sun, 22 Jun 2008 16:17:20 +0300 (EEST)
From: Mika Laitio <lamikr@pilppa.org>
To: linux-dvb@linuxtv.org
In-Reply-To: <Pine.LNX.4.64.0806180120550.25378@shogun.pilppa.org>
Message-ID: <Pine.LNX.4.64.0806221607190.6675@shogun.pilppa.org>
References: <484EFB7B.7020505@pilppa.org> <484F7A8B.1010602@dupondje.be>
	<Pine.LNX.4.64.0806180120550.25378@shogun.pilppa.org>
MIME-Version: 1.0
Subject: Re: [linux-dvb] HVR-1300 problems with new kernels
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

> DVB is however still not working with 2.6.24, 26.25 and 2.6.26-rc4
> kernels I have tested. But will work if I build and load v4l-dvb drivers.
>
> cx88/dvb related dmesg output looks ok for me and I have things created
> under /dev/dvb...

Some progress... It seems that the hvr-1300 drivers are actually ok for 
dvb-t in 26.24-26.26 kernels, the problem seems just be somehow in the 
load order of drivers.

If I remove the kernel/drivers/media/video/cx88 directory temporarily for 
the boot time to prevent the drivers to get loaded automatically and then 
put the cx88 folder back after boot and load following drivers manually, 
then dvb-t starts workinng ok

modprobe cx88_dvb
modprobe cx8800
modprobe cx22700

Any idea should I specify some module loading rules somewhere for example 
in /etc/modprobe.conf ?

Mika


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
