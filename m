Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42988 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755474Ab1H3PsZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Aug 2011 11:48:25 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Gary Thomas <gary@mlbassoc.com>
Subject: Re: Getting started with OMAP3 ISP
Date: Tue, 30 Aug 2011 17:48:52 +0200
Cc: linux-media@vger.kernel.org
References: <4E56734A.3080001@mlbassoc.com> <201108301620.09365.laurent.pinchart@ideasonboard.com> <4E5CFA0B.3010207@mlbassoc.com>
In-Reply-To: <4E5CFA0B.3010207@mlbassoc.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108301748.52596.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gary,

On Tuesday 30 August 2011 16:56:11 Gary Thomas wrote:
> On 2011-08-30 08:20, Laurent Pinchart wrote:
> > On Tuesday 30 August 2011 16:18:00 Gary Thomas wrote:
> >> On 2011-08-30 08:08, Gary Thomas wrote:

[snip]

> >>> When I run 'media-ctl -p', I see the various nodes, etc, and they all
> >>> look good except that I get lots of messages like this:
> >>> - entity 5: OMAP3 ISP CCDC (3 pads, 9 links)
> >>> type V4L2 subdev subtype Unknown
> >>> pad0: Input v4l2_subdev_open: Failed to open subdev device node
> >> 
> >> Could this be related to my missing [udev] device nodes?
> > 
> > It could be. You need the /dev/video* and /dev/v4l-subdev* device nodes.
> 
> Yes, that helped a lot.  When I create the devices by hand, I can now see
> my driver starting to be accessed (right now it's very much an empty stub)
> 
> Any ideas why udev (version 164) is not making these nodes automatically?

I'm sorry, I don't. You're not the first person to report this though. It 
would be nice if you could explain how you solved the issue when you'll find 
the solution.

-- 
Regards,

Laurent Pinchart
