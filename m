Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:60090 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674AbbLVSdz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Dec 2015 13:33:55 -0500
Date: Tue, 22 Dec 2015 16:33:50 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
	Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: next-20151222 - compile failure in
 drivers/media/usb/uvc/uvc_driver.c
Message-ID: <20151222163350.044bd9c4@recife.lan>
In-Reply-To: <1975883.EPhFUU4nET@avalon>
References: <75073.1450779516@turing-police.cc.vt.edu>
	<567944CB.4070505@osg.samsung.com>
	<1975883.EPhFUU4nET@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 22 Dec 2015 20:06:38 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Javier,
> 
> On Tuesday 22 December 2015 09:40:43 Javier Martinez Canillas wrote:
> > On 12/22/2015 07:18 AM, Valdis Kletnieks wrote:
> > > next-20151222 fails to build for me:
> > >   CC      drivers/media/usb/uvc/uvc_driver.o
> > > 
> > > drivers/media/usb/uvc/uvc_driver.c: In function 'uvc_probe':
> > > drivers/media/usb/uvc/uvc_driver.c:1941:32: error: 'struct uvc_device' has
> > > no member named 'mdev'> 
> > >   if (media_device_register(&dev->mdev) < 0)
> > >                                 ^
> > > 
> > > scripts/Makefile.build:258: recipe for target
> > > 'drivers/media/usb/uvc/uvc_driver.o' failed
> > > 
> > > 'git blame' points at that line being added in:
> > > 
> > > commit 1590ad7b52714fddc958189103c95541b49b1dae
> > > Author: Javier Martinez Canillas <javier@osg.samsung.com>
> > > Date:   Fri Dec 11 20:57:08 2015 -0200
> > > 
> > >     [media] media-device: split media initialization and registration
> > > 
> > > Not sure what went wrong here.
> > 
> > It was my forgetting to test with !CONFIG_MEDIA_CONTROLLER...
> > 
> > Anyways, I've already posted a fix for this:
> > 
> > https://lkml.org/lkml/2015/12/21/224
> 
> Thank you for the fix.
> 
> I know this is an unpopular request, but can't we make this MC rework series 
> bisectable ? We're introducing bugs, which is unavoidable given the scope of 
> the change, and I'm really worried about how difficult we'll make it to debug 
> them if we keep piling even compilation fixes on top.
> 
> I can spend a day this week rebasing the patches myself if that could help.

Laurent,

The problem is that those patches got merged already at media_tree,
at the media-controller topic branch.

Any rebase there will break the git copies from all developers that are
based on it. It will also break the trees at linuxtv.org, since the
developer trees share objects with media_tree.git, in order to save
space on the servers.

What we could try to do is to fold them just before sending the pull
request upstream, as we're using tags for pull requests.

I'll do that during the merge window, if someone reminds me about
what patches should be fold. I guess there are only two or three
patches to be fold, as the only compilation breakages I'm aware are
the ones related to Javier's patch series that broke media_device
init from the media devnode creation.

Regards,
Mauro
