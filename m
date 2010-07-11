Return-path: <linux-media-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:46209 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272Ab0GKDYm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Jul 2010 23:24:42 -0400
Date: Sat, 10 Jul 2010 20:24:28 -0700
From: Greg KH <greg@kroah.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	sfr@canb.auug.org.au
Subject: Re: [PATCH FOR 2.6.36] uvc: Move constants and structures
	definitions to linux/usb/video.h
Message-ID: <20100711032428.GB28009@kroah.com>
References: <1278785000-8980-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278785000-8980-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jul 10, 2010 at 08:03:20PM +0200, Laurent Pinchart wrote:
> The UVC host and gadget drivers both define constants and structures in
> private header files. Move all those definitions to linux/usb/video.h
> where they can be shared by the two drivers (and be available for
> userspace applications).
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Mauro, please take this one, feel free to add:
	Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

to it as well.

Let me know when it hits your tree, so I know to drop it from mine.

thanks,

greg k-h
