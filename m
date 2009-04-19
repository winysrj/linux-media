Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qw-out-2122.google.com ([74.125.92.25])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <user.vdr@gmail.com>) id 1LvbFN-0006l4-Of
	for linux-dvb@linuxtv.org; Sun, 19 Apr 2009 19:56:26 +0200
Received: by qw-out-2122.google.com with SMTP id 8so523168qwh.17
	for <linux-dvb@linuxtv.org>; Sun, 19 Apr 2009 10:56:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1214127575.4974.7.camel@jaswinder.satnam>
References: <1214127575.4974.7.camel@jaswinder.satnam>
Date: Sun, 19 Apr 2009 10:55:59 -0700
Message-ID: <a3ef07920904191055j4205ad8du3173a8a2328a214e@mail.gmail.com>
From: VDR User <user.vdr@gmail.com>
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] [PATCH] firmware: convert av7110 driver to
	request_firmware()
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

What is the purpose of this patch?  How does the driver benefit?  I
ran into a problem today where I was getting a 'dvb-ttpci: Failed to
load firmware "av7110/bootcode.bin"' error.  This happened after I
downloaded a fresh copy of v4l and compiled the drivers for my nexus.
After looking into this problem I've found that a lot of users have
experienced this error and from what I've read most have just reverted
to an older v4l tree.

Btw, the only "bootcode.bin" I see is at
v4l-dvb/linux/firmware/av7110/bootcode.bin.ihex and as per a warning,
I don't dare rename that file and try to copy av7110/bootcode.bin
somewhere and cross my fingers.

Maybe I'm ignorant of it's true purpose but the only thing this
bootcode patch seems to do is cause problems and frustrate users.
Please resolve this!

Thanks.

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
