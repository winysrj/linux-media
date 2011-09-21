Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:42929 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab1IUOvP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Sep 2011 10:51:15 -0400
Received: from euspt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LRV003KHNXEI0@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 21 Sep 2011 15:51:14 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LRV001WBNXDNL@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 21 Sep 2011 15:51:14 +0100 (BST)
Date: Wed, 21 Sep 2011 16:51:12 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v3 1/2] v4l2: Add the polarity flags for parallel camera
 bus FIELD signal
In-reply-to: <4E79E588.4000608@samsung.com>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	kyungmin.park@samsung.com, m.szyprowski@samsung.com,
	g.liakhovetski@gmx.de, sw0312.kim@samsung.com,
	riverful.kim@samsung.com
Message-id: <4E79F9E0.4010700@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-15
Content-transfer-encoding: 7BIT
References: <1316450497-6723-1-git-send-email-s.nawrocki@samsung.com>
 <1316452075-10700-1-git-send-email-s.nawrocki@samsung.com>
 <201109210112.39469.laurent.pinchart@ideasonboard.com>
 <4E79E588.4000608@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/21/2011 03:24 PM, Sylwester Nawrocki wrote:
> Hi Laurent,
> 
> On 09/21/2011 01:12 AM, Laurent Pinchart wrote:
>> Hi Sylwester,
>>
>> Thanks for the patch.
>>
>> On Monday 19 September 2011 19:07:55 Sylwester Nawrocki wrote:
>>> FIELD is an Even/Odd field selection signal, as specified in ITU-R BT.601
>>> standard. Add corresponding flag for configuring the FIELD signal polarity.
>>> Also add a comment about usage of V4L2_MBUS_[HV]SYNC* flags for the
>>> hardware that uses [HV]REF signals.
>>
>> I like this approach better.
>>
> ...
>>> +/* Field selection signal for interlaced scan mode */
>>> +#define V4L2_MBUS_FIELD_ACTIVE_HIGH		(1 << 10)
>>> +#define V4L2_MBUS_FIELD_ACTIVE_LOW		(1 << 11)
>>
>> What does this mean ? The FIELD signal is used to select between odd and even 
>> fields. Does "active high" mean that the field is odd or even when the signal 
>> has a high level ? The comment should make it explicit, or we could even 
>> rename those two constants to FIELD_ODD_HIGH/FIELD_ODD_LOW (or 
>> FIELD_EVEN_HIGH/FIELD_EVEN_LOW).
> 
> Yes, certainly I didn't think enough about this. I silently assumed that for
> V4L2_MBUS_FIELD_ACTIVE_HIGH FIELD = 0 selects Field1 (odd) and FIELD = 1 selects
> Field2 (even).
> I think it would be good to construct the macro so it is possibly self-explanatory,
> rather than requiring often to dig in the documentation.
> 
> So I would go for V4L2_MBUS_FIELD_ODD_LOW/V4L2_MBUS_FIELD_ODD_HIGH.
> Unless someone proposes something different/better I'll send an amended version
> tomorrow. 

Thinking some more of it, V4L2_MBUS_FIELD_EVEN_HIGH/V4L2_MBUS_FIELD_EVEN_LOW
is perhaps more in line with other defines where *HIGH means standard,
non-inverted case. So it seems better to me.
