Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:35431 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726678AbeJSToy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Oct 2018 15:44:54 -0400
Subject: Re: [PATCH 2/2] vicodec: Implement spec-compliant stop command
To: Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com
References: <20181018160841.17674-1-ezequiel@collabora.com>
 <20181018160841.17674-3-ezequiel@collabora.com>
 <b75076e1-075b-50eb-96ff-f7115168d2bd@xs4all.nl>
 <16ce7d348d553a91d8e52976c434952b4db0192c.camel@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <85909cfd-4b5b-a118-6936-2d290be0d91e@xs4all.nl>
Date: Fri, 19 Oct 2018 13:39:06 +0200
MIME-Version: 1.0
In-Reply-To: <16ce7d348d553a91d8e52976c434952b4db0192c.camel@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/19/18 13:35, Nicolas Dufresne wrote:
> Le vendredi 19 octobre 2018 à 09:28 +0200, Hans Verkuil a écrit :
>> On 10/18/2018 06:08 PM, Ezequiel Garcia wrote:
>>> Set up a statically-allocated, dummy buffer to
>>> be used as flush buffer, which signals
>>> a encoding (or decoding) stop.
>>>
>>> When the flush buffer is queued to the OUTPUT queue,
>>> the driver will send an V4L2_EVENT_EOS event, and
>>> mark the CAPTURE buffer with V4L2_BUF_FLAG_LAST.
>>
>> I'm confused. What is the current driver doing wrong? It is already
>> setting the LAST flag AFAIK. I don't see why a dummy buffer is
>> needed.
> 
> I'm not sure of this patch either. It seems to trigger the legacy
> "empty payload" buffer case. Driver should mark the last buffer, and
> then following poll should return EPIPE. Maybe it's the later that
> isn't respected ?

That would make more sense: vicodec doesn't set last_buffer_dequeued
to true in the vb2_queue, so you won't get EPIPE.

But that should be much easier to add.

Regards,

	Hans
