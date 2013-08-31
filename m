Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42215 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997Ab3HaU2I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Aug 2013 16:28:08 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: purchase@utopiacontrol.com
Cc: linux-media@vger.kernel.org
Subject: Re: Fw: Memory acquisition problem with yavta and media control.
Date: Sat, 31 Aug 2013 22:29:34 +0200
Message-ID: <1475404.9MHgQaVtRD@avalon>
In-Reply-To: <F74E216C170F4219AAD7D7D3D5CDFF61@store>
References: <F74E216C170F4219AAD7D7D3D5CDFF61@store>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nilesh,

On Saturday 31 August 2013 10:07:14 purchase@utopiacontrol.com wrote:
> //=================================
> linux-media@vger.kernel.org
> laurent.pinchart@ideasonboard.com
> //=================================
> 
> Hi laurent pinchart,

Just Laurent will do :-)

> You have done a great work for snapshot mode image sensor driver for linux.
> I am using your media control tool with yavta test application for
> interfacing the mt9v032 image sensor with Gumstix Overo Water Com board. I
> have successfully tested the snapshot mode with this combination. But the
> problem is that, when I attempt to grab lots of images (thousands) of images
> by this test application yavta. I found that the free memory goes increasing
> by some amount which will not get free. Afterwards I have calculate the
> amount of ram acquires on every snap is about 0.618 KB (after averaging
> 100000 frames). Will you please Give me any reason why this is happening
> with this test application? And how can I get overcome on this problem.

That's definitely not expected and should be debugged. First of all, is the 
memory released when you stop yavta ? If it isn't then we have a kernel bug, 
if it is the bug could be either on the kernel side or the application side.

-- 
Regards,

Laurent Pinchart

