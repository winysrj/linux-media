Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58088 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311Ab1KGLOj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Nov 2011 06:14:39 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Gary Thomas <gary@mlbassoc.com>
Subject: Re: media0 not showing up on beagleboard-xm
Date: Mon, 7 Nov 2011 12:14:35 +0100
Cc: whittenburg@gmail.com, linux-media@vger.kernel.org
References: <CABcw_OkE=ANKDCVRRxgj33Mt=b3KAtGpe3RMnL3h0UMgOQ0ZdQ@mail.gmail.com> <CABcw_Omf-xChfK8qu5u95KUqvnrKu99WQiPRWvZTmpy4rW6xiw@mail.gmail.com> <4EB7BC1F.50902@mlbassoc.com>
In-Reply-To: <4EB7BC1F.50902@mlbassoc.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111071214.36935.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 07 November 2011 12:08:15 Gary Thomas wrote:
> On 2011-11-06 15:26, Chris Whittenburg wrote:
> > On Fri, Nov 4, 2011 at 6:49 AM, Laurent Pinchart wrote:
> >> On Tuesday 25 October 2011 04:48:13 Chris Whittenburg wrote:
> >>> I'm using oe-core to build the 3.0.7+ kernel, which runs fine on my
> >>> beagleboard-xm.
> >> 
> >> You will need board code to register the OMAP3 ISP platform device that
> >> will then be picked by the OMAP3 ISP driver. Example of such board code
> >> can be found at
> >> 
> >> http://git.linuxtv.org/pinchartl/media.git/commit/37f505296ccd3fb055e03b
> >> 2ab15ccf6ad4befb8d
> > 
> > I followed your example to add the MT9P031 support, and now I get
> > /dev/media0 and /dev/video0 to 7.
> > 
> > I don't have the actual sensor hooked up yet.
> > 
> > If I try "media-ctl -p", I see lots of "Failed to open subdev device
> > node" msgs.
> > http://pastebin.com/F1TC9A1n
> > 
> > This is with the media-ctl utility from:
> > http://feeds.angstrom-distribution.org/feeds/core/ipk/eglibc/armv7a/base/
> > media-ctl_0.0.1-r0_armv7a.ipk
> > 
> > I also tried with the latest from your media-ctl repository, but got
> > the same msgs.
> > 
> > Is this an issue with my 3.0.8 kernel not being compatible with
> > current media-ctl utility?  Is there some older commit that I should
> > build from?  Or maybe it is just a side effect of the sensor not being
> > connected yet.
> 
> Does your kernel config enable CONFIG_VIDEO_V4L2_SUBDEV_API?

And does your system run udev, or have you created the device nodes manually ?

-- 
Regards,

Laurent Pinchart
