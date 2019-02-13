Return-Path: <SRS0=D6oO=QU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77715C282C2
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 12:11:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38A57222AE
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 12:11:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aCR7BC+m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726372AbfBMMLk (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Feb 2019 07:11:40 -0500
Received: from mail-lf1-f54.google.com ([209.85.167.54]:43388 "EHLO
        mail-lf1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726095AbfBMMLk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Feb 2019 07:11:40 -0500
Received: by mail-lf1-f54.google.com with SMTP id j1so1573222lfb.10
        for <linux-media@vger.kernel.org>; Wed, 13 Feb 2019 04:11:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=33zF/4braOReHDnEd29PdliUk/tCyVcWDQeW37vq2ug=;
        b=aCR7BC+m9wKc4iPf52f1yTV+6cl4ZowxcpVRHADQmh/czWV7vFXO7iLsMG0fUDJ+EP
         AeHX9xE1b1Kz4kT/UUtc/0Oq8igLkXxRKbHlh+uCrg2zYKK092UG63l/eh3IFK97a9D0
         8HGLkvBrm2sHNyrAf1GNErQTZP/FB7fueOnrHu5rWwF7SHe4b+FegGEb58FDqPFF3v/5
         SoW+bfiiH+EC/Z/MWzfzWsSimho3LGwHeirXHhVnsdVJ90Tcva9eDTfQs9thcV1QYxV1
         GOk15WKfqDdWexhTBI57eEAzOXfdQoCYjJuWpM7Q0U61b7pwl0yX44Kr/LPe/Ab0p0ef
         Uzow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=33zF/4braOReHDnEd29PdliUk/tCyVcWDQeW37vq2ug=;
        b=t5ddqIYnEZeYe0LxZsIxUfHCYNsLjZvvlgeCDMoq0nDvyXJN+DxnPJa6BFG+omaOzW
         uFZ9jAfLTHISgx6qOHUp7sjidqAQtNGR3Cu5ZBGqomWvaUAt5AsFf1L8DedLuoptwCF6
         vbrrRwJr0Q9HBIjePyvlly8jcOlPFs11IrY+nTxYzlgk0bMzmyLMQYhmpFD8RMuE19Pc
         9EOWsv4Z1eR8t4+jg0pf2J7VoRlEXy35UKLviudLu6fIMk09k4paa6mhOSY0MCQBjIOB
         P3clUg9zDnX9gJBasN5nQUYDBV+wJNfDD47G1iaVGlWrZRHzG5h9o7Mx2pzK3EL1wSJn
         c32g==
X-Gm-Message-State: AHQUAuZdXj5Hy+2aG3ClNSoE+hfIh/DiUT9vsfKXhFyFShF3nXNdARVt
        jEX9eNZWja60ReATE9S2RXM=
X-Google-Smtp-Source: AHgI3IYUG9esqByEAOQEKMPw6zbbml/KTggZ/AQQw9SKaJUT0rhh3iotQmZOJChL79m/kf0aqyGbxQ==
X-Received: by 2002:a19:7613:: with SMTP id c19mr99591lff.103.1550059897050;
        Wed, 13 Feb 2019 04:11:37 -0800 (PST)
Received: from [10.17.182.20] (ll-22.209.223.85.sovam.net.ua. [85.223.209.22])
        by smtp.gmail.com with ESMTPSA id 199sm1861448lfa.38.2019.02.13.04.11.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 Feb 2019 04:11:36 -0800 (PST)
Subject: Re: [Xen-devel][PATCH v4 1/1] cameraif: add ABI for para-virtual
 camera
To:     "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
References: <20190115093853.15495-1-andr2000@gmail.com>
 <20190115093853.15495-2-andr2000@gmail.com>
 <393f824d-e543-476c-777f-402bcc1c0bcb@xs4all.nl>
 <1152536e-9238-4192-653e-b784b34b8a0d@epam.com>
Cc:     Oleksandr Andrushchenko <Oleksandr_Andrushchenko@epam.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "jgross@suse.com" <jgross@suse.com>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "koji.matsuoka.xm@renesas.com" <koji.matsuoka.xm@renesas.com>,
        Artem Mygaiev <Artem_Mygaiev@epam.com>
From:   Oleksandr Andrushchenko <andr2000@gmail.com>
Message-ID: <8b81f1f5-491c-084a-a2b4-b07a48f0d612@gmail.com>
Date:   Wed, 13 Feb 2019 14:11:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1152536e-9238-4192-653e-b784b34b8a0d@epam.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Konrad, could you please review? So, I can send v5 with Hans'
comments addressed

Thank you,
Oleksandr

On 1/23/19 10:14 AM, Oleksandr Andrushchenko wrote:
> Any comments from Xen community?
> Konrad?
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
>>
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

