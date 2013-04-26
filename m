Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp6-g21.free.fr ([212.27.42.6]:60705 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757199Ab3DZAD6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Apr 2013 20:03:58 -0400
Message-ID: <1366934628.5179c4650033f@imp.free.fr>
Date: Fri, 26 Apr 2013 02:03:49 +0200
From: Pierre ANTOINE <nunux@free.fr>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Pierre ANTOINE <nunux@free.fr>, linux-media@vger.kernel.org
Subject: Re: uvcvideo: Trying to lower the URB buffers on eMPIA minicam
References: <1366843673.51786119b3ced@imp.free.fr> <2682572.gZg9L6lqOg@avalon> <1366917228.5179806c5f343@imp.free.fr> <2280626.yDrB0LeJ3D@avalon>
In-Reply-To: <2280626.yDrB0LeJ3D@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Selon Laurent Pinchart <laurent.pinchart@ideasonboard.com>:

> Thank you. I'll update the supported devices list on the uvcvideo website.
> Could you please give me the exact model name of the camera ?

The product description is here:

http://www.amazon.fr/dp/B00A487TPC/ref=pe_205631_30430471_3p_M3_dp_1

That is: Supereyes from XCSource know on Amazon as Microscope USB Cam.

>
> Yes, that looks good. Just make sure you only hack the endpoint bandwidth for
> the webcam and not for the other USB devices.
>

I'm trying this one:

---------------------------------------
        if (to_usb_device(ddev)->speed == USB_SPEED_HIGH)
        {
                unsigned maxp;

                maxp = usb_endpoint_maxp(&endpoint->desc) & 0x07ff;
                if (maxp == 912) endpoint->desc.wMaxPacketSize =
cpu_to_le16(256);
                dev_warn(ddev, "Hack 912 to 256 downsize endpoint by Nunux");
        }
---------------------------------------

That seem to trigger ... but not working ... and not showing is lsusb ...



