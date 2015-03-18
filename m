Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46983 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755590AbbCRMjG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Mar 2015 08:39:06 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tim Nordell <tim.nordell@logicpd.com>
Cc: linux-media@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH v2 25/26] omap3isp: Move to videobuf2
Date: Wed, 18 Mar 2015 14:39:14 +0200
Message-ID: <2161613.bbRGp2ApSQ@avalon>
In-Reply-To: <5508B15A.2050900@logicpd.com>
References: <1398083352-8451-1-git-send-email-laurent.pinchart@ideasonboard.com> <1398083352-8451-26-git-send-email-laurent.pinchart@ideasonboard.com> <5508B15A.2050900@logicpd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tim,

On Tuesday 17 March 2015 17:57:30 Tim Nordell wrote:
> On 04/21/14 07:29, Laurent Pinchart wrote:
> > Replace the custom buffers queue implementation with a videobuf2 queue.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> I realize this is late (it's in the kernel now), but I'm noticing that
> this does not appear to properly support the scatter-gather buffers that
> were previously supported as far as I recall (and can tell with what was
> removed with this patch), especially when using USERPTR.  You can
> observe this using "yavta" with the -u parameter.  Can you confirm if
> this works for you?  I get the following output from the kernel when
> attempting to stream a 640x480 UYVY framebuffer:
> 
> [  111.381256] contiguous mapping is too small 589824/614400

The OMAP3 ISP uses an IOMMU, physically non-contiguous buffers should thus be 
mapped contiguously into the device memory space. I haven't tried USERPTR 
support recently, but this surprises me. It requires investigation. Could you 
give it a try ?

-- 
Regards,

Laurent Pinchart

