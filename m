Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from www.youplala.net ([88.191.51.216] helo=mail.youplala.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nico@youplala.net>) id 1JdOAY-0000r7-TH
	for linux-dvb@linuxtv.org; Sun, 23 Mar 2008 12:15:21 +0100
Received: from [192.168.1.97] (user-514f84eb.l1.c4.dsl.pol.co.uk
	[81.79.132.235])
	by mail.youplala.net (Postfix) with ESMTP id 1C350D88130
	for <linux-dvb@linuxtv.org>; Sun, 23 Mar 2008 12:14:20 +0100 (CET)
From: Nicolas Will <nico@youplala.net>
To: linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <1206190455.6285.20.camel@youkaida>
References: <1206139910.12138.34.camel@youkaida>
	<1206185051.22131.5.camel@tux>  <1206190455.6285.20.camel@youkaida>
Date: Sun, 23 Mar 2008 11:13:54 +0000
Message-Id: <1206270834.4521.11.camel@shuttle>
Mime-Version: 1.0
Subject: Re: [linux-dvb] Nova-T-500 disconnects - They are back!
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

Guys,

Well, the disconnects are not remote-related, at least the last
disconnect happened with no interaction whatsoever.

There was no activity on the tuners (like recording) at the time either
(last one had finished 20mn before).

I'm not even sure that there was any EIT scanning going on.


Mar 23 10:32:40 favia kernel: [ 8244.672148] dib0700: Unknown remote controller key:  6 3C  1  0
Mar 23 10:32:41 favia kernel: [ 8245.734970] dib0700: Unknown remote controller key:  6 3C  1  0
Mar 23 10:33:18 favia kernel: [ 8282.337362] dib0700: Unknown remote controller key:  6 3C  1  0


There is quite some time between the last remote use and the disconnect:


Mar 23 10:54:10 favia kernel: [ 9532.658799] usb 4-1: USB disconnect, address 2
Mar 23 10:54:10 favia lircd-0.8.3pre1[5992]: error reading '/dev/input/dvb-ir'
Mar 23 10:54:10 favia kernel: [ 9532.693940] mt2060 I2C write failed
Mar 23 10:54:10 favia NetworkManager: <debug> [1206269650.277733] nm_hal_device_removed(): Device removed (hal udi is '/org/freedesktop/Hal/devices/usb_device_2040_9950_4028166400_logicaldev_input'). 
Mar 23 10:54:10 favia lircd-0.8.3pre1[5992]: caught signal
Mar 23 10:54:10 favia lircd-0.8.3pre1[5992]: closing '/dev/input/dvb-ir'


The delay is quite interesting too, and there is that dvb-usb error that I do not remember seing with 2.6.22 kernels:


Mar 23 10:57:50 favia kernel: [ 9752.272265] dvb-usb: error while stopping stream.
Mar 23 10:57:50 favia kernel: [ 9752.274256] mt2060 I2C write failed (len=2)
Mar 23 10:57:50 favia kernel: [ 9752.274260] mt2060 I2C write failed (len=6)
Mar 23 10:57:50 favia kernel: [ 9752.274261] mt2060 I2C read failed
Mar 23 10:57:50 favia kernel: [ 9752.280342] mt2060 I2C read failed
Mar 23 10:57:50 favia kernel: [ 9752.288306] mt2060 I2C read failed
Mar 23 10:57:50 favia kernel: [ 9752.296243] mt2060 I2C read failed
Mar 23 10:57:50 favia kernel: [ 9752.303877] mt2060 I2C read failed
Mar 23 10:57:50 favia kernel: [ 9752.311829] mt2060 I2C read failed
Mar 23 10:57:50 favia kernel: [ 9752.320208] mt2060 I2C read failed
Mar 23 10:57:50 favia kernel: [ 9752.328272] mt2060 I2C read failed
Mar 23 10:57:50 favia kernel: [ 9752.335949] mt2060 I2C read failed
Mar 23 10:57:50 favia kernel: [ 9752.344194] mt2060 I2C read failed
Mar 23 10:57:51 favia kernel: [ 9753.491057] mt2060 I2C write failed (len=2)
Mar 23 10:57:51 favia kernel: [ 9753.491064] mt2060 I2C write failed (len=6)
Mar 23 10:57:51 favia kernel: [ 9753.491067] mt2060 I2C read failed
Mar 23 10:57:51 favia kernel: [ 9753.499046] mt2060 I2C read failed
Mar 23 10:57:51 favia kernel: [ 9753.506578] mt2060 I2C read failed
Mar 23 10:57:51 favia kernel: [ 9753.514949] mt2060 I2C read failed
.....

Nico
not having any fun



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
