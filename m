Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f49.google.com ([209.85.219.49]:35503 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbaDOCHO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Apr 2014 22:07:14 -0400
Received: by mail-oa0-f49.google.com with SMTP id o6so10081359oag.36
        for <linux-media@vger.kernel.org>; Mon, 14 Apr 2014 19:07:14 -0700 (PDT)
Date: Mon, 14 Apr 2014 21:07:12 -0500 (CDT)
From: Thomas Pugliese <thomas.pugliese@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Thomas Pugliese <thomas.pugliese@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] uvc: update uvc_endpoint_max_bpi to handle USB_SPEED_WIRELESS
 devices
In-Reply-To: <14957224.mkfABmkaAb@avalon>
Message-ID: <alpine.DEB.2.10.1404142054390.22542@bitbucket>
References: <1390598248-343-1-git-send-email-thomas.pugliese@gmail.com> <8041079.da1zLPkO88@avalon> <alpine.DEB.2.10.1401270927410.16196@mint32-virtualbox> <14957224.mkfABmkaAb@avalon>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Mon, 27 Jan 2014, Laurent Pinchart wrote:

> Hi Thomas,
> 
> On Monday 27 January 2014 09:54:58 Thomas Pugliese wrote:
> > On Mon, 27 Jan 2014, Laurent Pinchart wrote:
> > > On Friday 24 January 2014 15:17:28 Thomas Pugliese wrote:
> > > > Isochronous endpoints on devices with speed == USB_SPEED_WIRELESS can
> > > > have a max packet size ranging from 1-3584 bytes.  Add a case to
> > > > uvc_endpoint_max_bpi to handle USB_SPEED_WIRELESS.  Otherwise endpoints
> > > > for those devices will fall to the default case which masks off any
> > > > values > 2047.  This causes uvc_init_video to underestimate the
> > > > bandwidth available and fail to find a suitable alt setting for high
> > > > bandwidth video streams.
> > > 
> > > I'm not too familiar with wireless USB, but shouldn't the value be
> > > multiplied by bMaxBurst from the endpoint companion descriptor ?
> > > Superspeed devices provide the multiplied value in their endpoint
> > > companion descriptor's wBytesPerInterval field, but there's no such field
> > > for wireless devices.
> >
> > For wireless USB isochronous endpoints, the values in the endpoint
> > descriptor are the logical interval and max packet size that the endpoint
> > can support.  They are provided for backwards compatibility for just this
> > type of situation.  You are correct that the actual endpoint
> > characteristics are the bMaxBurst, wOverTheAirPacketSize, and
> > bOverTheAirInterval values from the WUSB endpoint companion descriptor but
> > only the host controller really needs to know about those details.  In
> > fact, the values from the endpoint companion descriptor might actually
> > over-estimate the bandwidth available since the device can set bMaxBurst
> > to a higher value than necessary to allow for retries.
> 
> OK, I'll trust you on that :-)
> 
> I've taken the patch in my tree and will send a pull request for v3.15.
> 
> > > Out of curiosity, which device have you tested this with ?
> > 
> > The device is a standard wired UVC webcam: Quanta CQEC2B (VID: 0x0408,
> > PID: 0x9005).  It is connected to an Alereon Wireless USB bridge dev kit
> > which allows it to operate as a WUSB device.
> > 
> > Thomas
> > 
> > > > Signed-off-by: Thomas Pugliese <thomas.pugliese@gmail.com>
> > > > ---
> > > > 
> > > >  drivers/media/usb/uvc/uvc_video.c | 3 +++
> > > >  1 file changed, 3 insertions(+)
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 
> 

So it turns out that this change (commit 79af67e77f86404e77e65ad954bf) 
breaks wireless USB devices that were designed to work with Windows 
because Windows also does not differentiate between Wireless USB devices 
and USB 2.0 high speed devices.  This change should probably be reverted 
before it goes out in the 3.15 release.  Devices that are strictly WUSB 
spec compliant will not work with some max packet sizes but they never did 
anyway.

In order to support both compliant and non-compliant WUSB devices, 
uvc_endpoint_max_bpi should look at the endpoint companion descriptor but 
that descriptor is not readily available as it is for super speed devices 
so that patch will have to wait for another time.

Thanks,
Thomas
