Return-Path: <SRS0=c0D3=QM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7E33C282D7
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 12:14:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9065520821
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 12:14:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728832AbfBEMOX (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Feb 2019 07:14:23 -0500
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:34387 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728138AbfBEMOW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 5 Feb 2019 07:14:22 -0500
Received: from [IPv6:2001:983:e9a7:1:2989:f759:211b:c8a5] ([IPv6:2001:983:e9a7:1:2989:f759:211b:c8a5])
        by smtp-cloud8.xs4all.net with ESMTPA
        id qzcFgPLMzNR5yqzcGgozXh; Tue, 05 Feb 2019 13:14:18 +0100
Subject: Re: [Xen-devel][PATCH v4 1/1] cameraif: add ABI for para-virtual
 camera
To:     Oleksandr Andrushchenko <andr2000@gmail.com>,
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
 <08d6da1b-f061-010c-abf8-865564c26d49@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <de3288c3-2f3a-152f-88f2-e8f2fe690493@xs4all.nl>
Date:   Tue, 5 Feb 2019 13:14:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <08d6da1b-f061-010c-abf8-865564c26d49@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfO5sObZjDT7wWH04hHMsToe6vhpTgMAzrIrLQ9b9UBmYmF5DPmefAft9bS7tjutNu5BOWF1RIlBM6yUpnSKS/L4b6he8Ih2KGPfPaBSPy0UMI+gTZY1C
 2K8xNjmA6txDd5n3AnAPAtIoprgPdET9OG/brs6ke3A6VMZIUd6u4HmbN8eA1ikbh+oV84dzgpOZgfahpj3S8D7EkkcRd7SVQl49mc6ah4t/v5WfycLDkPHb
 1gKEq/hSlA8Tiwp6/UiH3XHMofbvn6EHaF9qdMfF/E8L+EhAq7vw/D8qA2pmA9ePqh5DAdI1u40fdHDJeQr5iGvYExzIsGT9z5N2gBhXpuQPE/Qv3S+8Llv4
 YRCiLQRlLp/H0mKc6F1ANpRS+oMnjI1UGpR54q5njwl2o5FuvBzDLPqQaOTMVhFSyT49wbyz5vGNvsxl6rVQ006HHP8ye8USOgmZ6tqNAsz0+aoC6erLOKzK
 l6bh1Vs0fqS39ggwRcvQ6ZG12CRhb6xOZ+d61DkrjL7IVEFRV7DPZWR7mcChQxkaYrXJtItECufQ7nz9QCFyay970vA8rcG6QWnPjggBqCX9hbKdgAQEayLy
 XO+ZhBev5rwNseu+qopq6XF8
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/5/19 12:44 PM, Oleksandr Andrushchenko wrote:
> On 2/5/19 12:53 PM, Hans Verkuil wrote:
>> On 2/5/19 11:44 AM, Oleksandr Andrushchenko wrote:
>>> On 2/5/19 11:34 AM, Hans Verkuil wrote:
>>>> On 2/5/19 9:48 AM, Oleksandr Andrushchenko wrote:
>>>>> On 1/23/19 10:14 AM, Oleksandr Andrushchenko wrote:
>>>>>> Any comments from Xen community?
>>>>>> Konrad?
>>>>> While I am still looking forward to any comments from Xen community...
>>>>>> On 1/15/19 4:44 PM, Hans Verkuil wrote:
>>>>>>> Hi Oleksandr,
>>>>>>>
>>>>>>> Just two remaining comments:
>>>>>>>
>>>>>>> On 1/15/19 10:38 AM, Oleksandr Andrushchenko wrote:
>>>>>>>> From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
>>>>>>>>
>>>>>>>> This is the ABI for the two halves of a para-virtualized
>>>>>>>> camera driver which extends Xen's reach multimedia capabilities even
>>>>>>>> farther enabling it for video conferencing, In-Vehicle Infotainment,
>>>>>>>> high definition maps etc.
>>>>>>>>
>>>>>>>> The initial goal is to support most needed functionality with the
>>>>>>>> final idea to make it possible to extend the protocol if need be:
>>>>>>>>
>>>>>>>> 1. Provide means for base virtual device configuration:
>>>>>>>>      - pixel formats
>>>>>>>>      - resolutions
>>>>>>>>      - frame rates
>>>>>>>> 2. Support basic camera controls:
>>>>>>>>      - contrast
>>>>>>>>      - brightness
>>>>>>>>      - hue
>>>>>>>>      - saturation
>>>>>>>> 3. Support streaming control
>>>>>>>>
>>>>>>>> Signed-off-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
>>>>>>>> ---
>>>>>>>>      xen/include/public/io/cameraif.h | 1364 ++++++++++++++++++++++++++++++
>>>>>>>>      1 file changed, 1364 insertions(+)
>>>>>>>>      create mode 100644 xen/include/public/io/cameraif.h
>>>>>>>>
>>>>>>>> diff --git a/xen/include/public/io/cameraif.h b/xen/include/public/io/cameraif.h
>>>>>>>> new file mode 100644
>>>>>>>> index 000000000000..246eb2457f40
>>>>>>>> --- /dev/null
>>>>>>>> +++ b/xen/include/public/io/cameraif.h
>>>>>>>> @@ -0,0 +1,1364 @@
>>>>>>> <snip>
>>>>>>>
>>>>>>>> +/*
>>>>>>>> + ******************************************************************************
>>>>>>>> + *                                 EVENT CODES
>>>>>>>> + ******************************************************************************
>>>>>>>> + */
>>>>>>>> +#define XENCAMERA_EVT_FRAME_AVAIL      0x00
>>>>>>>> +#define XENCAMERA_EVT_CTRL_CHANGE      0x01
>>>>>>>> +
>>>>>>>> +/* Resolution has changed. */
>>>>>>>> +#define XENCAMERA_EVT_CFG_FLG_RESOL    (1 << 0)
>>>>>>> I think this flag is a left-over from v2 and should be removed.
>>>>>>>
>>>>>>> <snip>
>>>>>>>
>>>>>>>> + * Request number of buffers to be used:
>>>>>>>> + *         0                1                 2               3        octet
>>>>>>>> + * +----------------+----------------+----------------+----------------+
>>>>>>>> + * |               id                | _OP_BUF_REQUEST|   reserved     | 4
>>>>>>>> + * +----------------+----------------+----------------+----------------+
>>>>>>>> + * |                             reserved                              | 8
>>>>>>>> + * +----------------+----------------+----------------+----------------+
>>>>>>>> + * |    num_bufs    |                     reserved                     | 12
>>>>>>>> + * +----------------+----------------+----------------+----------------+
>>>>>>>> + * |                             reserved                              | 16
>>>>>>>> + * +----------------+----------------+----------------+----------------+
>>>>>>>> + * |/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/|
>>>>>>>> + * +----------------+----------------+----------------+----------------+
>>>>>>>> + * |                             reserved                              | 64
>>>>>>>> + * +----------------+----------------+----------------+----------------+
>>>>>>>> + *
>>>>>>>> + * num_bufs - uint8_t, desired number of buffers to be used. This is
>>>>>>>> + *   limited to the value configured in XenStore.max-buffers.
>>>>>>>> + *   Passing zero num_bufs in this request (after streaming has stopped
>>>>>>>> + *   and all buffers destroyed) unblocks camera configuration changes.
>>>>>>> I think the phrase 'unblocks camera configuration changes' is confusing.
>>>>>>>
>>>>>>> In v3 this sentence came after the third note below, and so it made sense
>>>>>>> in that context, but now the order has been reversed and it became hard to
>>>>>>> understand.
>>>>>>>
>>>>>>> I'm not sure what the best approach is to fix this. One option is to remove
>>>>>>> the third note and integrate it somehow in the sentence above. Or perhaps
>>>>>>> do away with the 'notes' at all and just write a more extensive documentation
>>>>>>> for this op. I leave that up to you.
>>>>> Hans, how about:
>>>>>
>>>>>    * num_bufs - uint8_t, desired number of buffers to be used.
>>>>>    *
>>>>>    * The number of buffers in this request must not exceed the value configured
>>>>>    * in XenStore.max-buffers. If the number of buffers is not zero then after this
>>>>>    * request the camera configuration cannot be changed. In order to allow camera
>>>>>    * (re)configuration this request must be sent with num_bufs set to zero and
>>>>>    * the streaming must be stopped and buffers destroyed.
>>>>>    * It is allowed for the frontend to send multiple XENCAMERA_OP_BUF_REQUEST
>>>>>    * requests before sending XENCAMERA_OP_STREAM_START request to update or
>>>>>    * tune the final configuration.
>>>>>    * Frontend is responsible for checking the corresponding response in order to
>>>>>    * see if the values reported back by the backend do match the desired ones
>>>>>    * and can be accepted.
>>>>>    *
>>>>>    * See response format for this request.
>>>>>    */
>>>> Hmm, it still is awkward. Part of the reason for that is that VIDIOC_REQBUFS
>>>> is just weird in that a value of 0 has a special meaning.
>>>>
>>>> Perhaps it would be much cleaner for the Xen implementation to just add a new
>>>> OP: _OP_FREE_ALL_BUFS (or perhaps _RELEASE_ALL_BUFS) that effectively does
>>>> VIDIOC_REQBUFS with a 0 count value. And this OP_BUF_REQUEST (wouldn't
>>>> OP_REQUEST_BUFS be a better name?)
>>> I have all operation categorized, e.g. there are commands
>>> for configuration (XENCAMERA_OP_CONFIG_XXX),
>>> buffer handling (XENCAMERA_OP_BUF_XXX) etc., so I prefer to
>>> keep the name as is.
>>>>    would then do nothing or return an error
>>>> if num_bufs == 0.
>>>>
>>>> If you don't want to create a new Xen op, then I would change the text some
>>>> more since you do not actually explain what the op does if num_bufs is 0.
>>> Well, I tend to keep this as is with no additional op.
>>>> I would write something like this:
>>>>
>>>> If num_bufs is greater than 0, then <describe what happens>.
>>>>
>>>> If num_bufs is equal to 0, then <describe what happens>.
>>>>
>>>> If num_bufs is not zero then after this request the camera configuration
>>>> cannot be changed. In order to allow camera (re)configuration this request
>>>> must be sent with num_bufs set to zero and the streaming must be stopped
>>>> and buffers destroyed.
>>> Next try:
>>>
>>>   * num_bufs - uint8_t, desired number of buffers to be used.
>>>   *
>>>   * If num_bufs is not zero then the backend validates the requested number of
>>>   * buffers and responds with the number of buffers allowed for this frontend.
>>>   * Frontend is responsible for checking the corresponding response in order to
>>>   * see if the values reported back by the backend do match the desired ones
>>>   * and can be accepted.
>>>   * Frontend is allowed to send multiple XENCAMERA_OP_BUF_REQUEST requests
>>>   * before sending XENCAMERA_OP_STREAM_START request to update or tune the
>>>   * final configuration.
>>>   * Frontend is not allowed to change the number of buffers and/or camera
>>>   * configuration after the streaming has started.
>> This all looks good.
> Great
>>>   *
>>>   * In order to allow camera (re)configuration this request must be sent with
>>>   * num_bufs set to zero and the streaming must be stopped and buffers destroyed.
>> You just say that if you want to reconfigure (and this only applies to reconfigure,
>> not to the initial configure step since then there are no buffers allocated yet),
>> then you need to call this with num_bufs == 0. But you don't explain what this op
>> does if num_bufs == 0!
>>
>> So before this sentence you need to add a description of what this op does if num_bufs
>> is 0, and change '(re)configuration' to 'reconfiguration'.
> Well, it is a good question. I already describe what happens if
> streaming has stopped and buffers destroyed and num_bufs == 0:
> this is a reconfiguration.
> 
> I also have a note that "Frontend is not allowed to change the
> number of buffers and/or camera configuration after the streaming
> has started.": this is the case that we cannot change the number of
> buffers during the streaming, e.g. one cannot send num_bufs == 0
> at this time.
> 
> So, what is not covered is that the streaming has never started,
> num_bufs has or has not been set to some value and now frontend
> requests num_bufs == 0?
> It seems that we can state that in this case backend does
> nothing or it may free any buffers if it has allocated any, so the
> tail reads as:
> 
>  * If num_bufs is 0 and streaming has not started yet, then the backend may
>  * free all previously allocated buffers (if any) or do nothing.

Much better. Now you actually explain what this op does if num_bufs == 0.

>  *
>  * If camera reconfiguration is required then this request must be sent with
>  * num_bufs set to zero and streaming must be stopped and buffers destroyed.

Shouldn't the order be to first stop streaming, then call this request with
num_bufs set to 0 and finally destroy the buffers?

Trying to call this if streaming is in progress will result in an error.
I think that should be documented as well.

Sorry for paying so much attention to this, but I think it is important that
this is documented precisely.

Regards,

	Hans

>  *
>  * Please note, that the number of buffers in this request must not exceed
>  * the value configured in XenStore.max-buffers.
>  *
>  * See response format for this request.
> 
>>
>> Regards,
>>
>>     Hans
>>
>>>   *
>>>   * Please note, that the number of buffers in this request must not exceed
>>>   * the value configured in XenStore.max-buffers.
>>>   *
>>>   * See response format for this request.
>>>
>>>> Regards,
>>>>
>>>>      Hans
>>>>
>>>>>>>> + *
>>>>>>>> + * See response format for this request.
>>>>>>>> + *
>>>>>>>> + * Notes:
>>>>>>>> + *  - frontend must check the corresponding response in order to see
>>>>>>>> + *    if the values reported back by the backend do match the desired ones
>>>>>>>> + *    and can be accepted.
>>>>>>>> + *  - frontend may send multiple XENCAMERA_OP_BUF_REQUEST requests before
>>>>>>>> + *    sending XENCAMERA_OP_STREAM_START request to update or tune the
>>>>>>>> + *    configuration.
>>>>>>>> + *  - after this request camera configuration cannot be changed, unless
>>>>>>> camera configuration -> the camera configuration
>>>>>>>
>>>>>>>> + *    streaming is stopped and buffers destroyed
>>>>>>>> + */
>>>>>>> Regards,
>>>>>>>
>>>>>>>       Hans
> 

