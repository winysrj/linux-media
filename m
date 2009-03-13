Return-path: <linux-media-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.240]:2424 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbZCMTrH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2009 15:47:07 -0400
Date: Fri, 13 Mar 2009 12:46:47 -0700
From: Brandon Philips <brandon@ifup.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <gregkh@suse.de>, laurent.pinchart@skynet.be,
	linux-media@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: S4 hang with uvcvideo causing "Unlink after no-IRQ? Controller
	is probably using the wrong IRQ."
Message-ID: <20090313194647.GC21008@jenkins.ifup.org>
References: <20090313154058.GB14186@jenkins.ifup.org> <Pine.LNX.4.44L0.0903131402050.2898-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0903131402050.2898-100000@iolanthe.rowland.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 14:03 Fri 13 Mar 2009, Alan Stern wrote:
> On Fri, 13 Mar 2009, Brandon Philips wrote:
> 
> > > Okay, not much information there but it's a start.  Here's a more 
> > > informative patch to try instead.
> > 
> > Here is the log:
> >  http://ifup.org/~philips/467317/pearl-alan-debug-2.log
> 
> I still can't tell what's happening.  Here's yet another patch.

http://ifup.org/~philips/467317/pearl-alan-debug-3.log

Thanks, Brandon
