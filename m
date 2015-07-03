Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:51600 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755637AbbGCOtN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Jul 2015 10:49:13 -0400
Message-ID: <5596A09F.9030301@linux.intel.com>
Date: Fri, 03 Jul 2015 17:47:59 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
CC: mchehab@osg.samsung.com
Subject: Re: [PATCH v2 1/1] vb2: Only requeue buffers immediately once
 streaming is started
References: <1435927676-24559-1-git-send-email-sakari.ailus@linux.intel.com> <55968A26.1010102@xs4all.nl> <55968E02.3060102@linux.intel.com> <55969405.9090207@xs4all.nl>
In-Reply-To: <55969405.9090207@xs4all.nl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Hans Verkuil wrote:
> On 07/03/2015 03:28 PM, Sakari Ailus wrote:
>> Hi Hans,
>>
>> Hans Verkuil wrote:
>>> On 07/03/2015 02:47 PM, Sakari Ailus wrote:
>>>> Buffers can be returned back to videobuf2 in driver's streamon handler. In
>>>> this case vb2_buffer_done() with buffer state VB2_BUF_STATE_QUEUED will
>>>> cause the driver's buf_queue vb2 operation to be called, queueing the same
>>>> buffer again only to be returned to videobuf2 using vb2_buffer_done() and so
>>>> on.
>>>>
>>>> Add a new buffer state VB2_BUF_STATE_REQUEUEING which, when used as the
>>>
>>> It's spelled as requeuing (no e). The verb is 'to queue', but the -ing form is
>>> queuing. Check the dictionary: http://dictionary.reference.com/browse/queuing
>>
>> My dictionary disagrees with yours. :-)
>>
>> http://dictionary.cambridge.org/dictionary/british/queue?q=queueing
>
> $ git grep -i queueing|wc
>      655    5660   54709
> $ git grep -i queuing|wc
>      650    5623   55249
>
> That's not helpful either...
>
> On the other hand:
>
> $ git grep -i queuing drivers/media/|wc
>       19     200    1846
> $ git grep -i queueing drivers/media/|wc
>        2      25     203
>
> Within drivers/media there seems to be a clear preference for queuing :-)

The rest of the kernel apparently prefers "queueing" with a slight 
margin, if you don't consider V4L2. And who do you think might have 
added those lines containing "queuing" in V4L2? :-D

The matter was discussed long time ago and my understanding was in case 
of multiple possible spellings both should be allowed.

I'll post v3, replacing the if's at the end by a single switch. I think 
it's cleaner that way.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
