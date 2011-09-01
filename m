Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:42950 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787Ab1IAJOL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Sep 2011 05:14:11 -0400
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LQU002U26ZLBU@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 01 Sep 2011 10:14:09 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LQU00FMJ6ZKCP@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 01 Sep 2011 10:14:09 +0100 (BST)
Date: Thu, 01 Sep 2011 11:14:08 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH] media: Add camera controls for the ov5642 driver
In-reply-to: <20110901084722.GV12368@valkosipuli.localdomain>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Bastian Hecht <hechtb@googlemail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, hverkuil@xs4all.nl
Message-id: <4E5F4CE0.8050909@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
References: <alpine.DEB.2.02.1108171553540.17550@ipanema>
 <201108282006.09790.laurent.pinchart@ideasonboard.com>
 <CABYn4sx5jQPyLC4d6OfVbX5SSuS4TiNsB_LPoCheaOSbwM9Pzw@mail.gmail.com>
 <20110831212010.GS12368@valkosipuli.localdomain>
 <Pine.LNX.4.64.1109010911550.21309@axis700.grange>
 <20110901084722.GV12368@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 09/01/2011 10:47 AM, Sakari Ailus wrote:
> On Thu, Sep 01, 2011 at 09:15:20AM +0200, Guennadi Liakhovetski wrote:
>> On Thu, 1 Sep 2011, Sakari Ailus wrote:
>>
>>> On Wed, Aug 31, 2011 at 03:27:49PM +0000, Bastian Hecht wrote:
>>>> 2011/8/28 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
>>> [clip]
>>>>> If I'm not mistaken V4L2_CID_PRIVATE_BASE is deprecated.
>>>>
>>>> I checked at http://v4l2spec.bytesex.org/spec/x542.htm, googled
>>>> "V4L2_CID_PRIVATE_BASE deprecated" and read
>>>> Documentation/feature-removal-schedule.txt. I couldn't find anything.
>>>
>>> Hmm. Did you happen to check when that has been written? :)
>>>
>>> Please use this one instead:
>>>
>>> <URL:http://hverkuil.home.xs4all.nl/spec/media.html>
>>
>> "Drivers can also implement their own custom controls using 
>> V4L2_CID_PRIVATE_BASE and higher values."
>>
>> Which specific location describes V4L2_CID_PRIVATE_BASE differently there?
> 
> That was a general comment, not related to the private base. There's no
> use for a three-year-old spec as a reference!
> 
> The control framework does not support private controls, for example. The
> controls should be put to their own class in videodev2.h nowadays, that's my
> understanding. Cc Hans.

Is this really the case that we close the door for private controls in
the mainline kernel ? Or am I misunderstanding something ?
How about v4l2_ctrl_new_custom() ?

What if there are controls applicable to single driver only ?
Do we really want to have plenty of such in videodev2.h ?

-- 
Sylwester Nawrocki
Samsung Poland R&D Center
