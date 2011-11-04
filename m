Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51146 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603Ab1KDLtW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Nov 2011 07:49:22 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: whittenburg@gmail.com
Subject: Re: media0 not showing up on beagleboard-xm
Date: Fri, 4 Nov 2011 12:49:24 +0100
Cc: linux-media@vger.kernel.org
References: <CABcw_OkE=ANKDCVRRxgj33Mt=b3KAtGpe3RMnL3h0UMgOQ0ZdQ@mail.gmail.com>
In-Reply-To: <CABcw_OkE=ANKDCVRRxgj33Mt=b3KAtGpe3RMnL3h0UMgOQ0ZdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111041249.24661.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Chris,

On Tuesday 25 October 2011 04:48:13 Chris Whittenburg wrote:
> I'm using oe-core to build the 3.0.7+ kernel, which runs fine on my
> beagleboard-xm.
> 
> I'm interested in the media controller framework, which I believe is
> in this kernel.

Yes it is.

> I expected there to be a /dev/media0, but it is not there.  I do see
> "Linux media interface: v0.10" in my dmesg log, so I know
> media_devnode_init() is being called.
> 
> Even without a sensor connected and camera defined, I should still get
> a media0 which represents the ISP, correct?  I do have
> CONFIG_VIDEO_OMAP3=y in my kernel config.  The only reference in the
> log that I see related to the isp is:
> omap-iommu omap-iommu.0: isp registered
> 
> It looks like the kernel I'm using doesn't have support for the
> "camera=" cmdline option, so hopefully the presence of the camera is
> not required to kick things off.

You will need board code to register the OMAP3 ISP platform device that will 
then be picked by the OMAP3 ISP driver. Example of such board code can be 
found at

http://git.linuxtv.org/pinchartl/media.git/commit/37f505296ccd3fb055e03b2ab15ccf6ad4befb8d

-- 
Regards,

Laurent Pinchart
