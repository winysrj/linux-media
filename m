Return-Path: <SRS0=c0D3=QM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3227C282CB
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 08:48:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A7182054F
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 08:48:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oXWawnlK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbfBEIsw (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Feb 2019 03:48:52 -0500
Received: from mail-lj1-f182.google.com ([209.85.208.182]:45687 "EHLO
        mail-lj1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725898AbfBEIsw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Feb 2019 03:48:52 -0500
Received: by mail-lj1-f182.google.com with SMTP id s5-v6so2140595ljd.12
        for <linux-media@vger.kernel.org>; Tue, 05 Feb 2019 00:48:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=e0g+bo75yBjuQ2T9RTAqlte5/N0gl85lnZ9mOMQMw3o=;
        b=oXWawnlKqehNUj9wmsy8LtNSCATrIWba1Y4W5VK3v+DIYpzyhsDKu2EkNxKgQ0augG
         fjHJ0bT5cU0+7fXDEUKh9EOsZapaCvAXHk4BKtorF0/goCcACmI1wgyQBP+WNKKWsFvP
         Anqh5OZLUEXHzg6bwRJDdTKVM1Mj6OWRoMDQOYgITyhmS5WC/iP6XMVq2KIYlcDcjLUr
         zLnWh9Y7+ZYd/DFx4FEtrR93KCzz4/MLkimjKTm6HY0fLkOP9AVq5XaAtmUTS3513JWW
         uX9laEHVKQS6OiHVOwsyzIBHjmsZndkXEkBs0dWyJzO8B8Q7OhtAXnQbcAsnF0d7Qgtz
         CefQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=e0g+bo75yBjuQ2T9RTAqlte5/N0gl85lnZ9mOMQMw3o=;
        b=K0z0btA2B+HWRUTKvw11vm8P4eL4ufgz0JULtVbSW7cGvbwEyLq+DqhwKliFCIUSwh
         MwV394uaZkitXg876a5WguUEKxwaCblkkC1tBiGxQS5mzKN+zMnTproK+dEsx0vGe7/+
         Qb8PgmuzihQKxSc94RHPSUKm3dkunwl6qLeonHw7rRiEG6Oe+yFjfZieE4RWDOCL3lzz
         CiyEhHxZsRRTFn2IeXM2p0izj6auyWyTzYfuuHk0oxRUzFJIVUqNTyuBMZMocRoqxUN8
         KkgU6YChk4T0uB8tgWk3mTZkHw/nOUwRanSHsFOXzDhi+eN08kydSnHiAFpL1Wgw5vPN
         +DfQ==
X-Gm-Message-State: AHQUAuaO0XqFgluqr+xQjpoeBLVAW+IfXaAOzFIvo+sFVnDR6qThI/3V
        w6C1gSHvZgkp1uKcHPzan6U=
X-Google-Smtp-Source: AHgI3Ia/8RuZVXozHuTZ5P6tvRKC0uTbMnWfMCaxBOOtRBDr0yh6dyodYoqVbS0kSQ+XdWNzjvEqVA==
X-Received: by 2002:a2e:8007:: with SMTP id j7-v6mr2251215ljg.50.1549356530043;
        Tue, 05 Feb 2019 00:48:50 -0800 (PST)
Received: from [10.17.182.20] (ll-22.209.223.85.sovam.net.ua. [85.223.209.22])
        by smtp.gmail.com with ESMTPSA id y23-v6sm3169910ljk.95.2019.02.05.00.48.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Feb 2019 00:48:49 -0800 (PST)
Subject: Re: [Xen-devel][PATCH v4 1/1] cameraif: add ABI for para-virtual
 camera
To:     Oleksandr Andrushchenko <Oleksandr_Andrushchenko@epam.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
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
From:   Oleksandr Andrushchenko <andr2000@gmail.com>
Message-ID: <d8476f24-1952-e822-aa75-b8a5f5d5a552@gmail.com>
Date:   Tue, 5 Feb 2019 10:48:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1152536e-9238-4192-653e-b784b34b8a0d@epam.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 1/23/19 10:14 AM, Oleksandr Andrushchenko wrote:
> Any comments from Xen community?
> Konrad?
While I am still looking forward to any comments from Xen community...
>
> On 1/15/19 4:44 PM, Hans Verkuil wrote:
>> Hi Oleksandr,
>>
>> Just two remaining comments:
>>
>> On 1/15/19 10:38 AM, Oleksandr Andrushchenko wrote:
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
>>>    - pixel formats
>>>    - resolutions
>>>    - frame rates
>>> 2. Support basic camera controls:
>>>    - contrast
>>>    - brightness
>>>    - hue
>>>    - saturation
>>> 3. Support streaming control
>>>
>>> Signed-off-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
>>> ---
>>>    xen/include/public/io/cameraif.h | 1364 ++++++++++++++++++++++++++++++
>>>    1 file changed, 1364 insertions(+)
>>>    create mode 100644 xen/include/public/io/cameraif.h
>>>
>>> diff --git a/xen/include/public/io/cameraif.h b/xen/include/public/io/cameraif.h
>>> new file mode 100644
>>> index 000000000000..246eb2457f40
>>> --- /dev/null
>>> +++ b/xen/include/public/io/cameraif.h
>>> @@ -0,0 +1,1364 @@
>> <snip>
>>
>>> +/*
>>> + ******************************************************************************
>>> + *                                 EVENT CODES
>>> + ******************************************************************************
>>> + */
>>> +#define XENCAMERA_EVT_FRAME_AVAIL      0x00
>>> +#define XENCAMERA_EVT_CTRL_CHANGE      0x01
>>> +
>>> +/* Resolution has changed. */
>>> +#define XENCAMERA_EVT_CFG_FLG_RESOL    (1 << 0)
>> I think this flag is a left-over from v2 and should be removed.
>>
>> <snip>
>>
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
>>> + * num_bufs - uint8_t, desired number of buffers to be used. This is
>>> + *   limited to the value configured in XenStore.max-buffers.
>>> + *   Passing zero num_bufs in this request (after streaming has stopped
>>> + *   and all buffers destroyed) unblocks camera configuration changes.
>> I think the phrase 'unblocks camera configuration changes' is confusing.
>>
>> In v3 this sentence came after the third note below, and so it made sense
>> in that context, but now the order has been reversed and it became hard to
>> understand.
>>
>> I'm not sure what the best approach is to fix this. One option is to remove
>> the third note and integrate it somehow in the sentence above. Or perhaps
>> do away with the 'notes' at all and just write a more extensive documentation
>> for this op. I leave that up to you.
Hans, how about:

  * num_bufs - uint8_t, desired number of buffers to be used.
  *
  * The number of buffers in this request must not exceed the value 
configured
  * in XenStore.max-buffers. If the number of buffers is not zero then 
after this
  * request the camera configuration cannot be changed. In order to 
allow camera
  * (re)configuration this request must be sent with num_bufs set to 
zero and
  * the streaming must be stopped and buffers destroyed.
  * It is allowed for the frontend to send multiple XENCAMERA_OP_BUF_REQUEST
  * requests before sending XENCAMERA_OP_STREAM_START request to update or
  * tune the final configuration.
  * Frontend is responsible for checking the corresponding response in 
order to
  * see if the values reported back by the backend do match the desired ones
  * and can be accepted.
  *
  * See response format for this request.
  */

>>> + *
>>> + * See response format for this request.
>>> + *
>>> + * Notes:
>>> + *  - frontend must check the corresponding response in order to see
>>> + *    if the values reported back by the backend do match the desired ones
>>> + *    and can be accepted.
>>> + *  - frontend may send multiple XENCAMERA_OP_BUF_REQUEST requests before
>>> + *    sending XENCAMERA_OP_STREAM_START request to update or tune the
>>> + *    configuration.
>>> + *  - after this request camera configuration cannot be changed, unless
>> camera configuration -> the camera configuration
>>
>>> + *    streaming is stopped and buffers destroyed
>>> + */
>> Regards,
>>
>> 	Hans

