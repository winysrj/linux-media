Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:44522 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932848Ab0D3R0V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Apr 2010 13:26:21 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Greg KH <greg@kroah.com>
Subject: Re: [RFC 0/2] UVC gadget driver
Date: Thu, 29 Apr 2010 09:34:50 +0200
Cc: linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
	robert.lukassen@tomtom.com
References: <1272495179-2652-1-git-send-email-laurent.pinchart@ideasonboard.com> <201004290914.04140.laurent.pinchart@ideasonboard.com> <20100429073210.GA9462@kroah.com>
In-Reply-To: <20100429073210.GA9462@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004290934.50743.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Greg,

On Thursday 29 April 2010 09:32:10 Greg KH wrote:
> On Thu, Apr 29, 2010 at 09:14:03AM +0200, Laurent Pinchart wrote:
> > On Thursday 29 April 2010 05:41:11 Greg KH wrote:
> > > On Thu, Apr 29, 2010 at 12:52:57AM +0200, Laurent Pinchart wrote:
> > > > Hi everybody,
> > > > 
> > > > Here's a new version of the UVC gadget driver I posted on the list
> > > > some time ago, rebased on 2.6.34-rc5.
> > > > 
> > > > The private events API has been replaced by the new V4L2 events API
> > > > that will be available in 2.6.34 (the code is already available in
> > > > the v4l-dvb tree on linuxtv.org, and should be pushed to
> > > > git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-next.git
> > > > very soon).
> > > > 
> > > > Further testing of the changes related to the events API is required
> > > > (this is planned for the next few days). As it seems to be the UVC
> > > > gadget driver season (Robert Lukassen posted his own implementation -
> > > > having a different goal - two days ago)
> > > 
> > > What are the different goals here?  Shouldn't there just be only one
> > > way to implement this, or am I missing something?
> > 
> > Both drivers act as "webcams". Robert's version exports the local frame
> > buffer through USB, making the "webcam" capture what's displayed on the
> > device. My version exposes a V4L2 interface to userspace, allowing an
> > application on the device to send whatever it wants over USB (for
> > instance frames captured from a sensor, making the device a real
> > camera).
> 
> Ah.  So your's has the advantage of being able to do what his does as
> well, right?

I think so (although I'm not sure if a userspace application can capture the 
content of the frame buffer on sync events).

> > > > , I thought I'd post the patch as an RFC. I'd like the UVC function
> > > > driver to make it to 2.6.35, comments are more than welcome.
> > > 
> > > It needs to get into my tree _now_ if you are wanting it in .35....
> > > Just fyi.
> > 
> > Does now mean today, or before next week ?
> 
> Before next week would be good, as soon as possible is best.

I'd like to test the events API changes some more. I'll have time to do this 
before next week.

-- 
Regards,

Laurent Pinchart
