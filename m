Return-path: <mchehab@pedra>
Received: from kroah.org ([198.145.64.141]:48436 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755604Ab0IPSpp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Sep 2010 14:45:45 -0400
Date: Thu, 16 Sep 2010 11:45:30 -0700
From: Greg KH <greg@kroah.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
	linux-usb@vger.kernel.org
Subject: Re: [PATCH] uvc: Enable USB autosuspend by default on uvcvideo
Message-ID: <20100916184530.GB8803@kroah.com>
References: <1284660004-28158-1-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284660004-28158-1-git-send-email-mjg@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Sep 16, 2010 at 02:00:04PM -0400, Matthew Garrett wrote:
> We've been doing this for a while in Fedora without any complaints.

No complaints probably, but does it actually do anything?  Last time I
measured, it didn't, but that was in the .31 kernel days.

thanks,

greg k-h
