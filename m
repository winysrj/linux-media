Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54649 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972Ab2AHSTw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Jan 2012 13:19:52 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [RFC 09/17] v4l: Add pad op for pipeline validation
Date: Sun, 8 Jan 2012 19:20:16 +0100
Cc: linux-media@vger.kernel.org, dacohen@gmail.com, snjw23@gmail.com
References: <4EF0EFC9.6080501@maxwell.research.nokia.com> <201201061042.38152.laurent.pinchart@ideasonboard.com> <4F08D528.3050907@maxwell.research.nokia.com>
In-Reply-To: <4F08D528.3050907@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201081920.16352.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Sunday 08 January 2012 00:28:40 Sakari Ailus wrote:
> Laurent Pinchart wrote:
> > On Tuesday 20 December 2011 21:28:01 Sakari Ailus wrote:
> >> From: Sakari Ailus <sakari.ailus@iki.fi>
> >> 
> >> smiapp_pad_ops.validate_pipeline is intended to validate the full
> >> pipeline which is implemented by the driver to which the subdev
> >> implementing this op belongs to.
> > 
> > Should this be documented in Documentation/video4linux/v4l2-framework.txt
> > ?
> > 
> >> The validate_pipeline op must also call validate_pipeline on any
> >> external entity which is linked to its sink pads.
> > 
> > I'm uncertain about this. Subdev drivers would then have to implement the
> > pipeline walk logic, resulting in duplicate code. Our current situation
> > isn't optimal either: walking the pipeline should be implemented in the
> > media code. Would it suit your needs if the validate_pipeline operation
> > was replaced by a validate_link operation, with a
> > media_pipeline_validate() function in the media core to walk the
> > pipeline and call validate_link in each pad (or maybe each sink pad) ?
> 
> Albeit I don't see the pipeline checking a big problem in the subdev
> drivers, that does seem like a viable alternative --- it's definitely
> more generic. Any benefit of that is directly bound to the existence of
> generic pipeline validation function, which definitely shouldn't be too
> difficult to write.
> 
> It is also true that in practice, I assume, considering the pipeline
> validation inside subdev drivers, the SMIA++ driver is almost as complex
> any sensor driver will get in the near future. But once a practice has
> been established it's difficult to change that.
> 
> I'm for validate_link() op.
> 
> I assume that in the implementation the Media controller framework would
> walk the pipeline and call entity specific link_validate() ops. We
> already have link_setup() op there. Those would, in turn, check that the
> link requirements are fulfilled. How does that sound like to you?

That sounds good to me. If the operation isn't implemented, the core should 
just make sure that code, width and height are identical on the two ends of 
the link. That will be the usual requirement, checking it in the core will 
make drivers simpler.

-- 
Regards,

Laurent Pinchart
