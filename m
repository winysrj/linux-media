Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:35323 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685Ab2AGX2y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Jan 2012 18:28:54 -0500
Message-ID: <4F08D528.3050907@maxwell.research.nokia.com>
Date: Sun, 08 Jan 2012 01:28:40 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, dacohen@gmail.com, snjw23@gmail.com
Subject: Re: [RFC 09/17] v4l: Add pad op for pipeline validation
References: <4EF0EFC9.6080501@maxwell.research.nokia.com> <1324412889-17961-9-git-send-email-sakari.ailus@maxwell.research.nokia.com> <201201061042.38152.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201201061042.38152.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the review!!

Laurent Pinchart wrote:
> On Tuesday 20 December 2011 21:28:01 Sakari Ailus wrote:
>> From: Sakari Ailus <sakari.ailus@iki.fi>
>>
>> smiapp_pad_ops.validate_pipeline is intended to validate the full pipeline
>> which is implemented by the driver to which the subdev implementing this op
>> belongs to.
> 
> Should this be documented in Documentation/video4linux/v4l2-framework.txt ?
> 
>> The validate_pipeline op must also call validate_pipeline on any external
>> entity which is linked to its sink pads.
> 
> I'm uncertain about this. Subdev drivers would then have to implement the 
> pipeline walk logic, resulting in duplicate code. Our current situation isn't 
> optimal either: walking the pipeline should be implemented in the media code. 
> Would it suit your needs if the validate_pipeline operation was replaced by a 
> validate_link operation, with a media_pipeline_validate() function in the 
> media core to walk the pipeline and call validate_link in each pad (or maybe 
> each sink pad) ?

Albeit I don't see the pipeline checking a big problem in the subdev
drivers, that does seem like a viable alternative --- it's definitely
more generic. Any benefit of that is directly bound to the existence of
generic pipeline validation function, which definitely shouldn't be too
difficult to write.

It is also true that in practice, I assume, considering the pipeline
validation inside subdev drivers, the SMIA++ driver is almost as complex
any sensor driver will get in the near future. But once a practice has
been established it's difficult to change that.

I'm for validate_link() op.

I assume that in the implementation the Media controller framework would
walk the pipeline and call entity specific link_validate() ops. We
already have link_setup() op there. Those would, in turn, check that the
link requirements are fulfilled. How does that sound like to you?

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
