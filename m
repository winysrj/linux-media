Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:57748 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472Ab0ECVRx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 May 2010 17:17:53 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 1/2] USB gadget: video class function driver
Date: Mon, 3 May 2010 23:17:59 +0200
Cc: Viral Mehta <Viral.Mehta@lntinfotech.com>,
	"linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"robert.lukassen@tomtom.com" <robert.lukassen@tomtom.com>
References: <1272826662-8279-1-git-send-email-laurent.pinchart@ideasonboard.com> <201005031430.00428.laurent.pinchart@ideasonboard.com> <20100503171548.GA11151@kroah.com>
In-Reply-To: <20100503171548.GA11151@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005032318.02588.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Greg,

On Monday 03 May 2010 19:15:48 Greg KH wrote:
> On Mon, May 03, 2010 at 02:29:57PM +0200, Laurent Pinchart wrote:
> > On Monday 03 May 2010 13:14:11 Viral Mehta wrote:
> > > Hi,
> > > 
> > > >This USB video class function driver implements a video capture device
> > > >from the host's point of view. It creates a V4L2 output device on the
> > > >gadget's side to transfer data from a userspace application over USB.
> > > >
> > > >The UVC-specific descriptors are passed by the gadget driver to the
> > > >UVC function driver, making them completely configurable without any
> > > >modification to the function's driver code.
> > > 
> > > I wanted to test this code. I git cloned[1] tree. It has
> > > v4l2-event.[c,h] and so I assume that now this tree has support for
> > > v4l2 event code.
> > > 
> > > But, while compilation, I am getting this error.
> > > [root@viral linux-next]# make uImage > /dev/null && make modules
> > > 
> > >   CHK     include/linux/version.h
> > >   CHK     include/generated/utsrelease.h
> > > 
> > > make[1]: `include/generated/mach-types.h' is up to date.
> > > 
> > >   CALL    scripts/checksyscalls.sh
> > >   Building modules, stage 2.
> > >   MODPOST 5 modules
> > > 
> > > ERROR: "v4l2_event_dequeue" [drivers/usb/gadget/g_webcam.ko] undefined!
> > > ERROR: "v4l2_event_init" [drivers/usb/gadget/g_webcam.ko] undefined!
> > > make[1]: *** [__modpost] Error 1
> > > make: *** [modules] Error 2
> > > 
> > > And by looking at the code, those symbols are not exported and thus the
> > > error is obvious. Can you please point me out where to take v4l2-event
> > > code? I tried to look for on linuxtv.org but was not able to locate the
> > > right code.
> > > 
> > > [1]git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-next.git
> > 
> > There's a patch pending on the linux-media list to export those two
> > functions. It has been acked by Sakari (the author of the V4L2 events
> > patch set), but not committed by Mauro to his linux-next yet. That
> > should be a matter of days.
> 
> Do you have a pointer to that patch?  I'll take it into my usb tree for
> now, to keep things building, and let Mauro send it to Linus for
> merging.

Sure

https://patchwork.kernel.org/patch/96373/

But please note it requires the V4L2 events patch set from Mauro's linux-next 
tree.

-- 
Regards,

Laurent Pinchart
