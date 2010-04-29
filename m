Return-path: <linux-media-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:47926 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758706Ab0D3R2f (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Apr 2010 13:28:35 -0400
Date: Thu, 29 Apr 2010 00:32:10 -0700
From: Greg KH <greg@kroah.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
	robert.lukassen@tomtom.com
Subject: Re: [RFC 0/2] UVC gadget driver
Message-ID: <20100429073210.GA9462@kroah.com>
References: <1272495179-2652-1-git-send-email-laurent.pinchart@ideasonboard.com> <20100429034111.GA16573@kroah.com> <201004290914.04140.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004290914.04140.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 29, 2010 at 09:14:03AM +0200, Laurent Pinchart wrote:
> Hi Greg,
> 
> On Thursday 29 April 2010 05:41:11 Greg KH wrote:
> > On Thu, Apr 29, 2010 at 12:52:57AM +0200, Laurent Pinchart wrote:
> > > Hi everybody,
> > > 
> > > Here's a new version of the UVC gadget driver I posted on the list some
> > > time ago, rebased on 2.6.34-rc5.
> > > 
> > > The private events API has been replaced by the new V4L2 events API that
> > > will be available in 2.6.34 (the code is already available in the
> > > v4l-dvb tree on linuxtv.org, and should be pushed to
> > > git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-next.git very
> > > soon).
> > > 
> > > Further testing of the changes related to the events API is required
> > > (this is planned for the next few days). As it seems to be the UVC
> > > gadget driver season (Robert Lukassen posted his own implementation -
> > > having a different goal - two days ago)
> > 
> > What are the different goals here?  Shouldn't there just be only one way
> > to implement this, or am I missing something?
> 
> Both drivers act as "webcams". Robert's version exports the local frame buffer 
> through USB, making the "webcam" capture what's displayed on the device. My 
> version exposes a V4L2 interface to userspace, allowing an application on the 
> device to send whatever it wants over USB (for instance frames captured from a 
> sensor, making the device a real camera).

Ah.  So your's has the advantage of being able to do what his does as
well, right?

> > > , I thought I'd post the patch as an RFC. I'd like the UVC function
> > > driver to make it to 2.6.35, comments are more than welcome.
> > 
> > It needs to get into my tree _now_ if you are wanting it in .35....
> > Just fyi.
> 
> Does now mean today, or before next week ?

Before next week would be good, as soon as possible is best.

thanks,

greg k-h
