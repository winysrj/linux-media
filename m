Return-path: <linux-media-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:47308 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754247Ab0D2Dkx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Apr 2010 23:40:53 -0400
Date: Wed, 28 Apr 2010 20:41:11 -0700
From: Greg KH <greg@kroah.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
	robert.lukassen@tomtom.com
Subject: Re: [RFC 0/2] UVC gadget driver
Message-ID: <20100429034111.GA16573@kroah.com>
References: <1272495179-2652-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272495179-2652-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 29, 2010 at 12:52:57AM +0200, Laurent Pinchart wrote:
> Hi everybody,
> 
> Here's a new version of the UVC gadget driver I posted on the list some time
> ago, rebased on 2.6.34-rc5.
> 
> The private events API has been replaced by the new V4L2 events API that will
> be available in 2.6.34 (the code is already available in the v4l-dvb tree on
> linuxtv.org, and should be pushed to
> git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-next.git very
> soon).
> 
> Further testing of the changes related to the events API is required (this is
> planned for the next few days). As it seems to be the UVC gadget driver season
> (Robert Lukassen posted his own implementation - having a different goal - two
> days ago)

What are the different goals here?  Shouldn't there just be only one way
to implement this, or am I missing something?

> , I thought I'd post the patch as an RFC. I'd like the UVC function
> driver to make it to 2.6.35, comments are more than welcome.

It needs to get into my tree _now_ if you are wanting it in .35....
Just fyi.

thanks,

greg k-h
