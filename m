Return-Path: <SRS0=g7QC=O6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B75CDC43387
	for <linux-media@archiver.kernel.org>; Fri, 21 Dec 2018 08:24:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DA6C218E2
	for <linux-media@archiver.kernel.org>; Fri, 21 Dec 2018 08:24:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733083AbeLUIYw (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 21 Dec 2018 03:24:52 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:59494 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732782AbeLUIYv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Dec 2018 03:24:51 -0500
Received: from [IPv6:2001:a62:180a:4401:23b6:57c7:ac31:7c25] (unknown [IPv6:2001:a62:180a:4401:23b6:57c7:ac31:7c25])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: zzam)
        by smtp.gentoo.org (Postfix) with ESMTPSA id C1B48335C39;
        Fri, 21 Dec 2018 08:24:49 +0000 (UTC)
Subject: Re: [PATCH v2] media: si2165: fix a missing check of return value
To:     Kangjie Lu <kjlu@umn.edu>
Cc:     pakki001@umn.edu, Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20181221045403.59303-1-kjlu@umn.edu>
From:   Matthias Schwarzott <zzam@gentoo.org>
Message-ID: <7a5d505d-692b-f067-51f6-815787cffba3@gentoo.org>
Date:   Fri, 21 Dec 2018 09:24:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <20181221045403.59303-1-kjlu@umn.edu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Am 21.12.18 um 05:54 schrieb Kangjie Lu:
> si2165_readreg8() may fail. Looking into si2165_readreg8(), we will find
> that "val_tmp" will be an uninitialized value when regmap_read() fails.
> "val_tmp" is then assigned to "val". So if si2165_readreg8() fails,
> "val" will be a random value. Further use will lead to undefined
> behaviors. The fix checks if si2165_readreg8() fails, and if so, returns
> its error code upstream.
> 
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>

Reviewed-by: Matthias Schwarzott <zzam@gentoo.org>

> ---
>  drivers/media/dvb-frontends/si2165.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/dvb-frontends/si2165.c b/drivers/media/dvb-frontends/si2165.c
> index feacd8da421d..d55d8f169dca 100644
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
> +			return ret;
>  		if (val == 0x01)
>  			return 0;
>  		usleep_range(1000, 50000);
>  	}
>  	dev_err(&state->client->dev, "init_done was not set\n");
> -	return ret;
> +	return -EINVAL;
>  }
>  
>  static int si2165_upload_firmware_block(struct si2165_state *state,
> 

