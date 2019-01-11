Return-Path: <SRS0=SCQz=PT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3647AC43612
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 16:08:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F207A20872
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 16:08:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="JHvF1Cft"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731344AbfAKQI1 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 11 Jan 2019 11:08:27 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:60272 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbfAKQI1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Jan 2019 11:08:27 -0500
Received: from [192.168.0.21] (cpc89242-aztw30-2-0-cust488.18-1.cable.virginm.net [86.31.129.233])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id E3AFF53E;
        Fri, 11 Jan 2019 17:08:24 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1547222905;
        bh=Fjw0Tr36V5a8XwaLzpWpx/HkbeijVqcvLiEblkobg9U=;
        h=Reply-To:Subject:To:References:From:Date:In-Reply-To:From;
        b=JHvF1CfteibSJUjaM6ayBVoyvU29t/6ucCCoTsTHlfaBVgRrsM7WbrKe22YHj3JYh
         RQUpoblGn6KsmUTlUpzsdxgRXgA1kT4TGf2RU8ftCJFUuk1vj1VQdja63PmME0a6jM
         c7oXWSFyiX7gbHEeN1mkkJQ0C0AAwhMsfagbMwAY=
Reply-To: kieran.bingham+renesas@ideasonboard.com
Subject: Re: [PATCH 2/2] media: i2c: adv748x: Use devm to allocate the device
 struct
To:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
References: <20190111154345.29145-2-kieran.bingham+renesas@ideasonboard.com>
From:   Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Organization: Ideas on Board
Message-ID: <52412a2d-bf8a-916f-96f9-8f4af93a18c7@ideasonboard.com>
Date:   Fri, 11 Jan 2019 16:08:22 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190111154345.29145-2-kieran.bingham+renesas@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Steve,

On 11/01/2019 15:43, Kieran Bingham wrote:
> From: Steve Longerbeam <steve_longerbeam@mentor.com>

Thank you for the patch, (which was forwarded to me from the BSP team)

> Switch to devm_kzalloc() when allocating the adv748x device struct.
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---
>  drivers/media/i2c/adv748x/adv748x-core.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
> index 097e5c3a8e7e..4af2ae8fcc0a 100644
> --- a/drivers/media/i2c/adv748x/adv748x-core.c
> +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> @@ -774,7 +774,8 @@ static int adv748x_probe(struct i2c_client *client,
>  	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
>  		return -EIO;
>  
> -	state = kzalloc(sizeof(struct adv748x_state), GFP_KERNEL);
> +	state = devm_kzalloc(&client->dev, sizeof(struct adv748x_state),

I would instead use:

	state = devm_kzalloc(&client->dev, sizeof(*state));


I will submit a v2 with this change made.

--
Regards

Kieran


> +			     GFP_KERNEL);
>  	if (!state)
>  		return -ENOMEM;
>  
> @@ -861,7 +862,6 @@ static int adv748x_probe(struct i2c_client *client,
>  	adv748x_dt_cleanup(state);
>  err_free_mutex:
>  	mutex_destroy(&state->mutex);
> -	kfree(state);
>  
>  	return ret;
>  }
> @@ -880,8 +880,6 @@ static int adv748x_remove(struct i2c_client *client)
>  	adv748x_dt_cleanup(state);
>  	mutex_destroy(&state->mutex);
>  
> -	kfree(state);
> -
>  	return 0;
>  }
>  
> 

