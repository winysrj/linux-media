Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:28376 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769Ab2CFQkh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Mar 2012 11:40:37 -0500
Received: from euspt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M0H009GV2BL41@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 06 Mar 2012 16:40:33 +0000 (GMT)
Received: from [106.116.48.223] by spt1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0M0H00HNA2BM0I@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 06 Mar 2012 16:40:35 +0000 (GMT)
Date: Tue, 06 Mar 2012 17:40:34 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH v4 04/34] v4l: VIDIOC_SUBDEV_S_SELECTION and
 VIDIOC_SUBDEV_G_SELECTION IOCTLs
In-reply-to: <1506799.pbV6Ic45Ex@avalon>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, tuukkat76@gmail.com,
	k.debski@samsung.com, riverful@gmail.com, hverkuil@xs4all.nl,
	teturtia@gmail.com
Message-id: <4F563E02.7010406@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
References: <20120302173219.GA15695@valkosipuli.localdomain>
 <12441257.HgrTH0oxIp@avalon> <20120306155036.GJ1075@valkosipuli.localdomain>
 <1506799.pbV6Ic45Ex@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/06/2012 05:27 PM, Laurent Pinchart wrote:
> On Tuesday 06 March 2012 17:50:36 Sakari Ailus wrote:
>> On Mon, Mar 05, 2012 at 11:59:22AM +0100, Laurent Pinchart wrote:
>>> On Friday 02 March 2012 19:30:12 Sakari Ailus wrote:
>>>> Add support for VIDIOC_SUBDEV_S_SELECTION and VIDIOC_SUBDEV_G_SELECTION
>>>> IOCTLs. They replace functionality provided by VIDIOC_SUBDEV_S_CROP and
>>>> VIDIOC_SUBDEV_G_CROP IOCTLs and also add new functionality (composing).
>>>>
>>>> VIDIOC_SUBDEV_G_CROP and VIDIOC_SUBDEV_S_CROP continue to be supported.
>>>>
>>>> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
>>>
>>> Except for the ACTIVE name,
>>>
>>> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>>>
>>> Maybe we could discuss this on IRC with Tomasz ?
>>
>> Tomasz wasn't online when I checked.
>>
>> How about "CURRENT"?
> 
> Sounds good to me. Let's see if Tomasz will be online tomorrow ;-)
> 
Hi,

What do you think about ACTIVE -> ACTUAL?
Similar word with the same number of letters :)

Regards,
TS
