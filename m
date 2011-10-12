Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:30149 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040Ab1JLPIZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Oct 2011 11:08:25 -0400
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LSY009PYKPZU6@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 12 Oct 2011 16:08:23 +0100 (BST)
Received: from [106.116.48.223] by spt2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LSY00JXJKPYW2@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 12 Oct 2011 16:08:23 +0100 (BST)
Date: Wed, 12 Oct 2011 17:08:20 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH 1/4] v4l: add support for selection api
In-reply-to: <20111012114828.GE10001@valkosipuli.localdomain>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com
Message-id: <4E95AD64.2020702@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <1314793703-32345-1-git-send-email-t.stanislaws@samsung.com>
 <1314793703-32345-2-git-send-email-t.stanislaws@samsung.com>
 <20111012114828.GE10001@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/12/2011 01:48 PM, Sakari Ailus wrote:
> Hi Tomasz,
>
> On Wed, Aug 31, 2011 at 02:28:20PM +0200, Tomasz Stanislawski wrote:
> ...
>> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
>> index fca24cc..b7471fe 100644
>> --- a/include/linux/videodev2.h
>> +++ b/include/linux/videodev2.h
>> @@ -738,6 +738,48 @@ struct v4l2_crop {
>>   	struct v4l2_rect        c;
>>   };
>>
>> +/* Hints for adjustments of selection rectangle */
>> +#define V4L2_SEL_SIZE_GE	0x00000001
>> +#define V4L2_SEL_SIZE_LE	0x00000002
>
> A minor comment. If the patches have not been pulled yet, how about adding
> FLAG_ to the flag names? I.e. V4L2_SEL_FLAG_SIZE_GE and
> V4L2_SEL_FLAG_SIZE_LE.

Hi Sakari,

The idea is good. I preferred to avoid using long names if possible.
I agree that using _FLAGS_ produce more informative name.
I'll fix it in the new version of selection API.

Regards,
Tomasz Stanislawski

>
> Kind regards,
>

