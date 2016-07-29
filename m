Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:59236
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbcG2K5u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2016 06:57:50 -0400
Date: Fri, 29 Jul 2016 07:57:41 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: "Bird, Timothy" <Tim.Bird@am.sony.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Shimizu, Kazuhiro" <Kazuhiro.Shimizu@sony.com>,
	"Yamamoto, Masayuki" <Masayuki.Yamamoto@sony.com>,
	"Yonezawa, Kota" <Kota.Yonezawa@sony.com>,
	"Matsumoto, Toshihiko" <Toshihiko.Matsumoto@sony.com>,
	"Watanabe, Satoshi (SSS)" <Satoshi.C.Watanabe@sony.com>,
	"Berry, Tom" <Tom.Berry@sony.com>,
	"Takiguchi, Yasunari" <Yasunari.Takiguchi@sony.com>,
	"Rowand, Frank" <Frank.Rowand@am.sony.com>,
	"tbird20d@gmail.com" <tbird20d@gmail.com>
Subject: Re: Sony tuner chip driver questions
Message-ID: <20160729075741.15e1a05b@recife.lan>
In-Reply-To: <ECADFF3FD767C149AD96A924E7EA6EAF053BB5DA@USCULXMSG02.am.sony.com>
References: <ECADFF3FD767C149AD96A924E7EA6EAF053BB5DA@USCULXMSG02.am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 28 Jul 2016 22:12:10 +0000
"Bird, Timothy" <Tim.Bird@am.sony.com> escreveu:

> Hello Linux-media people... :-)
> 
> A group at Sony would like to develop a proper kernel driver
> for a TV/tuner chip that Sony produces, and we'd like to ask some questions
> before we get started.

Nice! Be welcomed to the community!

> FYI - I'm kicking off the conversation thread, but I'm not a TV or media-driver
> person, so please excuse anything that sounds strangely worded or is just
> a really dumb question.  I have experts CC:ed who can clarify anything I
> misstate. :-)
> 
> First some background:
> The chip is in the same family as other chips for which there
> are currently some kernel drivers in mainline, produced by
> 3rd parties (not Sony). The drivers already in the tree are
> linux/media/dvb-frontend/cxd2820.c, cxd2841er.c, and ascot2e.c.

I'm familiar with this driver, as I fixed a few things there
related to stats report.

> Currently Sony provides a user-space driver to its customers, but
> we'd like to switch to an in-kernel driver.
> 
> The chip has a tuner and demodulator included.

At the DVB frontend, the tuner and demodulators should be implemented
on different drivers, even when both are encapsulated on the same
silicon.

By using two drivers, it makes easier to review the code. It also
helps to better encapsulate the functions on each part of the chip.

> First, we will be delivering the actual video data over SPI.  Currently,
> we only see examples of doing this over PCI and USB busses.  Are
> there any examples of the appropriate method to transfer video
> data (or other high-volume data) over SPI?  If not, are there any
> recommendations or tips for going about this?

There aren't many DVB drivers that aren't either PCI or USB.
There's one at drivers/media/mmc/siano/smssdio.c, but I guess this
is not the best example. ST is working on upstreaming drivers for
some of their SoCs. They're placing their drivers under
drivers/media/platform/sti. Maybe this could help you more on that.

Yet, it would be nice if you could explain a little bit more your
architecture, for us to help more on that. We'll likely do a media
workshop in Berlin (either at ELCE or LinuxCon Europe - yet to
be defined).

> Second, the current drivers for the cxd2820 and cxd2841 seem to
> use a lot of hard-coded register values (and don't appear to use
> device tree).

There are some DT stuff at c8sectpfe/c8sectpfe-core.c. We don't use
DT for PCI or USB drivers, be cause it is not needed there.

Also, specially when the same driver can be used with both embedded
and non-embedded hardware, what we do is to provide a setup
structure for the demod and for the tuner drivers, that it is
passed via a function call from the main driver.

It is up to the main driver to do the device-specific initialization.

In practice, media devices can be very complex, so we can't let
them initialize on some random order. So, the main driver
orchestrates the other ones, making the init to happen at the
right places. I suspect that this is the model used by the
c8sectpfe driver as well.

At the V4L side, we use DT for the drivers used on SoC, but
then we need to add a hack to synchronize their initialization,
via v4l2-async.

> We're not sure if these drivers are the best examples
> to follow in creating a new dvb driver for Linux.  Is there a 
> recommended driver or example that shows the most recent or
> preferred good structure for such drivers, that we should use
> in starting ours? 

The DVB core didn't change much over the years. So, you won't see
much code diversity there. I suspect you should start looking
at the STi drivers and at the drivers for the Sony components
that are already there.

If the silicon you're wanting to add support is very similar to
an already existing driver, the best, IMHO, is to modify such
driver to add extra functionality, instead of starting from scratch.

> Is DVB is the correct kernel subsystem to use for this driver, or
> is V4L more appropriate?

If your driver is for digital TV, it has to use the DVB subsystem.
If it also provides analog TV, then you'll need to write it as a
hybrid driver, implementing both APIs.

There are some examples in the Kernel about how do to that, like
cx88.

> 
> If we have multiple files in our driver, should we put them all in
> the dvb-frontend directory, or should they be sprinkled around
> in different directories based on function? Or should we create
> a 'sony' directory somewhere to hold them?


The tuner part of the driver should be at drivers/media/tuners;
the frontend part at drivers/media/dvb-frontend, and the main
driver at drivers/media/platform. If each of those drivers
is splitted on multiple c files, then it could be interesting to
have a subdir there at the subdirs.

> What debugging tools, if any, are available for testing dvb drivers
> in the kernel?

We have several tools available at v4l-utils:
	https://git.linuxtv.org/v4l-utils.git/

It provides tools for remote controllers, V4L and DVB. It also
provides libraries for both V4L and DVB usage.

Most distros package it on different packages, depending on the
functions of what's there.

I also recommend using Kaffeine for testing:
	https://www.kde.org/applications/multimedia/kaffeine/development

Starting with version 2.x, Kaffeine now uses libdvbv5 (provided
by the v4l-utils tree). I wrote two articles about it:
	https://blogs.s-osg.org/?s=kaffeine

> Do any current tuner drivers support dual-tuner configurations?

Yes. One such example is the netup_unidvb driver, with actually
uses some Sony chipsets. It is for a dual-tuner, dual-CI PCIe
board.


Thanks,
Mauro
