Return-path: <linux-media-owner@vger.kernel.org>
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:62660 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750888AbaKZUWl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Nov 2014 15:22:41 -0500
Message-ID: <1417033359.29407.81.camel@x220>
Subject: Re: [linuxtv-media:master 7661/7664] ERROR: "omapdss_compat_init"
 [drivers/media/platform/omap/omap-vout.ko] undefined!
From: Paul Bolle <pebolle@tiscali.nl>
To: Fengguang Wu <fengguang.wu@intel.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: kbuild-all@01.org, linux-media@vger.kernel.org
Date: Wed, 26 Nov 2014 21:22:39 +0100
In-Reply-To: <20141126193053.GD19633@wfg-t540p.sh.intel.com>
References: <201411260931.8e2dBfm8%fengguang.wu@intel.com>
	 <1416988241.29407.5.camel@x220>
	 <20141126193053.GD19633@wfg-t540p.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Fengguang

On Wed, 2014-11-26 at 11:30 -0800, Fengguang Wu wrote:
> On Wed, Nov 26, 2014 at 08:50:41AM +0100, Paul Bolle wrote:
> > Hi Fengguang,
> > 
> > On Wed, 2014-11-26 at 09:34 +0800, kbuild test robot wrote:
> > > tree:   git://linuxtv.org/media_tree.git master
> > > head:   504febc3f98c87a8bebd8f2f274f32c0724131e4
> > > commit: 6b213e81ddf8b265383c9a1a1884432df88f701e [7661/7664] [media] omap: Fix typo "HAS_MMU"
> > > config: m68k-allmodconfig (attached as .config)
> > > reproduce:
> > >   wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
> > >   chmod +x ~/bin/make.cross
> > >   git checkout 6b213e81ddf8b265383c9a1a1884432df88f701e
> > >   # save the attached .config to linux build tree
> > >   make.cross ARCH=m68k 
> > 
> > This is the first time I've made the kbuild test robot trip. So I'm not
> > sure how to interpret this.
> > 
> > Is ARCH=m68k the only build that failed through this commit? Or is it
> > the first build that failed? If so, how can I determine which arches
> > build correctly?
> 
> It's the first build that failed. I checked log and find these
> failures, which covers m68k, mips and i386.

By now your bot sent its fanmail for those other two architectures too.
So the lesson here is, apparently, to wait a few hours. By then the bots
should have done their thing and I can do damage control.

Luckily, for me, Mauro already has done damage control (see
http://git.linuxtv.org/cgit.cgi/mchehab/media-next.git/commit/?id=7996d58f03c14c0caf9935e64bb32ed04dbe79c5 ). So all I'll have to do now is ponder how to make sure your bot leaves me alone in the future.

Thanks, both of you!


Paul Bolle

