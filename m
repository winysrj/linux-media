Return-Path: <SRS0=BdY7=QG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E303C282D7
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 10:36:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42452218AC
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 10:36:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="hLjlHbVq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730737AbfA3Kf6 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 30 Jan 2019 05:35:58 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35166 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729692AbfA3Kf5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Jan 2019 05:35:57 -0500
Received: by mail-wm1-f66.google.com with SMTP id t200so21179013wmt.0
        for <linux-media@vger.kernel.org>; Wed, 30 Jan 2019 02:35:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZFJINRnvRiZX6jz//vRVRyvCkB+8htjpB1+oo+t/RnI=;
        b=hLjlHbVqmRv9OPWJ1rbNFjjlBJlxo5iGhC1clvjVhp5z8sSlIiaAiDuqLbscexrIQB
         LSuqnUpqHZrzSi4QQqdVKtTZvknHDbv0RcU4l4y5o1BHi3sREJt/z98xM/0+fyrpubDZ
         qJXd3kBpgxqRfXpxmFoKyN0Q1tCo4THk4GtNM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZFJINRnvRiZX6jz//vRVRyvCkB+8htjpB1+oo+t/RnI=;
        b=t6Fu7q8o3R33Pl7dp6jRxwOf39fn3wfJ+r2YHwAuIH+C7ZkWr85VoQASaVndlRMxdb
         0PBvRzjAXib0MIhQn35JijxyBJu5G0+1HvByuq5XkJyK6vQETFeadzficyt9egArBvms
         Kw9UOIfopzOm2w0Fbz+zrZQS05f+A4HbIi5Rn2a8yG946n67OB/9JRD62VDvU2/+rNnv
         683wMaWiHvzUmVAB5SvFdhE2oxYnh6KjowJVCklHyo0TJUWIQEHrd6uRF6W6lSYzydhs
         N+fDU3QAUwADfzx7wn6s5G+n/Fwu5OUeocblfvxs2Om9ph5gzTiiv/2moWzyAq+CQhDJ
         wbZw==
X-Gm-Message-State: AJcUukcf/nDov/a3XnKZmeLVMfc/g/aQ+xkgIAJ4RXZs/8aUaqdw+5AN
        yf+p2KihwWpw9Av0NDaG7H3SYTlRdQI=
X-Google-Smtp-Source: ALg8bN4mpUeb8C5ls4myWN2TbMKuil2Cc4HdVH+y/bpBsw+GlEV+yAwIIVAYrV86Bm6TnW3NgdUnuA==
X-Received: by 2002:a1c:a104:: with SMTP id k4mr24386330wme.54.1548844555718;
        Wed, 30 Jan 2019 02:35:55 -0800 (PST)
Received: from [192.168.27.209] ([37.157.136.206])
        by smtp.googlemail.com with ESMTPSA id d4sm1611373wrp.89.2019.01.30.02.35.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Jan 2019 02:35:55 -0800 (PST)
Subject: Re: [PATCH v2] venus: enc: fix enum_frameintervals
To:     Nicolas Dufresne <nicolas@ndufresne.ca>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        linux-media@vger.kernel.org
Cc:     Hans Verkuil <hverkuil@xs4all.nl>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190122105322.22096-1-stanimir.varbanov@linaro.org>
 <9651c01bf3f2adcc405963bfab48b7e7a5656494.camel@ndufresne.ca>
From:   Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <3062ef17-ad35-68ba-5cad-be9de037e637@linaro.org>
Date:   Wed, 30 Jan 2019 12:35:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <9651c01bf3f2adcc405963bfab48b7e7a5656494.camel@ndufresne.ca>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Nicolas,

On 1/30/19 5:28 AM, Nicolas Dufresne wrote:
> Le mardi 22 janvier 2019 à 12:53 +0200, Stanimir Varbanov a écrit :
>> This ixes an issue when setting the encoder framerate because of
> 
> ixes -> fixes
> 
>> missing precision. Now the frameinterval type is changed to
>> TYPE_CONTINUOUS and step = 1. Also the math is changed when
>> framerate property is called - the firmware side expects that
>> the framerate one is 1 << 16 units.
> 
> Note sure, maybe you didn't mean to add 'one' here ? Why not just say
> that that firmware expect values in Q16 ?

yes, thanks for the suggestion.

> 
>>
>> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> 
> Looking toward testing it, but I had the bad luck of using an USB
> storage rootfs, and apparently USB no longer works on 5.0rc+, if you
> have a baseline tree to suggest, I'll take it. Thanks for this patch.

try qcomlt-4.14 release branch at [1].

-- 
regards,
Stan

[1]
https://git.linaro.org/landing-teams/working/qualcomm/kernel.git/log/?h=release/qcomlt-4.14
