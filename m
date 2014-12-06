Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55356 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbaLFAhR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Dec 2014 19:37:17 -0500
Date: Fri, 5 Dec 2014 16:37:16 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>,
	Felipe Balbi <balbi@ti.com>,
	Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH] usb: hcd: get/put device and hcd for hcd_buffers()
Message-ID: <20141206003716.GB3376@kroah.com>
References: <20141205200357.GA1586@linutronix.de>
 <20141205211932.GA24249@kroah.com>
 <20141205231313.GA4854@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141205231313.GA4854@linutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Dec 06, 2014 at 12:13:13AM +0100, Sebastian Andrzej Siewior wrote:
> * Greg Kroah-Hartman | 2014-12-05 13:19:32 [-0800]:
> 
> >On Fri, Dec 05, 2014 at 09:03:57PM +0100, Sebastian Andrzej Siewior wrote:
> >> Consider the following scenario:
> >> - plugin a webcam
> >> - play the stream via gst-launch-0.10 v4l2src device=/dev/video0…
> >> - remove the USB-HCD during playback via "rmmod $HCD"
> >> 
> >> and now wait for the crash
> >
> >Which you deserve, why did you ever remove a kernel module?  That's racy
> its been found by the testing team and looks legitimate.
> 
> >and _never_ recommended, which is why it never happens automatically and
> >only root can do it.
> I beg your pardon. So it is okay to remove the UVC-driver / plug the
> cable and expect that things continue to work but removing the HCD is a
> no no?

If you hot unplug the HCD and this is an issue, yes, that's something to
fix.  If you can only trigger this by unloading a kernel module, no,
it's not a big issue at all.  It's pretty trivial to cause kernel oopses
by unloading kernel modules if you know what you are doing.

> >> diff --git a/drivers/usb/core/buffer.c b/drivers/usb/core/buffer.c
> >> index 506b969ea7fd..01e080a61519 100644
> >> --- a/drivers/usb/core/buffer.c
> >> +++ b/drivers/usb/core/buffer.c
> >> @@ -107,7 +107,7 @@ void hcd_buffer_destroy(struct usb_hcd *hcd)
> >>   * better sharing and to leverage mm/slab.c intelligence.
> >>   */
> >>  
> >> -void *hcd_buffer_alloc(
> >> +static void *_hcd_buffer_alloc(
> >
> >Looks like this isn't really needed here, right?
> 
> either this or I would have the tree callers if the allocation succeded
> or not in order not to take a reference if the allocation failed.

My point is this isn't needed for this patch.

greg k-h
