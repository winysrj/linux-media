Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53599 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759443Ab3DYWz4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Apr 2013 18:55:56 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Pierre ANTOINE <nunux@free.fr>
Cc: linux-media@vger.kernel.org
Subject: Re: uvcvideo: Trying to lower the URB buffers on eMPIA minicam
Date: Fri, 26 Apr 2013 00:55:56 +0200
Message-ID: <2280626.yDrB0LeJ3D@avalon>
In-Reply-To: <1366917228.5179806c5f343@imp.free.fr>
References: <1366843673.51786119b3ced@imp.free.fr> <2682572.gZg9L6lqOg@avalon> <1366917228.5179806c5f343@imp.free.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pierre,

On Thursday 25 April 2013 21:13:48 Pierre ANTOINE wrote:
> Selon Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> > Just for my records, could you please repost the 'lsusb -v -d eb1a:299f'
> > output running as root ? The string descriptors are not displayed
> > otherwise.
> 
> Hi Laurent,
> 
> Please find the requested informations as root.

Thank you. I'll update the supported devices list on the uvcvideo website. 
Could you please give me the exact model name of the camera ?

> Where do you think I can try to hack the bandwidth size ?
> 
> Something like: source/drivers/usb/core/config.c usb_parse_endpoint() ?

Yes, that looks good. Just make sure you only hack the endpoint bandwidth for 
the webcam and not for the other USB devices.

-- 
Regards,

Laurent Pinchart

