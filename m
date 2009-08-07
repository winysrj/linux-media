Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:59747 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168AbZHGHqU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Aug 2009 03:46:20 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: How to efficiently handle DMA and cache on ARMv7 ? (was "Is get_user_pages() enough to prevent pages from being swapped out ?")
Date: Fri, 7 Aug 2009 09:48:24 +0200
Cc: David Xiao <dxiao@broadcom.com>, Ben Dooks <ben-linux@fluff.org>,
	Hugh Dickins <hugh.dickins@tiscali.co.uk>,
	Robin Holt <holt@sgi.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"v4l2_linux" <linux-media@vger.kernel.org>,
	"linux-arm-kernel@lists.arm.linux.org.uk"
	<linux-arm-kernel@lists.arm.linux.org.uk>
References: <200908061208.22131.laurent.pinchart@ideasonboard.com> <1249584374.29182.20.camel@david-laptop> <20090806222543.GG31579@n2100.arm.linux.org.uk>
In-Reply-To: <20090806222543.GG31579@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908070948.26389.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 07 August 2009 00:25:43 Russell King - ARM Linux wrote:
>
> As far as userspace DMA coherency, the only way you could do it with
> current kernel APIs is by using get_user_pages(), creating a scatterlist
> from those, and then passing it to dma_map_sg().  While the device has
> ownership of the SG, userspace must _not_ touch the buffer until after
> DMA has completed.

If the buffers are going to be reused again and again, would it be possible to 
mark the pages returned by get_user_pages() as non-cacheable instead ?

Regards,

Laurent Pinchart

