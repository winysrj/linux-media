Return-Path: <SRS0=c0D3=QM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8594CC282CB
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 12:30:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3199C2083B
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 12:30:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="idEj978L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727221AbfBEMao (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Feb 2019 07:30:44 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:37106 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbfBEMao (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Feb 2019 07:30:44 -0500
Received: by mail-lj1-f196.google.com with SMTP id t18-v6so2727959ljd.4
        for <linux-media@vger.kernel.org>; Tue, 05 Feb 2019 04:30:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=oCA+jJUgCsPMslv6Uos0OmNuevTfTV8l3yM/Xu4D5+g=;
        b=idEj978LSvZZN3Km5nZmFiPhOSOmcEZysO6XcX9rylkeQrEIUPU+4gt23UA2d0hGnI
         BStrWMTIhxV7xASAUkt2sTTUkQcRVzKaSMFkbVpcgnNARiuFb1a7pa7pOPJsUlgJJoa7
         MyJfWDpQQVO512vOWNOHDfykLW57eZ27D7x4N08hmlHoCnJ55qGUj1mLSLK+H0j6MBjx
         XIfbFsWnbq8K5UswNUqVNzRA2cAYUvMKmjqaQCKptoZaumLLwS2ymfa89Kq1nFk8VqVi
         lX4ef3HyBqD6i4U4iC5NSyA63A+zCGzhDFiFRjGwqxEHQarrfDXrL6VF8iwaDdt4pO7O
         J13w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=oCA+jJUgCsPMslv6Uos0OmNuevTfTV8l3yM/Xu4D5+g=;
        b=cc7xPnJvaEL2LwQAFbdpwiVRNZgaZo+oEH/13OkPa0J5UZtGlZBYnh8PGlGCXpC51K
         VZvWGL6CrHlWVXkUqhx9guxyh5COKlsZOyz3VfTEk9WN2Kyf5u7tb1H/5TukzRf6Rdp4
         AmlMuapf+OyOsG8hHMK9m0jz/PnAGYir9TPYvUtb/uHKy+IXU9LUXHHng3bZLlhzS6yT
         dadYiOQ2YpRv+zT1v1DcpX8UgZ3Te42isPy7Y8khp4R4EZ3j3c3AMyzP7m6Eu5wpHium
         K1/QyRyLuxQ048TsEgdzPdlWj6uxx9y/+U2RiUgH2QM+5LKXxGOg970xzAcjZV0R66Ke
         JU8A==
X-Gm-Message-State: AHQUAuYbV8AJQnCXCkNuEqpCddKBMCF6xLHdZIXaa6DhOPIqphMYnrRd
        mx4WJgsU0V5ryETTfC6rpN4=
X-Google-Smtp-Source: AHgI3IavuARJ2HCf83+tXElXB4atEje5JU2+EbWNRl+IewR9wlbYHNzRzAswuZPbvwMpP4PZGAVAZg==
X-Received: by 2002:a2e:8596:: with SMTP id b22-v6mr2835199lji.122.1549369841174;
        Tue, 05 Feb 2019 04:30:41 -0800 (PST)
Received: from [10.17.182.20] (ll-22.209.223.85.sovam.net.ua. [85.223.209.22])
        by smtp.gmail.com with ESMTPSA id q23sm3713530lfm.82.2019.02.05.04.30.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Feb 2019 04:30:40 -0800 (PST)
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
 <08d6da1b-f061-010c-abf8-865564c26d49@gmail.com>
 <de3288c3-2f3a-152f-88f2-e8f2fe690493@xs4all.nl>
From:   Oleksandr Andrushchenko <andr2000@gmail.com>
Message-ID: <474636e0-8059-7b75-8b48-a216c6defaf4@gmail.com>
Date:   Tue, 5 Feb 2019 14:30:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <de3288c3-2f3a-152f-88f2-e8f2fe690493@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/5/19 2:14 PM, Hans Verkuil wrote:
> On 2/5/19 12:44 PM, Oleksandr Andrushchenko wrote:
>> On 2/5/19 12:53 PM, Hans Verkuil wrote:
>>> On 2/5/19 11:44 AM, Oleksandr Andrushchenko wrote:
>>>> On 2/5/19 11:34 AM, Hans Verkuil wrote:
>>>>> On 2/5/19 9:48 AM, Oleksandr Andrushchenko wrote:
>>>>>> On 1/23/19 10:14 AM, Oleksandr Andrushchenko wrote:
>>>>>>> Any comments from Xen community?
>>>>>>> Konrad?
>>>>>> While I am still looking forward to any comments from Xen community...
>>>>>>> On 1/15/19 4:44 PM, Hans Verkuil wrote:
>>>>>>>> Hi Oleksandr,
>>>>>>>>
>>>>>>>> Just two remaining comments:
>>>>>>>>
>>>>>>>> On 1/15/19 10:38 AM, Oleksandr Andrushchenko wrote:
>>>>>>>>> From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
>>>>>>>>>
>>>>>>>>> This is the ABI for the two halves of a para-virtualized
>>>>>>>>> camera driver which extends Xen's reach multimedia capabilities even
>>>>>>>>> farther enabling it for video conferencing, In-Vehicle Infotainment,
>>>>>>>>> high definition maps etc.
>>>>>>>>>
>>>>>>>>> The initial goal is to support most needed functionality with the
>>>>>>>>> final idea to make it possible to extend the protocol if need be:
>>>>>>>>>
>>>>>>>>> 1. Provide means for base virtual device configuration:
>>>>>>>>>       - pixel formats
>>>>>>>>>       - resolutions
>>>>>>>>>       - frame rates
>>>>>>>>> 2. Support basic camera controls:
>>>>>>>>>       - contrast
>>>>>>>>>       - brightness
>>>>>>>>>       - hue
>>>>>>>>>       - saturation
>>>>>>>>> 3. Support streaming control
>>>>>>>>>
>>>>>>>>> Signed-off-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
>>>>>>>>> ---
>>>>>>>>>       xen/include/public/io/cameraif.h | 1364 ++++++++++++++++++++++++++++++
>>>>>>>>>       1 file changed, 1364 insertions(+)
>>>>>>>>>       create mode 100644 xen/include/public/io/cameraif.h
>>>>>>>>>
>>>>>>>>> diff --git a/xen/include/public/io/cameraif.h b/xen/include/public/io/cameraif.h
>>>>>>>>> new file mode 100644
>>>>>>>>> index 000000000000..246eb2457f40
>>>>>>>>> --- /dev/null
>>>>>>>>> +++ b/xen/include/public/io/cameraif.h
>>>>>>>>> @@ -0,0 +1,1364 @@
>>>>>>>> <snip>
>>>>>>>>
>>>>>>>>> +/*
>>>>>>>>> + ******************************************************************************
>>>>>>>>> + *                                 EVENT CODES
>>>>>>>>> + ******************************************************************************
>>>>>>>>> + */
>>>>>>>>> +#define XENCAMERA_EVT_FRAME_AVAIL      0x00
>>>>>>>>> +#define XENCAMERA_EVT_CTRL_CHANGE      0x01
>>>>>>>>> +
>>>>>>>>> +/* Resolution has changed. */
>>>>>>>>> +#define XENCAMERA_EVT_CFG_FLG_RESOL    (1 << 0)
>>>>>>>> I think this flag is a left-over from v2 and should be removed.
>>>>>>>>
>>>>>>>> <snip>
>>>>>>>>
>>>>>>>>> + * Request number of buffers to be used:
>>>>>>>>> + *         0                1                 2               3        octet
>>>>>>>>> + * +----------------+----------------+----------------+----------------+
>>>>>>>>> + * |               id                | _OP_BUF_REQUEST|   reserved     | 4
>>>>>>>>> + * +----------------+----------------+----------------+----------------+
>>>>>>>>> + * |                             reserved                              | 8
>>>>>>>>> + * +----------------+----------------+----------------+----------------+
>>>>>>>>> + * |    num_bufs    |                     reserved                     | 12
>>>>>>>>> + * +----------------+----------------+----------------+----------------+
>>>>>>>>> + * |                             reserved                              | 16
>>>>>>>>> + * +----------------+----------------+----------------+----------------+
>>>>>>>>> + * |/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/|
>>>>>>>>> + * +----------------+----------------+----------------+----------------+
>>>>>>>>> + * |                             reserved                              | 64
>>>>>>>>> + * +----------------+----------------+----------------+----------------+
>>>>>>>>> + *
>>>>>>>>> + * num_bufs - uint8_t, desired number of buffers to be used. This is
>>>>>>>>> + *   limited to the value configured in XenStore.max-buffers.
>>>>>>>>> + *   Passing zero num_bufs in this request (after streaming has stopped
>>>>>>>>> + *   and all buffers destroyed) unblocks camera configuration changes.
>>>>>>>> I think the phrase 'unblocks camera configuration changes' is confusing.
>>>>>>>>
>>>>>>>> In v3 this sentence came after the third note below, and so it made sense
>>>>>>>> in that context, but now the order has been reversed and it became hard to
>>>>>>>> understand.
>>>>>>>>
>>>>>>>> I'm not sure what the best approach is to fix this. One option is to remove
>>>>>>>> the third note and integrate it somehow in the sentence above. Or perhaps
>>>>>>>> do away with the 'notes' at all and just write a more extensive documentation
>>>>>>>> for this op. I leave that up to you.
>>>>>> Hans, how about:
>>>>>>
>>>>>>     * num_bufs - uint8_t, desired number of buffers to be used.
>>>>>>     *
>>>>>>     * The number of buffers in this request must not exceed the value configured
>>>>>>     * in XenStore.max-buffers. If the number of buffers is not zero then after this
>>>>>>     * request the camera configuration cannot be changed. In order to allow camera
>>>>>>     * (re)configuration this request must be sent with num_bufs set to zero and
>>>>>>     * the streaming must be stopped and buffers destroyed.
>>>>>>     * It is allowed for the frontend to send multiple XENCAMERA_OP_BUF_REQUEST
>>>>>>     * requests before sending XENCAMERA_OP_STREAM_START request to update or
>>>>>>     * tune the final configuration.
>>>>>>     * Frontend is responsible for checking the corresponding response in order to
>>>>>>     * see if the values reported back by the backend do match the desired ones
>>>>>>     * and can be accepted.
>>>>>>     *
>>>>>>     * See response format for this request.
>>>>>>     */
>>>>> Hmm, it still is awkward. Part of the reason for that is that VIDIOC_REQBUFS
>>>>> is just weird in that a value of 0 has a special meaning.
>>>>>
>>>>> Perhaps it would be much cleaner for the Xen implementation to just add a new
>>>>> OP: _OP_FREE_ALL_BUFS (or perhaps _RELEASE_ALL_BUFS) that effectively does
>>>>> VIDIOC_REQBUFS with a 0 count value. And this OP_BUF_REQUEST (wouldn't
>>>>> OP_REQUEST_BUFS be a better name?)
>>>> I have all operation categorized, e.g. there are commands
>>>> for configuration (XENCAMERA_OP_CONFIG_XXX),
>>>> buffer handling (XENCAMERA_OP_BUF_XXX) etc., so I prefer to
>>>> keep the name as is.
>>>>>     would then do nothing or return an error
>>>>> if num_bufs == 0.
>>>>>
>>>>> If you don't want to create a new Xen op, then I would change the text some
>>>>> more since you do not actually explain what the op does if num_bufs is 0.
>>>> Well, I tend to keep this as is with no additional op.
>>>>> I would write something like this:
>>>>>
>>>>> If num_bufs is greater than 0, then <describe what happens>.
>>>>>
>>>>> If num_bufs is equal to 0, then <describe what happens>.
>>>>>
>>>>> If num_bufs is not zero then after this request the camera configuration
>>>>> cannot be changed. In order to allow camera (re)configuration this request
>>>>> must be sent with num_bufs set to zero and the streaming must be stopped
>>>>> and buffers destroyed.
>>>> Next try:
>>>>
>>>>    * num_bufs - uint8_t, desired number of buffers to be used.
>>>>    *
>>>>    * If num_bufs is not zero then the backend validates the requested number of
>>>>    * buffers and responds with the number of buffers allowed for this frontend.
>>>>    * Frontend is responsible for checking the corresponding response in order to
>>>>    * see if the values reported back by the backend do match the desired ones
>>>>    * and can be accepted.
>>>>    * Frontend is allowed to send multiple XENCAMERA_OP_BUF_REQUEST requests
>>>>    * before sending XENCAMERA_OP_STREAM_START request to update or tune the
>>>>    * final configuration.
>>>>    * Frontend is not allowed to change the number of buffers and/or camera
>>>>    * configuration after the streaming has started.
>>> This all looks good.
>> Great
>>>>    *
>>>>    * In order to allow camera (re)configuration this request must be sent with
>>>>    * num_bufs set to zero and the streaming must be stopped and buffers destroyed.
>>> You just say that if you want to reconfigure (and this only applies to reconfigure,
>>> not to the initial configure step since then there are no buffers allocated yet),
>>> then you need to call this with num_bufs == 0. But you don't explain what this op
>>> does if num_bufs == 0!
>>>
>>> So before this sentence you need to add a description of what this op does if num_bufs
>>> is 0, and change '(re)configuration' to 'reconfiguration'.
>> Well, it is a good question. I already describe what happens if
>> streaming has stopped and buffers destroyed and num_bufs == 0:
>> this is a reconfiguration.
>>
>> I also have a note that "Frontend is not allowed to change the
>> number of buffers and/or camera configuration after the streaming
>> has started.": this is the case that we cannot change the number of
>> buffers during the streaming, e.g. one cannot send num_bufs == 0
>> at this time.
>>
>> So, what is not covered is that the streaming has never started,
>> num_bufs has or has not been set to some value and now frontend
>> requests num_bufs == 0?
>> It seems that we can state that in this case backend does
>> nothing or it may free any buffers if it has allocated any, so the
>> tail reads as:
>>
>>   * If num_bufs is 0 and streaming has not started yet, then the backend may
>>   * free all previously allocated buffers (if any) or do nothing.
> Much better. Now you actually explain what this op does if num_bufs == 0.
>
>>   *
>>   * If camera reconfiguration is required then this request must be sent with
>>   * num_bufs set to zero and streaming must be stopped and buffers destroyed.
> Shouldn't the order be to first stop streaming, then call this request with
> num_bufs set to 0 and finally destroy the buffers?
Yes, I meant that, but this does need to be more clear:
  * If camera reconfiguration is required then the streaming must be stopped
  * and this request must be sent with num_bufs set to zero and finally
  * buffers destroyed.

>
> Trying to call this if streaming is in progress will result in an error.
> I think that should be documented as well.
Sure
>
> Sorry for paying so much attention to this, but I think it is important that
> this is documented precisely.
Thank you for helping with this - your comments are really
important and make the description precise. Ok, so finally:

  * num_bufs - uint8_t, desired number of buffers to be used.
  *
  * If num_bufs is not zero then the backend validates the requested 
number of
  * buffers and responds with the number of buffers allowed for this 
frontend.
  * Frontend is responsible for checking the corresponding response in 
order to
  * see if the values reported back by the backend do match the desired ones
  * and can be accepted.
  * Frontend is allowed to send multiple XENCAMERA_OP_BUF_REQUEST requests
  * before sending XENCAMERA_OP_STREAM_START request to update or tune the
  * final configuration.
  * Frontend is not allowed to change the number of buffers and/or camera
  * configuration after the streaming has started.
  *
  * If num_bufs is 0 and streaming has not started yet, then the backend may
  * free all previously allocated buffers (if any) or do nothing.
  * Trying to call this if streaming is in progress will result in an error.
  *
  * If camera reconfiguration is required then the streaming must be stopped
  * and this request must be sent with num_bufs set to zero and finally
  * buffers destroyed.
  *
  * Please note, that the number of buffers in this request must not exceed
  * the value configured in XenStore.max-buffers.
  *
  * See response format for this request.

> Regards,
>
> 	Hans
Thank you,
Oleksandr
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
>>>>    *
>>>>    * Please note, that the number of buffers in this request must not exceed
>>>>    * the value configured in XenStore.max-buffers.
>>>>    *
>>>>    * See response format for this request.
>>>>
>>>>> Regards,
>>>>>
>>>>>       Hans
>>>>>
>>>>>>>>> + *
>>>>>>>>> + * See response format for this request.
>>>>>>>>> + *
>>>>>>>>> + * Notes:
>>>>>>>>> + *  - frontend must check the corresponding response in order to see
>>>>>>>>> + *    if the values reported back by the backend do match the desired ones
>>>>>>>>> + *    and can be accepted.
>>>>>>>>> + *  - frontend may send multiple XENCAMERA_OP_BUF_REQUEST requests before
>>>>>>>>> + *    sending XENCAMERA_OP_STREAM_START request to update or tune the
>>>>>>>>> + *    configuration.
>>>>>>>>> + *  - after this request camera configuration cannot be changed, unless
>>>>>>>> camera configuration -> the camera configuration
>>>>>>>>
>>>>>>>>> + *    streaming is stopped and buffers destroyed
>>>>>>>>> + */
>>>>>>>> Regards,
>>>>>>>>
>>>>>>>>        Hans

