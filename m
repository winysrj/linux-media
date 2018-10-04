Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33079 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727407AbeJEBVX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2018 21:21:23 -0400
Received: by mail-wr1-f67.google.com with SMTP id e4-v6so11003962wrs.0
        for <linux-media@vger.kernel.org>; Thu, 04 Oct 2018 11:26:55 -0700 (PDT)
Subject: Re: [PATCH v3 00/14] imx-media: Fixes for interlaced capture
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
References: <1533150747-30677-1-git-send-email-steve_longerbeam@mentor.com>
 <db3940a6-d837-9b6a-1f1e-122dda1e1650@xs4all.nl>
 <0701dea4-f3b7-fda9-0dd0-f717a868991d@gmail.com>
 <fcfade70-b5c2-7ce2-ab04-1471e61eedd4@xs4all.nl>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <79e24ed6-080c-6259-84a0-baf4a8e42d0f@gmail.com>
Date: Thu, 4 Oct 2018 11:26:50 -0700
MIME-Version: 1.0
In-Reply-To: <fcfade70-b5c2-7ce2-ab04-1471e61eedd4@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 10/04/2018 06:41 AM, Hans Verkuil wrote:
> On 10/04/18 01:21, Steve Longerbeam wrote:
>> Hi Hans,
>>
>>
>> On 10/01/2018 03:07 AM, Hans Verkuil wrote:
>>> Hi Steve,
>>>
>>> On 08/01/2018 09:12 PM, Steve Longerbeam wrote:
>>>> A set of patches that fixes some bugs with capturing from an
>>>> interlaced source, and incompatibilites between IDMAC interlace
>>>> interweaving and 4:2:0 data write reduction.
>>> I reviewed this series and it looks fine to me.
>> Cool.
>>
>>> It appears that the ipu* patches are already merged, so can you rebase and
>>> repost?
>> Done. There are still two ipu* patches that still need a merge:
>>
>> gpu: ipu-csi: Swap fields according to input/output field types
>> gpu: ipu-v3: Add planar support to interlaced scan
>>
>> so those will still be included in the v4 submission.
>>
>>> I would also like to see the 'v4l2-compliance -f' for an interlaced source,
>>> if at all possible.
>> Sure, I've run 'v4l2-compliance -f' on two configured pipelines: unprocessed
>> capture (no scaling, CSC, rotation using ipu), and a VDIC de-interlace
>> pipeline.
>>
>> I have the text output, the output is huge but here is the abbreviated
>> results:
>>
>> Unprocessed pipeline:
>>
>> root@mx6q:/home/fu# v4l2-compliance -d4 -f
>> v4l2-compliance SHA   : 2d35de61ac90b030fe15439809b807014e9751fe
>> <snip>
>> test VIDIOC_G/S/ENUMINPUT: FAIL
>> <snip>
>> test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: FAIL
> This looks like something that should work. Not relevant for this patch
> series, but something you should look into.

Yes, I've been meaning to implement (UN)SUBSCRIBE_EVENT/DQEVENT
at the capture interface. I'll send a patch soon.

>
>> <snip>
>>
>> Total: 715, Succeeded: 713, Failed: 2, Warnings: 0
>>
>>
>> VDIC de-interlace pipeline:
>>
>> root@mx6q:/home/fu# v4l2-compliance -d1 -f
>> v4l2-compliance SHA   : 2d35de61ac90b030fe15439809b807014e9751fe
>> <snip>
>> test VIDIOC_G/S/ENUMINPUT: FAIL
>> <snip>
>> test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: FAIL
>> <snip>
>> test VIDIOC_G/S_PARM: FAIL
> Same here: this appears to be an actual bug. But also not related to this
> patch series.

It's because the capture interface passes vidioc_[gs]_parm down to its
connected source subdevice as [gs]_frame_interval, which in this case
is PRPVF, which just accepts whatever frame interval is requested. Not
sure why v4l2-compliance reports an error, but perhaps [gs]_frame_interval
should be chained, until it reaches a subdevice that actually cares about
frame intervals (in this case CSI and VDIC), similar to how [gs]_stream is
chained. Anyway something else to look at later.

Steve
