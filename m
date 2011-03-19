Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <thunder.m@email.cz>) id 1Q15K3-0005jk-1y
	for linux-dvb@linuxtv.org; Sun, 20 Mar 2011 00:12:39 +0100
Received: from smtp.seznam.cz ([77.75.76.43])
	by mail.tu-berlin.de (exim-4.74/mailfrontend-d) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1Q15K2-0006Ji-2G; Sun, 20 Mar 2011 00:12:38 +0100
Message-ID: <4D853861.7010206@email.cz> 
Date: Sun, 20 Mar 2011 00:12:33 +0100 
From: =?UTF-8?B?TWlyZWsgU2x1Z2XFiA==?= <thunder.m@email.cz> 
MIME-Version: 1.0 
To: linux-dvb@linuxtv.org 
Content-Type: multipart/mixed; boundary="------------020609000506040405000006" 
Cc: linux-kernel@vger.kernel.org
Subject: [linux-dvb] Patch for broken radio in XC2k and XC3k tuners
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
--------------020609000506040405000006
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi, I am very supprised that no one complains about broken radio support 
on devices with XC2k and XC3k tuner, it is broken since commit:

V4L/DVB: tuner-xc2028: fix tuning logic to solve a regression in Australia

from date 19.3.2010

BUG is present in current kernel stable version 2.6.38 and also olders 
like 2.6.37, fix is very trivial.

I tested this fix with Leadtek DTV1800H radio and it works great, before 
this fix I can listen so much of noise on tuned frequency (so something 
wrong with tuning).

Feel free to modify this patch :)

M. Slugen

--------------020609000506040405000006
Content-Type: text/x-patch;
 name="kernel_xc2000_radio.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="kernel_xc2000_radio.diff"

--- linux-2.6.37.2.old/drivers/media/common/tuners/tuner-xc2028.c	2011-03-19 23:25:28.000000000 +0100
+++ linux-2.6.37.2/drivers/media/common/tuners/tuner-xc2028.c	2011-03-19 23:26:13.458252000 +0100
@@ -937,6 +937,8 @@
 		rc = send_seq(priv, {0x00, 0x00});
 
 		/* Analog modes require offset = 0 */
+	} else if (new_mode == T_RADIO) {
+		/* nop */
 	} else {
 		/*
 		 * Digital modes require an offset to adjust to the

--------------020609000506040405000006
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------020609000506040405000006--
