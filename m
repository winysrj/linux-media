Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from b01.banan.cz ([77.78.110.131])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nafik@nafik.cz>) id 1KWBYA-0000m4-9q
	for linux-dvb@linuxtv.org; Thu, 21 Aug 2008 16:54:10 +0200
Received: from p01.banan.cz (p01.banan.cz [77.93.194.164])
	by b01.banan.cz (Postfix) with ESMTP id D63C517A9D
	for <linux-dvb@linuxtv.org>; Thu, 21 Aug 2008 16:54:05 +0200 (CEST)
Received: from [192.168.0.10] (ip-85-160-83-165.eurotel.cz [85.160.83.165])
	by p01.banan.cz (Postfix) with ESMTP id 89CEA663D3
	for <linux-dvb@linuxtv.org>; Thu, 21 Aug 2008 17:01:24 +0200 (CEST)
From: gothic nafik <nafik@nafik.cz>
To: linux-dvb@linuxtv.org
Date: Thu, 21 Aug 2008 16:52:11 +0200
Message-Id: <1219330331.15825.2.camel@dark>
Mime-Version: 1.0
Subject: [linux-dvb] dib0700 and analog broadcasting
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


hi,

i have problems with my tv tuner. It is hybrid (analog receiver, digital
receiver, radio fm reciver) tv tuner with chipset dib7700. I had to hack
dib0700 module and update a line with my product id and vendor id
(because my hardware was not there). It is tv tuner in notebook Asus
M51SN.

nafik@dark:~$ lsusb -s 007:002 

Bus 007 Device 002: ID 1164:1f08 YUAN High-Tech Development Co., Ltd  

nafik@dark:~$ sudo modprobe dvb-usb-dib0700

nafik@dark:~$ dmesg 

[   41.965881] dib0700: loaded with support for 6 different device-types
[   41.966089] dvb-usb: found a 'DiBcom STK7700D reference design' in
warm state.
[   41.966127] dvb-usb: will pass the complete MPEG2 transport stream to
the software demuxer.
[   41.966307] DVB: registering new adapter (DiBcom STK7700D reference
design)
[   42.000752] dvb-usb: no frontend was attached by 'DiBcom STK7700D
reference design'
[   42.000760] dvb-usb: will pass the complete MPEG2 transport stream to
the software demuxer.
[   42.000975] DVB: registering new adapter (DiBcom STK7700D reference
design)
[   42.152993] DVB: registering frontend 1 (DiBcom 7000PC)...
[   42.154697] MT2266 I2C read failed
[   42.154851] input: IR-receiver inside an USB DVB receiver
as /devices/pci0000:00/0000:00:1d.7/usb7/7-5/input/input9
[   42.207246] dvb-usb: schedule remote query interval to 150 msecs.
[   42.207253] dvb-usb: DiBcom STK7700D reference design successfully
initialized and connected.
[   42.207517] usbcore: registered new interface driver dvb_usb_dib0700

nafik@dark:~$ ls /dev/dvb/*
/dev/dvb/adapter0:
demux0  dvr0  net0

/dev/dvb/adapter1:
demux0  dvr0  frontend0  net0

Digital tv is maybe working, I do not know, becasue in my region is not
digital broadcasting yet. But I want to watch analog tv or listen to
radio. And I am not sure, but I need device /dev/video or /dev/video0
(/dev/radio is not created too) for watching analog broadcasting (module
dib0700 did not create any /dev/video, just /dev/dvb/*)? Am I right? 

 
Thanks for help

nafik 





_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
