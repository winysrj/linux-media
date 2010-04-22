Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <herbert@turboprinzessin.de>) id 1O51rP-0000Fm-CM
	for linux-dvb@linuxtv.org; Thu, 22 Apr 2010 21:14:51 +0200
Received: from mail.gmx.net ([213.165.64.20])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-c) with smtp
	for <linux-dvb@linuxtv.org>
	id 1O51rO-0000l5-5k; Thu, 22 Apr 2010 21:14:51 +0200
Message-ID: <4BD0A01E.4020107@turboprinzessin.de>
Date: Thu, 22 Apr 2010 21:14:38 +0200
From: herbert <herbert@turboprinzessin.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Technotrend S2-3200 artifacts on second card
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi List

I am using two TT 3200 cards in my mythtv setup.
Both of them with a CI-draughtboard, a "SCM Viaccess red label" cam and 
a registered keycard attached.
Decryption is working with Both cards, if i insert the cam after boot - 
Boot with inserted cams works sometimes...

Anyway -  Back to the artifacts:
They appear on all channels but only on the second card and only if both 
cams are attached.

There are no problems with:
- one cam attached on the first card
- one cam attached on the second card


OS: Gentoo GNU/Linux
Kernel:  2.6.31 (+vserver)
v4l-dvb:  rev 13546
mb: gigabyte k8n8
cpu:  amd athlon64 3400+ (k8)

Is this a hardware (mb, interrupt) issue?

Let me know, if i should collect some debug logs.

regards,
herbert





_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
