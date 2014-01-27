Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52109 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbaA0Vs5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jan 2014 16:48:57 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Thomas Pugliese <thomas.pugliese@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] uvc: update uvc_endpoint_max_bpi to handle USB_SPEED_WIRELESS devices
Date: Mon, 27 Jan 2014 22:49:46 +0100
Message-ID: <14957224.mkfABmkaAb@avalon>
In-Reply-To: <alpine.DEB.2.10.1401270927410.16196@mint32-virtualbox>
References: <1390598248-343-1-git-send-email-thomas.pugliese@gmail.com> <8041079.da1zLPkO88@avalon> <alpine.DEB.2.10.1401270927410.16196@mint32-virtualbox>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Thomas,

On Monday 27 January 2014 09:54:58 Thomas Pugliese wrote:
> On Mon, 27 Jan 2014, Laurent Pinchart wrote:
> > On Friday 24 January 2014 15:17:28 Thomas Pugliese wrote:
> > > Isochronous endpoints on devices with speed == USB_SPEED_WIRELESS can
> > > have a max packet size ranging from 1-3584 bytes.  Add a case to
> > > uvc_endpoint_max_bpi to handle USB_SPEED_WIRELESS.  Otherwise endpoints
> > > for those devices will fall to the default case which masks off any
> > > values > 2047.  This causes uvc_init_video to underestimate the
> > > bandwidth available and fail to find a suitable alt setting for high
> > > bandwidth video streams.
> > 
> > I'm not too familiar with wireless USB, but shouldn't the value be
> > multiplied by bMaxBurst from the endpoint companion descriptor ?
> > Superspeed devices provide the multiplied value in their endpoint
> > companion descriptor's wBytesPerInterval field, but there's no such field
> > for wireless devices.
>
> For wireless USB isochronous endpoints, the values in the endpoint
> descriptor are the logical interval and max packet size that the endpoint
> can support.  They are provided for backwards compatibility for just this
> type of situation.  You are correct that the actual endpoint
> characteristics are the bMaxBurst, wOverTheAirPacketSize, and
> bOverTheAirInterval values from the WUSB endpoint companion descriptor but
> only the host controller really needs to know about those details.  In
> fact, the values from the endpoint companion descriptor might actually
> over-estimate the bandwidth available since the device can set bMaxBurst
> to a higher value than necessary to allow for retries.

OK, I'll trust you on that :-)

I've taken the patch in my tree and will send a pull request for v3.15.

> > Out of curiosity, which device have you tested this with ?
> 
> The device is a standard wired UVC webcam: Quanta CQEC2B (VID: 0x0408,
> PID: 0x9005).  It is connected to an Alereon Wireless USB bridge dev kit
> which allows it to operate as a WUSB device.
> 
> Thomas
> 
> > > Signed-off-by: Thomas Pugliese <thomas.pugliese@gmail.com>
> > > ---
> > > 
> > >  drivers/media/usb/uvc/uvc_video.c | 3 +++
> > >  1 file changed, 3 insertions(+)

-- 
Regards,

Laurent Pinchart

