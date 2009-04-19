Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from casper.infradead.org ([85.118.1.10])
	by mail.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<BATV+4e201fa2c735d38e8b61+2065+infradead.org+dwmw2@casper.srs.infradead.org>)
	id 1Lvc6G-0003Yu-LU
	for linux-dvb@linuxtv.org; Sun, 19 Apr 2009 20:50:45 +0200
From: David Woodhouse <dwmw2@infradead.org>
To: VDR User <user.vdr@gmail.com>
In-Reply-To: <a3ef07920904191055j4205ad8du3173a8a2328a214e@mail.gmail.com>
References: <1214127575.4974.7.camel@jaswinder.satnam>
	<a3ef07920904191055j4205ad8du3173a8a2328a214e@mail.gmail.com>
Date: Sun, 19 Apr 2009 19:50:36 +0100
Message-Id: <1240167036.3589.310.camel@macbook.infradead.org>
Mime-Version: 1.0
Cc: Jaswinder Singh <jaswinder@infradead.org>,
	linux-dvb <linux-dvb@linuxtv.org>
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

On Sun, 2009-04-19 at 10:55 -0700, VDR User wrote:
> What is the purpose of this patch?  How does the driver benefit?  I
> ran into a problem today where I was getting a 'dvb-ttpci: Failed to
> load firmware "av7110/bootcode.bin"' error.  This happened after I
> downloaded a fresh copy of v4l and compiled the drivers for my nexus.
> After looking into this problem I've found that a lot of users have
> experienced this error and from what I've read most have just reverted
> to an older v4l tree.
> 
> Btw, the only "bootcode.bin" I see is at
> v4l-dvb/linux/firmware/av7110/bootcode.bin.ihex and as per a warning,
> I don't dare rename that file and try to copy av7110/bootcode.bin
> somewhere and cross my fingers.
> 
> Maybe I'm ignorant of it's true purpose but the only thing this
> bootcode patch seems to do is cause problems and frustrate users.
> Please resolve this!

Since the fix is so obvious, and you don't want to post using your real
name, I'm going to assume that you're just trolling and not actually
attempt to answer you directly.

-- 
dwmw2


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
