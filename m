Return-Path: <SRS0=ZIWa=RP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0473C43381
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 10:09:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCC6C214AF
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 10:09:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725917AbfCLKJN (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 06:09:13 -0400
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:56098 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725872AbfCLKJM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 06:09:12 -0400
Received: from [IPv6:2001:420:44c1:2579:40b3:7335:3138:6a0] ([IPv6:2001:420:44c1:2579:40b3:7335:3138:6a0])
        by smtp-cloud9.xs4all.net with ESMTPA
        id 3eLIhD6MFI8AW3eLLhZn0B; Tue, 12 Mar 2019 11:09:10 +0100
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
 <27235a93-3896-6353-9665-15dd701cf634@xs4all.nl>
 <e5c8e820-8867-c77a-8902-9e0ea9275082@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <2689ce24-0ac0-206f-bd5a-64dddb0a6b10@xs4all.nl>
Date:   Tue, 12 Mar 2019 11:09:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <e5c8e820-8867-c77a-8902-9e0ea9275082@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfOvRy68RGovdeL3nRe2kZ0RimNnwiaiG+U2VHSgiivpNJ6YdrosiKTzSpxu9kKm8zeK2dD6rWGa4fZxYRKzVOIGl0JC2xZSor51qzrkxwmcgHlcoq7fe
 Lu5e76rDVHkYULNhlxtVEGnVMKfyKQXJdPGVjoHaEOPjxPQAyalyO3+PbBpzW5LpGuecsc5HPgrnUL8TIwrpHwouwt/YSnNN73ZTDAy0q39kcyKih2UdPka2
 iNudGXDpRfBrwrldgUNKnYnJBj8L74tZ/nirXvWupXtPaCj6PRYptOrzHio8cs3a/i2pptMGXjezkjItHfyq+81NnoBdZfyHN3HxuQD5lRU/8+WQWpwuT/ZX
 1wLAkpzCuzPXi+xIGCEwIAjsEccHIAGm7WO9C5W4iFGuI25zvBOOR8ihGFyxFQ3cdqcldt7k8i5Ap7iKICmb39LIrL1iC/eAI2zFjqjphsnSkgA3nId9Cl+J
 1LsFeMheiuavp21vp6RFMdcGrf5XirTEnxoM1PWPAlXJuj6ONTJqO+9PDOAH53gLcEUqp5zwCA5MH/rvNvhspBwAv1wyI/JI3/MoyvuRKGW19XvHbAy5/VFN
 kzp14MqyA4CChNqRQKaIwFroga2cVE/aGiY0DVX0itOXOA==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 3/12/19 10:35 AM, Oleksandr Andrushchenko wrote:
> On 3/12/19 11:30 AM, Hans Verkuil wrote:
>> On 3/12/19 10:08 AM, Oleksandr Andrushchenko wrote:
>>> On 3/12/19 10:58 AM, Hans Verkuil wrote:
>>>> Hi Oleksandr,
>>>>
>>>> Just one comment:
>>>>
>>>> On 3/12/19 9:20 AM, Oleksandr Andrushchenko wrote:
>>>>> From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
>>>>>
>>>>> This is the ABI for the two halves of a para-virtualized
>>>>> camera driver which extends Xen's reach multimedia capabilities even
>>>>> farther enabling it for video conferencing, In-Vehicle Infotainment,
>>>>> high definition maps etc.
>>>>>
>>>>> The initial goal is to support most needed functionality with the
>>>>> final idea to make it possible to extend the protocol if need be:
>>>>>
>>>>> 1. Provide means for base virtual device configuration:
>>>>>    - pixel formats
>>>>>    - resolutions
>>>>>    - frame rates
>>>>> 2. Support basic camera controls:
>>>>>    - contrast
>>>>>    - brightness
>>>>>    - hue
>>>>>    - saturation
>>>>> 3. Support streaming control
>>>>>
>>>>> Signed-off-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
>>>>> ---
>>>>>    xen/include/public/io/cameraif.h | 1370 ++++++++++++++++++++++++++++++
>>>>>    1 file changed, 1370 insertions(+)
>>>>>    create mode 100644 xen/include/public/io/cameraif.h
>>>>>
>>>>> diff --git a/xen/include/public/io/cameraif.h b/xen/include/public/io/cameraif.h
>>>>> new file mode 100644
>>>>> index 000000000000..1ae4c51ea758
>>>>> --- /dev/null
>>>>> +++ b/xen/include/public/io/cameraif.h
>>>>> @@ -0,0 +1,1370 @@
>>>> <snip>
>>>>
>>>>> +/*
>>>>> + * Request camera buffer's layout:
>>>>> + *         0                1                 2               3        octet
>>>>> + * +----------------+----------------+----------------+----------------+
>>>>> + * |               id                | _BUF_GET_LAYOUT|   reserved     | 4
>>>>> + * +----------------+----------------+----------------+----------------+
>>>>> + * |                             reserved                              | 8
>>>>> + * +----------------+----------------+----------------+----------------+
>>>>> + * |/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/|
>>>>> + * +----------------+----------------+----------------+----------------+
>>>>> + * |                             reserved                              | 64
>>>>> + * +----------------+----------------+----------------+----------------+
>>>>> + *
>>>>> + * See response format for this request.
>>>>> + *
>>>>> + *
>>>>> + * Request number of buffers to be used:
>>>>> + *         0                1                 2               3        octet
>>>>> + * +----------------+----------------+----------------+----------------+
>>>>> + * |               id                | _OP_BUF_REQUEST|   reserved     | 4
>>>>> + * +----------------+----------------+----------------+----------------+
>>>>> + * |                             reserved                              | 8
>>>>> + * +----------------+----------------+----------------+----------------+
>>>>> + * |    num_bufs    |                     reserved                     | 12
>>>>> + * +----------------+----------------+----------------+----------------+
>>>>> + * |                             reserved                              | 16
>>>>> + * +----------------+----------------+----------------+----------------+
>>>>> + * |/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/|
>>>>> + * +----------------+----------------+----------------+----------------+
>>>>> + * |                             reserved                              | 64
>>>>> + * +----------------+----------------+----------------+----------------+
>>>>> + *
>>>>> + * num_bufs - uint8_t, desired number of buffers to be used.
>>>>> + *
>>>>> + * If num_bufs is not zero then the backend validates the requested number of
>>>>> + * buffers and responds with the number of buffers allowed for this frontend.
>>>>> + * Frontend is responsible for checking the corresponding response in order to
>>>>> + * see if the values reported back by the backend do match the desired ones
>>>>> + * and can be accepted.
>>>>> + * Frontend is allowed to send multiple XENCAMERA_OP_BUF_REQUEST requests
>>>>> + * before sending XENCAMERA_OP_STREAM_START request to update or tune the
>>>>> + * final configuration.
>>>>> + * Frontend is not allowed to change the number of buffers and/or camera
>>>>> + * configuration after the streaming has started.
>>>> This last sentence isn't quite right, and I missed that when reviewing the
>>>> proposed text during the v4 discussions.
>>>>
>>>> The bit about not being allowed to change the number of buffers when streaming
>>>> has started is correct.
>>>>
>>>> But the camera configuration is more strict: you can't change the camera
>>>> configuration after this request unless you call this again with num_bufs = 0.
>>>>
>>>> The camera configuration changes the buffer size, so once the buffers are
>>>> allocated you can no longer change the camera config. It is unrelated to streaming.
>>> Can you please give me a hint of what would be the right thing to put in?
>> How about this:
>>
>> Frontend is not allowed to change the camera configuration after this call with
>> a non-zero value of num_bufs. If camera reconfiguration is required then this
>> request must be sent with num_bufs set to zero and any created buffers must be
>> destroyed first.
>>
>> Frontend is not allowed to change the number of buffers after the streaming has started.
> Sounds great, so I'll replace:
> 
> "Frontend is not allowed to change the number of buffers and/or camera
>   configuration after the streaming has started."
> 
> with:
> 
> "Frontend is not allowed to change the camera configuration after this 
> call with
>   a non-zero value of num_bufs. If camera reconfiguration is required 
> then this
>   request must be sent with num_bufs set to zero and any created buffers 
> must be
>   destroyed first.
> 
>   Frontend is not allowed to change the number of buffers after the 
> streaming has started.
> "
> 
> Are these all the changes you see at the moment?

Also this change below...

>>>>> + *
>>>>> + * If num_bufs is 0 and streaming has not started yet, then the backend will
>>>>> + * free all previously allocated buffers (if any).
>>>>> + * Trying to call this if streaming is in progress will result in an error.
>>>>> + *
>>>>> + * If camera reconfiguration is required then the streaming must be stopped
>>>>> + * and this request must be sent with num_bufs set to zero and finally
>>>>> + * buffers destroyed.
>> I would rewrite the last part as well:
>>
>> ...set to zero and any created buffers must be destroyed.

^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

And note my note below :-)

>>
>>
>> Note that "any created buffers must be destroyed" is something that you need to
>> check for in your code if I am not mistaken.

^^^^^^^^^^^^^^^^^

Regards,

	Hans
