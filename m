Return-Path: <SRS0=ZIWa=RP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90E57C43381
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 09:30:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6097E2171F
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 09:30:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726409AbfCLJaX (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 05:30:23 -0400
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:54725 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725832AbfCLJaT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 05:30:19 -0400
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud8.xs4all.net with ESMTPA
        id 3djghZJ6m4HFn3djjhImwl; Tue, 12 Mar 2019 10:30:16 +0100
Subject: Re: [Xen-devel][PATCH v5 1/1] cameraif: add ABI for para-virtual
 camera
To:     Oleksandr Andrushchenko <andr2000@gmail.com>,
        "Oleksandr_Andrushchenko@epam.com" <Oleksandr_Andrushchenko@epam.com>,
        xen-devel@lists.xenproject.org, konrad.wilk@oracle.com,
        jgross@suse.com, boris.ostrovsky@oracle.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        koji.matsuoka.xm@renesas.com
References: <20190312082000.32181-1-andr2000@gmail.com>
 <20190312082000.32181-2-andr2000@gmail.com>
 <82d683f9-72a6-f806-33fd-294da10c95f9@xs4all.nl>
 <fd07546d-50a2-fb10-6f37-7f96acf0ce40@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <27235a93-3896-6353-9665-15dd701cf634@xs4all.nl>
Date:   Tue, 12 Mar 2019 10:30:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <fd07546d-50a2-fb10-6f37-7f96acf0ce40@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfO7p3rzjEuWT2aH/hY0h78XIWlfoZQ9j6wbW248jHi6+a3GFJ5BMPlTomOVGy+2J277WThwnBOUc7e9FpfebRJU7CPKljI8ceUhmI+eu2mfT/2kxSFYT
 yonjA4lzBsVdbDWsT3LTeWA/Sk53bvDeYUsO3vS9fZv+5GLe9GYXIgpLM1KVnhgOF193AKqlR0E/KuYgUW8szuk2cmcuX94ZMHt2Td/UhykAjq5BZBvpyTJY
 wGmO1M+plzj8VZ9tbpz8D24+hGK9b/Q1ESm1HO/J72LtDEsf4faT76FZyTH7KTslTp8rNIuLU1gjhyshQQTN7WqL0UiqAn5OMhpQ0Lp0wES5V+FWqBq/DppV
 oSejsvVyto4sSVDtw308BzAqaqyQ7/rTzaa2kv8MkDo6b4kmRNjKnj8YG/wIXgEOaailQzkRwHIXsbOIoNuO4rJgvXOgdokaMlJJKxnSz2PMIlWQOjQlSt0u
 PSG4OxLX7SErWL2MnVul45ZEAamnKLfWBI8YpYAm6WrGpk3BDR2fremBYrw=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 3/12/19 10:08 AM, Oleksandr Andrushchenko wrote:
> On 3/12/19 10:58 AM, Hans Verkuil wrote:
>> Hi Oleksandr,
>>
>> Just one comment:
>>
>> On 3/12/19 9:20 AM, Oleksandr Andrushchenko wrote:
>>> From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
>>>
>>> This is the ABI for the two halves of a para-virtualized
>>> camera driver which extends Xen's reach multimedia capabilities even
>>> farther enabling it for video conferencing, In-Vehicle Infotainment,
>>> high definition maps etc.
>>>
>>> The initial goal is to support most needed functionality with the
>>> final idea to make it possible to extend the protocol if need be:
>>>
>>> 1. Provide means for base virtual device configuration:
>>>   - pixel formats
>>>   - resolutions
>>>   - frame rates
>>> 2. Support basic camera controls:
>>>   - contrast
>>>   - brightness
>>>   - hue
>>>   - saturation
>>> 3. Support streaming control
>>>
>>> Signed-off-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
>>> ---
>>>   xen/include/public/io/cameraif.h | 1370 ++++++++++++++++++++++++++++++
>>>   1 file changed, 1370 insertions(+)
>>>   create mode 100644 xen/include/public/io/cameraif.h
>>>
>>> diff --git a/xen/include/public/io/cameraif.h b/xen/include/public/io/cameraif.h
>>> new file mode 100644
>>> index 000000000000..1ae4c51ea758
>>> --- /dev/null
>>> +++ b/xen/include/public/io/cameraif.h
>>> @@ -0,0 +1,1370 @@
>> <snip>
>>
>>> +/*
>>> + * Request camera buffer's layout:
>>> + *         0                1                 2               3        octet
>>> + * +----------------+----------------+----------------+----------------+
>>> + * |               id                | _BUF_GET_LAYOUT|   reserved     | 4
>>> + * +----------------+----------------+----------------+----------------+
>>> + * |                             reserved                              | 8
>>> + * +----------------+----------------+----------------+----------------+
>>> + * |/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/|
>>> + * +----------------+----------------+----------------+----------------+
>>> + * |                             reserved                              | 64
>>> + * +----------------+----------------+----------------+----------------+
>>> + *
>>> + * See response format for this request.
>>> + *
>>> + *
>>> + * Request number of buffers to be used:
>>> + *         0                1                 2               3        octet
>>> + * +----------------+----------------+----------------+----------------+
>>> + * |               id                | _OP_BUF_REQUEST|   reserved     | 4
>>> + * +----------------+----------------+----------------+----------------+
>>> + * |                             reserved                              | 8
>>> + * +----------------+----------------+----------------+----------------+
>>> + * |    num_bufs    |                     reserved                     | 12
>>> + * +----------------+----------------+----------------+----------------+
>>> + * |                             reserved                              | 16
>>> + * +----------------+----------------+----------------+----------------+
>>> + * |/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/|
>>> + * +----------------+----------------+----------------+----------------+
>>> + * |                             reserved                              | 64
>>> + * +----------------+----------------+----------------+----------------+
>>> + *
>>> + * num_bufs - uint8_t, desired number of buffers to be used.
>>> + *
>>> + * If num_bufs is not zero then the backend validates the requested number of
>>> + * buffers and responds with the number of buffers allowed for this frontend.
>>> + * Frontend is responsible for checking the corresponding response in order to
>>> + * see if the values reported back by the backend do match the desired ones
>>> + * and can be accepted.
>>> + * Frontend is allowed to send multiple XENCAMERA_OP_BUF_REQUEST requests
>>> + * before sending XENCAMERA_OP_STREAM_START request to update or tune the
>>> + * final configuration.
>>> + * Frontend is not allowed to change the number of buffers and/or camera
>>> + * configuration after the streaming has started.
>> This last sentence isn't quite right, and I missed that when reviewing the
>> proposed text during the v4 discussions.
>>
>> The bit about not being allowed to change the number of buffers when streaming
>> has started is correct.
>>
>> But the camera configuration is more strict: you can't change the camera
>> configuration after this request unless you call this again with num_bufs = 0.
>>
>> The camera configuration changes the buffer size, so once the buffers are
>> allocated you can no longer change the camera config. It is unrelated to streaming.
> Can you please give me a hint of what would be the right thing to put in?

How about this:

Frontend is not allowed to change the camera configuration after this call with
a non-zero value of num_bufs. If camera reconfiguration is required then this
request must be sent with num_bufs set to zero and any created buffers must be
destroyed first.

Frontend is not allowed to change the number of buffers after the streaming has started.


> 
> Thank you,
> Oleksandr
>> Regards,
>>
>> 	Hans
>>
>>> + *
>>> + * If num_bufs is 0 and streaming has not started yet, then the backend will
>>> + * free all previously allocated buffers (if any).
>>> + * Trying to call this if streaming is in progress will result in an error.
>>> + *
>>> + * If camera reconfiguration is required then the streaming must be stopped
>>> + * and this request must be sent with num_bufs set to zero and finally
>>> + * buffers destroyed.

I would rewrite the last part as well:

...set to zero and any created buffers must be destroyed.


Note that "any created buffers must be destroyed" is something that you need to
check for in your code if I am not mistaken.

Regards,

	Hans

>>> + *
>>> + * Please note, that the number of buffers in this request must not exceed
>>> + * the value configured in XenStore.max-buffers.
>>> + *
>>> + * See response format for this request.
>>> + */
>> <snip>
>>
>> Regards,
>>
>> 	Hans
> 

