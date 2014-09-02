Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:30148 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbaIBHgL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Sep 2014 03:36:11 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NB9004DOJWZEO80@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 02 Sep 2014 08:38:59 +0100 (BST)
Message-id: <54057367.6010507@samsung.com>
Date: Tue, 02 Sep 2014 09:36:07 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
MIME-version: 1.0
To: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Cc: Nicolas Dufresne <nicolas.dufresne@collabora.co.uk>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] videobuf: Allow reqbufs(0) to free current buffers
References: <1409480361-12821-1-git-send-email-hdegoede@redhat.com>
 <540474AE.4070706@xs4all.nl> <54049268.3060004@redhat.com>
In-reply-to: <54049268.3060004@redhat.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 2014-09-01 17:36, Hans de Goede wrote:
> Hi,
>
> On 09/01/2014 03:29 PM, Hans Verkuil wrote:
>> Hi Hans,
>>
>> At first glance this looks fine. But making changes in videobuf is always scary :-)
>> so I hope Marek can look at this as well.
>>
>> How well was this tested?
> I ran some tests on bttv which all ran well.
>
> Note that the code already allowed for going from say 4 buffers to 1,
> and the old code path for reqbufs was already calling __videobuf_free()
> before re-allocating the buffers again. So in essence this just changes
> things to allow the 4 buffers to 1 case to also be 4 buffers to 0.

The patch looks fine and the explanation is also convincing, so it 
turned out
that this long standing issue can be fixed quite easily, however I don't 
have
any hardware to do the tests right now.

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> On 08/31/2014 12:19 PM, Hans de Goede wrote:
>>> All the infrastructure for this is already there, and despite our desires for
>>> the old videobuf code to go away, it is currently still in use in 18 drivers.
>>>
>>> Allowing reqbufs(0) makes these drivers behave consistent with modern drivers,
>>> making live easier for userspace, see e.g. :
>>> https://bugzilla.gnome.org/show_bug.cgi?id=735660
>>>
>>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>>> ---
>>>   drivers/media/v4l2-core/videobuf-core.c | 11 ++++++-----
>>>   1 file changed, 6 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/drivers/media/v4l2-core/videobuf-core.c b/drivers/media/v4l2-core/videobuf-core.c
>>> index fb5ee5d..b91a266 100644
>>> --- a/drivers/media/v4l2-core/videobuf-core.c
>>> +++ b/drivers/media/v4l2-core/videobuf-core.c
>>> @@ -441,11 +441,6 @@ int videobuf_reqbufs(struct videobuf_queue *q,
>>>   	unsigned int size, count;
>>>   	int retval;
>>>   
>>> -	if (req->count < 1) {
>>> -		dprintk(1, "reqbufs: count invalid (%d)\n", req->count);
>>> -		return -EINVAL;
>>> -	}
>>> -
>>>   	if (req->memory != V4L2_MEMORY_MMAP     &&
>>>   	    req->memory != V4L2_MEMORY_USERPTR  &&
>>>   	    req->memory != V4L2_MEMORY_OVERLAY) {
>>> @@ -471,6 +466,12 @@ int videobuf_reqbufs(struct videobuf_queue *q,
>>>   		goto done;
>>>   	}
>>>   
>>> +	if (req->count == 0) {
>>> +		dprintk(1, "reqbufs: count invalid (%d)\n", req->count);
>>> +		retval = __videobuf_free(q);
>>> +		goto done;
>>> +	}
>>> +
>>>   	count = req->count;
>>>   	if (count > VIDEO_MAX_FRAME)
>>>   		count = VIDEO_MAX_FRAME;
>>>
>>>

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

