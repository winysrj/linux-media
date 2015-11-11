Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:53163 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414AbbKKROb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Nov 2015 12:14:31 -0500
Date: Wed, 11 Nov 2015 15:14:25 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Warren Sturm <warren.sturm@gmail.com>
Cc: Andy Walls <awalls@md.metrocast.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	andy <andy@silverblocksystems.net>
Subject: Re: PVR-250 Composite 3 unavailable [Re: ivtv driver]
Message-ID: <20151111151425.32eadd9b@recife.lan>
In-Reply-To: <1446831368.20743.7.camel@gmail.com>
References: <1445901232.9389.2.camel@gmail.com>
	<77A58399-549F-4A8A-8F87-8F40B7756D3A@md.metrocast.net>
	<1446831368.20743.7.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 06 Nov 2015 10:36:08 -0700
Warren Sturm <warren.sturm@gmail.com> escreveu:

> On Mon, 2015-10-26 at 19:49 -0400, Andy Walls wrote:
> > On October 26, 2015 7:13:52 PM EDT, Warren Sturm <
> > warren.sturm@gmail.com> wrote:
> > > Hi Andy.
> > > 
> > > I don't know whether this was intended but the pvr250 lost the
> > > composite 3 input when going from kernel version 4.1.10 to 4.2.3.
> > > 
> > > This is on a Fedora 22 x86_64 system.
> > > 
> > > 
> > > Thanks for any insight.
> > 
> > Unintentional.
> > 
> > I'm guessing this commit was the problem:
> > 
> > http://git.linuxtv.org/cgit.cgi/media_tree.git/commit/drivers/media/pci/ivtv/ivtv-driver.c?id=09290cc885937cab3b2d60a6d48fe3d2d3e04061

My fault. I'll revert that patch.

> > 
> > Could you confirm?
> > 
> > R,
> > Andy
> 
> Ok.  I rebuilt the SRPM for kernel-4.2.5-201 with the patch reverted
> and installed it.
> 
> uname -a
> Linux wrs 4.2.5-201.fc22.x86_64 #1 SMP Fri Nov 6 00:13:17 MST 2015 x86_64 x86_64 x86_64 GNU/Linux
> 
> Attached are the v4l2-ctl --list-inputs for the respective kernels.
> 
> Hope this is sufficient confirmation.
> 
> 
> 
