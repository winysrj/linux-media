Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:50234 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758011Ab3DZA4f (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Apr 2013 20:56:35 -0400
Message-ID: <1366937783.5179d0b7b4993@imp.free.fr>
Date: Fri, 26 Apr 2013 02:56:23 +0200
From: Pierre ANTOINE <nunux@free.fr>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: uvcvideo: Trying to lower the URB buffers on eMPIA minicam
References: <1366843673.51786119b3ced@imp.free.fr> <2280626.yDrB0LeJ3D@avalon> <1366934628.5179c4650033f@imp.free.fr> <1880069.7yVprJ14P8@avalon>
In-Reply-To: <1880069.7yVprJ14P8@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent,

I finally did it !

On usbcore, I correct the bandwidth of endpoint 4 from 912 to 1024.

maxp = usb_endpoint_maxp(&endpoint->desc) & 0x07ff;
if (maxp == 912) endpoint->desc.wMaxPacketSize = cpu_to_le16(1024);

On uvcvideo:
I set: 768 B/frame bandwidth
I use endpoint alt-setting 4 by disabling some checking code.
And I get uvcvideo: Allocated 5 URB buffers of 32x1024 bytes each.

So I can run the 4 cam on the same USB card:

gst-launch v4l2src device=/dev/video0 !
'video/x-raw-yuv,width=160,height=120,framerate=30/1' ! xvimagesink
gst-launch v4l2src device=/dev/video1 !
'video/x-raw-yuv,width=160,height=120,framerate=30/1' ! xvimagesink
gst-launch v4l2src device=/dev/video2 !
'video/x-raw-yuv,width=160,height=120,framerate=30/1' ! xvimagesink
gst-launch v4l2src device=/dev/video3 !
'video/x-raw-yuv,width=160,height=120,framerate=30/1' ! xvimagesink

I will try to do it less dirty next week ...

Thank's a lot for pointing me on usbcore ...

Many regards,

Pierre

Selon Laurent Pinchart <laurent.pinchart@ideasonboard.com>:

> lsusb parses the raw descriptors. Could you print the wMaxPacketSize value
> for all the endpoints in the uvcvideo driver ? The value is also exported
through
> a sysfs attribute.
>
> --
> Regards,
>
> Laurent Pinchart
>
>
