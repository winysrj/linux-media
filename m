Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:44419 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753789AbZCEWUQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Mar 2009 17:20:16 -0500
Date: Thu, 5 Mar 2009 23:20:14 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Trent Piepho <xyzzy@speakeasy.org>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jean Delvare <khali@linux-fr.org>
Subject: Re: Results of the 'dropping support for kernels <2.6.22' poll
In-Reply-To: <Pine.LNX.4.58.0903051243270.24268@shell2.speakeasy.net>
Message-ID: <Pine.LNX.4.64.0903052315530.4980@axis700.grange>
References: <200903022218.24259.hverkuil@xs4all.nl> <20090304141715.0a1af14d@pedra.chehab.org>
 <Pine.LNX.4.64.0903051954460.4980@axis700.grange>
 <Pine.LNX.4.58.0903051217070.24268@shell2.speakeasy.net>
 <Pine.LNX.4.64.0903052129510.4980@axis700.grange>
 <Pine.LNX.4.58.0903051243270.24268@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 5 Mar 2009, Trent Piepho wrote:

> ALSA used a partial tree, but their system was much worse than v4l-dvb's.
> I think the reason more systems don't do it is that setting up the build
> system we have with v4l-dvb was a lot of work.  They don't have that.

Right, it was a lot of work, it is still quite a bit of work (well, I'm 
not doing that work directly, but it affetcs me too, when I have to adjust 
patches, that I generated from a complete kernel tree to fit 
compatibility-"emhanced" versions), and it is not going to be less work.

> Lots of subsystems are more tightly connected to the kernel and compiling
> the subsystem out of tree against any kernel just wouldn't work.  Some
> subsystems (like say gpio or led) mostly provide a framework to the rest of
> the kernel so working on them without the rest of the tree doesn't make
> sense either.  Or they don't get many patches and don't have many active
> maintainers so they don't really have any development SCM at all.  Just
> some patches through email that get applied by one maintainer.

That's why I didn't give LED or GPIO or SPI or I2C or SCSI or ATA or MMC 
or MTD or ... as examples, but audio and network, which are also largely 
"consumer" interfaces and are actively developed.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
