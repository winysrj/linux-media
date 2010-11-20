Return-path: <mchehab@gaivota>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22088 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755605Ab0KTXvr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Nov 2010 18:51:47 -0500
From: "Shuzhen Wang" <shuzhenw@codeaurora.org>
To: "'Laurent Pinchart'" <laurent.pinchart@ideasonboard.com>
Cc: <linux-media@vger.kernel.org>
References: <000001cb883f$ec4e4220$c4eac660$@org> <201011201837.18832.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201011201837.18832.laurent.pinchart@ideasonboard.com>
Subject: RE: Zooming with V4L2
Date: Sat, 20 Nov 2010 15:50:59 -0800
Message-ID: <000001cb890d$c870ffe0$5952ffa0$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Content-Language: en-us
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hello, Laurent,

Thank you for the reply.

In our case, most of the time the sensor outputs bigger image size than the
output size, so the ISP hardware does downscaling.
When zooming in, we can do cropping, and less downscaling to achieve the
same output size. All these happen under of the hood of ISP driver.
That's why I said it was like optical zoom to the application.

So if "digital zoom == cropping and upscaling", then I don't think my case
fits in digital zoom category.

Regards,
Shuzhen

-----Original Message-----
From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com] 
Sent: Saturday, November 20, 2010 9:37 AM
To: Shuzhen Wang
Cc: linux-media@vger.kernel.org
Subject: Re: Zooming with V4L2

Hi Shuzhen,

On Saturday 20 November 2010 00:17:23 Shuzhen Wang wrote:
> Hello,
> 
> I am working on a SOC V4L2 driver, and need to implement zoom
> functionality.
> 
> From application, there are 2 ways to do zooming. The 1st way is to use
> cropping and scaling as described in section 1.11.1. The application needs
> to figure out what the steps will be, and calling VIDIOC_S_CROP.
> 
> The 2nd way is to use V4L2_CID_ZOOM_ABSOLUTE and V4L2_CID_ZOOM_RELATIVE as
> described by Laurent in
> http://video4linux-list.1448896.n2.nabble.com/RFC-Zoom-controls-in-V4L2-
td1451987.html.
> 
> Our camera hardware supports digital zoom. However, it acts LIKE optical
> zoom because it doesn't do upscaling, so no video quality is sacrificed.

How can you apply a digital zoom, keeping the output size constant, without 
performing upscaling ?

> As a driver writter, is it okay to support only V4L2_CID_ZOOM_ABSOLUTE and
> V4L2_CID_ZOOM_RELATIVE?
> 
> I guess it also depends on how zooming is done for most of the V4L2 user
> application out there.

The V4L2_CID_ZOOM_* controls are really meant for optical zoom. Digital zoom

should be implemented using cropping.

-- 
Regards,

Laurent Pinchart

