Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752021AbdGLTS6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Jul 2017 15:18:58 -0400
Subject: Re: [PATCH v2 2/7] [media] ov9650: switch i2c device id to lower case
To: Hugues Fruchet <hugues.fruchet@st.com>
Cc: "H. Nikolaus Schaller" <hns@goldelico.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yannick Fertre <yannick.fertre@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
References: <1499073368-31905-1-git-send-email-hugues.fruchet@st.com>
 <1499073368-31905-3-git-send-email-hugues.fruchet@st.com>
From: Sylwester Nawrocki <snawrocki@kernel.org>
Message-ID: <8b84296e-b3c7-f5d1-5e90-5890b1b0ed48@kernel.org>
Date: Wed, 12 Jul 2017 21:18:52 +0200
MIME-Version: 1.0
In-Reply-To: <1499073368-31905-3-git-send-email-hugues.fruchet@st.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/03/2017 11:16 AM, Hugues Fruchet wrote:
> Switch i2c device id to lower case as it is

s/i2c/I2C ?

> done for other omnivision cameras.

s/omnivision/Omnivision

This is required for properly matching driver with device on DT platforms,
right? It might be worth to mention that so it is clear why we break any
non-dt platform that could be already using this driver. There seem to be 
none in the mainline kernel tree though.

> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>

Reviewed-by: Sylwester Nawrocki <snawrocki@kernel.org>

> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
> ---
>   drivers/media/i2c/ov9650.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/i2c/ov9650.c b/drivers/media/i2c/ov9650.c
> index 2de2fbb..1e4e99e 100644
> --- a/drivers/media/i2c/ov9650.c
> +++ b/drivers/media/i2c/ov9650.c
> @@ -1545,8 +1545,8 @@ static int ov965x_remove(struct i2c_client *client)
>   }
>   
>   static const struct i2c_device_id ov965x_id[] = {
> -	{ "OV9650", 0 },
> -	{ "OV9652", 0 },
> +	{ "ov9650", 0 },
> +	{ "ov9652", 0 },
>   	{ /* sentinel */ }
>   };
>   MODULE_DEVICE_TABLE(i2c, ov965x_id);
 
