Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway32.websitewelcome.com ([192.185.145.113]:24636 "EHLO
        gateway32.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756760AbeDBUlg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 2 Apr 2018 16:41:36 -0400
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway32.websitewelcome.com (Postfix) with ESMTP id 1E449118DEA
        for <linux-media@vger.kernel.org>; Mon,  2 Apr 2018 15:17:39 -0500 (CDT)
Subject: Re: [PATCH 3/3] media: i2c: tvp5150: Use parentheses for sizeof
To: Nasser Afshin <afshin.nasser@gmail.com>, mchehab@kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20180402195907.14368-1-Afshin.Nasser@gmail.com>
 <20180402195907.14368-4-Afshin.Nasser@gmail.com>
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Message-ID: <d5e8dbe4-b68b-ac4e-0076-a3ee995f8327@embeddedor.com>
Date: Mon, 2 Apr 2018 15:17:37 -0500
MIME-Version: 1.0
In-Reply-To: <20180402195907.14368-4-Afshin.Nasser@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 04/02/2018 02:59 PM, Nasser Afshin wrote:
> This patch resolves a checkpatch.pl warning

It would be nice if you explicitly mention the warning.

Thanks.
--
Gustavo

> Signed-off-by: Nasser Afshin <Afshin.Nasser@gmail.com>
> ---
>   drivers/media/i2c/tvp5150.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
> index d561d87d219a..d528fddbea16 100644
> --- a/drivers/media/i2c/tvp5150.c
> +++ b/drivers/media/i2c/tvp5150.c
> @@ -625,7 +625,7 @@ static int tvp5150_g_sliced_vbi_cap(struct v4l2_subdev *sd,
>   	int line, i;
>   
>   	dev_dbg_lvl(sd->dev, 1, debug, "g_sliced_vbi_cap\n");
> -	memset(cap, 0, sizeof *cap);
> +	memset(cap, 0, sizeof(*cap));
>   
>   	for (i = 0; i < ARRAY_SIZE(vbi_ram_default); i++) {
>   		const struct i2c_vbi_ram_value *regs = &vbi_ram_default[i];
