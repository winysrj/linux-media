Return-Path: <SRS0=c0D3=QM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 372FAC282CC
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 13:06:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEF25217FA
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 13:06:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bxcCqu/4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729118AbfBENGy (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Feb 2019 08:06:54 -0500
Received: from mail-lf1-f45.google.com ([209.85.167.45]:42600 "EHLO
        mail-lf1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727949AbfBENGx (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Feb 2019 08:06:53 -0500
Received: by mail-lf1-f45.google.com with SMTP id l10so2562670lfh.9
        for <linux-media@vger.kernel.org>; Tue, 05 Feb 2019 05:06:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=MZijtisJvnouBUk0MwK1JXNuWxZ5lhODcWXpNxCBjkU=;
        b=bxcCqu/4ZX9JkfY6YHK3exIDDqENomXg7kRemNJzMkv3EOCL8UFTPUTXSjfKuCjpgO
         EV3kfJCajt6b2zYTbVO4Mjvxsjc3yNoibdV4IN/nFjUedcNZTwfefHxF8JCSiqo9mvCU
         YpmiQgWtdudAzOIryS2Pt7C+iBUpfGzOZN6H5efKprZjMjbikX/0fusaWYhv6OdigxVf
         B9RKNl1ySbWwlGJxuKM1SKpzGCThON7DrfRRAlnbQziChXkdwz6MRrTK1BOQ6RnfLwEM
         2eodYyUTc7662vs6QDg1JnB4tkQG1ZZ9AsgfElPgfNYBHBuZCrhUfvbikhEc8iIvaFQp
         SUFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=MZijtisJvnouBUk0MwK1JXNuWxZ5lhODcWXpNxCBjkU=;
        b=djyYXmLqg+yrGdVfLqgez1mzQHw9WZVmJg1dCHCp/rkRSt0BsxK40RB4tHklyqUFbK
         TkRxoPoqquG8HCjYHIJuQbBiuCZdqXx09XySUG8t/0bqegpQaCqwLk2q38mL19Qgnh2v
         p46EjIRZ3VSi8/ylA+3q6LSvSWiRn6Abh3TLT3RxMd8xuObhMKXFxFOYNzOuGfPTFhDp
         SjiE4v/EynxW57PKWuJXB9lcxiUZwxC3RPTfL4nH/OQvPgpoVNQeyo3a424y8JE/SwWC
         oyBNT5HxQQhUdv7yJEWfj1wEOLrhYqaB87TtdJ5nRIHUM1ko4TG+uDtvvVhT4ohpUb9u
         GWkg==
X-Gm-Message-State: AHQUAuZ0gdUgsjUu+5g4oqi4ZTo6B/F6ZEZnDaSvq4f4QrFE4S9DqSIF
        gLSyZpttOS7JA72l5+BZy6DNXfsE
X-Google-Smtp-Source: AHgI3IaScA98G5zzcKIeSsBP7hS6LKYg8yM57BSPvjM5Izz1+WBReCseCIs6VMhg/hZiBkm76iI+Pg==
X-Received: by 2002:a19:a345:: with SMTP id m66mr3136309lfe.84.1549372010526;
        Tue, 05 Feb 2019 05:06:50 -0800 (PST)
Received: from [10.17.182.20] (ll-22.209.223.85.sovam.net.ua. [85.223.209.22])
        by smtp.gmail.com with ESMTPSA id c22sm3244555lfi.27.2019.02.05.05.06.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Feb 2019 05:06:49 -0800 (PST)
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
 <474636e0-8059-7b75-8b48-a216c6defaf4@gmail.com>
 <5679f9a9-1218-0cdb-0c61-45864159ab29@xs4all.nl>
From:   Oleksandr Andrushchenko <andr2000@gmail.com>
Message-ID: <f3fa2587-3641-56ea-31c2-3758ee7ae96f@gmail.com>
Date:   Tue, 5 Feb 2019 15:06:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <5679f9a9-1218-0cdb-0c61-45864159ab29@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/5/19 3:02 PM, Hans Verkuil wrote:
> On 2/5/19 1:30 PM, Oleksandr Andrushchenko wrote:
>>> Sorry for paying so much attention to this, but I think it is important that
>>> this is documented precisely.
>> Thank you for helping with this - your comments are really
>> important and make the description precise. Ok, so finally:
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
>>   *
>>   * If num_bufs is 0 and streaming has not started yet, then the backend may
>>   * free all previously allocated buffers (if any) or do nothing.
> I would rephrase this:
>
> * If num_bufs is 0 and streaming has not started yet, then the backend will
> * free all previously allocated buffers (if any).
>
> The previous text suggested that the backend might choose not to free
> the allocated buffers, but that's not the case.
>
Ok, makes sense
>>   * Trying to call this if streaming is in progress will result in an error.
>>   *
>>   * If camera reconfiguration is required then the streaming must be stopped
>>   * and this request must be sent with num_bufs set to zero and finally
>>   * buffers destroyed.
>>   *
>>   * Please note, that the number of buffers in this request must not exceed
>>   * the value configured in XenStore.max-buffers.
>>   *
>>   * See response format for this request.
> With that small change the text looks good to me.
Thank you for your time and help with this!
It seems I can push v5 for the (final?) review then
> Regards,
>
> 	Hans
Thank you,
Oleksandr
