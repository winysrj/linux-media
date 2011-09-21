Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:63634 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab1IUIhi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Sep 2011 04:37:38 -0400
Received: from euspt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LRV00BNI6MNTI@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 21 Sep 2011 09:37:35 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LRV00IX96MN0U@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 21 Sep 2011 09:37:35 +0100 (BST)
Date: Wed, 21 Sep 2011 10:37:34 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 1/3] v4l: Extend V4L2_CID_COLORFX control with AQUA effect
In-reply-to: <201109210023.21478.laurent.pinchart@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Subash Patel <subashrp@gmail.com>, linux-media@vger.kernel.org,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	sw0312.kim@samsung.com, riverful.kim@samsung.com,
	Xiaolin Zhang <xiaolin.zhang@intel.com>
Message-id: <4E79A24E.3020302@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-15
Content-transfer-encoding: 7BIT
References: <1316192730-18099-1-git-send-email-s.nawrocki@samsung.com>
 <4E76DC47.7050106@gmail.com> <4E7726EF.7050003@samsung.com>
 <201109210023.21478.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 09/21/2011 12:23 AM, Laurent Pinchart wrote:
> On Monday 19 September 2011 13:26:39 Sylwester Nawrocki wrote:
>> On 09/19/2011 08:08 AM, Subash Patel wrote:
>>> Hi Laurent,
>>>
>>> I am not representing Sylwester :), But with a similar sensor I use, Aqua
>>> means cool tone which is Cb/Cr manipulations.
>>>
>>> On 09/19/2011 04:38 AM, Laurent Pinchart wrote:
>>>> On Friday 16 September 2011 19:05:28 Sylwester Nawrocki wrote:
>>>>> Add V4L2_COLORFX_AQUA image effect in the V4L2_CID_COLORFX menu.
>>>>
>>>> What's the aqua effect ?
>>
>> Aqua means cool tone, as Subash explained. It's somehow opposite to Sepia
>> which is warm tone. I'll improve the commit description in the next patch
>> version.
>> I tried to make a table with short description of each color effect in the
>> DocBook but it was taking me too long so I dropped it for a moment.
>>
>> I have attached an image presenting the color effects. Maybe it's worth
>> to add something like this to the DocBook, or perhaps just the
>> descriptions.
> 
> Thanks for the information. I think it would indeed be useful to add 
> descriptions to the documentation.

Sure, I'll try to find some time to complete this. And I wonder, what BLUE_SKY
effect is ? I suspect it's very much same as the Aqua effect which is present
in our sensor ISP. Does anyone know exactly ? Perhaps I could just use it
instead of adding new menu entry.

Regards,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
