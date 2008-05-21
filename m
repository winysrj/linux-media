Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.168])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <dennis.schwan@gmail.com>) id 1JynoR-0008Oe-UV
	for linux-dvb@linuxtv.org; Wed, 21 May 2008 14:53:01 +0200
Received: by ug-out-1314.google.com with SMTP id m3so147698uge.20
	for <linux-dvb@linuxtv.org>; Wed, 21 May 2008 05:52:55 -0700 (PDT)
Message-ID: <48341B25.2070306@leuchtturm-it.de>
Date: Wed, 21 May 2008 14:52:53 +0200
From: Dennis Schwan <dennis.schwan@leuchtturm-it.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Problems with cx88
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

Hi,

I have problems with my Hauppauge Nova-S Card. It works mostly but i 
have problems when watching Live-TV on a MythTV Client.
The Errors ind the Backends Syslog are as follows:

May 21 14:49:38 myth kernel: [  319.630976] cx88[0]/2-mpeg: general 
errors: 0x00000100
May 21 14:49:39 myth kernel: [  320.638820] cx88[0]/2-mpeg: general 
errors: 0x00000100
May 21 14:49:40 myth kernel: [  321.646477] cx88[0]/2-mpeg: general 
errors: 0x00000100
May 21 14:49:41 myth kernel: [  322.654081] cx88[0]/2-mpeg: general 
errors: 0x00000100
May 21 14:49:42 myth kernel: [  323.661852] cx88[0]/2-mpeg: general 
errors: 0x00000100
May 21 14:49:43 myth kernel: [  324.669599] cx88[0]/2-mpeg: general 
errors: 0x00000100
May 21 14:49:44 myth kernel: [  325.677362] cx88[0]/2-mpeg: general 
errors: 0x00000100
May 21 14:49:45 myth kernel: [  326.685118] cx88[0]/2-mpeg: general 
errors: 0x00000100
May 21 14:49:46 myth kernel: [  327.691986] cx88[0]/2-mpeg: general 
errors: 0x00000100
May 21 14:49:47 myth kernel: [  328.700559] cx88[0]/2-mpeg: general 
errors: 0x00000100
May 21 14:49:48 myth kernel: [  329.707352] cx88[0]/2-mpeg: general 
errors: 0x00000100
May 21 14:49:49 myth kernel: [  330.714884] cx88[0]/2-mpeg: general 
errors: 0x00000100
May 21 14:49:50 myth kernel: [  331.722389] cx88[0]/2-mpeg: general 
errors: 0x00000100

When i reload the driver and just use my budget-card everything works 
fine, so i really need a solition for this.
The card worked without problems before upgrading to Ubuntu Hardy/8.04

The problem occurs with the default Ubuntu drivers and also with newes 
CVS drivers.

Regards,
Dennis


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
