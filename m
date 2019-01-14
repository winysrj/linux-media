Return-Path: <SRS0=CLae=PW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C74CAC43612
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 13:06:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96E1120873
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 13:06:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ragnatech-se.20150623.gappssmtp.com header.i=@ragnatech-se.20150623.gappssmtp.com header.b="ZVrfqAE1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbfANNG0 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 14 Jan 2019 08:06:26 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:37516 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726565AbfANNG0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Jan 2019 08:06:26 -0500
Received: by mail-lj1-f193.google.com with SMTP id t18-v6so18954261ljd.4
        for <linux-media@vger.kernel.org>; Mon, 14 Jan 2019 05:06:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ragnatech-se.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=uor43rimp1qiUh7VU3UiYHBcRjP4oYtwSHGYuSyzkes=;
        b=ZVrfqAE1CN2M4aLUpS3XwHERp3uz5yyOCScGgIWFDfwVNrMik8ghFfAGnSxkbJiU0b
         GFdi0X8CWX3ZIhm/KIIgVjlVGxqwdhIQZYrTe9Rf+QpLLqJJcQ6MsqI+Bzwtcv7WRWYy
         yx3r1AEKoPCJyy+1iHMRtlm1iOdT9eCveP1HWbONbjnQRJs2mcBlStvssTZpJy7Vjc0w
         Tz1u2giE8tmagGddPbDlBXgkSP8OtlVK71d3QUWZicWE+N3J3A717HJdST9mRXVwgZsp
         QeCo2pNgwbrbZwlGi25pRXoLh7VZARQQPcnniImJy6vRDVuOTEI4Uq6KWlg2jwPHH2MD
         gDKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=uor43rimp1qiUh7VU3UiYHBcRjP4oYtwSHGYuSyzkes=;
        b=syQJbO6X2mpFTo7HRMFaivPikwNvmvug8uhOGHLEyZg8+GmlwW3/EF+1gVHQ+JjslE
         2MAuoRvzdP/iV5+pk4OIYkr34my1AzvuIHg7Mv2LS4xlGpEopG8eN87ak+MM2IOd1J4m
         3HL98jNXM3xDWwdrrvpr1cT1AeCryb4kA0Vqf/nXMZb7sr6Ewl9x9YhuJAzCfGKFwdvM
         vDQ+EeUe0sJDumI65jYvem/MUOgxU5KZLEVEyySDDEZ4IV3NICgDBZ4qhSS4dq7t/b+n
         fbf7uK/BxMbrRippMnDhOzXESJ2eJhWTAr2rxLMJm7HqP1wzu1GkCklDB9PKVIvbT3/u
         ANOg==
X-Gm-Message-State: AJcUukfotI+AW+Ik/N1a2lPrgLetQ5X/G2NrzYeO7Q2Ly6btVTa9k/85
        n5fIbaBPaXLnq89dlUG2dOr8EQ==
X-Google-Smtp-Source: ALg8bN7xVDzz1o4EXPWbs5wQm25LyId8BTuyiu6j5jLuYGXzo0bv1duYRDW0eNRNVMaVWJxVsev2mg==
X-Received: by 2002:a2e:82d7:: with SMTP id n23-v6mr12660838ljh.143.1547471183729;
        Mon, 14 Jan 2019 05:06:23 -0800 (PST)
Received: from localhost (89-233-230-99.cust.bredband2.com. [89.233.230.99])
        by smtp.gmail.com with ESMTPSA id f18sm84229lfk.18.2019.01.14.05.06.22
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 14 Jan 2019 05:06:22 -0800 (PST)
Date:   Mon, 14 Jan 2019 14:06:22 +0100
From:   Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@ragnatech.se>
To:     Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH v2] media: i2c: adv748x: Use devm to allocate the device
 struct
Message-ID: <20190114130622.GE30160@bigcity.dyn.berto.se>
References: <20190111161703.7972-1-kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190111161703.7972-1-kieran.bingham+renesas@ideasonboard.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Kieran,

Thanks for your work.

On 2019-01-11 16:17:03 +0000, Kieran Bingham wrote:
> From: Steve Longerbeam <steve_longerbeam@mentor.com>
> 
> Switch to devm_kzalloc() when allocating the adv748x device struct.
> 
> The sizeof() is updated to determine the correct allocation size from
> the dereferenced pointer type rather than hardcoding the struct type.

I would put this under a changes since v1 section and not for inclusion 
on the commit message upstream. Apart from that

Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> [Kieran: Change sizeof() to dereference the pointer type]
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> ---
>  drivers/media/i2c/adv748x/adv748x-core.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
> index 060d0c5b4989..1e5c7bbcf6b2 100644
> --- a/drivers/media/i2c/adv748x/adv748x-core.c
> +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> @@ -674,7 +674,7 @@ static int adv748x_probe(struct i2c_client *client,
>  	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
>  		return -EIO;
>  
> -	state = kzalloc(sizeof(struct adv748x_state), GFP_KERNEL);
> +	state = devm_kzalloc(&client->dev, sizeof(*state), GFP_KERNEL);
>  	if (!state)
>  		return -ENOMEM;
>  
> @@ -772,7 +772,6 @@ static int adv748x_probe(struct i2c_client *client,
>  	adv748x_dt_cleanup(state);
>  err_free_mutex:
>  	mutex_destroy(&state->mutex);
> -	kfree(state);
>  
>  	return ret;
>  }
> @@ -791,8 +790,6 @@ static int adv748x_remove(struct i2c_client *client)
>  	adv748x_dt_cleanup(state);
>  	mutex_destroy(&state->mutex);
>  
> -	kfree(state);
> -
>  	return 0;
>  }
>  
> -- 
> 2.17.1
> 

-- 
Regards,
Niklas Söderlund
