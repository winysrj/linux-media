Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52334 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbaDOPQb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Apr 2014 11:16:31 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Thomas Pugliese <thomas.pugliese@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] uvc: update uvc_endpoint_max_bpi to handle USB_SPEED_WIRELESS devices
Date: Tue, 15 Apr 2014 17:16:32 +0200
Message-ID: <1483439.ESi3RcYlPK@avalon>
In-Reply-To: <alpine.DEB.2.10.1404142054390.22542@bitbucket>
References: <1390598248-343-1-git-send-email-thomas.pugliese@gmail.com> <14957224.mkfABmkaAb@avalon> <alpine.DEB.2.10.1404142054390.22542@bitbucket>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Thomas,

On Monday 14 April 2014 21:07:12 Thomas Pugliese wrote:
> On Mon, 27 Jan 2014, Laurent Pinchart wrote:
> > On Monday 27 January 2014 09:54:58 Thomas Pugliese wrote:
> > > On Mon, 27 Jan 2014, Laurent Pinchart wrote:
> > > > On Friday 24 January 2014 15:17:28 Thomas Pugliese wrote:
> > > > > Isochronous endpoints on devices with speed == USB_SPEED_WIRELESS
> > > > > can have a max packet size ranging from 1-3584 bytes. Add a case to
> > > > > uvc_endpoint_max_bpi to handle USB_SPEED_WIRELESS. Otherwise
> > > > > endpoints for those devices will fall to the default case which
> > > > > masks off any values > 2047. This causes uvc_init_video to
> > > > > underestimate the bandwidth available and fail to find a suitable
> > > > > alt setting for high bandwidth video streams.
> > > > 
> > > > I'm not too familiar with wireless USB, but shouldn't the value be
> > > > multiplied by bMaxBurst from the endpoint companion descriptor ?
> > > > Superspeed devices provide the multiplied value in their endpoint
> > > > companion descriptor's wBytesPerInterval field, but there's no such
> > > > field for wireless devices.
> > > 
> > > For wireless USB isochronous endpoints, the values in the endpoint
> > > descriptor are the logical interval and max packet size that the
> > > endpoint can support. They are provided for backwards compatibility for
> > > just this type of situation. You are correct that the actual endpoint
> > > characteristics are the bMaxBurst, wOverTheAirPacketSize, and
> > > bOverTheAirInterval values from the WUSB endpoint companion descriptor
> > > but only the host controller really needs to know about those details. 
> > > In fact, the values from the endpoint companion descriptor might
> > > actually over-estimate the bandwidth available since the device can set
> > > bMaxBurst to a higher value than necessary to allow for retries.
> > 
> > OK, I'll trust you on that :-)
> > 
> > I've taken the patch in my tree and will send a pull request for v3.15.
> > 
> > > > Out of curiosity, which device have you tested this with ?
> > > 
> > > The device is a standard wired UVC webcam: Quanta CQEC2B (VID: 0x0408,
> > > PID: 0x9005).  It is connected to an Alereon Wireless USB bridge dev kit
> > > which allows it to operate as a WUSB device.
> > > 
> > > Thomas
> > > 
> > > > > Signed-off-by: Thomas Pugliese <thomas.pugliese@gmail.com>
> > > > > ---
> > > > > 
> > > > >  drivers/media/usb/uvc/uvc_video.c | 3 +++
> > > > >  1 file changed, 3 insertions(+)
> 
> So it turns out that this change (commit 79af67e77f86404e77e65ad954bf)
> breaks wireless USB devices that were designed to work with Windows
> because Windows also does not differentiate between Wireless USB devices
> and USB 2.0 high speed devices.  This change should probably be reverted
> before it goes out in the 3.15 release.  Devices that are strictly WUSB
> spec compliant will not work with some max packet sizes but they never did
> anyway.
> 
> In order to support both compliant and non-compliant WUSB devices,
> uvc_endpoint_max_bpi should look at the endpoint companion descriptor but
> that descriptor is not readily available as it is for super speed devices
> so that patch will have to wait for another time.

Could you please send me a proper revert patch with the above description in 
the commit message and CC Mauro Carvalho Chehab <m.chehab@samsung.com> ?

-- 
Regards,

Laurent Pinchart

