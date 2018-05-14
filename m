Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:38200 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932608AbeENQDI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 May 2018 12:03:08 -0400
Received: by mail-pl0-f66.google.com with SMTP id c11-v6so7639134plr.5
        for <linux-media@vger.kernel.org>; Mon, 14 May 2018 09:03:08 -0700 (PDT)
Subject: Re: [PATCH 5/7] imx: fix compiler warning
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
References: <20180514131346.15795-1-hverkuil@xs4all.nl>
 <20180514131346.15795-6-hverkuil@xs4all.nl>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <42a74bf5-6c5e-b5d7-d0ae-1eb015e16c32@gmail.com>
Date: Mon, 14 May 2018 09:03:05 -0700
MIME-Version: 1.0
In-Reply-To: <20180514131346.15795-6-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by: Steve Longerbeam <steve_longerbeam@mentor.com>


On 05/14/2018 06:13 AM, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> drivers/staging/media/imx/imx-media-capture.c: In function 'vidioc_querycap':
> drivers/staging/media/imx/imx-media-capture.c:76:2: warning: 'strncpy' output truncated copying 15 bytes from a string of length 17 [-Wstringop-truncation]
>    strncpy(cap->driver, "imx-media-capture", sizeof(cap->driver) - 1);
>    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Steve Longerbeam <slongerbeam@gmail.com>
> Cc: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>   drivers/staging/media/imx/imx-media-capture.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/media/imx/imx-media-capture.c b/drivers/staging/media/imx/imx-media-capture.c
> index 0ccabe04b0e1..4e3fdf8aeef5 100644
> --- a/drivers/staging/media/imx/imx-media-capture.c
> +++ b/drivers/staging/media/imx/imx-media-capture.c
> @@ -73,8 +73,8 @@ static int vidioc_querycap(struct file *file, void *fh,
>   {
>   	struct capture_priv *priv = video_drvdata(file);
>   
> -	strncpy(cap->driver, "imx-media-capture", sizeof(cap->driver) - 1);
> -	strncpy(cap->card, "imx-media-capture", sizeof(cap->card) - 1);
> +	strlcpy(cap->driver, "imx-media-capture", sizeof(cap->driver));
> +	strlcpy(cap->card, "imx-media-capture", sizeof(cap->card));
>   	snprintf(cap->bus_info, sizeof(cap->bus_info),
>   		 "platform:%s", priv->src_sd->name);
>   
