Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f169.google.com ([209.85.128.169]:38772 "EHLO
        mail-wr0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934434AbdGTPqJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 11:46:09 -0400
Received: by mail-wr0-f169.google.com with SMTP id f21so16013920wrf.5
        for <linux-media@vger.kernel.org>; Thu, 20 Jul 2017 08:46:08 -0700 (PDT)
Subject: Re: [Patch v5 12/12] Documention: v4l: Documentation for HEVC CIDs
To: Smitha T Murthy <smitha.t@samsung.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        kamil@wypas.org, jtp.park@samsung.com, a.hajda@samsung.com,
        mchehab@kernel.org, pankaj.dubey@samsung.com, krzk@kernel.org,
        m.szyprowski@samsung.com, s.nawrocki@samsung.com
References: <1497849055-26583-1-git-send-email-smitha.t@samsung.com>
 <CGME20170619052521epcas5p36a0bc384d10809dcfe775e6da87ed37b@epcas5p3.samsung.com>
 <1497849055-26583-13-git-send-email-smitha.t@samsung.com>
 <617cb1c5-074c-3f47-0096-fe7568dab8be@linaro.org>
 <1500290336.16819.6.camel@smitha-fedora>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <54ad8901-ccd0-4b0b-bb3f-23779d3534e8@linaro.org>
Date: Thu, 20 Jul 2017 18:46:04 +0300
MIME-Version: 1.0
In-Reply-To: <1500290336.16819.6.camel@smitha-fedora>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

>>> +
>>> +    * - ``V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN``
>>> +      - Main profile.
>>
>> MAIN10?
>>
> No just MAIN.

I haven't because the MFC does not supported it?

If so, I think we have to add MAIN10 for completeness and because other
drivers could have support for it.

-- 
regards,
Stan
