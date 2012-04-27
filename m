Return-path: <linux-media-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:35301 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760326Ab2D0SAJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Apr 2012 14:00:09 -0400
Date: Fri, 27 Apr 2012 11:00:07 -0700
From: Greg KH <greg@kroah.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-usb@vger.kernel.org,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: How do I detect if disconnect is called due to module removal?
Message-ID: <20120427180007.GA27310@kroah.com>
References: <201204271943.50706.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201204271943.50706.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 27, 2012 at 07:43:50PM +0200, Hans Verkuil wrote:
> Hi all,
> 
> I'm cleaning up some USB FM radio drivers and I realized that I need to know
> in the disconnect callback whether I'm called due to a module unload or due
> to an unplug event.

You shouldn't care.

> In the first case I need to first mute the audio output of the device, in the
> second case I can skip that.

Why?  The "mute" operation would just fail if the device isn't present,
no problem.

> I can just try and always mute the device but that results in a error message
> in the case the device is unplugged.

Then don't display that error message :)

> Is there a field I can test somewhere to detect what caused the disconnect?

No, sorry, you shouldn't really do anything different here the driver
does not know the difference, nor should it.

thanks,

greg k-h
