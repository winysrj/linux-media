Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:55433 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727567AbeKPVrh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Nov 2018 16:47:37 -0500
Subject: Re: [PATCHv2 0/9] vb2/cedrus: add tag support
To: Tomasz Figa <tfiga@chromium.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        nicolas@ndufresne.ca
References: <20181114134743.18993-1-hverkuil@xs4all.nl>
 <CAAFQd5DUQQuJnMry7J4Eke_C-LPQRp+qNNT3JyvfHe5_2pwMEA@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <ecb91483-af8a-4741-c314-10ff9b80f103@xs4all.nl>
Date: Fri, 16 Nov 2018 12:35:34 +0100
MIME-Version: 1.0
In-Reply-To: <CAAFQd5DUQQuJnMry7J4Eke_C-LPQRp+qNNT3JyvfHe5_2pwMEA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/16/2018 10:00 AM, Tomasz Figa wrote:
> Hi Hans,
> 
> On Wed, Nov 14, 2018 at 10:47 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>
>> From: Hans Verkuil <hansverk@cisco.com>
>>
>> As was discussed here (among other places):
>>
>> https://lkml.org/lkml/2018/10/19/440
>>
>> using capture queue buffer indices to refer to reference frames is
>> not a good idea. A better idea is to use a 'tag' where the
>> application can assign a u64 tag to an output buffer, which is then
>> copied to the capture buffer(s) derived from the output buffer.
>>
> 
> Thanks for the patches. Please see my comments below.
> 
>> A u64 is chosen since this allows userspace to also use pointers to
>> internal structures as 'tag'.
>>
> 
> I think this is not true anymore in this version.

Ah, forgot to update the commit message.

> 
>> The first three patches add core tag support, the next patch document
>> the tag support, then a new helper function is added to v4l2-mem2mem.c
>> to easily copy data from a source to a destination buffer that drivers
>> can use.
>>
>> Next a new supports_tags vb2_queue flag is added to indicate that
>> the driver supports tags. Ideally this should not be necessary, but
>> that would require that all m2m drivers are converted to using the
>> new helper function introduced in the previous patch. That takes more
>> time then I have now since we want to get this in for 4.20.
>>
>> Finally the vim2m, vicodec and cedrus drivers are converted to support
>> tags.
>>
>> I also removed the 'pad' fields from the mpeg2 control structs (it
>> should never been added in the first place) and aligned the structs
>> to a u32 boundary (u64 for the tag values).
> 
> u32 in this version
> 
>>
>> Note that this might change further (Paul suggested using bitfields).
>>
>> Also note that the cedrus code doesn't set the sequence counter, that's
>> something that should still be added before this driver can be moved
>> out of staging.
>>
>> Note: if no buffer is found for a certain tag, then the dma address
>> is just set to 0. That happened before as well with invalid buffer
>> indices. This should be checked in the driver!
> 
> Note that DMA address 0 may as well be a valid address. Should we have
> another way of signaling that?

See this patch:

https://patchwork.linuxtv.org/patch/52975/

The memory of the reference buffer should be checked and the refcount
incremented in the request validate function.

Once that's done the dma address will be guaranteed to be OK.

This is missing functionality that is important to add.

> 
>>
>> The previous RFC series was tested successfully with the cedrus driver.
>>
>> Regards,
>>
>>         Hans
>>
>> Changes since v1:
>>
>> - changed to a u32 tag. Using a 64 bit tag was overly complicated due
>>   to the bad layout of the v4l2_buffer struct, and there is no real
>>   need for it by applications.
> 
> I hope these won't become famous last words. :) For Chromium it should
> be okay indeed.

The only 'feature' that is now missing is the ability to store pointers
as the tag. So worst case you need to do an extra lookup in the application.

> 
> Since we've been thinking about a redesign of the buffer struct,
> perhaps we can live with u32 for now and we can design the new struct
> to handle u64 nicely?

It could be done, but I'm not sure if it is a good idea to have
different behavior between v4l2_buffer and v4l2_ext_buffer.

Something to discuss at that time.

Regards,

	Hans

> 
> Best regards,
> Tomasz
> 
