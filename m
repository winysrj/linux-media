Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from hermes.acsalaska.net ([209.112.173.230])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <rogerx@sdf.lonestar.org>) id 1MDWpI-0002qw-DH
	for linux-dvb@linuxtv.org; Mon, 08 Jun 2009 06:51:17 +0200
Received: from [192.168.1.3] (66-230-83-240-rb1.fai.dsl.dynamic.acsalaska.net
	[66.230.83.240])
	by hermes.acsalaska.net (8.14.1/8.14.1) with ESMTP id n584p60Z079462
	for <linux-dvb@linuxtv.org>; Sun, 7 Jun 2009 20:51:07 -0800 (AKDT)
	(envelope-from rogerx@sdf.lonestar.org)
From: Roger <rogerx@sdf.lonestar.org>
To: linux-dvb@linuxtv.org
Date: Sun, 07 Jun 2009 20:51:03 -0800
Message-Id: <1244436663.3797.3.camel@localhost2.local>
Mime-Version: 1.0
Subject: [linux-dvb] s5h1411_readreg: readreg error (ret == -5)
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

>From looking at "linux/drivers/media/dvb/frontends/s5h1411.c",  The
s5h1411_readreg wants to see "2" but is getting "-5" from the i2c bus.

--- Snip ---

s5h1411_readreg: readreg error (ret == -5)
pvrusb2: unregistering DVB devices
device: 'dvb0.net0': device_unregister

--- Snip ---

What exactly does this mean?



$ uname -a
Linux localhost2.local 2.6.29-gentoo-r4Y #9 SMP PREEMPT Tue Jun 2
03:38:16 AKDT 2009 i686 Pentium III (Coppermine) GenuineIntel GNU/Linux

Using pvrusb2 which requests firmware to initialize a Hauppauge HVR-1950
device.

-- 
Roger
http://rogerx.freeshell.org


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
