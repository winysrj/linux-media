Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C731C43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 20:50:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8F692075C
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 20:50:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZaEuS2h6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbfAIUuw (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 15:50:52 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:41584 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727113AbfAIUuw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2019 15:50:52 -0500
Received: by mail-lf1-f68.google.com with SMTP id c16so6678507lfj.8;
        Wed, 09 Jan 2019 12:50:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=B42gs8Y3HgVHs+5T0aoIuishxfjjrxk1B5kiRgNNK0A=;
        b=ZaEuS2h6aAzWZUhyZGtuHYMxWM2IR/3aPP/mXJgGz9Mof5VOWdbmdu4ooWc7lpieqi
         GP79IUQjXd4I48tXilbh32g+03ufwIoscYAv+3GyD/fLnvoNfcWkwoREJSDxzDvvpxO7
         YJ1RN6NQLhPRIttZ091xuKCPWZ65gYVRwP5Aet6uePpXCEuhyWMQZFYLd8LbNY4UyDD9
         IUwfdaN1/7eeXsehtqPoWloKCT1D2TEhTtktl2irNaS/uZvSEkuCunbZdgxba8+JBEsi
         5meg3K5AjwMv2AJQXI9WwFr1y2/TgZY6cZLdVuAOUA+tzBUU0JwdU4J5HLlUsRN0tYGs
         U17g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=B42gs8Y3HgVHs+5T0aoIuishxfjjrxk1B5kiRgNNK0A=;
        b=SWnZ5qn3NsZObp+Z9RFqxpha7pzmAy/HdYhwUJf2z4IfFaDMdUHQXndmLFUUwfL7bm
         k5lg3L+SvLa+cexTPlaC5vjrdbQoc7QjarXPDLUUfnRUK4vQ5mFWpBblXW2L56aCOIpz
         9y3QBrpoHSh+4gQfRJmDONwqGgUt7pXF/h136SPGEebgJRarsWWYAVyvMQxJJj0kIZ95
         azdTo+/6Sa+KiIRe+lx+tp8JDbOHptaR5BJhc3brGDDAN7iWQIqXChNC72y15gA401XN
         wmxSIOY5qGIFpyvHMRMr068GU89rUE0SzjDpd0svy2KYYhnPT9Dcy1EJpZuYjP93icJS
         ooYQ==
X-Gm-Message-State: AJcUukdSjiTjO2XztNPOS0n8XOrjNdQbwuW/ykhCs/zFSP+YgZV8Cetb
        gJKBURDcyoKbNHFWOvEK253BBJV9
X-Google-Smtp-Source: ALg8bN4jWDbiVaQ6UqbalhDJl1H+6XAAhUcEYZ3FZ3nQCka3PW5vTUwBHXPvuJ1oO20kQNMfHDC3fg==
X-Received: by 2002:a19:1994:: with SMTP id 142mr4590396lfz.134.1547067049570;
        Wed, 09 Jan 2019 12:50:49 -0800 (PST)
Received: from [192.168.1.18] (chc231.neoplus.adsl.tpnet.pl. [83.31.0.231])
        by smtp.gmail.com with ESMTPSA id t18sm13710341lft.93.2019.01.09.12.50.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Jan 2019 12:50:48 -0800 (PST)
Subject: Re: [PATCH] media: s5p-jpeg: Correct step and max values for
 V4L2_CID_JPEG_RESTART_INTERVAL
To:     =?UTF-8?Q?Pawe=c5=82_Chmiel?= <pawel.mikolaj.chmiel@gmail.com>,
        andrzej.p@samsung.com
Cc:     mchehab@kernel.org, s.nawrocki@samsung.com,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
References: <20190109180041.31052-1-pawel.mikolaj.chmiel@gmail.com>
From:   Jacek Anaszewski <jacek.anaszewski@gmail.com>
Message-ID: <843c632a-0804-8a30-0002-a87b85de1ed3@gmail.com>
Date:   Wed, 9 Jan 2019 21:50:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190109180041.31052-1-pawel.mikolaj.chmiel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Paweł,

Thank you for the patch.

On 1/9/19 7:00 PM, Paweł Chmiel wrote:
> This commit corrects max and step values for v4l2 control for
> V4L2_CID_JPEG_RESTART_INTERVAL. Max should be 0xffff and step should be 1.
> It was found by using v4l2-compliance tool and checking result of
> VIDIOC_QUERY_EXT_CTRL/QUERYMENU test.
> Previously it was complaining that step was bigger than difference
> between max and min.
> 
> Fixes: 15f4bc3b1f42 ("[media] s5p-jpeg: Add JPEG controls support")
> Signed-off-by: Paweł Chmiel <pawel.mikolaj.chmiel@gmail.com>
> ---
>   drivers/media/platform/s5p-jpeg/jpeg-core.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> index 3f9000b70385..33e9927db9a0 100644
> --- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
> +++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> @@ -2002,7 +2002,7 @@ static int s5p_jpeg_controls_create(struct s5p_jpeg_ctx *ctx)
>   
>   		v4l2_ctrl_new_std(&ctx->ctrl_handler, &s5p_jpeg_ctrl_ops,
>   				  V4L2_CID_JPEG_RESTART_INTERVAL,
> -				  0, 3, 0xffff, 0);
> +				  0, 0xffff, 1, 0);
>   		if (ctx->jpeg->variant->version == SJPEG_S5P)
>   			mask = ~0x06; /* 422, 420 */
>   	}
> 

Reviewed-by: Jacek Anaszewski <jacek.anaszewski@gmail.com>

-- 
Best regards,
Jacek Anaszewski
