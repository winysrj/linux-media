Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:55285 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753227AbeCTNmw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Mar 2018 09:42:52 -0400
Received: by mail-wm0-f68.google.com with SMTP id h76so3543264wme.4
        for <linux-media@vger.kernel.org>; Tue, 20 Mar 2018 06:42:52 -0700 (PDT)
Subject: Re: [PATCH v2] venus: vdec: fix format enumeration
To: Alexandre Courbot <acourbot@chromium.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20180319093229.76253-1-acourbot@chromium.org>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <35d51db4-bbca-e76a-abff-ed74172a5fe2@linaro.org>
Date: Tue, 20 Mar 2018 15:42:47 +0200
MIME-Version: 1.0
In-Reply-To: <20180319093229.76253-1-acourbot@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alex,

Thanks!

On 03/19/2018 11:32 AM, Alexandre Courbot wrote:
> find_format_by_index() stops enumerating formats as soon as the index
> matches, and returns NULL if venus_helper_check_codec() finds out that
> the format is not supported. This prevents formats to be properly
> enumerated if a non-supported format is present, as the enumeration will
> end with it.
> 
> Fix this by moving the call to venus_helper_check_codec() into the loop,
> and keep enumerating when it fails.
> 
> Fixes: 29f0133ec6 media: venus: use helper function to check supported codecs
> 
> Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
> ---
>  drivers/media/platform/qcom/venus/vdec.c | 13 +++++++------
>  drivers/media/platform/qcom/venus/venc.c | 13 +++++++------
>  2 files changed, 14 insertions(+), 12 deletions(-)

Acked-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>

-- 
regards,
Stan
