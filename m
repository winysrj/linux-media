Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:48019 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560AbZHGH1s (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Aug 2009 03:27:48 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "David Xiao" <dxiao@broadcom.com>
Subject: Re: How to efficiently handle DMA and cache on ARMv7 ? (was "Is get_user_pages() enough to prevent pages from being swapped out ?")
Date: Fri, 7 Aug 2009 09:29:53 +0200
Cc: "Ben Dooks" <ben-linux@fluff.org>,
	"Hugh Dickins" <hugh.dickins@tiscali.co.uk>,
	"Robin Holt" <holt@sgi.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"v4l2_linux" <linux-media@vger.kernel.org>,
	"linux-arm-kernel@lists.arm.linux.org.uk"
	<linux-arm-kernel@lists.arm.linux.org.uk>
References: <200908061208.22131.laurent.pinchart@ideasonboard.com> <200908061506.23874.laurent.pinchart@ideasonboard.com> <1249584374.29182.20.camel@david-laptop>
In-Reply-To: <1249584374.29182.20.camel@david-laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908070929.53873.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 06 August 2009 20:46:14 David Xiao wrote:

[snip]

> Another approach is working from a different direction: the kernel
> allocates the non-cached buffer and then mmap() into user space. I have
> done that in similar situation to try to achieve "zero-copy".

That's what most drivers do. While it's probably the easiest solution in many 
cases, it will sometimes introduce additional memcpy() operations that I'd 
like to avoid.

Think about the simple following use case. An application wants to display 
video it acquires from the device to the screen using Xv. The video buffer is 
allocated by Xv. Using the v4l2 user pointer streaming method, the device can 
DMA directly to the Xv buffer. Using driver-allocated buffers, a memcpy() is 
required between the v4l2 buffer and the Xv buffer.

Regards,

Laurent Pinchart

