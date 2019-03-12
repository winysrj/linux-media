Return-Path: <SRS0=ZIWa=RP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 130B2C43381
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 09:08:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA946214D8
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 09:08:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pqif1X/T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbfCLJIO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 05:08:14 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:45391 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726873AbfCLJIN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 05:08:13 -0400
Received: by mail-lf1-f68.google.com with SMTP id f16so1419902lfk.12
        for <linux-media@vger.kernel.org>; Tue, 12 Mar 2019 02:08:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=6Um35BuARJEFcJpPIWq5bCgPYMRYQdc/THhKVPmiCVc=;
        b=pqif1X/TmSpGgCvCSEV8LgV5WNQELBQrC7JPWvx93J2UKErjwADjVozCk7P0r7WiIH
         7dVIupUneo+1xf7EloA7J2djIcKMCS+zGbAlUYdGh6DmWCMdlCaLr2Gs7G35066T8Nkz
         9/9TPvfLcbZ1I8Dq5Fnyawwj/Ol6Pd5WIMVG3GzWzNafRzD84+5cbNqB5ItQYrbrSegy
         1NSG20nEqswrh6bTrA/BTU4lT/mC4fk0x9ybF68O6Sz4QI40M2/QWux06XMBjMu9pbnR
         p9N4jApvr3P4zQExxMozKZ5UppRjm1YKmi1L62k0wwlbW8XXJji+yw4r/r9Ramt0j/+C
         bNpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=6Um35BuARJEFcJpPIWq5bCgPYMRYQdc/THhKVPmiCVc=;
        b=BunXyzEHCuhqSPu8DbRWd/Rdf9i2QeaS5Ap2BrekZinG6OyqMdGra9NwIXFybNDEJI
         QSfoS2q8f+YHeEbQbtQwvdYC8TFM3Sxv+WONhYLQJcK1YXEObpXW6cYCJpS18uT20OVK
         7vkY40wx0yJc1e8nXpToXB/TH+u9TMlz+glZ2aqDckvS9HC2WRETw3GqS7gx25ztbpJe
         6B2zcme70Zk8ESG75C2SOOSEPxiUkaCeisEXPJ9HUQKuITQLnFahVPyS7HJfvrLAGYuw
         R5kfe1GujUlVVK3VN+ZMAf8CDv51OzFEh4S7CO76poY9znijTTlZw5JjpErh6MfCbcCp
         0gkQ==
X-Gm-Message-State: APjAAAVIfZnxQIHhShn3Di7DxOy8Rdyn+AOcyWSyt03kQcXrksxcD7Td
        sdjxct8J2pe6K0RaDddCNFs7F5Va
X-Google-Smtp-Source: APXvYqxmQE7UhcFEhKKymX2UZ2QiJy93GF4srFcwQFp+N282lCO6HVfapyAk5+RCL1LtytZTASqoGQ==
X-Received: by 2002:a19:f707:: with SMTP id z7mr7889293lfe.61.1552381691110;
        Tue, 12 Mar 2019 02:08:11 -0700 (PDT)
Received: from [10.17.182.20] (ll-22.209.223.85.sovam.net.ua. [85.223.209.22])
        by smtp.gmail.com with ESMTPSA id d75sm106397lfd.87.2019.03.12.02.08.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Mar 2019 02:08:10 -0700 (PDT)
Subject: Re: [Xen-devel][PATCH v5 1/1] cameraif: add ABI for para-virtual
 camera
To:     Hans Verkuil <hverkuil@xs4all.nl>,
        "Oleksandr_Andrushchenko@epam.com" <Oleksandr_Andrushchenko@epam.com>,
        xen-devel@lists.xenproject.org, konrad.wilk@oracle.com,
        jgross@suse.com, boris.ostrovsky@oracle.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        koji.matsuoka.xm@renesas.com
References: <20190312082000.32181-1-andr2000@gmail.com>
 <20190312082000.32181-2-andr2000@gmail.com>
 <82d683f9-72a6-f806-33fd-294da10c95f9@xs4all.nl>
From:   Oleksandr Andrushchenko <andr2000@gmail.com>
Message-ID: <fd07546d-50a2-fb10-6f37-7f96acf0ce40@gmail.com>
Date:   Tue, 12 Mar 2019 11:08:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <82d683f9-72a6-f806-33fd-294da10c95f9@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 3/12/19 10:58 AM, Hans Verkuil wrote:
> Hi Oleksandr,
>
> Just one comment:
>
> On 3/12/19 9:20 AM, Oleksandr Andrushchenko wrote:
>> From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
>>
>> This is the ABI for the two halves of a para-virtualized
>> camera driver which extends Xen's reach multimedia capabilities even
>> farther enabling it for video conferencing, In-Vehicle Infotainment,
>> high definition maps etc.
>>
>> The initial goal is to support most needed functionality with the
>> final idea to make it possible to extend the protocol if need be:
>>
>> 1. Provide means for base virtual device configuration:
>>   - pixel formats
>>   - resolutions
>>   - frame rates
>> 2. Support basic camera controls:
>>   - contrast
>>   - brightness
>>   - hue
>>   - saturation
>> 3. Support streaming control
>>
>> Signed-off-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
>> ---
>>   xen/include/public/io/cameraif.h | 1370 ++++++++++++++++++++++++++++++
>>   1 file changed, 1370 insertions(+)
>>   create mode 100644 xen/include/public/io/cameraif.h
>>
>> diff --git a/xen/include/public/io/cameraif.h b/xen/include/public/io/cameraif.h
>> new file mode 100644
>> index 000000000000..1ae4c51ea758
>> --- /dev/null
>> +++ b/xen/include/public/io/cameraif.h
>> @@ -0,0 +1,1370 @@
> <snip>
>
>> +/*
>> + * Request camera buffer's layout:
>> + *         0                1                 2               3        octet
>> + * +----------------+----------------+----------------+----------------+
>> + * |               id                | _BUF_GET_LAYOUT|   reserved     | 4
>> + * +----------------+----------------+----------------+----------------+
>> + * |                             reserved                              | 8
>> + * +----------------+----------------+----------------+----------------+
>> + * |/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/|
>> + * +----------------+----------------+----------------+----------------+
>> + * |                             reserved                              | 64
>> + * +----------------+----------------+----------------+----------------+
>> + *
>> + * See response format for this request.
>> + *
>> + *
>> + * Request number of buffers to be used:
>> + *         0                1                 2               3        octet
>> + * +----------------+----------------+----------------+----------------+
>> + * |               id                | _OP_BUF_REQUEST|   reserved     | 4
>> + * +----------------+----------------+----------------+----------------+
>> + * |                             reserved                              | 8
>> + * +----------------+----------------+----------------+----------------+
>> + * |    num_bufs    |                     reserved                     | 12
>> + * +----------------+----------------+----------------+----------------+
>> + * |                             reserved                              | 16
>> + * +----------------+----------------+----------------+----------------+
>> + * |/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/|
>> + * +----------------+----------------+----------------+----------------+
>> + * |                             reserved                              | 64
>> + * +----------------+----------------+----------------+----------------+
>> + *
>> + * num_bufs - uint8_t, desired number of buffers to be used.
>> + *
>> + * If num_bufs is not zero then the backend validates the requested number of
>> + * buffers and responds with the number of buffers allowed for this frontend.
>> + * Frontend is responsible for checking the corresponding response in order to
>> + * see if the values reported back by the backend do match the desired ones
>> + * and can be accepted.
>> + * Frontend is allowed to send multiple XENCAMERA_OP_BUF_REQUEST requests
>> + * before sending XENCAMERA_OP_STREAM_START request to update or tune the
>> + * final configuration.
>> + * Frontend is not allowed to change the number of buffers and/or camera
>> + * configuration after the streaming has started.
> This last sentence isn't quite right, and I missed that when reviewing the
> proposed text during the v4 discussions.
>
> The bit about not being allowed to change the number of buffers when streaming
> has started is correct.
>
> But the camera configuration is more strict: you can't change the camera
> configuration after this request unless you call this again with num_bufs = 0.
>
> The camera configuration changes the buffer size, so once the buffers are
> allocated you can no longer change the camera config. It is unrelated to streaming.
Can you please give me a hint of what would be the right thing to put in?

Thank you,
Oleksandr
> Regards,
>
> 	Hans
>
>> + *
>> + * If num_bufs is 0 and streaming has not started yet, then the backend will
>> + * free all previously allocated buffers (if any).
>> + * Trying to call this if streaming is in progress will result in an error.
>> + *
>> + * If camera reconfiguration is required then the streaming must be stopped
>> + * and this request must be sent with num_bufs set to zero and finally
>> + * buffers destroyed.
>> + *
>> + * Please note, that the number of buffers in this request must not exceed
>> + * the value configured in XenStore.max-buffers.
>> + *
>> + * See response format for this request.
>> + */
> <snip>
>
> Regards,
>
> 	Hans

