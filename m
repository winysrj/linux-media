Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:42769 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965199Ab2CFT4Q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Mar 2012 14:56:16 -0500
Message-ID: <4F566BC8.9090400@iki.fi>
Date: Tue, 06 Mar 2012 21:55:52 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, tuukkat76@gmail.com,
	k.debski@samsung.com, riverful@gmail.com, hverkuil@xs4all.nl,
	teturtia@gmail.com
Subject: Re: [PATCH v4 04/34] v4l: VIDIOC_SUBDEV_S_SELECTION and VIDIOC_SUBDEV_G_SELECTION
 IOCTLs
References: <20120302173219.GA15695@valkosipuli.localdomain> <12441257.HgrTH0oxIp@avalon> <20120306155036.GJ1075@valkosipuli.localdomain> <1506799.pbV6Ic45Ex@avalon> <4F563E02.7010406@samsung.com>
In-Reply-To: <4F563E02.7010406@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

Tomasz Stanislawski wrote:
> On 03/06/2012 05:27 PM, Laurent Pinchart wrote:
>> On Tuesday 06 March 2012 17:50:36 Sakari Ailus wrote:
>>> On Mon, Mar 05, 2012 at 11:59:22AM +0100, Laurent Pinchart wrote:
>>>> On Friday 02 March 2012 19:30:12 Sakari Ailus wrote:
>>>>> Add support for VIDIOC_SUBDEV_S_SELECTION and VIDIOC_SUBDEV_G_SELECTION
>>>>> IOCTLs. They replace functionality provided by VIDIOC_SUBDEV_S_CROP and
>>>>> VIDIOC_SUBDEV_G_CROP IOCTLs and also add new functionality (composing).
>>>>>
>>>>> VIDIOC_SUBDEV_G_CROP and VIDIOC_SUBDEV_S_CROP continue to be supported.
>>>>>
>>>>> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
>>>>
>>>> Except for the ACTIVE name,
>>>>
>>>> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>>>>
>>>> Maybe we could discuss this on IRC with Tomasz ?
>>>
>>> Tomasz wasn't online when I checked.
>>>
>>> How about "CURRENT"?
>>
>> Sounds good to me. Let's see if Tomasz will be online tomorrow ;-)
>>
> Hi,
> 
> What do you think about ACTIVE -> ACTUAL?
> Similar word with the same number of letters :)

Sounds good to me; perhaps even better than CURRENT. I'm fine with
either with perhaps a small inclination towards "actual".

Laurent?

Cheers,

-- 
Sakari Ailus
sakari.ailus@iki.fi
