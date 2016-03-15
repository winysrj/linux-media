Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:53432 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932378AbcCOLyB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Mar 2016 07:54:01 -0400
Subject: Re: subdev sensor driver and
 V4L2_FRMIVAL_TYPE_CONTINUOUS/V4L2_FRMIVAL_TYPE_STEPWISE
To: Sakari Ailus <sakari.ailus@iki.fi>,
	Philippe De Muyter <phdm@macq.eu>
References: <20160315101417.GA31990@frolo.macqel>
 <20160315110608.GT11084@valkosipuli.retiisi.org.uk>
Cc: linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56E7F7EE.10308@xs4all.nl>
Date: Tue, 15 Mar 2016 12:54:22 +0100
MIME-Version: 1.0
In-Reply-To: <20160315110608.GT11084@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/15/16 12:06, Sakari Ailus wrote:
> Hi Philippe,
> 
> On Tue, Mar 15, 2016 at 11:14:17AM +0100, Philippe De Muyter wrote:
>> Hi,
>>
>> Sorry if you read the following twice, but the subject of my previous post
>> was not precise enough :(
>>
>> I am in the process of converting a sensor driver compatible with the imx6
>> freescale linux kernel, to a subdev driver compatible with a current kernel
>> and Steve Longerbeam's work.
>>
>> My sensor can work at any fps (even fractional) up to 60 fps with its default
>> frame size or even higher when using crop or "binning'.  That fact is reflected
>> in my previous implemetation of VIDIOC_ENUM_FRAMEINTERVALS, which answered
>> with a V4L2_FRMIVAL_TYPE_CONTINUOUS-type reply.
>>
>> This seem not possible anymore because of the lack of the needed fields
>> in the 'struct v4l2_subdev_frame_interval_enum' used to delegate the question
>> to the subdev driver.  V4L2_FRMIVAL_TYPE_STEPWISE does not seem possible
>> anymore either.  Has that been replaced by something else or is that
>> functionality not considered relevant anymorea ?
> 
> I think the issue was that the CONTINUOUS and STEPWISE were considered too
> clumsy for applications and practically no application was using them, or at
> least the need for these was not seen to be there. They were not added to
> the V4L2 sub-device implementation of the interface as a result.

It never made sense to me why the two APIs weren't kept the same.

My suggestion would be to add step_width and step_height fields to
struct v4l2_subdev_frame_size_enum, that way you have the same functionality
back.

I.e. for discrete formats the min values equal the max values, for continuous
formats the step values are both 1 (or 0 for compability's sake) and the
remainder maps to a stepwise range.

Regards,

	Hans

> 
> Cc Hans.
> 
> The smiapp driver uses horizontal and vertical blanking controls for
> changing the frame rate. That's a bit lower level interface than most
> drivers use, but then you have to provide enough other information to the
> user space as well, including the pixel rate.
> 
