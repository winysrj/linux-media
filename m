Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp.seznam.cz ([77.75.72.43])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <oldium.pro@seznam.cz>) id 1LQ4R6-0008G2-Fg
	for linux-dvb@linuxtv.org; Thu, 22 Jan 2009 19:37:54 +0100
From: Oldrich Jedlicka <oldium.pro@seznam.cz>
To: linux-dvb@linuxtv.org
Date: Thu, 22 Jan 2009 19:37:14 +0100
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200901221937.14552.oldium.pro@seznam.cz>
Subject: [linux-dvb] [PATCH] Added support for AVerMedia Cardbus Hybrid
	remote control
Reply-To: linux-media@vger.kernel.org
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

Hi all,

I've found a way to get the remote control for AVerMedia Cardbus Hybrid (and 
possibly other Cardbus cards like Cardbus Plus) work, so here is the patch 
for it. Currently only the Hybrid (E506R) uses it. Comments are welcome.

Patch created against v4l-dvb, tested with vanilla 2.6.28.1. Works for me.

Enjoy (and please apply :-))

Regards,
Oldrich.

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
