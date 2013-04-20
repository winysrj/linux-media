Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:49660 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755644Ab3DTWAf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Apr 2013 18:00:35 -0400
Received: by mail-la0-f53.google.com with SMTP id eg20so614717lab.26
        for <linux-media@vger.kernel.org>; Sat, 20 Apr 2013 15:00:33 -0700 (PDT)
Message-ID: <51730FCE.8000604@cogentembedded.com>
Date: Sun, 21 Apr 2013 01:59:42 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: mchehab@redhat.com, linux-media@vger.kernel.org
CC: linux-sh@vger.kernel.org, matsu@igel.co.jp,
	vladimir.barinov@cogentembedded.com
Subject: Re: [PATCH 1/5] V4L2: I2C: ML86V7667 video decoder driver
References: <201304210013.46110.sergei.shtylyov@cogentembedded.com> <201304210016.33720.sergei.shtylyov@cogentembedded.com>
In-Reply-To: <201304210016.33720.sergei.shtylyov@cogentembedded.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 04/21/2013 12:16 AM, Sergei Shtylyov wrote:

> From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
>
> Add OKI Semiconductor ML86V7667 video decoder driver.
>
> Signed-off-by: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
> [Sergei: added v4l2_device_unregister_subdev() call to the error cleanup path of
> ml86v7667_probe(); some cleanup.]
> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

[...]

> Index: renesas/drivers/media/i2c/ml86v7667.c
> ===================================================================
> --- /dev/null
> +++ renesas/drivers/media/i2c/ml86v7667.c
> @@ -0,0 +1,504 @@

[...]

> +/* ACC Loop filter & Chrominance control register bits */
> +#define ACCC_CHROMA_CR_SHIFT	3
> +#define ACCC_CHROMA_CR_MASK	(7 << 3)
> +#define ACCC_CHROMA_CB_SHIFT	0
> +#define ACCC_CHROMA_CB_MASK	(7 << 3)

     Should be (7 << 0), of course. My fault. :-(

WBR, Sergei


