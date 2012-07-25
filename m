Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49062 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab2GYVcl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jul 2012 17:32:41 -0400
Received: by bkwj10 with SMTP id j10so845039bkw.19
        for <linux-media@vger.kernel.org>; Wed, 25 Jul 2012 14:32:40 -0700 (PDT)
Message-ID: <501065F5.9060004@gmail.com>
Date: Wed, 25 Jul 2012 23:32:37 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Shaik Ameer Basha <shaik.ameer@samsung.com>
CC: linux-media@vger.kernel.org, sungchun.kang@samsung.com,
	khw0178.kim@samsung.com, mchehab@infradead.org,
	laurent.pinchart@ideasonboard.com, sy0816.kang@samsung.com,
	s.nawrocki@samsung.com, posciak@google.com, alim.akhtar@gmail.com,
	prashanth.g@samsung.com, joshi@samsung.com, shaik.samsung@gmail.com
Subject: Re: [PATCH v3 5/5] media: gscaler: Add Makefile for G-Scaler Driver
References: <1343219191-3969-1-git-send-email-shaik.ameer@samsung.com> <1343219191-3969-6-git-send-email-shaik.ameer@samsung.com>
In-Reply-To: <1343219191-3969-6-git-send-email-shaik.ameer@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/25/2012 02:26 PM, Shaik Ameer Basha wrote:
> This patch adds the Makefile for G-Scaler driver.
>
> Signed-off-by: Shaik Ameer Basha<shaik.ameer@samsung.com>
> ---
>   drivers/media/video/Kconfig             |    8 ++++++++
>   drivers/media/video/Makefile            |    2 ++
>   drivers/media/video/exynos-gsc/Makefile |    3 +++
>   3 files changed, 13 insertions(+), 0 deletions(-)
>   create mode 100644 drivers/media/video/exynos-gsc/Makefile
>
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index 99937c9..47ec55a 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -1215,4 +1215,12 @@ config VIDEO_MX2_EMMAPRP
>   	    memory to memory. Operations include resizing and format
>   	    conversion.
>
> +config VIDEO_SAMSUNG_EXYNOS_GSC
> +        tristate "Samsung Exynos GSC driver"

s/GSC/Gscaler ?


Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

--

Regards,
Sylwester
