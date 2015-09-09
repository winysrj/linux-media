Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48479 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989AbbIINUQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Sep 2015 09:20:16 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, pawel@osciak.com,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	hverkuil@xs4all.nl, Sumit Semwal <sumit.semwal@linaro.org>,
	Rob Clark <robdclark@gmail.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Laura Abbott <labbott@redhat.com>
Subject: Re: [RFC 00/11] vb2: Handle user cache hints, allow drivers to choose cache coherency
Date: Wed, 09 Sep 2015 16:20:14 +0300
Message-ID: <2585884.0AruC9DFGi@avalon>
In-Reply-To: <1441708435-12736-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1441708435-12736-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

+ Sumit, Rob, Laura and Daniel who have discussed cache optimization with me 
at LPC in the context of dmabuf.

The full patch set can be found at https://www.mail-archive.com/linux-media@vger.kernel.org/msg92120.html

On Tuesday 08 September 2015 13:33:44 Sakari Ailus wrote:
> Hi folks,
> 
> This RFC patchset achieves two main objectives:
> 
> 1. Respects cache flags passed from the user space. As no driver nor
> videobuf2 has (ever?) implemented them, the two flags are replaced by a
> single one (V4L2_BUF_FLAG_NO_CACHE_SYNC) and the two old flags are
> deprecated. This is done since a single flag provides the driver with
> enough information on what to do. (See more info in patch 4.)
> 
> 2. Allows a driver using videobuf2 dma-contig memory type to choose
> whether it prefers coherent or non-coherent CPU access to buffer memory
> for MMAP and USERPTR buffers. This could be later extended to be specified
> by the user, and per buffer if needed.
> 
> Only dma-contig memory type is changed but the same could be done to
> dma-sg as well. I can add it to the set if people are happy with the
> changes to dma-contig.

-- 
Regards,

Laurent Pinchart

