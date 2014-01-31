Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2478 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033AbaAaQHd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jan 2014 11:07:33 -0500
Message-ID: <52EBCA3D.2040106@xs4all.nl>
Date: Fri, 31 Jan 2014 17:07:25 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@linux.intel.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] v4l: subdev: Allow 32-bit compat IOCTLs
References: <1391182129-5234-1-git-send-email-sakari.ailus@linux.intel.com> <52EBC33C.6050902@xs4all.nl> <52EBC693.6040709@linux.intel.com> <52EBC9EA.1000809@linux.intel.com>
In-Reply-To: <52EBC9EA.1000809@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 01/31/2014 05:06 PM, Sakari Ailus wrote:
> Sakari Ailus wrote:
>> Hi Hans,
>>
>> Thanks for the comments.
>>
>> Hans Verkuil wrote:
>>> Hi Sakari,
>>>
>>> Sorry, this isn't right.
>>>
>>> It should go through v4l2_compat_ioctl32, otherwise ioctls for e.g.
>>> extended controls
>>> won't be converted correctly.
>>
>> Now that you mention it, indeed the state back when I thought this was
>> already implemented, the IOCTLs were exactly the same. Now that struct
>> v4l2_subdev_edid is used on VIDIOC_SUBDEV_G_EDID and
>> VIDIOC_SUBDEV_S_EDID32, this no longer holds.
> 
> Well, indeed, with the patch, the compat_ioctl32 handler wrongly would handle the non-compat IOCTL as well.
> 
> To fix this properly, the sub-device IOCTL numbers that require no conversion should be added to v4l2_compat_ioctl32() list of IOCTLs. Currently they're not there. Is this what you meant?
> 

Yes.

	Hans
