Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:51027 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756606AbZCGABM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Mar 2009 19:01:12 -0500
Date: Fri, 6 Mar 2009 16:01:09 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jean Delvare <khali@linux-fr.org>
Subject: Re: Results of the 'dropping support for kernels <2.6.22' poll
In-Reply-To: <Pine.LNX.4.64.0903052315530.4980@axis700.grange>
Message-ID: <Pine.LNX.4.58.0903061532210.24268@shell2.speakeasy.net>
References: <200903022218.24259.hverkuil@xs4all.nl> <20090304141715.0a1af14d@pedra.chehab.org>
 <Pine.LNX.4.64.0903051954460.4980@axis700.grange>
 <Pine.LNX.4.58.0903051217070.24268@shell2.speakeasy.net>
 <Pine.LNX.4.64.0903052129510.4980@axis700.grange>
 <Pine.LNX.4.58.0903051243270.24268@shell2.speakeasy.net>
 <Pine.LNX.4.64.0903052315530.4980@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 5 Mar 2009, Guennadi Liakhovetski wrote:
> On Thu, 5 Mar 2009, Trent Piepho wrote:
> > ALSA used a partial tree, but their system was much worse than v4l-dvb's.
> > I think the reason more systems don't do it is that setting up the build
> > system we have with v4l-dvb was a lot of work.  They don't have that.
>
> Right, it was a lot of work, it is still quite a bit of work (well, I'm
> not doing that work directly, but it affetcs me too, when I have to adjust
> patches, that I generated from a complete kernel tree to fit
> compatibility-"emhanced" versions), and it is not going to be less work.

Why must you generate your patches from a different tree?  One could just
as well say that the linux kernel indentation style is more work, since
they use GNU style have to translate their patch from a re-indented tree.

You could just make your patches in the v4l-dvb tree and then you wouldn't
have the translate them.  In fact it could be easier, as you can develop
your patches against the kernel you are using now instead of needing to
switch to the latest kernel from a few hours ago.

I wish I could use the v4l-dvb system for embedded system development in
other areas.  In my experience most embedded hardware can't run the stock
kernel.  Most embedded system development is for new systems that don't
have all their code in the stock kernel yet.  They often have very device
specific things that aren't even wanted in the kernel.  So you end up
needing to do development with an older kernel that works for your device,
e.g. the kernel that came with the BSP.

In order to submit your patches, you then have to port them to the latest
kernel.  Not only is that extra work, you now have two patches, one in your
device tree and one in your kernel.org tree.  If you fix one patch you have
to manually keep the other in sync.  The v4l-dvb is much better as you can
have just _one_ patch that works on _both_ kernels.

> > Lots of subsystems are more tightly connected to the kernel and compiling
> > the subsystem out of tree against any kernel just wouldn't work.  Some
> > subsystems (like say gpio or led) mostly provide a framework to the rest of
> > the kernel so working on them without the rest of the tree doesn't make
> > sense either.  Or they don't get many patches and don't have many active
> > maintainers so they don't really have any development SCM at all.  Just
> > some patches through email that get applied by one maintainer.
>
> That's why I didn't give LED or GPIO or SPI or I2C or SCSI or ATA or MMC
> or MTD or ... as examples, but audio and network, which are also largely
> "consumer" interfaces and are actively developed.

Audio was out of tree.  If they had a better system, like v4l-dvb does,
they might well still be out of tree.  And aren't there some wireless
packages that are out of tree?
