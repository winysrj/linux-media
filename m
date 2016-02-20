Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:43635 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751208AbcBTRVE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Feb 2016 12:21:04 -0500
Message-ID: <1455988859.21645.6.camel@xs4all.nl>
Subject: Re: DVBSky T980C CI issues (kernel 4.0.x)
From: Jurgen Kramer <gtmkramer@xs4all.nl>
To: Torbjorn Jansson <torbjorn.jansson@mbox200.swipnet.se>,
	Olli Salonen <olli.salonen@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media <linux-media@vger.kernel.org>
Date: Sat, 20 Feb 2016 18:20:59 +0100
In-Reply-To: <56C88CEB.3080907@mbox200.swipnet.se>
References: <1436697509.2446.14.camel@xs4all.nl>
	 <1440352250.13381.3.camel@xs4all.nl> <55F332FE.7040201@mbox200.swipnet.se>
	 <1442041326.2442.2.camel@xs4all.nl>
	 <CAAZRmGxvrXjanCTcd0Ybk-qzHhqO5e6JhrpSWxNXSa+zzPsdUg@mail.gmail.com>
	 <1454007436.13371.4.camel@xs4all.nl>
	 <CAAZRmGwuinufZpCpTs8t+BRyTcfio-4z34PCKH7Ha3J+dxXNqw@mail.gmail.com>
	 <56ADCBE4.6050609@mbox200.swipnet.se>
	 <CAAZRmGy21S+qkrC9d0hz02J98woUc9p+LtnhK8Det=yWmb_myg@mail.gmail.com>
	 <56C88CEB.3080907@mbox200.swipnet.se>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Sat, 2016-02-20 at 16:57 +0100, Torbjorn Jansson wrote:
> i have tested your patch with my dvbsky dvb-t2 card.
> testing was done by compiling a custom kernel with your patch
> included.
> test was done against fedora 22 4.3.4-200 kernel
> 
> with the patch included the CI slot is found.
> so there is some progress for sure
> -----
> [   10.189408] cx25840 11-0044: loaded v4l-cx23885-avcore-01.fw
> firmware 
> (16382 bytes)
> [   10.206683] cx23885_dvb_register() allocating 1 frontend(s)
> [   10.207968] cx23885[0]: cx23885 based dvb card
> [   10.224306] i2c i2c-10: Added multiplexed i2c bus 12
> [   10.225633] si2168 10-0064: Silicon Labs Si2168 successfully
> attached
> [   10.243310] si2157 12-0060: Silicon Labs Si2147/2148/2157/2158 
> successfully attached
> [   10.244560] DVB: registering new adapter (cx23885[0])
> [   10.245807] cx23885 0000:07:00.0: DVB: registering adapter 0
> frontend 
> 0 (Silicon Labs Si2168)...
> [   10.417402] sp2 9-0040: CIMaX SP2 successfully attached
> [   10.447120] DVBSky T980C MAC address: 00:17:42:54:09:85
> [   10.448844] cx23885_dev_checkrevision() Hardware revision = 0xa5
> [   10.450550] cx23885[0]/0: found at 0000:07:00.0, rev: 4, irq: 19, 
> latency: 0, mmio: 0xf6e00000
> 
> later when tuning:
> 
> [   67.728109] si2168 10-0064: found a 'Silicon Labs Si2168-A20'
> [   67.802203] si2168 10-0064: downloading firmware from file 
> 'dvb-demod-si2168-a20-01.fw'
> [   68.968336] si2168 10-0064: firmware version: 2.0.5
> [   68.977071] si2157 12-0060: found a 'Silicon Labs Si2158-A20'
> [   69.961057] si2157 12-0060: downloading firmware from file 
> 'dvb-tuner-si2158-a20-01.fw'
> [   70.969094] si2157 12-0060: firmware version: 2.1.9
> ----
> 
> but using dvbv5-scan to scan it doesn't find any channel.
> all i get is this:
> ----
> Scanning frequency #1 770000000
>         (0x00) Signal= -114.00dBm
> Scanning frequency #2 754000000
>         (0x00) Signal= -27.00dBm C/N= 32.50dB
> Scanning frequency #3 546000000
>         (0x00) Signal= -25.00dBm C/N= 33.75dB
> Scanning frequency #4 650000000
>         (0x00) Signal= -18.00dBm C/N= 36.00dB
> Scanning frequency #5 522000000
>         (0x00) Signal= -28.00dBm C/N= 33.00dB
> ----
> 
> so something else is broken too.
> 
I have been using the patches for a few days. So far everything works
great (using MythTV). Scanning with dvbv5_scan does indeed not work
(never did for me). w_scan works though.

Can these patches please be included in the stable kernels ?

Jurgen


> On 2016-02-16 21:20, Olli Salonen wrote:
> > Hi all,
> > 
> > Found the issue and submitted a patch.
> > 
> > The I2C buses for T980C/T2-4500CI were crossed when CI registration
> > was moved to its own function.
> > 
> > Cheers,
> > -olli
> > 
> > On 31 January 2016 at 10:55, Torbjorn Jansson
> > <torbjorn.jansson@mbox200.swipnet.se> wrote:
> > > this ci problem is the reason i decided to buy the CT2-4650 usb
> > > based device
> > > instead.
> > > but the 4650 was a slightly newer revision needing a patch i
> > > submitted
> > > earlier.
> > > and also this 4650 device does not have auto switching between
> > > dvb-t and t2
> > > like the dvbsky card have, so i also need an updated version of
> > > mythtv.
> > > 
> > > my long term wish is to not have to patch things or build custom
> > > kernels or
> > > modules.
> > > so anything done to improve the dvbsky card or the 4650 is much
> > > appreciated.
> > > 
> > > 
> > > On 2016-01-28 20:42, Olli Salonen wrote:
> > > > 
> > > > Hi Jürgen & Mauro,
> > > > 
> > > > I did bisect this and it seems this rather big patch broke it:
> > > > 
> > > > 2b0aac3011bc7a9db27791bed4978554263ef079 is the first bad
> > > > commit
> > > > commit 2b0aac3011bc7a9db27791bed4978554263ef079
> > > > Author: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > > > Date:   Tue Dec 23 13:48:07 2014 -0200
> > > > 
> > > >       [media] cx23885: move CI/MAC registration to a separate
> > > > function
> > > > 
> > > >       As reported by smatch:
> > > >           drivers/media/pci/cx23885/cx23885-dvb.c:2080
> > > > dvb_register()
> > > > Function too hairy.  Giving up.
> > > > 
> > > >       This is indeed a too complex function, with lots of stuff
> > > > inside.
> > > >       Breaking this into two functions makes it a little bit
> > > > less hairy.
> > > > 
> > > >       Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung
> > > > .com>
> > > > 
> > > > It's getting a bit late, so I'll call it a day now and have a
> > > > look at
> > > > the patch to see what goes wrong there.
> > > > 
> > > > Cheers,
> > > > -olli
> > > > 
> > > > On 28 January 2016 at 20:57, Jurgen Kramer <gtmkramer@xs4all.nl
> > > > > wrote:
> > > > > 
> > > > > Hi Olli,
> > > > > 
> > > > > On Thu, 2016-01-28 at 19:26 +0200, Olli Salonen wrote:
> > > > > > 
> > > > > > Hi Jürgen,
> > > > > > 
> > > > > > Did you get anywhere with this?
> > > > > > 
> > > > > > I have a clone of your card and was just starting to look
> > > > > > at this
> > > > > > issue. Kernel 3.19 seems to work ok, but 4.3 not. Did you
> > > > > > have any
> > > > > > time to try to pinpoint this more?
> > > > > 
> > > > > No, unfortunately not. I have spend a few hours adding
> > > > > printk's but it
> > > > > did not get me any closer what causes the issue. This really
> > > > > needs
> > > > > investigation from someone who is more familiar with linux
> > > > > media.
> > > > > 
> > > > > Last thing I tried was the latest (semi open) drivers from
> > > > > dvbsky on a
> > > > > 4.3 kernel. Here the CI and CAM registered successfully.
> > > > > 
> > > > > Greetings,
> > > > > Jurgen
> > > > > 
> > > > > > Cheers,
> > > > > > -olli
> > > > > > 
> > > > > > On 12 September 2015 at 10:02, Jurgen Kramer <gtmkramer@xs4
> > > > > > all.nl>
> > > > > > wrote:
> > > > > > > 
> > > > > > > On Fri, 2015-09-11 at 22:01 +0200, Torbjorn Jansson
> > > > > > > wrote:
> > > > > > > > 
> > > > > > > > On 2015-08-23 19:50, Jurgen Kramer wrote:
> > > > > > > > > 
> > > > > > > > > 
> > > > > > > > > On Sun, 2015-07-12 at 12:38 +0200, Jurgen Kramer
> > > > > > > > > wrote:
> > > > > > > > > > 
> > > > > > > > > > I have been running a couple of DVBSky T980C's with
> > > > > > > > > > CIs with
> > > > > > > > > > success
> > > > > > > > > > using an older kernel (3.17.8) with media-build and
> > > > > > > > > > some
> > > > > > > > > > added patches
> > > > > > > > > > from the mailing list.
> > > > > > > > > > 
> > > > > > > > > > I thought lets try a current 4.0 kernel to see if I
> > > > > > > > > > no longer
> > > > > > > > > > need to be
> > > > > > > > > > running a custom kernel. Everything works just fine
> > > > > > > > > > except
> > > > > > > > > > the CAM
> > > > > > > > > > module. I am seeing these:
> > > > > > > > > > 
> > > > > > > > > > [  456.574969] dvb_ca adapter 0: Invalid PC card
> > > > > > > > > > inserted :(
> > > > > > > > > > [  456.626943] dvb_ca adapter 1: Invalid PC card
> > > > > > > > > > inserted :(
> > > > > > > > > > [  456.666932] dvb_ca adapter 2: Invalid PC card
> > > > > > > > > > inserted :(
> > > > > > > > > > 
> > > > > > > > > > The normal 'CAM detected and initialised' messages
> > > > > > > > > > to do show
> > > > > > > > > > up with
> > > > > > > > > > 4.0.8
> > > > > > > > > > 
> > > > > > > > > > I am not sure what changed in the recent kernels,
> > > > > > > > > > what is
> > > > > > > > > > needed to
> > > > > > > > > > debug this?
> > > > > > > > > > 
> > > > > > > > > > Jurgen
> > > > > > > > > 
> > > > > > > > > Retest. I've isolated one T980C on another PC with
> > > > > > > > > kernel
> > > > > > > > > 4.1.5, still the same 'Invalid PC card inserted :('
> > > > > > > > > message.
> > > > > > > > > Even after installed today's media_build from git no
> > > > > > > > > improvement.
> > > > > > > > > 
> > > > > > > > > Any hints where to start looking would be
> > > > > > > > > appreciated!
> > > > > > > > > 
> > > > > > > > > cimax2.c|h do not seem to have changed. There are
> > > > > > > > > changes to
> > > > > > > > > dvb_ca_en50221.c
> > > > > > > > > 
> > > > > > > > > Jurgen
> > > > > > > > > 
> > > > > > > > 
> > > > > > > > did you get it to work?
> > > > > > > 
> > > > > > > 
> > > > > > > No, it needs a thorough debug session. So far no one
> > > > > > > seems able to
> > > > > > > help...
> > > > > > > 
> > > > > > > > i got a dvbsky T980C too for dvb-t2 reception and so
> > > > > > > > far the only
> > > > > > > > drivers that have worked at all is the ones from dvbsky
> > > > > > > > directly.
> > > > > > > > 
> > > > > > > > i was very happy when i noticed that recent kernels
> > > > > > > > have support
> > > > > > > > for it
> > > > > > > > built in but unfortunately only the modules and
> > > > > > > > firmware loads
> > > > > > > > but then
> > > > > > > > nothing actually works.
> > > > > > > > i use mythtv and it complains a lot about the signal,
> > > > > > > > running
> > > > > > > > femon also
> > > > > > > > produces lots of errors.
> > > > > > > > 
> > > > > > > > so i had to switch back to kernel 4.0.4 with mediabuild
> > > > > > > > from
> > > > > > > > dvbsky.
> > > > > > > > 
> > > > > > > > if there were any other dvb-t2 card with ci support
> > > > > > > > that had
> > > > > > > > better
> > > > > > > > drivers i would change right away.
> > > > > > > > 
> > > > > > > > one problem i have with the mediabuilt from dvbsky is
> > > > > > > > that at
> > > > > > > > boot the
> > > > > > > > cam never works and i have to first tune a channel,
> > > > > > > > then remove
> > > > > > > > and
> > > > > > > > reinstert the cam to get it to work.
> > > > > > > > without that nothing works.
> > > > > > > > 
> > > > > > > > and finally a problem i ran into when i tried
> > > > > > > > mediabuilt from
> > > > > > > > linuxtv.org.
> > > > > > > > fedora uses kernel modules with .ko.xz extension so
> > > > > > > > when you
> > > > > > > > install the
> > > > > > > > mediabuilt modulels you get one modulename.ko and one
> > > > > > > > modulename.ko.xz
> > > > > > > > 
> > > > > > > > before a make install from mediabuild overwrote the
> > > > > > > > needed
> > > > > > > > modules.
> > > > > > > > any advice on how to handle this now?
> > > > > > > > 
> > > > > > > > 
> > > > > > > 
> > > > > > > 
> > > > > > > --
> > > > > > > To unsubscribe from this list: send the line "unsubscribe
> > > > > > > linux-
> > > > > > > media" in
> > > > > > > the body of a message to majordomo@vger.kernel.org
> > > > > > > More majordomo info at  http://vger.kernel.org/majordomo-
> > > > > > > info.html
> 
