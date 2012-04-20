Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36295 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751376Ab2DTMca (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Apr 2012 08:32:30 -0400
Message-ID: <4F91575C.4070904@iki.fi>
Date: Fri, 20 Apr 2012 15:32:28 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Andy Walls <awalls@md.metrocast.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: Re: [GIT PULL FOR v3.5] Various fixes
References: <201204191748.51323.hverkuil@xs4all.nl> <20120420115700.GK5356@valkosipuli.localdomain> <201204201415.18341.hverkuil@xs4all.nl>
In-Reply-To: <201204201415.18341.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Hans Verkuil wrote:
> On Friday, April 20, 2012 13:57:00 Sakari Ailus wrote:
>> Hi Hans,
>>
>> On Thu, Apr 19, 2012 at 05:48:51PM +0200, Hans Verkuil wrote:
>>> While I was cleaning up some older drivers I came across a few bugs that are
>>> fixed here. The fixes are all trivial one-liners.
>>>
>>> Regards,
>>>
>>> 	Hans
>>>
>>> The following changes since commit f4d4e7656b26a6013bc5072c946920d2e2c44e8e:
>>>
>>>    [media] em28xx: Make em28xx-input.c a separate module (2012-04-10 20:45:41 -0300)
>>>
>>> are available in the git repository at:
>>>
>>>    git://linuxtv.org/hverkuil/media_tree.git fixes
>>>
>>> for you to fetch changes up to f85e735051e71410bfd695536a25c1013bceeabc:
>>>
>>>    vivi: fix duplicate line. (2012-04-19 17:38:52 +0200)
>>>
>>> ----------------------------------------------------------------
>>> Hans Verkuil (4):
>>>        V4L: fix incorrect refcounting.
>>>        V4L2: drivers implementing vidioc_default should also return -ENOTTY
>>>        v4l2-ctrls.c: zero min/max/step/def values for 64 bit integers.
>>
>> Thanks for the patches.
>>
>> I'd put the setting of the min/max/step values for 64-bit controls to
>> v4l2_ctrl_new() instead for two reasons:
>>
>> - All 64-bit controls require this for the time being, independent of the
>> purpose, at least until min/max/step are implemented for them and
>>
>> - that's where part of the string control initialisation is done as well.
>>
>> What do you think?
>
> I disagree :-)
>
> v4l2_ctrl_fill is the only function at the moment that fills in these fields.
> Doing it elsewhere just for that type is inconsistent.
>
> Also, v4l2_ctrl_fill is also called by some older drivers that do not use the
> control framework yet, so it really has to be done there.

Ok; after taking another look there I agree with you.

> Another matter is that ivtv-controls.c uses non-zero max and step values for
> these 64 bit controls, that should be fixed as well.

Right. Feel free to add to that patch:

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

>> I think that in the long run we'll need to add capability to get
>> min/max/step for 64-bit controls also to user space, but the information
>> could be added to the controls in the kernel already earlier.
>
> It wouldn't be difficult to make min/max/def of type s64. At this moment I do
> not see a compelling reason, but if we get more 64-bit integer controls that
> do need this, then we will have to add it.

The controls the SMIA++ driver uses these for are also read-only and so 
set by the driver. Once we get controls that would benefit from 
min/max/step they should be added at the same time.

Regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
