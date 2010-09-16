Return-path: <mchehab@pedra>
Received: from kroah.org ([198.145.64.141]:50492 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755975Ab0IPTav (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Sep 2010 15:30:51 -0400
Date: Thu, 16 Sep 2010 12:08:13 -0700
From: Greg KH <greg@kroah.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
	linux-usb@vger.kernel.org
Subject: Re: [PATCH] uvc: Enable USB autosuspend by default on uvcvideo
Message-ID: <20100916190813.GA9451@kroah.com>
References: <1284660004-28158-1-git-send-email-mjg@redhat.com>
 <20100916184530.GB8803@kroah.com>
 <20100916185317.GA19955@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100916185317.GA19955@srcf.ucam.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Sep 16, 2010 at 07:53:18PM +0100, Matthew Garrett wrote:
> On Thu, Sep 16, 2010 at 11:45:30AM -0700, Greg KH wrote:
> > On Thu, Sep 16, 2010 at 02:00:04PM -0400, Matthew Garrett wrote:
> > > We've been doing this for a while in Fedora without any complaints.
> > 
> > No complaints probably, but does it actually do anything?  Last time I
> > measured, it didn't, but that was in the .31 kernel days.
> 
> It's necessary if you want to be able to do runtime PCI power management 
> on the HCD.

Ok, fair enough, no objection from me.

thanks,

greg k-h
