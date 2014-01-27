Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f41.google.com ([209.85.219.41]:56803 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545AbaA0PzA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jan 2014 10:55:00 -0500
Received: by mail-oa0-f41.google.com with SMTP id j17so6888412oag.14
        for <linux-media@vger.kernel.org>; Mon, 27 Jan 2014 07:55:00 -0800 (PST)
Date: Mon, 27 Jan 2014 09:54:58 -0600 (CST)
From: Thomas Pugliese <thomas.pugliese@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Thomas Pugliese <thomas.pugliese@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] uvc: update uvc_endpoint_max_bpi to handle USB_SPEED_WIRELESS
 devices
In-Reply-To: <8041079.da1zLPkO88@avalon>
Message-ID: <alpine.DEB.2.10.1401270927410.16196@mint32-virtualbox>
References: <1390598248-343-1-git-send-email-thomas.pugliese@gmail.com> <8041079.da1zLPkO88@avalon>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Mon, 27 Jan 2014, Laurent Pinchart wrote:

> Hi Thomas,
> 
> Thank you for the patch.
> 
> On Friday 24 January 2014 15:17:28 Thomas Pugliese wrote:
> > Isochronous endpoints on devices with speed == USB_SPEED_WIRELESS can
> > have a max packet size ranging from 1-3584 bytes.  Add a case to
> > uvc_endpoint_max_bpi to handle USB_SPEED_WIRELESS.  Otherwise endpoints
> > for those devices will fall to the default case which masks off any
> > values > 2047.  This causes uvc_init_video to underestimate the
> > bandwidth available and fail to find a suitable alt setting for high
> > bandwidth video streams.
> 
> I'm not too familiar with wireless USB, but shouldn't the value be multiplied 
> by bMaxBurst from the endpoint companion descriptor ? Superspeed devices 
> provide the multiplied value in their endpoint companion descriptor's 
> wBytesPerInterval field, but there's no such field for wireless devices.
> 

For wireless USB isochronous endpoints, the values in the endpoint 
descriptor are the logical interval and max packet size that the endpoint 
can support.  They are provided for backwards compatibility for just this 
type of situation.  You are correct that the actual endpoint 
characteristics are the bMaxBurst, wOverTheAirPacketSize, and 
bOverTheAirInterval values from the WUSB endpoint companion descriptor but 
only the host controller really needs to know about those details.  In 
fact, the values from the endpoint companion descriptor might actually 
over-estimate the bandwidth available since the device can set bMaxBurst 
to a higher value than necessary to allow for retries.

> Out of curiosity, which device have you tested this with ?

The device is a standard wired UVC webcam: Quanta CQEC2B (VID: 0x0408, 
PID: 0x9005).  It is connected to an Alereon Wireless USB bridge dev kit 
which allows it to operate as a WUSB device.

Thomas

> 
> > Signed-off-by: Thomas Pugliese <thomas.pugliese@gmail.com>
> > ---
> >  drivers/media/usb/uvc/uvc_video.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 
> 
