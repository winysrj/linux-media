Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from aa011msr.fastwebnet.it ([85.18.95.71])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ml@punkrockworld.it>) id 1K8cWo-0004Hy-9H
	for linux-dvb@linuxtv.org; Tue, 17 Jun 2008 16:51:23 +0200
Received: from [192.168.0.12] (37.244.170.61) by aa011msr.fastwebnet.it
	(8.0.013.5) id 483216FE03985CC3 for linux-dvb@linuxtv.org;
	Tue, 17 Jun 2008 16:50:48 +0200
Message-ID: <4857CF5A.4030909@punkrockworld.it>
Date: Tue, 17 Jun 2008 16:51:06 +0200
From: Francesco <ml@punkrockworld.it>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <485638CE.6020406@punkrockworld.it>
In-Reply-To: <485638CE.6020406@punkrockworld.it>
Subject: Re: [linux-dvb] Firmware error for Asus MyCinema P7131H (NXP)
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

Francesco ha scritto:
> Hi,
>    I've a problem with new version of MyCinema 7131H, one with NXP chip 
> (saa7131E, tda10046A).
> 
> On boot, system fail to load firmware for tda10046, showing a wrong 
> firmware revision number (normally 80, but sometimes other numbers).
> 
> If I reboot (not shutdown & power up!), or if I unload all saa7134* 
> modules from memory and reload saa7134-dvb, firmware is loaded correctly 
> with revision 20...
> 
> Note: I never had this problem with old Philips-brand Asus P7131H.
> 
> 
> thanks in advance,
> Francesco Ferrario
> 
> IT Manager Chimera project
> www.chimeratv.it

After reading "unstable tda1004x firmware loading", I've found a little 
workaround (not a solution, but...) for this problem...

Simply adding "saa7134-dvb" to /etc/modules, make a successful firmware 
loading on boot.
(My system is an Ubuntu 7.10)




Francesco Ferrario
- Chimera project -
- www.chimeratv.it -

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
