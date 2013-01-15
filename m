Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:32158 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637Ab3AOOe5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Jan 2013 09:34:57 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MGO009KU8FPD540@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 15 Jan 2013 14:34:55 +0000 (GMT)
Received: from [106.116.147.88] by eusync4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0MGO00LZJ8I6QM60@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 15 Jan 2013 14:34:55 +0000 (GMT)
Message-id: <50F56907.2030301@samsung.com>
Date: Tue, 15 Jan 2013 15:34:47 +0100
From: Andrzej Hajda <a.hajda@samsung.com>
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: RFC: add parameters to V4L controls
References: <50EAA78E.4090904@samsung.com> <50F1DE2B.6060508@iki.fi>
In-reply-to: <50F1DE2B.6060508@iki.fi>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12.01.2013 23:05, Sakari Ailus wrote:
> Hi Andrzej,
>
> Andrzej Hajda wrote:
>> Hi,
>>
>> I have included this proposition already in the post "[PATCH RFC 0/2]
>> V4L: Add auto focus area control and selection" but it left unanswered.
>> I repost it again in a separate e-mail, I hope this way it will be
>> easier to attract attention.
>>
>> Problem description
>>
>> Currently V4L2 controls can have only single value (of type int, int64,
>> string). Some hardware controls require more than single int parameter,
>> for example to set auto-focus (AF) rectangle four coordinates should be
>> passed, to set auto-focus spot two coordinates should be passed.
>>
>> Current solution
>>
>> In case of AF rectangle we can reuse selection API as in "[PATCH RFC
>> 0/2] V4L: Add auto focus area control and selection" post.
>> Pros:
>> - reuse existing API,
>> Cons:
>> - two IOCTL's to perform one action,
> I think changing AF mode and AF window of interest are still two
> operations: you may well change just either one, and be happy with it.
I see no point in changing AF window of interest without applying area AF.
So we will have here always two operations in that case.
> You might want to disable AF during the configuration from the
> application. Would this work for you?
>
>> - non-atomic operation,
> True, but this is the way V4L2 works.
>
> There are many cases where implementing multiple more or less unrelated
> operations atomically would be beneficial, but so far there always have
> been workarounds to perform those actions non-atomicly. Format
> configuration, for example.
>
> Atomic operations are hard to get right and typically the required
> effort refutes the gain of doing so in drivers, and everything that may
> be done atomically always must be implemented beforehand in drivers.
>
> Your use case would be from the more simple end, though.
>
>> - fits well only for rectangles and spots (but with unused fields width,
>> height), in case of other parameters we should find a different way.
>>
>> Proposed solution
>>
>> The solution takes an advantage of the fact VIDIOC_(G/S/TRY)_EXT_CTRLS
>> ioctls can be called with multiple controls per call.
>>
>> I will present it using AF area control example.
>>
>> There could be added four pseudo-controls, lets call them for short:
>> LEFT, TOP, WIDTH, HEIGHT.
>> Those controls could be passed together with V4L2_AUTO_FOCUS_AREA_RECTANGLE
>> control in one ioctl as a kind of parameters.
>>
>> For example setting auto-focus spot would require calling
>> VIDIOC_S_EXT_CTRLS
>> with the following controls:
>> - V4L2_CID_AUTO_FOCUS_AREA = V4L2_AUTO_FOCUS_AREA_RECTANGLE
>> - LEFT = ...
>> - RIGHT = ...
>>
>> Setting AF rectangle:
>> - V4L2_CID_AUTO_FOCUS_AREA = V4L2_AUTO_FOCUS_AREA_RECTANGLE
>> - LEFT = ...
>> - TOP = ...
>> - WIDTH = ...
>> - HEIGHT = ...
>>
>> Setting  AF object detection (no parameters required):
>> - V4L2_CID_AUTO_FOCUS_AREA = V4L2_AUTO_FOCUS_AREA_OBJECT_DETECTION
>>
>> I have presented all three cases to show the advantages of this solution:
>> - atomicity - control and its parameters are passed in one call,
>> - flexibility - we are not limited by a fixed number of parameters,
>> - no-redundancy - we can pass only required parameters
>>      (no need to pass null width and height in case of spot selection),
>> - extensibility - it is possible to extend parameters in the future,
>> for example add parameters to V4L2_AUTO_FOCUS_AREA_OBJECT_DETECTION,
>> without breaking API,
>> - backward compatibility,
>> - re-usability - this schema could be used in other controls,
>>      pseudo-controls could be re-used in other controls as well.
>> - API backward compatibility.
> What I'm not terribly fond of in the above proposal is that it uses
> several controls to describe rectangles which are an obvious domain of
> the selection API: selections are roughly like controls but rather use a
> rectangle type instead of a single integer value (or a string).
The problem wit AF is that it can require different set of parameters 
depending on the hardware:
- spots (ex. Galaxy S3),
- rectangles (ex. Samsung NX210),
- multiple rectangles with weight or priority (ex. Samsung DV300F),
- ...
(To be honest I am sure only for GalaxyS3, other examples is just my 
prediction based on the analysis of user manuals of those cameras)

Implementation of all those cases would be quite straightforward (for 
me) using proposed pseudo-controls, without it every time it would
require serious brainstorming and API extending. And this is the main 
reason of my proposition.

>
> Also, I can't see any other reason to use controls for this than making
> the operation atomic.
>

Regards
Andrzej Hajda

