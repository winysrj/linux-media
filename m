Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <spam.ugnius40@gmail.com>) id 1P4jM3-0000Tl-VU
	for linux-dvb@linuxtv.org; Sun, 10 Oct 2010 02:01:32 +0200
Received: from mail-wy0-f182.google.com ([74.125.82.182])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-d) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1P4jM3-00054P-1s; Sun, 10 Oct 2010 02:01:31 +0200
Received: by wyb29 with SMTP id 29so3384009wyb.41
	for <linux-dvb@linuxtv.org>; Sat, 09 Oct 2010 17:01:30 -0700 (PDT)
From: Ugnius Soraka <spam.ugnius40@gmail.com>
To: linux-dvb@linuxtv.org
Date: Sun, 10 Oct 2010 00:59:16 +0100
Message-ID: <1286668756.3990.41.camel@linux-efue.site>
Mime-Version: 1.0
Subject: [linux-dvb] rtl2831-r2 still not working for Compro VideoMate U80
Reply-To: linux-media@vger.kernel.org, spam.ugnius40@gmail.com
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

Hi,

I'd like to get in touch with driver developers, is there any way I
could help make RTL2831U driver work with Compro VideoMate U80. I would
like to actively participate. My programming skills are well below
required to write kernel modules, so I know I would be no use there. But
anything else, testing with VideoMate U80, sending debug logs, I think I
could do that.

I've tried http://linuxtv.org/hg/~jhoogenraad/rtl2831-r2 driver, it
looked promising. U80 device was recognised as VideoMate U90, /dev/dvb
entries were created. But when scanning it says there's no signal. Debug
gives TPS_NON_LOCK, Signal NOT Present, rtd2830_soft_reset, etc. (I
could post message log, if it's any use to somebody).
U80 has a led which (on windows) shows if TV stick is tuned in and
working, when scanning on linux it's always on.

I've also tried to compile http://linuxtv.org/hg/~anttip/rtl2831u/ but
for now it's based on old dvb tree and seems to be incompatible with new
kernels (mine 2.6.34.7-0.3).

Is anttip driver supposed to be included in kernel, but it looks like
development is going slow.

Thank you,
Ugnius



_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
