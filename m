Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:32590 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795Ab2AGQyD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Jan 2012 11:54:03 -0500
Message-ID: <4F0878A0.4080708@maxwell.research.nokia.com>
Date: Sat, 07 Jan 2012 18:53:52 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, dacohen@gmail.com, snjw23@gmail.com
Subject: Re: [RFC 04/17] v4l: VIDIOC_SUBDEV_S_SELECTION and VIDIOC_SUBDEV_G_SELECTION
 IOCTLs
References: <4EF0EFC9.6080501@maxwell.research.nokia.com> <4F080BAF.1010800@maxwell.research.nokia.com> <4F0827E9.1070303@maxwell.research.nokia.com> <201201071654.09645.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201201071654.09645.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart wrote:
> Hi Sakari,
> 
> On Saturday 07 January 2012 12:09:29 Sakari Ailus wrote:
>> Sakari Ailus wrote:
>> ...
>>
>>> On second thought, I think I'll combine them into a new anonymous struct
>>> the field name of which I call "pad", unless that requires too intrusive
>>> changes in other drivers. How about that?
>>
>> And the answer to that is "no". The smia++ driver does store the format,
>> crop and compose values in arrays indexed by pad numbers which I think
>> is a natural thing for the driver to do. In many functiona the driver
>> uses internally it's trivial to choose the array either from driver's
>> internal data structure (V4L2_SUBDEV_FORMAT_ACTIVE) or the file handle
>> (V4L2_SUBDEV_FORMAT_TRY).
>>
>> Alternatively a named struct could be created for the same, but the
>> drivers might not need all the fields at all, or choose to store them in
>> a different form.
> 
> Drivers should use the v4l2_subdev_get_try_format(), 
> v4l2_subdev_get_try_crop() and v4l2_subdev_get_try_compose() functions to 
> access TRY formats and selection rectangles on file handles, so they shouldn't 
> care about the allocation details.

Good point... That requires some changes as well, like introduction of
v4l2_subdev_get_try_compose(). :-)

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
