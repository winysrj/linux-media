Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:35131 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754968AbdFXQo7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Jun 2017 12:44:59 -0400
Received: by mail-pg0-f68.google.com with SMTP id f127so9928105pgc.2
        for <linux-media@vger.kernel.org>; Sat, 24 Jun 2017 09:44:58 -0700 (PDT)
Subject: Re: [PATCH] media: imx.rst: add it to v4l-drivers book
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Kieran Bingham <kieran+renesas@ksquared.org.uk>
References: <cc7036633839dfd82e3123fa025dd44b009910a8.1498321073.git.mchehab@s-opensource.com>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <6df72cba-7f3b-11d5-9583-c162dbf6c98d@gmail.com>
Date: Sat, 24 Jun 2017 09:44:56 -0700
MIME-Version: 1.0
In-Reply-To: <cc7036633839dfd82e3123fa025dd44b009910a8.1498321073.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 06/24/2017 09:18 AM, Mauro Carvalho Chehab wrote:
> Avoid the following warning when building documentation:
> 	checking consistency... /devel/v4l/patchwork/Documentation/media/v4l-drivers/imx.rst:: WARNING: document isn't included in any toctree
>
> While here, avoid placing all driver authors at just one line at
> the html/pdf output.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Acked-by: Steve Longerbeam <steve_longerbeam@mentor.com>

Steve

> ---
>   Documentation/media/v4l-drivers/imx.rst   | 7 ++++---
>   Documentation/media/v4l-drivers/index.rst | 1 +
>   2 files changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/media/v4l-drivers/imx.rst b/Documentation/media/v4l-drivers/imx.rst
> index e0ee0f1aeb05..3c4f58bda178 100644
> --- a/Documentation/media/v4l-drivers/imx.rst
> +++ b/Documentation/media/v4l-drivers/imx.rst
> @@ -607,8 +607,9 @@ References
>   
>   Authors
>   -------
> -Steve Longerbeam <steve_longerbeam@mentor.com>
> -Philipp Zabel <kernel@pengutronix.de>
> -Russell King <linux@armlinux.org.uk>
> +
> +- Steve Longerbeam <steve_longerbeam@mentor.com>
> +- Philipp Zabel <kernel@pengutronix.de>
> +- Russell King <linux@armlinux.org.uk>
>   
>   Copyright (C) 2012-2017 Mentor Graphics Inc.
> diff --git a/Documentation/media/v4l-drivers/index.rst b/Documentation/media/v4l-drivers/index.rst
> index 2e24d6806052..10f2ce42ece2 100644
> --- a/Documentation/media/v4l-drivers/index.rst
> +++ b/Documentation/media/v4l-drivers/index.rst
> @@ -41,6 +41,7 @@ For more details see the file COPYING in the source distribution of Linux.
>   	cx88
>   	davinci-vpbe
>   	fimc
> +	imx
>   	ivtv
>   	max2175
>   	meye
