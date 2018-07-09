Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:52419 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754474AbeGINrm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Jul 2018 09:47:42 -0400
Subject: Re: [PATCHv5 11/12] media-ioc-enum-links.rst: improve pad index
 description
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hansverk@cisco.com>
References: <20180629114331.7617-1-hverkuil@xs4all.nl>
 <20180629114331.7617-12-hverkuil@xs4all.nl> <3247616.pqdvV2kJkN@avalon>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <6c1e215e-c3b9-c294-23a8-31a5395c2720@xs4all.nl>
Date: Mon, 9 Jul 2018 15:47:39 +0200
MIME-Version: 1.0
In-Reply-To: <3247616.pqdvV2kJkN@avalon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/07/18 15:10, Laurent Pinchart wrote:
> Hi Hans,
> 
> Thank you for the patch.
> 
> On Friday, 29 June 2018 14:43:30 EEST Hans Verkuil wrote:
>> From: Hans Verkuil <hansverk@cisco.com>
>>
>> Make it clearer that the index starts at 0, and that it won't change
>> since future new pads will be added at the end.
>>
>> Signed-off-by: Hans Verkuil <hansverk@cisco.com>
>> ---
>>  Documentation/media/uapi/mediactl/media-ioc-enum-links.rst | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst
>> b/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst index
>> 17abdeed1a9c..4cceeb8a6f73 100644
>> --- a/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst
>> +++ b/Documentation/media/uapi/mediactl/media-ioc-enum-links.rst
>> @@ -92,7 +92,9 @@ returned during the enumeration process.
>>
>>      *  -  __u16
>>         -  ``index``
>> -       -  0-based pad index.
>> +       -  Pad index, starts at 0. Pad indices are stable. If new pads are
>> added
>> +	  for an entity in the future, then those will be added at the end of the
>> +	  entity's pad array.
> 
> Is that true strictly speaking ? We do mandate pad indices to be stable, but 
> couldn't new pads still be inserted in the array ? The array wouldn't be 
> sorted by pad index anymore, but I don't think we require that. If we want to 
> I don't have any objection, but it should then be documented.

You are right, you might have two pads with indices 0 and 3, then add a new pad
at index 2. As long as existing pad indices remain stable (i.e. are never renumbered)
you are fine.

I'll rephrase this.

Regards,

	Hans

> 
>>      *  -  __u32
>>         -  ``flags``
> 
