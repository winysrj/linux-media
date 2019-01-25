Return-Path: <SRS0=PLMr=QB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12E9FC282C0
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 10:35:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8D19218D0
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 10:35:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="GUWlGWAg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727043AbfAYKfy (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 25 Jan 2019 05:35:54 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40362 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726111AbfAYKfy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Jan 2019 05:35:54 -0500
Received: by mail-wr1-f68.google.com with SMTP id p4so9718292wrt.7
        for <linux-media@vger.kernel.org>; Fri, 25 Jan 2019 02:35:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ealOnVHVYH/YbyAmfaqodTCJ/ZpZvOckJdBQrb+F6rc=;
        b=GUWlGWAgn+BlULBg7c8+qTcJX03xpf+jxJEZOUcTioFUD6uUTKJDxcY4lVkDG2Ir95
         NM10k8PRNy++j2IAAiLXiwQnThm57T+s61yrZ2ScxpYsVaZTAJoGIaQ8b/ohUvsPyrHg
         nbuDzqKclboK8S4fOZ7XH1N5lFDFa+rLIi5mY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ealOnVHVYH/YbyAmfaqodTCJ/ZpZvOckJdBQrb+F6rc=;
        b=OvjwUUv5t6SLpeq2aYbIYfTdfUkfxewKgcrIhZO6XdTrABakTXU+xb02LVhWwmmo4h
         RT/9K9/wzFR+vP6T/0xNSe3H5qxmTFrL6MemoOQUOdb6xofZLQ3s+2aezZRfkxG5NX9t
         POQBjC1x3He4fAF10I7BXRh6xsuSpDfdDwcCT/KfKTZvfXgNckDqm0wGPWv5EYUKNctz
         IOIFkpbVh01WwHw0aF9fDk+LvPBFOFYUybP7BtifFEi895s3V0xe23/Wux7rWvlDANBG
         Y75Pao1FNE2ZvJqkMvvK0jqeJJHQ2gSxErAnWLIFvYKNBaevGAqi6BK8FCsyg07/weNO
         LRew==
X-Gm-Message-State: AJcUukd+Vx6gQ7f5yXxV9/cvZdi2/u2pEmCgMsHGeE4RRaVAQrlXE0Fz
        y4+KayS5liesTvw13kQ6WNcEmg==
X-Google-Smtp-Source: ALg8bN4kqQBRKydQRP1WfLkf37XGfg0MrzaepvhXD5TDWgMFDpF0V4v0fo85i0Y1YtvIblFOkTjtdQ==
X-Received: by 2002:adf:f28d:: with SMTP id k13mr11373650wro.78.1548412552686;
        Fri, 25 Jan 2019 02:35:52 -0800 (PST)
Received: from [192.168.27.209] ([37.157.136.206])
        by smtp.googlemail.com with ESMTPSA id y1sm81447532wme.1.2019.01.25.02.35.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Jan 2019 02:35:52 -0800 (PST)
Subject: Re: [PATCH 00/10] Venus stateful Codec API
To:     Alexandre Courbot <acourbot@chromium.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Malathi Gottam <mgottam@codeaurora.org>
References: <20190117162008.25217-1-stanimir.varbanov@linaro.org>
 <CAPBb6MVOPmRhhM=J-RqLOpc+mDbnxYdCMO3mqQfgN-F3b=kBCw@mail.gmail.com>
 <10deb3d1-2b10-43fe-bc77-4465f561c90a@linaro.org>
 <CAPBb6MUqi3xhgE_WPRP_7gZWcH2WGz8A7vskGGJW9zGM0=D1Sw@mail.gmail.com>
From:   Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <80b97fd8-bd3a-df74-c611-5da11bd7adc6@linaro.org>
Date:   Fri, 25 Jan 2019 12:35:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <CAPBb6MUqi3xhgE_WPRP_7gZWcH2WGz8A7vskGGJW9zGM0=D1Sw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Alex,

On 1/25/19 7:34 AM, Alexandre Courbot wrote:
> On Thu, Jan 24, 2019 at 7:13 PM Stanimir Varbanov
> <stanimir.varbanov@linaro.org> wrote:
>>
>> Hi Alex,
>>
>> Thank you for review and valuable comments!
>>
>> On 1/24/19 10:43 AM, Alexandre Courbot wrote:
>>> Hi Stanimir,
>>>
>>> On Fri, Jan 18, 2019 at 1:20 AM Stanimir Varbanov
>>> <stanimir.varbanov@linaro.org> wrote:
>>>>
>>>> Hello,
>>>>
>>>> This aims to make Venus decoder compliant with stateful Codec API [1].
>>>> The patches 1-9 are preparation for the cherry on the cake patch 10
>>>> which implements the decoder state machine similar to the one in the
>>>> stateful codec API documentation.
>>>
>>> Thanks *a lot* for this series! I am still stress-testing it against
>>> the Chromium decoder tests, but so far it has been rock-solid. I have
>>> a few inline comments on some patches ; I will also want to review the
>>> state machine more thoroughly after refreshing my mind on Tomasz doc,
>>> but this looks pretty promising already.
>>
>> I'm expecting problems with ResetAfterFirstConfigInfo. I don't know why
>> but this test case is very dirty. I'd appreciate any help to decipher
>> what is the sequence of v4l2 calls made by this unittest case.
> 
> I did not see any issue with ResetAfterFirstConfigInfo, however
> ResourceExhaustion seems to hang once in a while. But I could already
> see this behavior with the older patchset.

Is it hangs badly?

> 
> In any case I plan to thoroughly review the state machine. I agree it
> is a bit complex to grasp.

yes the state machine isn't simple and I blamed Tomasz many times for
that :)

-- 
regards,
Stan
