Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from casper.infradead.org ([85.118.1.10])
	by mail.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<BATV+4e201fa2c735d38e8b61+2065+infradead.org+dwmw2@casper.srs.infradead.org>)
	id 1Lve9C-00007f-UR
	for linux-dvb@linuxtv.org; Sun, 19 Apr 2009 23:01:56 +0200
From: David Woodhouse <dwmw2@infradead.org>
To: VDR User <user.vdr@gmail.com>
In-Reply-To: <a3ef07920904191340x6a4e9c5o5c51fe0169cbddab@mail.gmail.com>
References: <1214127575.4974.7.camel@jaswinder.satnam>
	<a3ef07920904191055j4205ad8du3173a8a2328a214e@mail.gmail.com>
	<1240167036.3589.310.camel@macbook.infradead.org>
	<a3ef07920904191214p7be3a0eem7f7abd91ffb374d2@mail.gmail.com>
	<1240170449.3589.334.camel@macbook.infradead.org>
	<a3ef07920904191340x6a4e9c5o5c51fe0169cbddab@mail.gmail.com>
Date: Sun, 19 Apr 2009 22:01:48 +0100
Message-Id: <1240174908.3589.387.camel@macbook.infradead.org>
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

On Sun, 2009-04-19 at 13:40 -0700, VDR User wrote:
> 
> To be absolutely clear; users compiling dvb drivers outside of the
> kernel should copy v4l-dvb/linux/firmware/av7110/bootcode.bin.ihex to
> /lib/firmware/av7110/bootcode.bin correct?

Run 'objcopy -Iihex -Obinary bootcode.bin.ihex bootcode.bin' first, then
copy the resulting bootcode.bin file to /lib/firmware/av7110/

We didn't want to put raw binary files into the kernel source tree so we
converted them to a simple hex form instead.

As I said, the makefiles in the kernel tree get this right, and convert
them to binary for you and automatically install them. It shouldn't be
hard to fix the v4l tree to do it too, but as I also said, I'm not
particularly interested in doing that myself.

-- 
dwmw2


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
