Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54100 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758830Ab3DZAl6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Apr 2013 20:41:58 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Pierre ANTOINE <nunux@free.fr>
Cc: linux-media@vger.kernel.org
Subject: Re: uvcvideo: Trying to lower the URB buffers on eMPIA minicam
Date: Fri, 26 Apr 2013 02:41:58 +0200
Message-ID: <1880069.7yVprJ14P8@avalon>
In-Reply-To: <1366934628.5179c4650033f@imp.free.fr>
References: <1366843673.51786119b3ced@imp.free.fr> <2280626.yDrB0LeJ3D@avalon> <1366934628.5179c4650033f@imp.free.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pierre,

On Friday 26 April 2013 02:03:49 Pierre ANTOINE wrote:
> Selon Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> > Thank you. I'll update the supported devices list on the uvcvideo website.
> > Could you please give me the exact model name of the camera ?
> 
> The product description is here:
> 
> http://www.amazon.fr/dp/B00A487TPC/ref=pe_205631_30430471_3p_M3_dp_1
> 
> That is: Supereyes from XCSource know on Amazon as Microscope USB Cam.

Thank you.

> > Yes, that looks good. Just make sure you only hack the endpoint bandwidth
> > for the webcam and not for the other USB devices.
> 
> I'm trying this one:
> 
> ---------------------------------------
>         if (to_usb_device(ddev)->speed == USB_SPEED_HIGH)
>         {
>                 unsigned maxp;
> 
>                 maxp = usb_endpoint_maxp(&endpoint->desc) & 0x07ff;
>                 if (maxp == 912) endpoint->desc.wMaxPacketSize =
> cpu_to_le16(256);
>                 dev_warn(ddev, "Hack 912 to 256 downsize endpoint by
> Nunux"); }
> ---------------------------------------
> 
> That seem to trigger ... but not working ... and not showing is lsusb ...

lsusb parses the raw descriptors. Could you print the wMaxPacketSize value for 
all the endpoints in the uvcvideo driver ? The value is also exported through 
a sysfs attribute.

-- 
Regards,

Laurent Pinchart

