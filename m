Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <sibxol@btconnect.com>) id 1P3GZN-0002lF-Mr
	for linux-dvb@linuxtv.org; Wed, 06 Oct 2010 01:05:14 +0200
Received: from c2bthomr09.btconnect.com ([213.123.20.127]
	helo=mail.btconnect.com)
	by mail.tu-berlin.de (exim-4.69/mailfrontend-a) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1P3GZN-0003ru-AW; Wed, 06 Oct 2010 01:05:13 +0200
From: sibu xolo <sibxol@btconnect.com>
To: linux-dvb@linuxtv.org
Date: Wed, 6 Oct 2010 00:05:33 +0100
MIME-Version: 1.0
Message-Id: <201010060005.33998.sibxol@btconnect.com>
Subject: [linux-dvb] dvb,amd64,kernel2.6.35.5, circles
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
Sender: <mchehab@pedra>
List-ID: <linux-dvb@linuxtv.org>

Greetings,

I am attempting to install dvbT on a computer with  these:-

-----------cpu -amd64 2 cores
-----------o/s 64-bit cblfs linux kernel-2.6.35.5 Xoorg7.5 KDE-4.4.5
-----------udev:-161  dvbT devices described below

I have two dvbT devices avermedia-dbvT-usb2 (DEVICE1) and Hauppauge wintv 
NovatT-usb2(DEVICE2).  I am not a total novice at installing dvb on linux 
(cblfs  (compile all from scratch).  I  have done so in the past on 

--kernels 2.6.17/2.6.19
--kernel-2.6.27/2.6.31
firmwares in /lib/firmware
AND Both worked  successfully.

For the present attempt(s) I have done the following:-

-----------A) I compiled the kernel  for in-kernel drivers/modern V4L-api/with  
DEVICE1 in situ. On booting -  I obtained  /dev/dvb/adapter0.  Eureka I 
thought.  I then  tried booting with DEVICE2 and  the machine dwelled   then 
reported that firmware file could not be found.  I  Then rebooted with DEVICE1 
only to  be met with the same message.  I surmised that perhaps I should use 
the older api  marked depreciated as 
DECICEs{1/2} are ~6 years old.

----------B)So I recompiled the kernel  with both devices attached  selecting 
v4l- depreciated  and compiled all as modules.  After kernel installation   
DEVICES{1/2} registered as /dev/dvb/adapter{0/1). 
Hurray  at last. I removed the device did something else and rebooted the 
machine. with one device. On booting  I obntained the  'cant find firmware 
error as reported   under A).  I tried the other device  and obtained the same 
error.


I recall a  while back when DVB  drivers were not in the kernel.   Then they  
were  integrated within  thus requiring only a kernel compilation.  I came 
across the somewhat  ubuntified  wiki
( http://www.linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-
DVB_Device_Drivers )*
(which seems  to suggest the old method    is now needed  although as far as I 
can see these are in the kernel sources.


I would be most grateful if someone on list could explain what is going on 
please and  guidance on installing dvb on   the setup describe above.  

sincerely
sibuXolo
* ps you need to copy all of this ()* to your brrowser window

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
