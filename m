Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41305 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbaDQV7T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Apr 2014 17:59:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Thomas Pugliese <thomas.pugliese@gmail.com>
Cc: linux-media@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] uvc: update uvc_endpoint_max_bpi to handle USB_SPEED_WIRELESS devices
Date: Thu, 17 Apr 2014 23:59:22 +0200
Message-ID: <13572613.UXhodzMO7U@avalon>
In-Reply-To: <alpine.DEB.2.10.1404170949070.8990@mint32-virtualbox>
References: <1390598248-343-1-git-send-email-thomas.pugliese@gmail.com> <18912543.lQLItvHSYH@avalon> <alpine.DEB.2.10.1404170949070.8990@mint32-virtualbox>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Thomas,

On Thursday 17 April 2014 09:53:32 Thomas Pugliese wrote:
> On Thu, 17 Apr 2014, Laurent Pinchart wrote:
> > On Wednesday 16 April 2014 12:29:22 Thomas Pugliese wrote:

[snip]

> > > As you had mentioned previously, it should be possible to support both
> > > formats by ignoring the endpoint descriptor and looking at the
> > > bMaxBurst, bOverTheAirInterval and wOverTheAirPacketSize fields in the
> > > WUSB endpoint companion descriptor.  That is a more involved change to
> > > the UVC driver and also would require changes to USB core to store the
> > > WUSB endpoint companion descriptor in struct usb_host_endpoint similar
> > > to what is done for super speed devices.
> > 
> > It's more complex indeed, but I believe it would be worth it. Any
> > volunteer ? ;-) In the meantime I'm fine with a patch that reverts to the
> > previous behaviour. Please include the explanation of the problem in the
> > commit message.
> 
> I may make an attempt at the more complete fix once I finish some of the
> other items in my queue.
> 
> For clarification, would you like a patch that reverts to the pre-super
> speed behavior where windows-compatible devices work not but spec
> compliant devices will not (i.e. treat USB_SPEED_HIGH and
> USB_SPEED_WIRELESS the same)?

I'll trust your judgment on that, if you believe it would be better from a 
user point of view, please send a patch. Otherwise we can wait until you find 
time to work on a proper fix.

-- 
Regards,

Laurent Pinchart

