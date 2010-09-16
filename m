Return-path: <mchehab@pedra>
Received: from cavan.codon.org.uk ([93.93.128.6]:60902 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568Ab0IPSxZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Sep 2010 14:53:25 -0400
Date: Thu, 16 Sep 2010 19:53:18 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Greg KH <greg@kroah.com>
Cc: laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
	linux-usb@vger.kernel.org
Subject: Re: [PATCH] uvc: Enable USB autosuspend by default on uvcvideo
Message-ID: <20100916185317.GA19955@srcf.ucam.org>
References: <1284660004-28158-1-git-send-email-mjg@redhat.com> <20100916184530.GB8803@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100916184530.GB8803@kroah.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Sep 16, 2010 at 11:45:30AM -0700, Greg KH wrote:
> On Thu, Sep 16, 2010 at 02:00:04PM -0400, Matthew Garrett wrote:
> > We've been doing this for a while in Fedora without any complaints.
> 
> No complaints probably, but does it actually do anything?  Last time I
> measured, it didn't, but that was in the .31 kernel days.

It's necessary if you want to be able to do runtime PCI power management 
on the HCD.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
