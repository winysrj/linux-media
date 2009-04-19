Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from casper.infradead.org ([85.118.1.10])
	by mail.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<BATV+4e201fa2c735d38e8b61+2065+infradead.org+dwmw2@casper.srs.infradead.org>)
	id 1LvczI-00013y-4x
	for linux-dvb@linuxtv.org; Sun, 19 Apr 2009 21:47:36 +0200
From: David Woodhouse <dwmw2@infradead.org>
To: VDR User <user.vdr@gmail.com>
In-Reply-To: <a3ef07920904191214p7be3a0eem7f7abd91ffb374d2@mail.gmail.com>
References: <1214127575.4974.7.camel@jaswinder.satnam>
	<a3ef07920904191055j4205ad8du3173a8a2328a214e@mail.gmail.com>
	<1240167036.3589.310.camel@macbook.infradead.org>
	<a3ef07920904191214p7be3a0eem7f7abd91ffb374d2@mail.gmail.com>
Date: Sun, 19 Apr 2009 20:47:29 +0100
Message-Id: <1240170449.3589.334.camel@macbook.infradead.org>
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

On Sun, 2009-04-19 at 12:14 -0700, VDR User wrote:
> Maybe the fix is obvious to you but it clearly isn't to a lot of other
> people. 

OK then. For reference, for those of you who have slept through the last
few years of Linux development...

When the kernel complains that it cannot find a certain item of firmware
that is required for a driver to work, you need to place that firmware
into the /lib/firmware directory, so that it can be found on demand.


A recent development is that we're starting to collect those firmware
images into a central repository, so that you don't have to go hunting
all over the place for them. That repository is at
  git://git.kernel.org/pub/scm/linux/kernel/git/dwmw2/linux-firmware.git

We've also started to fix up some of the older drivers which used to
have firmware built directly into the kernel instead of using the
request_firmware() API to fetch it only when it's needed. Firmware for
_those_ drivers, which includes av7110, is actually included directly in
the kernel source tree for now, but cleanly separated from the drivers.
It can be included in the kernel if you build the driver in and set the
CONFIG_FIRMWARE_IN_KERNEL option, or otherwise it'll be automatically
installed for you when you run 'make modules_install', if you build the
driver as a module.

The major distributions are now shipping 'kernel-firmware' packages
which contain the firmware extracted from these older kernel drivers,
and are in the process of switching to the linux-firmware.git tree
instead, to include more firmware images.

If you were using a normal kernel tree, this would all 'just work'. I
believe the main problem, other than the fact that you don't _want_ to
see the obvious answer, is that you're using a tree which has a lot of
the normal kernel bits stripped out, so the automatic installation of
the firmware doesn't work?

I _would_ look at fixing that, but life's too short to learn to use
everyone's weird version control system du jour; if it isn't in git, I
have better things to do. When I encounter a project which doesn't use
git, I usually figure they just don't _want_ me to contribute, and find
something more productive to do.

As it is, you just need to copy one file. It's _really_ simple. Which is
why I assumed (and still assume) that you're just trolling.

-- 
dwmw2


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
