Return-Path: <SRS0=c0D3=QM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E275C282CB
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 11:45:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 317222080D
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 11:45:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GRqETzHb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbfBELpD (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Feb 2019 06:45:03 -0500
Received: from mail-lj1-f170.google.com ([209.85.208.170]:36721 "EHLO
        mail-lj1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbfBELpD (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Feb 2019 06:45:03 -0500
Received: by mail-lj1-f170.google.com with SMTP id g11-v6so2625578ljk.3
        for <linux-media@vger.kernel.org>; Tue, 05 Feb 2019 03:45:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=kpCm2GdzPkrkWw7R0VU0FrsFAqVJi8DvcvK37htJ6ps=;
        b=GRqETzHb40xgEaDx6eULaiDovLxHLLxZM93Fb4+m5NE9xqMcIYOLI+Oew4Y+1rZiXd
         i0/n/8vO0lmGhy3tkXufLA9vzLyUbfZAVXpNy/7V0O9AV5RAk1jTElKYuybZr1rr0pCJ
         eymbQvDHuiBpg9op25DYrd7D8LdOhy+9p7Zan1K/ovhW23HlfME9JGIQSiIWiujNcN39
         0yd4bI9WNjgrVtYsn8RM4c1tnZ63+wB2MtVT54q6PwbMZLYV/D0cExC1TDGksUFAVqGQ
         4ZJbbojeBPr4nIz6X36MfVwHqAxgqT5j6vGevpOgvfsU+TSqCCXEHrL9Uuqaz4VYfdxd
         cVug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=kpCm2GdzPkrkWw7R0VU0FrsFAqVJi8DvcvK37htJ6ps=;
        b=eut6SHD+HJj+X59EZ50uczDFKkIglGQcxze8YXh7oUNFYnDusrW/ac1o4SnaXSa+82
         ZQLx/qWsaWvb9D2fCrSZWwqL9uzSs//iPhJhMkRVAYqn+cW2c6JKEMdKshMlZYQQY5B8
         bFJ0ScZnrNhKZQxZMY79Wcb+YOtpCiY1Xg8DBj7WZIy+9rXrfqJhuBWiDhh32NcTYAT9
         D7gjO8ijUnu2pPBdXjXHn0VXGCAGnsrjfQBYjbuiAwhdvlkQtLvOGI4LoB6S/Yb9FFVx
         g62ykmX2wdL74m5mdkVCJOSHmmUrfVvoB+QnKyO5oI5LWKDMWINWu+XwWDkEL99VQbPS
         pDIQ==
X-Gm-Message-State: AHQUAuZ6O0ERinhvtL+HdArkmyVHle60Op1HFlC1dFlKzGjWTCoCa/hr
        M1oNU+78FdtqW0fCA5PsEEM=
X-Google-Smtp-Source: AHgI3IY6qX12gxYbnFjD652wZpOurCmy3AEO6AyJJh8JQuLE/DXpprUkbvz8K7XTRHKIQU05sLIvWQ==
X-Received: by 2002:a2e:4218:: with SMTP id p24-v6mr2644397lja.58.1549367100148;
        Tue, 05 Feb 2019 03:45:00 -0800 (PST)
Received: from [10.17.182.20] (ll-22.209.223.85.sovam.net.ua. [85.223.209.22])
        by smtp.gmail.com with ESMTPSA id u24sm3704404lfi.24.2019.02.05.03.44.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Feb 2019 03:44:59 -0800 (PST)
Subject: Re: [Xen-devel][PATCH v4 1/1] cameraif: add ABI for para-virtual
 camera
To:     Hans Verkuil <hverkuil@xs4all.nl>,
        "Oleksandr_Andrushchenko@epam.com" <Oleksandr_Andrushchenko@epam.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "jgross@suse.com" <jgross@suse.com>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "koji.matsuoka.xm@renesas.com" <koji.matsuoka.xm@renesas.com>
References: <20190115093853.15495-1-andr2000@gmail.com>
 <20190115093853.15495-2-andr2000@gmail.com>
 <393f824d-e543-476c-777f-402bcc1c0bcb@xs4all.nl>
 <1152536e-9238-4192-653e-b784b34b8a0d@epam.com>
 <d8476f24-1952-e822-aa75-b8a5f5d5a552@gmail.com>
 <e5bbde8f-ef5a-791a-a3aa-645c57ddcf82@xs4all.nl>
 <d26401fd-9e16-548e-cfa0-af488a701b59@gmail.com>
 <3ea2c5a1-b5a1-ba70-ade5-d14cc3aace66@xs4all.nl>
From:   Oleksandr Andrushchenko <andr2000@gmail.com>
Message-ID: <08d6da1b-f061-010c-abf8-865564c26d49@gmail.com>
Date:   Tue, 5 Feb 2019 13:44:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <3ea2c5a1-b5a1-ba70-ade5-d14cc3aace66@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/5/19 12:53 PM, Hans Verkuil wrote:
> On 2/5/19 11:44 AM, Oleksandr Andrushchenko wrote:
>> On 2/5/19 11:34 AM, Hans Verkuil wrote:
>>> On 2/5/19 9:48 AM, Oleksandr Andrushchenko wrote:
>>>> On 1/23/19 10:14 AM, Oleksandr Andrushchenko wrote:
>>>>> Any comments from Xen community?
>>>>> Konrad?
>>>> While I am still looking forward to any comments from Xen community...
>>>>> On 1/15/19 4:44 PM, Hans Verkuil wrote:
>>>>>> Hi Oleksandr,
>>>>>>
>>>>>> Just two remaining comments:
>>>>>>
>>>>>> On 1/15/19 10:38 AM, Oleksandr Andrushchenko wrote:
>>>>>>> From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
>>>>>>>
>>>>>>> This is the ABI for the two halves of a para-virtualized
>>>>>>> camera driver which extends Xen's reach multimedia capabilities even
>>>>>>> farther enabling it for video conferencing, In-Vehicle Infotainment,
>>>>>>> high definition maps etc.
>>>>>>>
>>>>>>> The initial goal is to support most needed functionality with the
>>>>>>> final idea to make it possible to extend the protocol if need be:
>>>>>>>
>>>>>>> 1. Provide means for base virtual device configuration:
>>>>>>>      - pixel formats
>>>>>>>      - resolutions
>>>>>>>      - frame rates
>>>>>>> 2. Support basic camera controls:
>>>>>>>      - contrast
>>>>>>>      - brightness
>>>>>>>      - hue
>>>>>>>      - saturation
>>>>>>> 3. Support streaming control
>>>>>>>
>>>>>>> Signed-off-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
>>>>>>> ---
>>>>>>>      xen/include/public/io/cameraif.h | 1364 ++++++++++++++++++++++++++++++
>>>>>>>      1 file changed, 1364 insertions(+)
>>>>>>>      create mode 100644 xen/include/public/io/cameraif.h
>>>>>>>
>>>>>>> diff --git a/xen/include/public/io/cameraif.h b/xen/include/public/io/cameraif.h
>>>>>>> new file mode 100644
>>>>>>> index 000000000000..246eb2457f40
>>>>>>> --- /dev/null
>>>>>>> +++ b/xen/include/public/io/cameraif.h
>>>>>>> @@ -0,0 +1,1364 @@
>>>>>> <snip>
>>>>>>
>>>>>>> +/*
>>>>>>> + ******************************************************************************
>>>>>>> + *                                 EVENT CODES
>>>>>>> + ******************************************************************************
>>>>>>> + */
>>>>>>> +#define XENCAMERA_EVT_FRAME_AVAIL      0x00
>>>>>>> +#define XENCAMERA_EVT_CTRL_CHANGE      0x01
>>>>>>> +
>>>>>>> +/* Resolution has changed. */
>>>>>>> +#define XENCAMERA_EVT_CFG_FLG_RESOL    (1 << 0)
>>>>>> I think this flag is a left-over from v2 and should be removed.
>>>>>>
>>>>>> <snip>
>>>>>>
>>>>>>> + * Request number of buffers to be used:
>>>>>>> + *         0                1                 2               3        octet
>>>>>>> + * +----------------+----------------+----------------+----------------+
>>>>>>> + * |               id                | _OP_BUF_REQUEST|   reserved     | 4
>>>>>>> + * +----------------+----------------+----------------+----------------+
>>>>>>> + * |                             reserved                              | 8
>>>>>>> + * +----------------+----------------+----------------+----------------+
>>>>>>> + * |    num_bufs    |                     reserved                     | 12
>>>>>>> + * +----------------+----------------+----------------+----------------+
>>>>>>> + * |                             reserved                              | 16
>>>>>>> + * +----------------+----------------+----------------+----------------+
>>>>>>> + * |/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/|
>>>>>>> + * +----------------+----------------+----------------+----------------+
>>>>>>> + * |                             reserved                              | 64
>>>>>>> + * +----------------+----------------+----------------+----------------+
>>>>>>> + *
>>>>>>> + * num_bufs - uint8_t, desired number of buffers to be used. This is
>>>>>>> + *   limited to the value configured in XenStore.max-buffers.
>>>>>>> + *   Passing zero num_bufs in this request (after streaming has stopped
>>>>>>> + *   and all buffers destroyed) unblocks camera configuration changes.
>>>>>> I think the phrase 'unblocks camera configuration changes' is confusing.
>>>>>>
>>>>>> In v3 this sentence came after the third note below, and so it made sense
>>>>>> in that context, but now the order has been reversed and it became hard to
>>>>>> understand.
>>>>>>
>>>>>> I'm not sure what the best approach is to fix this. One option is to remove
>>>>>> the third note and integrate it somehow in the sentence above. Or perhaps
>>>>>> do away with the 'notes' at all and just write a more extensive documentation
>>>>>> for this op. I leave that up to you.
>>>> Hans, how about:
>>>>
>>>>    * num_bufs - uint8_t, desired number of buffers to be used.
>>>>    *
>>>>    * The number of buffers in this request must not exceed the value configured
>>>>    * in XenStore.max-buffers. If the number of buffers is not zero then after this
>>>>    * request the camera configuration cannot be changed. In order to allow camera
>>>>    * (re)configuration this request must be sent with num_bufs set to zero and
>>>>    * the streaming must be stopped and buffers destroyed.
>>>>    * It is allowed for the frontend to send multiple XENCAMERA_OP_BUF_REQUEST
>>>>    * requests before sending XENCAMERA_OP_STREAM_START request to update or
>>>>    * tune the final configuration.
>>>>    * Frontend is responsible for checking the corresponding response in order to
>>>>    * see if the values reported back by the backend do match the desired ones
>>>>    * and can be accepted.
>>>>    *
>>>>    * See response format for this request.
>>>>    */
>>> Hmm, it still is awkward. Part of the reason for that is that VIDIOC_REQBUFS
>>> is just weird in that a value of 0 has a special meaning.
>>>
>>> Perhaps it would be much cleaner for the Xen implementation to just add a new
>>> OP: _OP_FREE_ALL_BUFS (or perhaps _RELEASE_ALL_BUFS) that effectively does
>>> VIDIOC_REQBUFS with a 0 count value. And this OP_BUF_REQUEST (wouldn't
>>> OP_REQUEST_BUFS be a better name?)
>> I have all operation categorized, e.g. there are commands
>> for configuration (XENCAMERA_OP_CONFIG_XXX),
>> buffer handling (XENCAMERA_OP_BUF_XXX) etc., so I prefer to
>> keep the name as is.
>>>    would then do nothing or return an error
>>> if num_bufs == 0.
>>>
>>> If you don't want to create a new Xen op, then I would change the text some
>>> more since you do not actually explain what the op does if num_bufs is 0.
>> Well, I tend to keep this as is with no additional op.
>>> I would write something like this:
>>>
>>> If num_bufs is greater than 0, then <describe what happens>.
>>>
>>> If num_bufs is equal to 0, then <describe what happens>.
>>>
>>> If num_bufs is not zero then after this request the camera configuration
>>> cannot be changed. In order to allow camera (re)configuration this request
>>> must be sent with num_bufs set to zero and the streaming must be stopped
>>> and buffers destroyed.
>> Next try:
>>
>>   * num_bufs - uint8_t, desired number of buffers to be used.
>>   *
>>   * If num_bufs is not zero then the backend validates the requested number of
>>   * buffers and responds with the number of buffers allowed for this frontend.
>>   * Frontend is responsible for checking the corresponding response in order to
>>   * see if the values reported back by the backend do match the desired ones
>>   * and can be accepted.
>>   * Frontend is allowed to send multiple XENCAMERA_OP_BUF_REQUEST requests
>>   * before sending XENCAMERA_OP_STREAM_START request to update or tune the
>>   * final configuration.
>>   * Frontend is not allowed to change the number of buffers and/or camera
>>   * configuration after the streaming has started.
> This all looks good.
Great
>>   *
>>   * In order to allow camera (re)configuration this request must be sent with
>>   * num_bufs set to zero and the streaming must be stopped and buffers destroyed.
> You just say that if you want to reconfigure (and this only applies to reconfigure,
> not to the initial configure step since then there are no buffers allocated yet),
> then you need to call this with num_bufs == 0. But you don't explain what this op
> does if num_bufs == 0!
>
> So before this sentence you need to add a description of what this op does if num_bufs
> is 0, and change '(re)configuration' to 'reconfiguration'.
Well, it is a good question. I already describe what happens if
streaming has stopped and buffers destroyed and num_bufs == 0:
this is a reconfiguration.

I also have a note that "Frontend is not allowed to change the
number of buffers and/or camera configuration after the streaming
has started.": this is the case that we cannot change the number of
buffers during the streaming, e.g. one cannot send num_bufs == 0
at this time.

So, what is not covered is that the streaming has never started,
num_bufs has or has not been set to some value and now frontend
requests num_bufs == 0?
It seems that we can state that in this case backend does
nothing or it may free any buffers if it has allocated any, so the
tail reads as:

  * If num_bufs is 0 and streaming has not started yet, then the backend may
  * free all previously allocated buffers (if any) or do nothing.
  *
  * If camera reconfiguration is required then this request must be sent 
with
  * num_bufs set to zero and streaming must be stopped and buffers 
destroyed.
  *
  * Please note, that the number of buffers in this request must not exceed
  * the value configured in XenStore.max-buffers.
  *
  * See response format for this request.

>
> Regards,
>
> 	Hans
>
>>   *
>>   * Please note, that the number of buffers in this request must not exceed
>>   * the value configured in XenStore.max-buffers.
>>   *
>>   * See response format for this request.
>>
>>> Regards,
>>>
>>>      Hans
>>>
>>>>>>> + *
>>>>>>> + * See response format for this request.
>>>>>>> + *
>>>>>>> + * Notes:
>>>>>>> + *  - frontend must check the corresponding response in order to see
>>>>>>> + *    if the values reported back by the backend do match the desired ones
>>>>>>> + *    and can be accepted.
>>>>>>> + *  - frontend may send multiple XENCAMERA_OP_BUF_REQUEST requests before
>>>>>>> + *    sending XENCAMERA_OP_STREAM_START request to update or tune the
>>>>>>> + *    configuration.
>>>>>>> + *  - after this request camera configuration cannot be changed, unless
>>>>>> camera configuration -> the camera configuration
>>>>>>
>>>>>>> + *    streaming is stopped and buffers destroyed
>>>>>>> + */
>>>>>> Regards,
>>>>>>
>>>>>>       Hans

