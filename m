Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53777 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756305Ab2KHQfu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Nov 2012 11:35:50 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org, Pawel Osciak <pawel@osciak.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 27/26] v4l: vb2: Set data_offset to 0 for single-plane buffers
Date: Thu, 08 Nov 2012 17:36:29 +0100
Message-ID: <1404204.ssiMvSrs8l@avalon>
In-Reply-To: <509BCF8C.3060806@samsung.com>
References: <1349880405-26049-1-git-send-email-t.stanislaws@samsung.com> <5434150.xFoZpmKjxA@avalon> <509BCF8C.3060806@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On Thursday 08 November 2012 16:28:12 Tomasz Stanislawski wrote:
> Hi Laurent,
> The fix was partially applied in "[PATCHv10 03/26] v4l: vb2: add support for
> shared buffer (dma_buf)". The data_offset is set to 0 for DMABUF
> capture/output for single-planar API.

My bad, I had an old version of your patch set in my git tree. The other half 
of the patch should still be applied, but it can go through Mauro's tree 
without going through yours.

> We should define the meaning of data_offset in case of USERPTR and MMAP
> buffers. For output device it is pretty intuitive.
> 
> For DMABUF capture devices data_offset maybe used to inform a driver to
> capture the image at some offset inside the DMABUF buffer.

That's indeed missing from the documentation.

> BTW. Should {} be added after "if (V4L2_TYPE_IS_OUTPUT(b->type))"
> to avoid 'interesting' behavior? :)

Oops :-) I'll fix that.

-- 
Regards,

Laurent Pinchart
