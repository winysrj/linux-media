Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39405 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932237Ab2BATq4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Feb 2012 14:46:56 -0500
Received: by wgbdt10 with SMTP id dt10so1698710wgb.1
        for <linux-media@vger.kernel.org>; Wed, 01 Feb 2012 11:46:54 -0800 (PST)
Message-ID: <4F2996A9.2000809@gmail.com>
Date: Wed, 01 Feb 2012 20:46:49 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
CC: linux-media@vger.kernel.org, mchehab@infradead.org,
	kyungmin.park@samsung.com, k.debski@samsung.com,
	patches@linaro.org, Kamil Debski <k.debski@samsung.com>
Subject: Re: [PATCH v4] [media] s5p-g2d: Add HFLIP and VFLIP support
References: <1328089723-18482-1-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1328089723-18482-1-git-send-email-sachin.kamat@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

On 02/01/2012 10:48 AM, Sachin Kamat wrote:
> Add support for flipping the image horizontally and vertically.
> 
> Signed-off-by: Sachin Kamat<sachin.kamat@linaro.org>
> ---
>   drivers/media/video/s5p-g2d/g2d-hw.c |    5 +++++
>   drivers/media/video/s5p-g2d/g2d.c    |   27 ++++++++++++++++++++-------
>   drivers/media/video/s5p-g2d/g2d.h    |    4 ++++
>   3 files changed, 29 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/media/video/s5p-g2d/g2d-hw.c b/drivers/media/video/s5p-g2d/g2d-hw.c
> index 39937cf..5b86cbe 100644
> --- a/drivers/media/video/s5p-g2d/g2d-hw.c
> +++ b/drivers/media/video/s5p-g2d/g2d-hw.c
> @@ -77,6 +77,11 @@ void g2d_set_rop4(struct g2d_dev *d, u32 r)
>   	w(r, ROP4_REG);
>   }
> 
> +void g2d_set_flip(struct g2d_dev *d, u32 r)
> +{
> +	w(r, SRC_MSK_DIRECT_REG);
> +}

nit: This could be added instead to g2d.h as a "static inline" function.
Whether you decide to change it or not:

 Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

I assume Kamil is going to add locking in subsequent patch(es).

--

Regards,
Sylwester
