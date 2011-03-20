Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <thunder.m@email.cz>) id 1Q1Qk6-0000dd-2u
	for linux-dvb@linuxtv.org; Sun, 20 Mar 2011 23:04:58 +0100
Received: from smtp.seznam.cz ([77.75.76.43])
	by mail.tu-berlin.de (exim-4.74/mailfrontend-b) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1Q1Qk5-0005lE-8r; Sun, 20 Mar 2011 23:04:57 +0100
Message-ID: <4D867A0C.7050809@email.cz> 
Date: Sun, 20 Mar 2011 23:05:00 +0100 
From: =?UTF-8?B?TWlyZWsgU2x1Z2XFiA==?= <thunder.m@email.cz> 
MIME-Version: 1.0 
To: linux-dvb@linuxtv.org 
Content-Type: multipart/mixed; boundary="------------040909000204060505020902" 
Cc: linux-kernel@vger.kernel.org
Subject: [linux-dvb] PATCH: Leadtek DTVb1800H require longer delay for tuner
	reset
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
Sender: <mchehab@pedra>
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--------------040909000204060505020902
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

	I am using alot of tuners Leadtek DTV1800H under Linux, minimum 5 
devices per one PC with kernel 2.6.37.4. I discovered bug which I can se 
very often but not always. When device tuner is reseted there is not 
enough time to do all needed stuff and sometimes (randomly) kernel show 
this message:

[  821.369647] cx88[0]/1: IRQ loop detected, disabling interrupts

Patch is again very simple, we need to adjust time in reset function 
after cx_clear and cx_set calls from 50 to 75 us. I tested this patch on 
4 PC with similar problems and all are without this issue.

M. Slugen

--------------040909000204060505020902
Content-Type: text/x-patch;
 name="kernel_cx88_reset.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="kernel_cx88_reset.diff"

diff -Naur linux-2.6.37.4.old//drivers/media/video/cx88/cx88-cards.c linux-2.6.37.4/drivers/media/video/cx88/cx88-cards.c
--- linux-2.6.37.4.old//drivers/media/video/cx88/cx88-cards.c	2011-03-20 21:30:52.000000000 +0100
+++ linux-2.6.37.4/drivers/media/video/cx88/cx88-cards.c	2011-03-20 22:25:54.710228001 +0100
@@ -3019,9 +3019,9 @@
 		cx_set(MO_GP1_IO, 0x1010);
 		mdelay(50);
 		cx_clear(MO_GP1_IO, 0x10);
-		mdelay(50);
+		mdelay(75);
 		cx_set(MO_GP1_IO, 0x10);
-		mdelay(50);
+		mdelay(75);
 		return 0;
 	}
 	return -EINVAL;

--------------040909000204060505020902
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------040909000204060505020902--
