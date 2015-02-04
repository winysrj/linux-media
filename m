Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57291 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932952AbbBDOFU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Feb 2015 09:05:20 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Florian Echtler <floe@butterbrot.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] add raw video support for Samsung SUR40 touchscreen
Date: Wed, 04 Feb 2015 16:06:05 +0200
Message-ID: <1606232.uUWpMankZz@avalon>
In-Reply-To: <54D21CEB.1090506@butterbrot.org>
References: <1420626920-9357-1-git-send-email-floe@butterbrot.org> <54D204F2.3040006@xs4all.nl> <54D21CEB.1090506@butterbrot.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Florian,

On Wednesday 04 February 2015 14:21:47 Florian Echtler wrote:
> On 04.02.2015 12:39, Hans Verkuil wrote:
> > On 02/04/15 12:34, Laurent Pinchart wrote:
> >> On Wednesday 04 February 2015 11:56:58 Florian Echtler wrote:
> >>> That's what I assumed, however, I'm running into the same problem as
> >>> with dma-sg when I switch to vmalloc...?
> >> 
> >> I don't expect vmalloc to work, as you can't DMA to vmalloc memory
> >> directly without any IOMMU in the general case (the allocated memory
> >> being physically fragmented).
> >> 
> >> dma-sg should work though, but you won't be able to use usb_bulk_msg().
> >> You need to create the URBs manually, set their sg and num_sgs fields and
> >> submit them.
> 
> Can I also use usb_sg_init/_wait for this? I can't find any other driver
> which uses USB in conjunction with dma-sg, can you suggest one I could
> use as an example?

usb_sg_init() is an interesting abstraction that transparently splits SG lists 
into several URBs if the USB host controller can't support SG lists directly. 
Unfortunately the API is blocking. It shouldn't be too difficult to add an 
asynchronous option with a complete callback.

> > Anyway Florian, based on Laurent's explanation I think trying to make
> > dma-sg work seems to be the best solution. And I've learned something
> > new :-)
> 
> Thanks for the clarification, please ignore the v2 patch submission for
> now :-)

-- 
Regards,

Laurent Pinchart

