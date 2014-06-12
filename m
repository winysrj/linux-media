Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:35372 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbaFLVfQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 17:35:16 -0400
Received: by mail-pa0-f51.google.com with SMTP id ey11so1376901pad.24
        for <linux-media@vger.kernel.org>; Thu, 12 Jun 2014 14:35:15 -0700 (PDT)
Message-ID: <539A1D12.1040808@boundarydevices.com>
Date: Thu, 12 Jun 2014 14:35:14 -0700
From: Troy Kisky <troy.kisky@boundarydevices.com>
MIME-Version: 1.0
To: Steve Longerbeam <steve_longerbeam@mentor.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
CC: Steve Longerbeam <slongerbeam@gmail.com>,
	linux-media@vger.kernel.org, Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH 00/43] i.MX6 Video capture
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>	 <1402485696.4107.107.camel@paszta.hi.pengutronix.de>	 <5398FC95.1070504@mentor.com> <1402591841.3444.136.camel@paszta.hi.pengutronix.de> <539A1627.5010602@mentor.com>
In-Reply-To: <539A1627.5010602@mentor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 6/12/2014 2:05 PM, Steve Longerbeam wrote:
> On 06/12/2014 09:50 AM, Philipp Zabel wrote:
>> Hi Steve,
>>
>> [Added Russell to Cc: because of the question how to send IPU core 
>>  patches to drm-next]
>>
>> Am Mittwoch, den 11.06.2014, 18:04 -0700 schrieb Steve Longerbeam:
>>> Hi Philipp and Sascha,
>>>
>>> First of all, thanks for the detailed review.
>>
>> You are welcome. I am tasked to prepare our own capture drivers for
>> mainline submission, but they are not quite there yet. I'd be very
>> interested in getting this worked out together, especially since we
>> seem to be interested in orthogonal features (we had no use for the
>> preview and and encoder IC tasks or MIPI CSI-2 so far, but we need
>> media controller support
> 
> Ok. Yes, we definitely need preview and MIPI CSI-2, and adding IC to the
> capture path is nice too, since it allows userland to select arbitrary user
> resolutions, pixel format color space, and also rotation controls. The
> capture driver decides whether to include the IC in the capture pipeline
> based on user format and rotation control. I.e. if user colorspace is
> different from what the sensor can output, IC CSC is required. If user
> resolution is different from the selected capture cropping rectangle,
> IC resizer is required, and finally if user requests rotation, the IC
> rotation unit is required. If none of those are true, the capture driver
> decides to exclude the IC from the pipeline and send raw sensor frames
> (well, after cropping anyway) directly to memory via the SMFC.
> 
> So in our driver, the decision to link the IC in a pipeline is made
> internally by the driver and is not a decision exported to userland.
> 
> My plan was to add media device framework support, but only after basic
> video capture is in place. Our driver is full featured in terms of basic
> capture support, and it works on all three reference platforms. But I
> agree it needs to convert subdev's to media entities and allow some of
> them to be linked via the media controller API.
> 
> But only some linkages make sense to me. As I explain above, if the IC were
> to be made a media entity, I think it's linkage should be made internally
> by the capture driver, and this should not be controllable by userspace.
> 

What if 2 cameras on different CSIs on the same IPU want to use the IC.
Is it 1st come 1st server? Or, both routed to memory, and a separate
memory convert? Is the 1st pipeline shut down and restarted in this mode?




