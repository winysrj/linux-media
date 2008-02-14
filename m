Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <vist@comhem.se>) id 1JPj1U-0002Zi-6G
	for linux-dvb@linuxtv.org; Thu, 14 Feb 2008 19:41:28 +0100
Received: from ch-cpps01.sth.basefarm.net ([10.2.6.80]:58590)
	by ch-smtp02.sth.basefarm.net with esmtps (TLSv1:AES256-SHA:256)
	(Exim 4.68) (envelope-from <vist@comhem.se>) id 1JPj1R-0001lp-8K
	for linux-dvb@linuxtv.org; Thu, 14 Feb 2008 19:41:27 +0100
Received: from localhost ([127.0.0.1]:58588 helo=ch-cpps01.sth.basefarm.net)
	by ch-cpps01.sth.basefarm.net with esmtp (Exim 4.66)
	(envelope-from <vist@comhem.se>) id 1JPj1K-0005Z8-Ug
	for linux-dvb@linuxtv.org; Thu, 14 Feb 2008 19:41:18 +0100
Message-ID: <13397504.34281203014478950.JavaMail.defaultUser@defaultHost>
Date: Thu, 14 Feb 2008 19:41:18 +0100 (CET)
From: <vist@comhem.se>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] Terratec Cinergy T USB XE
Reply-To: vist@comhem.se
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hello, I have a Terratec Cinergy T USB XE, 0ccd:0069 and have been trying to 
compile from site:

http://www.jusst.de/hg/af901x/

My kernel is 2.6.22.5-31-x86_64.

I get the following error/warning  messages when compiling:

 CC [M]  /usr/build/af901x/v4l/af9015.o
/usr/build/af901x/v4l/af9015.c: In function 'af901x_read_snr':
/usr/build/af901x/v4l/af9015.c:477: warning: array subscript is above array 
bounds
/usr/build/af901x/v4l/af9015.c: In function 'af901x_attach':
/usr/build/af901x/v4l/af9015.c:1608: warning: 'fw_ver' may be used 
uninitialized in this function
  CC [M]  /usr/build/af901x/v4l/af9015_biu.o
/usr/build/af901x/v4l/af9015_biu.c: In function 'af9015_read_eeprom':
/usr/build/af901x/v4l/af9015_biu.c:463: warning: unused variable 'eeprom_reg'
/usr/build/af901x/v4l/af9015_biu.c: In function 'af9015_get_biu_config':
/usr/build/af901x/v4l/af9015_biu.c:685: warning: label 'exit' defined but not 
used
/usr/build/af901x/v4l/af9015_biu.c: In function 'af9015_epconfig_mode_15':

/usr/build/af901x/v4l/af9015_biu.c:817: warning: overflow in implicit constant 
conversion
/usr/build/af901x/v4l/af9015_biu.c:822: warning: overflow in implicit constant 
conversion
/usr/build/af901x/v4l/af9015_biu.c:829: warning: overflow in implicit constant 
conversion
/usr/build/af901x/v4l/af9015_biu.c:834: warning: overflow in implicit constant 
conversion
/usr/build/af901x/v4l/af9015_biu.c:841: warning: overflow in implicit constant 
conversion
/usr/build/af901x/v4l/af9015_biu.c:848: warning: overflow in implicit constant 
conversion
/usr/build/af901x/v4l/af9015_biu.c: In function 'af9015_epconfig_mode_17':
/usr/build/af901x/v4l/af9015_biu.c:963: warning: overflow in implicit constant 
conversion
/usr/build/af901x/v4l/af9015_biu.c:968: warning: overflow in implicit constant 
conversion
/usr/build/af901x/v4l/af9015_biu.c:974: warning: overflow in implicit constant 
conversion
/usr/build/af901x/v4l/af9015_biu.c: In function 'af9015_tuner_attach':
/usr/build/af901x/v4l/af9015_biu.c:1096: warning: unused variable 'err'
/usr/build/af901x/v4l/af9015_biu.c: In function 'af9015_usb_probe':
/usr/build/af901x/v4l/af9015_biu.c:1167: warning: unused variable 'biu'
/usr/build/af901x/v4l/af9015_biu.c: At top level:
/usr/build/af901x/v4l/af9015_biu.c:1138: warning: 'af9015_biu_epconfig' 
defined but not used

When I connect the stick it is recognised, firmware is downloaded and the 
tuner is attached according to the messages,
but when trying to scan dvb-t  the tuning fails.

Do I need another kernel? I have tried 2.6.24 but it did not seem to work at 
all with http://www.jusst.de/hg/af901x/

Is the support for Terratec Cinergy T USB XE, 0ccd:0069 and the Freescale 
tuner going to http://linuxtv.org/hg/ for all kernels?

Is there anything I can do to solve this?

Thank you in advance




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
