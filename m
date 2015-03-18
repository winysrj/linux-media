Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47149 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666AbbCRO7j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Mar 2015 10:59:39 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tim Nordell <tim.nordell@logicpd.com>
Cc: linux-media@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH v2 25/26] omap3isp: Move to videobuf2
Date: Wed, 18 Mar 2015 16:59:47 +0200
Message-ID: <2315546.eR07gyadH5@avalon>
In-Reply-To: <550991C2.80503@logicpd.com>
References: <1398083352-8451-1-git-send-email-laurent.pinchart@ideasonboard.com> <2161613.bbRGp2ApSQ@avalon> <550991C2.80503@logicpd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tim,

On Wednesday 18 March 2015 09:54:58 Tim Nordell wrote:
> On 03/18/15 07:39, Laurent Pinchart wrote:
> > On Tuesday 17 March 2015 17:57:30 Tim Nordell wrote:
> >> On 04/21/14 07:29, Laurent Pinchart wrote:
> >>> Replace the custom buffers queue implementation with a videobuf2 queue.
> >>> 
> >>> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> >> 
> >> I realize this is late (it's in the kernel now), but I'm noticing that
> >> this does not appear to properly support the scatter-gather buffers that
> >> were previously supported as far as I recall (and can tell with what was
> >> removed with this patch), especially when using USERPTR.  You can
> >> observe this using "yavta" with the -u parameter.  Can you confirm if
> >> this works for you?  I get the following output from the kernel when
> >> attempting to stream a 640x480 UYVY framebuffer:
> >> 
> >> [  111.381256] contiguous mapping is too small 589824/614400
> > 
> > The OMAP3 ISP uses an IOMMU, physically non-contiguous buffers should thus
> > be mapped contiguously into the device memory space. I haven't tried
> > USERPTR support recently, but this surprises me. It requires
> > investigation. Could you give it a try ?
> 
> That's why I wrote the e-mail since I did give it a try.  It doesn't
> work in kernel v3.19 as expected.  I'm using a BT.656 device (and with
> the patches I submitted last week since it didn't work for my device
> without those that I wrote), so it's a little harder to go back to the
> exact patch that causes it to fail (since I believe it's this patch
> which is pre-BT.656 support) but I would guess that it's the one I
> replied to here.
> 
> The videobuf2-dma-contig framework is what is emitting this error, and
> part of it's framework checks that the buffer is fully contiguous in
> memory rather than doing scatter-gather.

The names might be a bit misleading, vb2-dma-contig requires contiguous memory 
in the device memory space, not in physical memory. The IOMMU, managed through 
dma_map_sg_attrs, should have mapped the userptr buffer contiguously in the 
ISP DMA address space. If it hasn't, that's what need to be investigated.

> The function "vb2_dc_get_contiguous_size(...)" is what finds the full
> contiguous area of the buffer and reports back internally how much is
> available in a row.  Would videobuf2-dma-sg have been a better choice here? 
> I tried a naive conversion to that (that is, I'm sure I messed something
> up), but it yielded the kernel spewing messages about "Address Hole seen by
> CAM" from the omap_l3_smx driver.

vb2-dma-sg is used for devices that support scatter-gather. The OMAP3 ISP 
doesn't, it requires DMA contiguous memory.

-- 
Regards,

Laurent Pinchart

