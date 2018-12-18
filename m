Return-Path: <SRS0=J9mZ=O3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4A33C43387
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 15:13:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CF4521873
	for <linux-media@archiver.kernel.org>; Tue, 18 Dec 2018 15:13:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbeLRPNR (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 18 Dec 2018 10:13:17 -0500
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:46675 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726546AbeLRPNR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Dec 2018 10:13:17 -0500
Received: from [IPv6:2001:983:e9a7:1:fde7:94a4:18d3:95d6] ([IPv6:2001:983:e9a7:1:fde7:94a4:18d3:95d6])
        by smtp-cloud8.xs4all.net with ESMTPA
        id ZH3ZgFHJjeA2FZH3agOqJd; Tue, 18 Dec 2018 16:13:15 +0100
Subject: Re: [PATCHv5 6/8] vb2: add vb2_find_timestamp()
To:     Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc:     Alexandre Courbot <acourbot@chromium.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        =?UTF-8?Q?Jernej_=c5=a0krabec?= <jernej.skrabec@gmail.com>
References: <20181212123901.34109-1-hverkuil-cisco@xs4all.nl>
 <20181212123901.34109-7-hverkuil-cisco@xs4all.nl>
 <AM0PR03MB4676988BC60352DFDFAD0783ACA70@AM0PR03MB4676.eurprd03.prod.outlook.com>
 <985a4c64-f914-8405-2a78-422bcd8f2139@xs4all.nl>
 <d1be50c07d19713a7813e5fed4b88e56d4d106e8.camel@bootlin.com>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Message-ID: <e7c4c9f9-a724-f872-fb2d-db38edff76f9@xs4all.nl>
Date:   Tue, 18 Dec 2018 16:13:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <d1be50c07d19713a7813e5fed4b88e56d4d106e8.camel@bootlin.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfOxhsj+php2WGwFQuIxFaC1GQRswr1tTg/VJxIk8b2mjlMHfRFKSwuAEQYgtloWwAjOltbGOBYbFiEjU7lcss8PyvGatdjspV/0RJWOxzC1TzpyVCUu5
 4RtWY6U5tiZRbMqwHASVgY4qahi/vO4fJtweSO2TaxXELLf54SEoJ3A3UVAZLdRiUKL21fDdnwEd5Zd7q9s7NxxvEGWOs9s01Ff9DrXQJ1o1uqGJ1B7WecPd
 Rs56jwNOQp5O/7oIn2qdxccXGwk9ZFVSyYpYv/1ZfFE44ZgB0xqzKrNF1BOvguW8wTBrHXAIjmDyl4ZkuXsuKrfuQqS9Qo85DRjAP9n1/nphLXFk/urGXfS2
 TTsu+5oCqiUHCtrmAEytu6b+nvMOCS01PgyPUM9s5ZxxUc1zUpJtUy9/sUFbOauYh71kVWPO9v2kdiAJEgaZwo8YM+0jE2lw+BMT+/WLVWH5CUlyI3Yb2Uwc
 JtLCbDr6aGbO0j9c2FVoFnFxD6X8q7J5pnpKMOwRE/IiPWLh7hgfrnXr64LCx/806iCYGs6sdeTf/VxlWjmupgvTLPrpcSz8XCP1dw==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 12/18/18 3:21 PM, Paul Kocialkowski wrote:
> Hi,
> 
> On Thu, 2018-12-13 at 13:28 +0100, Hans Verkuil wrote:
>> On 12/12/18 7:28 PM, Jonas Karlman wrote:
>>> Hi Hans,
>>>
>>> Since this function only return DEQUEUED and DONE buffers,
>>> it cannot be used to find a capture buffer that is both used for
>>> frame output and is part of the frame reference list.
>>> E.g. a bottom field referencing a top field that is already
>>> part of the capture buffer being used for frame output.
>>> (top and bottom field is output in same buffer)
>>>
>>> Jernej Škrabec and me have worked around this issue in cedrus driver by
>>> first checking
>>> the tag/timestamp of the current buffer being used for output frame.
>>>
>>>
>>> // field pictures may reference current capture buffer and is not
>>> returned by vb2_find_tag
>>> if (v4l2_buf->tag == dpb->tag)
>>>     buf_idx = v4l2_buf->vb2_buf.index;
>>> else
>>>     buf_idx = vb2_find_tag(cap_q, dpb->tag, 0);
>>>
>>>
>>> What is the recommended way to handle such case?
>>
>> That is the right approach for this. Interesting corner case, I hadn't
>> considered that.
>>
>>> Could vb2_find_timestamp be extended to allow QUEUED buffers to be returned?
>>
>> No, because only the driver knows what the current buffer is.
>>
>> Buffers that are queued to the driver are in state ACTIVE. But there may be
>> multiple ACTIVE buffers and vb2 doesn't know which buffer is currently
>> being processed by the driver.
>>
>> So this will have to be checked by the driver itself.
> 
> Interesting corner case indeed, we hadn't considered the possibility of
> interlaced pictures refeering to the current capture buffer.
> 
> Hans, do you want to include that change in a future revision of this
> series or should that be a separate follow-up patch?
> 
> I'm fine with both options (and could definitely craft the change in
> the latter case).

If you can make a separate patch for this, then that would be great!

Regards,

	Hans

> 
> Cheers,
> 
> Paul
> 
>>> In our sample code we only keep at most one output, one capture buffer
>>> in queue
>>> and use buffer indices as tag/timestamp to simplify buffer handling.
>>> FFmpeg keeps track of buffers/frames referenced and a buffer will not be
>>> reused
>>> until the codec and display pipeline have released all references to it.
>>>
>>> Sample code having interlaced and multi-slice support using previous tag
>>> version of this patchset can be found at:
>>> https://github.com/jernejsk/LibreELEC.tv/blob/hw_dec_ffmpeg/projects/Allwinner/patches/linux/0025-H264-fixes.patch#L120-L124
>>> https://github.com/Kwiboo/FFmpeg/compare/4.0.3-Leia-Beta5...v4l2-request-hwaccel
>>>
>>> Regards,
>>> Jonas

