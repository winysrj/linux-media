Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B9FAC282C3
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 10:13:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B648218A2
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 10:13:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="Pq7VLDmt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbfAXKNA (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 05:13:00 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35713 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbfAXKM7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 05:12:59 -0500
Received: by mail-wm1-f65.google.com with SMTP id t200so2394695wmt.0
        for <linux-media@vger.kernel.org>; Thu, 24 Jan 2019 02:12:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tmuXCAXVUS9B80pXhxGg1Rqmyz2jE+W4ecUCClcdeMk=;
        b=Pq7VLDmt6HCHUkNI7DCmOpNMfoVJQXvqm506ucSr4DOmQlLM8k54DWxcIQobP1WR+s
         NpKLdjpgjLmisvMu+YxqPD4TDs/bD2yd4ur2hau6jO5InI82mpmY6IdV938IhIPo7eFe
         gmgYPE47zvaciVw1kqB+6E1TJzmmyGZHS6Xjc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tmuXCAXVUS9B80pXhxGg1Rqmyz2jE+W4ecUCClcdeMk=;
        b=JKx/C8uepFTHAQ7BZ0CVA0/eEdO02we/AbSOfMwg08GswdjjrUswpljSvwoxaCVDNo
         IGQfeNBcDt4Npiv31d3SsKhcjf0uSNSd7VEbUH3vLKI2va6qlE5wwcl/7O786Zog7acw
         x4fpzxezga90GD6r15ibRnKoKCFReeFkLlLyiLXo5WYopHXLZJvWctD6H3VH7R+tyPnp
         Uw11zTXRbaxlChxyXVHmD46MZamFAjQJZOLsdEq/CrCw+kLos5pWsORf9RByk2FHps3o
         mXG8ROkOlbak1+4ORu1eQtcTmu7NSA2D/NKqosdpxNLXcDadBmTJBZ6GwFR8vXHRGdCE
         tPOA==
X-Gm-Message-State: AJcUukdzobTdG/HRzWeTEYfqOLyy7zbf0K/EF7xWDjaAKJtU7F+oNBLR
        CnVaYE/JQXedR7EOdiXrHsBEwQ==
X-Google-Smtp-Source: ALg8bN4fevqzkyY0/pb03dK18G7PGh5ligGtHqABGBKLYGHpfZosEXJKDuMwQLN/Q5xK7seu+gyX+A==
X-Received: by 2002:a7b:cb86:: with SMTP id m6mr1940315wmi.61.1548324777914;
        Thu, 24 Jan 2019 02:12:57 -0800 (PST)
Received: from [192.168.27.209] ([37.157.136.206])
        by smtp.googlemail.com with ESMTPSA id j24sm127517045wrd.86.2019.01.24.02.12.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 02:12:57 -0800 (PST)
Subject: Re: [PATCH 00/10] Venus stateful Codec API
To:     Alexandre Courbot <acourbot@chromium.org>
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
From:   Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <10deb3d1-2b10-43fe-bc77-4465f561c90a@linaro.org>
Date:   Thu, 24 Jan 2019 12:12:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <CAPBb6MVOPmRhhM=J-RqLOpc+mDbnxYdCMO3mqQfgN-F3b=kBCw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Alex,

Thank you for review and valuable comments!

On 1/24/19 10:43 AM, Alexandre Courbot wrote:
> Hi Stanimir,
> 
> On Fri, Jan 18, 2019 at 1:20 AM Stanimir Varbanov
> <stanimir.varbanov@linaro.org> wrote:
>>
>> Hello,
>>
>> This aims to make Venus decoder compliant with stateful Codec API [1].
>> The patches 1-9 are preparation for the cherry on the cake patch 10
>> which implements the decoder state machine similar to the one in the
>> stateful codec API documentation.
> 
> Thanks *a lot* for this series! I am still stress-testing it against
> the Chromium decoder tests, but so far it has been rock-solid. I have
> a few inline comments on some patches ; I will also want to review the
> state machine more thoroughly after refreshing my mind on Tomasz doc,
> but this looks pretty promising already.

I'm expecting problems with ResetAfterFirstConfigInfo. I don't know why
but this test case is very dirty. I'd appreciate any help to decipher
what is the sequence of v4l2 calls made by this unittest case.

-- 
regards,
Stan
