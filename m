Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.26]:30857 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770Ab1BDMDS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Feb 2011 07:03:18 -0500
Message-ID: <4D4BEB01.9000502@maxwell.research.nokia.com>
Date: Fri, 04 Feb 2011 14:03:13 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v6 7/7] v4l: subdev: Events support
References: <1296131338-29892-1-git-send-email-laurent.pinchart@ideasonboard.com> <1296131338-29892-8-git-send-email-laurent.pinchart@ideasonboard.com> <201102041112.14105.hverkuil@xs4all.nl>
In-Reply-To: <201102041112.14105.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

Thanks for the comments!

Hans Verkuil wrote:
...
>> @@ -424,6 +430,8 @@ struct v4l2_subdev_ops {
>>  #define V4L2_SUBDEV_FL_IS_SPI			(1U << 1)
>>  /* Set this flag if this subdev needs a device node. */
>>  #define V4L2_SUBDEV_FL_HAS_DEVNODE		(1U << 2)
>> +/* Set this flag if this subdev generates events. */
>> +#define V4L2_SUBDEV_FL_HAS_EVENTS		(1U << 3)
> 
> Do we need this flag...
> 
>>  
>>  /* Each instance of a subdev driver should create this struct, either
>>     stand-alone or embedded in a larger struct.
>> @@ -446,6 +454,8 @@ struct v4l2_subdev {
>>  	/* subdev device node */
>>  	struct video_device devnode;
>>  	unsigned int initialized;
>> +	/* number of events to be allocated on open */
>> +	unsigned int nevents;
> 
> ...when we have this field? We could just test whether nevents > 0.

Not necessarily. But:

- It's easy to check whether events are expected to be supported by the
driver using the flag and

- AFAIR it was agreed that as the driver is free to allocate more events
using v4l2_event_alloc(), it may choose not to allocate any at
initialisation but e.g. do it in in VIDIOC_SUBSCRIBE_EVENT only.

What do you think?

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
