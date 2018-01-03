Return-path: <linux-media-owner@vger.kernel.org>
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:47389 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751140AbeACGHq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 3 Jan 2018 01:07:46 -0500
Subject: Re: [PATCH] uvcvideo: Apply flags from device to actual properties
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-media@vger.kernel.org
References: <ca483e75-4519-2bc3-eb11-db647fc60860@edgarthier.net>
 <7807bf0a-a0a1-65ad-1a10-3a3234e566e9@edgarthier.net>
 <1772347.19cENqiAhc@avalon> <4142585.lFnxXeD9HU@avalon>
From: Edgar Thier <info@edgarthier.net>
Message-ID: <c95024db-c6f8-f346-07f7-d99acf05cd00@edgarthier.net>
Date: Wed, 3 Jan 2018 07:07:44 +0100
MIME-Version: 1.0
In-Reply-To: <4142585.lFnxXeD9HU@avalon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Emmanuel,

>>> +	int flags = 0;
>>> +
>>> +	data = kmalloc(2, GFP_KERNEL);
> 
> Isn't 1 byte enough ?
> 

To quote from Kieran further up this thread:
>> kmalloc seems a bit of an overhead for 2 bytes (only one of which is used).
>> Can this use local stack storage?
>>
>> (Laurent, looks like you originally wrote the code that did that, was there a
>> reason for the kmalloc for 2 bytes?)
> Aha - OK, Just spoke with Laurent and - yes this is needed, as we can't DMA to
> the stack  - I hadn't realised the 'data' was being DMA'd ..

>>
>> All these are small issues. Let me try to address them, I'll send you an
>> updated patch shortly.

I'll be waiting.

Regards,

Edgar
