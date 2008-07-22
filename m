Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rayleigh.systella.fr ([213.41.184.253])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bertrand@systella.fr>) id 1KLEvC-00052d-NV
	for linux-dvb@linuxtv.org; Tue, 22 Jul 2008 12:16:43 +0200
Received: from [192.168.0.4] (bertrand@cauchy.systella.fr [192.168.0.4])
	(authenticated bits=0)
	by rayleigh.systella.fr (8.14.3/8.14.3/Debian-4) with ESMTP id
	m6MAFt7Z020879
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-dvb@linuxtv.org>; Tue, 22 Jul 2008 12:15:57 +0200
Message-ID: <4885B35B.1080006@systella.fr>
Date: Tue, 22 Jul 2008 12:15:55 +0200
From: =?ISO-8859-1?Q?BERTRAND_Jo=EBl?= <bertrand@systella.fr>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] AverMedia Hybrid Express
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

	Hello,

	I'm trying to configure an AverTV Hybrid Express card. I've probably
done a mistake...

Distribution : Linux Debian lenny (kernel 2.6.26 from kernel.org).

cauchy:[/etc/modprobe.d] > lspci
...
02:00.0 Multimedia video controller: Conexant Device 8852 (rev 02)
...
cauchy:[/etc/modprobe.d] > lspci -nv
...
02:00.0 0400: 14f1:8852 (rev 02)
         Subsystem: 1461:c039
         Flags: bus master, fast devsel, latency 0, IRQ 16
         Memory at f0000000 (64-bit, non-prefetchable) [size=2M]
         Capabilities: [40] Express Endpoint, MSI 00
         Capabilities: [80] Power Management version 2
         Capabilities: [90] Vital Product Data <?>
         Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+
Queue=0/0 Enable-
         Capabilities: [100] Advanced Error Reporting <?>
         Capabilities: [200] Virtual Channel <?>
         Kernel driver in use: cx23885
         Kernel modules: cx23885
...

	I have seen that this card should work with cx23885.
 From dmesg :

CORE cx23885[0]: subsystem: 1461:c039, board: DViCO FusionHDTV5 Express
[card=4,insmod option]
cx23885[0]: i2c bus 0 registered
cx23885[0]: i2c bus 1 registered
cx25840' 3-0044: cx25  0-21 found @ 0x88 (cx23885[0])
cx23885[0]: i2c bus 2 registered
cx23885[0]: cx23885 based dvb card
tuner-simple 1-0061: creating new instance
tuner-simple 1-0061: type set to 64 (LG TDVS-H06xF)
DVB: registering new adapter (cx23885[0])
DVB: registering frontend 0 (LG Electronics LGDT3303 VSB/QAM Frontend)...
cx23885_dev_checkrevision() Hardware revision = 0xb0
cx23885[0]/0: found at 0000:02:00.0, rev: 2, irq: 16, latency: 0, mmio:
0xf0000000

	I have to add card=4 option. With all others card, dvb devices are not
created. Card seems to be usable :
Root cauchy:[/sys/class/dvb] > ls -al
total 0
drwxr-xr-x  6 root root 0 jui 21 19:24 .
drwxr-xr-x 35 root root 0 jui 21 19:21 ..
drwxr-xr-x  3 root root 0 jui 21 19:24 dvb0.demux0
drwxr-xr-x  3 root root 0 jui 21 19:24 dvb0.dvr0
drwxr-xr-x  3 root root 0 jui 21 19:24 dvb0.frontend0
drwxr-xr-x  3 root root 0 jui 21 19:24 dvb0.net0
Root cauchy:[/sys/class/dvb] > ls /dev/dvb/
adapter0
Root cauchy:[/sys/class/dvb] > ls /dev/dvb/adapter0/*
/dev/dvb/adapter0/demux0  /dev/dvb/adapter0/frontend0
/dev/dvb/adapter0/dvr0    /dev/dvb/adapter0/net0
Root cauchy:[/sys/class/dvb] >

	But I'm not able to continue...

Root cauchy:[~] > dvbscan -out raw test /usr/share/dvb/dvb-t/fr-Paris

	This last command does not crash, but does nothing...

  1599 root      20   0 14092  492  368 R  100  0.0  28:16.61 dvbscan


	Where's my mistake ?

	Regards,

	JKB


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
