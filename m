Return-Path: <SRS0=s3Lq=O5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63131C43387
	for <linux-media@archiver.kernel.org>; Thu, 20 Dec 2018 13:47:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C2E821852
	for <linux-media@archiver.kernel.org>; Thu, 20 Dec 2018 13:47:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733220AbeLTNq6 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 20 Dec 2018 08:46:58 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:49116 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733117AbeLTNq5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Dec 2018 08:46:57 -0500
Received: from [IPv6:2001:a62:180a:4401:23b6:57c7:ac31:7c25] (unknown [IPv6:2001:a62:180a:4401:23b6:57c7:ac31:7c25])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: zzam)
        by smtp.gentoo.org (Postfix) with ESMTPSA id E2285335C6F;
        Thu, 20 Dec 2018 13:46:55 +0000 (UTC)
Subject: Re: [PATCH] media: si2165: fix a missing check of return value
To:     Kangjie Lu <kjlu@umn.edu>
Cc:     pakki001@umn.edu, Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20181220081209.40807-1-kjlu@umn.edu>
From:   Matthias Schwarzott <zzam@gentoo.org>
Message-ID: <40956844-c18d-31d2-1f2c-e164dfe82ecf@gentoo.org>
Date:   Thu, 20 Dec 2018 14:46:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <20181220081209.40807-1-kjlu@umn.edu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Am 20.12.18 um 09:12 schrieb Kangjie Lu:
> si2165_readreg8() may fail. Looking into si2165_readreg8(), we will find
> that "val_tmp" will be an uninitialized value when regmap_read() fails.
> "val_tmp" is then assigned to "val". So if si2165_readreg8() fails,
> "val" will be a random value. Further use will lead to undefined
> behaviors. The fix checks if si2165_readreg8() fails, and if so, returns
> "-EINVAL".
> 
Good catch. I reviewed it.
See below.

> Signed-off-by: Kangjie Lu <kjlu@umn.edu>
> ---
>  drivers/media/dvb-frontends/si2165.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/dvb-frontends/si2165.c b/drivers/media/dvb-frontends/si2165.c
> index feacd8da421d..c134f312fa5b 100644
> --- a/drivers/media/dvb-frontends/si2165.c
> +++ b/drivers/media/dvb-frontends/si2165.c
> @@ -275,18 +275,20 @@ static u32 si2165_get_fe_clk(struct si2165_state *state)
>  
>  static int si2165_wait_init_done(struct si2165_state *state)
>  {
> -	int ret = -EINVAL;
> +	int ret;
>  	u8 val = 0;
>  	int i;
>  
>  	for (i = 0; i < 3; ++i) {
> -		si2165_readreg8(state, REG_INIT_DONE, &val);
> +		ret = si2165_readreg8(state, REG_INIT_DONE, &val);
> +		if (ret < 0)
> +			return -EINVAL;
This code should return "ret" instead of "-EINVAL".

>  		if (val == 0x01)
>  			return 0;
>  		usleep_range(1000, 50000);
>  	}
>  	dev_err(&state->client->dev, "init_done was not set\n");
> -	return ret;
> +	return -EINVAL;

Here I am not sure if -ETIMEDOUT would be a better return code.

>  }
>  
>  static int si2165_upload_firmware_block(struct si2165_state *state,
> 

