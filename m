Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f47.google.com ([209.85.219.47]:49810 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbaDHHno (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Apr 2014 03:43:44 -0400
Received: by mail-oa0-f47.google.com with SMTP id i11so597244oag.6
        for <linux-media@vger.kernel.org>; Tue, 08 Apr 2014 00:43:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1396876573-15811-4-git-send-email-j.anaszewski@samsung.com>
References: <1396876573-15811-1-git-send-email-j.anaszewski@samsung.com>
	<1396876573-15811-4-git-send-email-j.anaszewski@samsung.com>
Date: Tue, 8 Apr 2014 13:13:43 +0530
Message-ID: <CAK9yfHwBVhe6eycHW9xdQSa6qG8DV5070rLsFCKxXS6c+Jpv5Q@mail.gmail.com>
Subject: Re: [PATCH 4/8] [media] s5p-jpeg: Fix build break when CONFIG_OF is undefined
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

On 7 April 2014 18:46, Jacek Anaszewski <j.anaszewski@samsung.com> wrote:
> This patch fixes build break occurring when
> there is no support for Device Tree turned on
> in the kernel configuration. In such a case only
> the driver variant for S5PC210 SoC will be available.
>
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
<snip>

>
> +       if (!IS_ENABLED(CONFIG_OF) || dev->of_node == NULL)

!dev->of_node instead of equating to NULL.


> +               return &s5p_jpeg_drvdata;
> +
>         match = of_match_node(of_match_ptr(samsung_jpeg_match),

Since you are returning above if CONFIG_OF is not enabled, of_match_ptr
is not needed.

-- 
With warm regards,
Sachin
