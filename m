Return-Path: <SRS0=2Dg0=OV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45FE5C65BAF
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 17:55:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F38E20851
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 17:55:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0F38E20851
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727900AbeLLRzC (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 12 Dec 2018 12:55:02 -0500
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:50252 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727881AbeLLRzC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Dec 2018 12:55:02 -0500
Received: from [IPv6:2001:983:e9a7:1:d5c3:7636:7173:44a0] ([IPv6:2001:983:e9a7:1:d5c3:7636:7173:44a0])
        by smtp-cloud8.xs4all.net with ESMTPA
        id X8ikgl0opuDWoX8ilgJEVC; Wed, 12 Dec 2018 18:55:00 +0100
Subject: Re: [PATCH] media: imx214: don't de-reference a NULL pointer
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
References: <4800f277368eb6cc6099eb622988588e5a5de9ae.1544182979.git.mchehab+samsung@kernel.org>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Message-ID: <823b68c7-dd0d-088a-d870-596c8b8e1bf5@xs4all.nl>
Date:   Wed, 12 Dec 2018 18:54:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <4800f277368eb6cc6099eb622988588e5a5de9ae.1544182979.git.mchehab+samsung@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfNf5E1Wy46m7DXQzylHBxAOoZL7XUYvPG5GZPE0R2FteK3mrfyYHgzdIvO8eTy2UjZuczZyOjfFHvZxFCtvZ+ZUtcwOchcZPbzxIFV+dkE+GUwnZyv6r
 ULJfYTIosko2fKnJcqAsE15O54g0MwOA3P8if+6QtUCzzPoq4OjdtjAxKa0byIJmi6z4p7CUT8PekxSgoaHCLP1NBRSZm+wyCy8cZSe8Jk8T0/dn7MkvolbE
 t9I1Cp9FEXNL2HBpyotw19mUzI9a6+EMMXpTu2RN//Ek+X9x3Fw8dp2lTMBOeqvglAvcxv3nq0BLPZ4soeRiMcJ1TK5nLzG1rRkl1iSbsitIwo0rXXvzdJX9
 z0Je65I4wkk+upSzMwkUCZNqx7/wto8kk/5GZ3chMpPh0AIEoME=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 12/7/18 12:43 PM, Mauro Carvalho Chehab wrote:
> As warned by smatch:
> 	drivers/media/i2c/imx214.c:591 imx214_set_format() warn: variable dereferenced before check 'format' (see line 589)
> 
> It turns that the code at imx214_set_format() has support for being
> called with the format being NULL. I've no idea why, as it is only
> called internally with the pointer set, and via subdev API (with
> should also set it).
> 
> Also, the entire logic there depends on having format != NULL, so
> just remove the bogus broken support for a null format.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

Reviewed-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Regards,

	Hans

> ---
>  drivers/media/i2c/imx214.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/i2c/imx214.c b/drivers/media/i2c/imx214.c
> index ec3d1b855f62..b046a26219a4 100644
> --- a/drivers/media/i2c/imx214.c
> +++ b/drivers/media/i2c/imx214.c
> @@ -588,12 +588,10 @@ static int imx214_set_format(struct v4l2_subdev *sd,
>  
>  	__crop = __imx214_get_pad_crop(imx214, cfg, format->pad, format->which);
>  
> -	if (format)
> -		mode = v4l2_find_nearest_size(imx214_modes,
> -				ARRAY_SIZE(imx214_modes), width, height,
> -				format->format.width, format->format.height);
> -	else
> -		mode = &imx214_modes[0];
> +	mode = v4l2_find_nearest_size(imx214_modes,
> +				      ARRAY_SIZE(imx214_modes), width, height,
> +				      format->format.width,
> +				      format->format.height);
>  
>  	__crop->width = mode->width;
>  	__crop->height = mode->height;
> 

