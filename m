Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52284 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbbLVSGk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Dec 2015 13:06:40 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: next-20151222 - compile failure in drivers/media/usb/uvc/uvc_driver.c
Date: Tue, 22 Dec 2015 20:06:38 +0200
Message-ID: <1975883.EPhFUU4nET@avalon>
In-Reply-To: <567944CB.4070505@osg.samsung.com>
References: <75073.1450779516@turing-police.cc.vt.edu> <567944CB.4070505@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

On Tuesday 22 December 2015 09:40:43 Javier Martinez Canillas wrote:
> On 12/22/2015 07:18 AM, Valdis Kletnieks wrote:
> > next-20151222 fails to build for me:
> >   CC      drivers/media/usb/uvc/uvc_driver.o
> > 
> > drivers/media/usb/uvc/uvc_driver.c: In function 'uvc_probe':
> > drivers/media/usb/uvc/uvc_driver.c:1941:32: error: 'struct uvc_device' has
> > no member named 'mdev'> 
> >   if (media_device_register(&dev->mdev) < 0)
> >                                 ^
> > 
> > scripts/Makefile.build:258: recipe for target
> > 'drivers/media/usb/uvc/uvc_driver.o' failed
> > 
> > 'git blame' points at that line being added in:
> > 
> > commit 1590ad7b52714fddc958189103c95541b49b1dae
> > Author: Javier Martinez Canillas <javier@osg.samsung.com>
> > Date:   Fri Dec 11 20:57:08 2015 -0200
> > 
> >     [media] media-device: split media initialization and registration
> > 
> > Not sure what went wrong here.
> 
> It was my forgetting to test with !CONFIG_MEDIA_CONTROLLER...
> 
> Anyways, I've already posted a fix for this:
> 
> https://lkml.org/lkml/2015/12/21/224

Thank you for the fix.

I know this is an unpopular request, but can't we make this MC rework series 
bisectable ? We're introducing bugs, which is unavoidable given the scope of 
the change, and I'm really worried about how difficult we'll make it to debug 
them if we keep piling even compilation fixes on top.

I can spend a day this week rebasing the patches myself if that could help.

-- 
Regards,

Laurent Pinchart

