Return-Path: <SRS0=tcVs=Q6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B050BC43381
	for <linux-media@archiver.kernel.org>; Sat, 23 Feb 2019 01:44:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80F94206C0
	for <linux-media@archiver.kernel.org>; Sat, 23 Feb 2019 01:44:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ragnatech-se.20150623.gappssmtp.com header.i=@ragnatech-se.20150623.gappssmtp.com header.b="iUbX08bE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726225AbfBWBo0 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 22 Feb 2019 20:44:26 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:37429 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725859AbfBWBo0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Feb 2019 20:44:26 -0500
Received: by mail-lj1-f193.google.com with SMTP id a17so3142107ljd.4
        for <linux-media@vger.kernel.org>; Fri, 22 Feb 2019 17:44:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ragnatech-se.20150623.gappssmtp.com; s=20150623;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=5oKcICB60Z9p4Kmm99krOm5BfGVjExdsVEBUDXaAPGk=;
        b=iUbX08bE1pT6ezeLiGfClPgvJ1Y3j9wNx4f4FfpXbLDBUaTSWQoB0HU8GQPKRHHL2y
         BNPDinbtXJZ8KmniWH8/UtMCyFVpgttIEFadVoAu3cKqgmwopr5sigqvqE/eClGKjKj4
         LS2tNsBqmbzJaz7onHma9nOeLxYAk3OzKwXU+MbeTd2jvVWPgwDRTqwIcHTSCmBOGtkO
         55vWIwJOV37vKEIbCaV0LuEuLtM8BbI9tg1mU05J55le061qJCX12o68BWAjYzezqYw8
         L+OufM1GLKg/GPRn4urhoKbYo9KvqBx4Y77I27b+AvdeO7pK+DxrFXWddfuYmJ7WJToL
         rz2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=5oKcICB60Z9p4Kmm99krOm5BfGVjExdsVEBUDXaAPGk=;
        b=C43Dcs1PLug4V5oBDTbPLYngWUuRYn1YGZkRAjzSCSCwCWhD5Aq4sypj7WbMf4Wgh8
         0H8nYowfCl8kPw0P0QdoklxKxRI6JkrYtuY25Z9PL/xD7lt1TamWMp3008u2d6AY2owR
         rKAm933IYtmPBPbw/ZlIV9ih1OV7Pjkj5OMJhuL+ekc+LpItCzbgJVG1YqZuElTTApJ2
         RbwJjo/XyOBha3/mE3ORo6uJkahfR9CodCaqydllFKnhO/+LNKLOrsIBdYqJrDRrnWII
         b/rMa2OmXhTQoD9vF/oYysNh/OasrjK7QpGZbcyj8807x6SdBl/53+caFSscC7M0vLqr
         GHUA==
X-Gm-Message-State: AHQUAuaYI8Y5hrjjz6wPKOBnKh9Glg+ev1ulL51lvZX41rgSY5OOWxje
        ARGuJhhIOAzTAGmczoBc3ZFz0A==
X-Google-Smtp-Source: AHgI3IYJD7tjYVzYlprPZS/6dB6b3HevxzxsaBG+i+iWq3Wj8Fx5fmXqXOJ/lFbIpawPMm87HFV9tg==
X-Received: by 2002:a2e:8456:: with SMTP id u22mr3823038ljh.108.1550886263496;
        Fri, 22 Feb 2019 17:44:23 -0800 (PST)
Received: from localhost (89-233-230-99.cust.bredband2.com. [89.233.230.99])
        by smtp.gmail.com with ESMTPSA id g13sm928748lfb.57.2019.02.22.17.44.22
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 22 Feb 2019 17:44:22 -0800 (PST)
From:   "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
X-Google-Original-From: Niklas =?iso-8859-1?Q?S=F6derlund?= <niklas.soderlund+renesas@ragnatech.se>
Date:   Sat, 23 Feb 2019 02:44:22 +0100
To:     Shuah Khan <shuah@kernel.org>
Cc:     mchehab@kernel.org, hans.verkuil@cisco.com, keescook@chromium.org,
        sakari.ailus@linux.intel.com, colin.king@canonical.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] au0828: minor fix to a misleading comment in _close()
Message-ID: <20190223014422.GS11484@bigcity.dyn.berto.se>
References: <20190222174559.8084-1-shuah@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190222174559.8084-1-shuah@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Shuah,

Thanks for your patch.

On 2019-02-22 10:45:59 -0700, Shuah Khan wrote:
> Fix misleading comment in _close()
> 
> Signed-off-by: Shuah Khan <shuah@kernel.org>
> ---
>  drivers/media/usb/au0828/au0828-video.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
> index 7876c897cc1d..08f566006a1f 100644
> --- a/drivers/media/usb/au0828/au0828-video.c
> +++ b/drivers/media/usb/au0828/au0828-video.c
> @@ -1074,7 +1074,7 @@ static int au0828_v4l2_close(struct file *filp)
>  		 * so the s_power callback are silently ignored.
>  		 * So, the current logic here does the following:
>  		 * Disable (put tuner to sleep) when
> -		 * - ALSA and DVB aren't not streaming;
> +		 * - ALSA and DVB aren't streaming;

Nit-picking, as you are modifying the line anyhow I would s/;/./
With or without this changed,

Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

>  		 * - the last V4L2 file handler is closed.
>  		 *
>  		 * FIXME:
> -- 
> 2.17.1
> 

-- 
Regards,
Niklas Söderlund
