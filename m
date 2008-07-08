Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.cpfc.org ([67.15.181.35] helo=venus.cpfc.org)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <dave@cpfc.org>) id 1KGCGH-0006Nh-RY
	for linux-dvb@linuxtv.org; Tue, 08 Jul 2008 14:25:42 +0200
Received: from [87.194.133.119] (helo=Macintosh-2.local)
	by venus.cpfc.org with esmtpa (Exim 4.63)
	(envelope-from <dave@cpfc.org>) id 1KGCG7-0005Xp-PO
	for linux-dvb@linuxtv.org; Tue, 08 Jul 2008 13:25:29 +0100
Message-ID: <48735CB5.9040304@cpfc.org>
Date: Tue, 08 Jul 2008 13:25:25 +0100
From: David Campbell <dave@cpfc.org>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Hauppauge WinTV Nova-TD Dual DVB-T Tuner With Diversity
	- Model 1175
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

Hi - I am trying to get this usb tuner working and am wondering if the 
chipset has changed or similar?

http://www.play.com/PC/PCs/4-/3273849/Hauppauge-WinTV-Nova-TD-Dual-DVB-T-Tuner-With-Diversity-Model-1175/Product.html

I am getting no output from the kernel at all


Linux mac-mini 2.6.22-14-generic #1 SMP Tue Feb 12 07:42:25 UTC 2008 
i686 GNU/Linux


root@mac-mini:/lib/firmware# lsusb | grep H
Bus 005 Device 008: ID 2040:9580 Hauppauge


root@mac-mini:/lib/firmware# lsmod | grep -i dvb
dvb_usb_dib0700        13704  0
dib7000m               16004  1 dvb_usb_dib0700
dib7000p               14340  1 dvb_usb_dib0700
dvb_usb                21644  1 dvb_usb_dib0700
dvb_core               82216  1 dvb_usb
dvb_pll                15492  1 dvb_usb
dib3000mc              13444  1 dvb_usb_dib0700
i2c_core               26112  6 
dib7000m,dib7000p,dvb_usb,dvb_pll,dib3000mc,dibx000_common
usbcore               138632  12 
dvb_usb_dib0700,dvb_usb,hci_usb,xpad,usbhid,appleir,lirc_mceusb2,usb_storage,libusual,ehci_hcd,uhci_hcd


root@mac-mini:/lib/firmware# dmesg | grep -i dvb
[  225.636000] usbcore: registered new interface driver dvb_usb_dib0700

root@mac-mini:/lib/firmware# grep -i dvb /var/log/kern.log
Jul  8 12:37:28 mac-mini kernel: [59132.476000] usbcore: deregistering 
interface driver dvb_usb_dib0700
Jul  8 12:38:18 mac-mini kernel: [59182.808000] usbcore: registered new 
interface driver dvb_usb_dib0700
Jul  8 12:44:54 mac-mini kernel: [  225.636000] usbcore: registered new 
interface driver dvb_usb_dib0700


firmware


/lib/firmware/dvb-usb-nova-t-usb2-02.fw
/lib/firmware/dvb-usb-nova-t-usb2-01.fw
/lib/firmware/dvb-usb-dib0700-1.10.fw

Thanks

Dave

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
