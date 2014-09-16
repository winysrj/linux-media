Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:27064 "EHLO
	aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061AbaIPN5B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Sep 2014 09:57:01 -0400
Message-ID: <541841A9.5020700@cisco.com>
Date: Tue, 16 Sep 2014 15:56:57 +0200
From: Hans Verkuil <hansverk@cisco.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Pawel Osciak <pawel@osciak.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>
Subject: Re: [PATCH] [media] BZ#84401: Revert "[media] v4l: vb2: Don't return
 POLLERR during transient buffer underruns"
References: <1410826255-2025-1-git-send-email-m.chehab@samsung.com>	<4972900.uUGnPegBxW@avalon>	<20140916075812.04a8290d@concha.lan>	<1507629.uqIm3tmQgH@avalon> <20140916104121.63a6d954@concha.lan>
In-Reply-To: <20140916104121.63a6d954@concha.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 09/16/14 15:41, Mauro Carvalho Chehab wrote:
> Em Tue, 16 Sep 2014 14:42:36 +0300
> Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:
> 
>> Hi Mauro,
>>
>> On Tuesday 16 September 2014 07:58:12 Mauro Carvalho Chehab wrote:
>>> Em Tue, 16 Sep 2014 13:15:27 +0300 Laurent Pinchart escreveu:
>>>> On Tuesday 16 September 2014 07:01:29 Mauro Carvalho Chehab wrote:
>>>>> Em Tue, 16 Sep 2014 12:09:01 +0300 Laurent Pinchart escreveu:
>>>>>> On Monday 15 September 2014 21:10:55 Mauro Carvalho Chehab wrote:
>>>>>>> This reverts commit 9241650d62f79a3da01f1d5e8ebd195083330b75.
>>>>>>>
>>>>>>> The commit 9241650d62f7 was meant to solve an issue with Gstreamer
>>>>>>> version 0.10 with libv4l 1.2, where a fixup patch for DQBUF exposed
>>>>>>> a bad behavior ag Gstreamer.
>>>>>>
>>>>>> That's not correct. The patch was created to solve an issue observed
>>>>>> with the Gstreamer 0.10 v4l2src element accessing the video device
>>>>>> directly, *without* libv4l.
>>>>>
>>>>> Ok. From the discussions we took yesterday on the thread, I got the
>>>>> wrong impression from Nicolas comments that this happens only with
>>>>> gst < 1.4 and libv4l >= 1.2.
>>>>
>>>> My understanding is that recent gst versions worked around the problem,
>>>> and the above combination of versions might be problematic, but gst 0.10
>>>> is definitely affected.
>>>>
>>>>>> The V4L2 specification documents poll() as follows.
>>>>>>
>>>>>> "When the application did not call VIDIOC_QBUF or VIDIOC_STREAMON yet
>>>>>> the poll() function succeeds, but sets the POLLERR flag in the revents
>>>>>> field."
>>>>>>
>>>>>> The vb2 poll implementation didn't conform with that, as it returned
>>>>>> POLLERR when the buffer list was empty due to a transient buffer
>>>>>> underrun, even if both VIDIOC_STREAMON and VIDIOC_QBUF have been
>>>>>> called.
>>>>>>
>>>>>> The commit thus brought the vb2 poll implementation in line with the
>>>>>> specification. If we really want to revert it to its broken behaviour,
>>>>>> then it would be fair to explain this in the revert message,
>>>>>
>>>>> Ok, I'll rewrite the text. We likely want to fix the documentation too,
>>>>> in order to reflect the way it is.
>>>>>
>>>>>> and I want to know how you propose fixing this properly, as the revert
>>>>>> really causes issues for userspace.
>>>>>
>>>>> This patch simply broke all VBI applications. So, it should be reverted.
>>>>>
>>>>> From what you're saying, using Gst 0.10 with a kernel before 3.16 and
>>>>> VB2 was always broken, right?
>>>>
>>>> Correct. And not only gst 0.10, any userspace application that doesn't
>>>> specifically handles transient buffer underruns will be affected.
>>>>
>>>> vb2 doesn't conform to the V4L2 specification, and I believe the
>>>> specification is right in this case. Reverting this patch will push the
>>>> problem to userspace, where all applications will have to handle buffer
>>>> underruns manually.
>>>
>>> What happens with VB1? How is it solved there?
>>>
>>> I don't generally use gst 0.10, but I don't remember a single error
>>> report about gst 0.10 and VB1-based drivers.
>>
>> I haven't tried VB1, but a quick look at the source code shows it to be 
>> affected as well.
> 
> Well, from a quick look I did at VB1, when the device is not streaming,
> VB1 starts streaming, returning POLLERR only when stream start fails.
> 
> VB2, on the other hand, doesn't try to start streaming. That's likely
> what broke VBI applications when you added the condition to return
> POLLERR is vb2 is not streaming.

No, that's not the reason. VB1 tries to start streaming, yes, but it
wants to set that up for read() support (and that is something vb2 does
as well). I am certain that the start streaming in vb1 fails somewhere
because REQBUFS is already called and buffers are queued and so it just
sets POLLERR. If it would succeed you would never be able to use stream
I/O for vbi since q->reading would be true (i.e. streaming uses the
read() API).

Where exactly it fails in __videobuf_read_start I would have to debug,
as usual the vb1 control flow is a nightmare.

> 
> In other words, the VB2 equivalent to what VB1 does is:
> 
> 	if (!vb2_is_streaming(q))
> 		vb2_internal_streamon(q, type);

So this is certainly not what should happen in vb2.

Regards,

	Hans

> 
>         if (list_empty(&q->queued_list) && !vb2_is_streaming(q))
>                 return res | POLLERR;
> 
>> The problem with gst 0.10 is only noticeable when a buffer underrun occurs 
>> (when you don't requeue buffers fast enough and the queue buffers list becomes 
>> temporarily empty), so it can very well go unnoticed for a long time.
>>
>>>>> And with VB1, is it also broken? If so, then this is a Gst 0.10 bug,
>>>>> and the fix should be a patch for it, or a recommendation to upgrade
>>>>> to a newer version without such bug.
>>>>
>>>> As explained above, this isn't a gst bug.
>>>>
>>>>> If, otherwise, it works with VB1, then we need to patch VB2 to have
>>>>> exactly the same behavior as VB1 with that regards, as VBI works
>>>>> with VB1.
>>>>
>>>> One option would be to have implement a different poll behaviour for VBI
>>>> and video.
>>>
>>> That would be a nightmare.
>>
>> I don't like it much either. Hans has posted a proposal to fix the problem an 
>> hour ago, let's discuss it.
>>
> 
> Ok, I'll add my comments there.
> 
> PS.: I'm in a travel today, so unable to test or to do much comments.
> 
