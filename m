Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57641 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab2AOWxF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jan 2012 17:53:05 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [RFC 06/17] v4l: Add selections documentation.
Date: Sun, 15 Jan 2012 23:53:08 +0100
Cc: linux-media@vger.kernel.org, dacohen@gmail.com, snjw23@gmail.com,
	Tomasz Stanislawski <t.stanislaws@samsung.com>
References: <4EF0EFC9.6080501@maxwell.research.nokia.com> <201201061243.56158.laurent.pinchart@ideasonboard.com> <4F0B2EF0.5080203@maxwell.research.nokia.com>
In-Reply-To: <4F0B2EF0.5080203@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201201152353.08912.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Monday 09 January 2012 19:16:16 Sakari Ailus wrote:
> Laurent Pinchart wrote:
> > On Tuesday 20 December 2011 21:27:58 Sakari Ailus wrote:

[snip]

> >> The PADDED target
> >> +      provides the width and height for the padded image,
> > 
> > Is it valid for both crop and compose rectangles ?
> 
> I think all targets are valid for all rectangles. Should I mention that?
> 
> The practical use cases may be more limited, though. I wonder if I
> should remove the padded targets until we get use cases for them. I
> included them for the reason that they also exist in the V4L2.
> 
> Tomasz, Sylwester: do you have use for the PADDED targets?
> 
> I think we also must define what will be done in cases where crop (on
> either sink or source) / scaling / composition is not supported by the
> subdev. That's currently undefined. I think it'd be most clear to return
> an error code but I'm not sure which one --- EINVAL is an obvious
> candidate but that is also returned when the pad is wrong. It looks
> still like the best choice to me.

If the rectangle isn't supported, EINVAL is appropriate. Do we need a way to 
discover what rectangles are supported ?

If the rectangle is supported by the size is out of range, the driver should 
adjust it instead of returning an error.

-- 
Regards,

Laurent Pinchart
