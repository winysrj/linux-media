Return-Path: <SRS0=5UJH=RM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36CDCC43381
	for <linux-media@archiver.kernel.org>; Sat,  9 Mar 2019 11:02:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEB142081B
	for <linux-media@archiver.kernel.org>; Sat,  9 Mar 2019 11:02:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ragnatech-se.20150623.gappssmtp.com header.i=@ragnatech-se.20150623.gappssmtp.com header.b="PM96cNat"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726268AbfCILCV (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 9 Mar 2019 06:02:21 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:42603 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726233AbfCILCV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 9 Mar 2019 06:02:21 -0500
Received: by mail-lj1-f194.google.com with SMTP id d14so125964ljl.9
        for <linux-media@vger.kernel.org>; Sat, 09 Mar 2019 03:02:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ragnatech-se.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=q7EgyTKkBwCKENlJl+P4FiMkN5L+S2Lq9VbdUR33+dI=;
        b=PM96cNatutYRGN+iq2u2T2qoRxxFuuER0zpWwSJkvqLaqkSGThHEpAJUuWllBn32UE
         GmRqoXL86HU3mm+d3rFjVzQmqSFrtvEXn4ijiDMpXXYlU4AJ8PgaCrssqGmhH0mhAjxT
         Q8eRYVYSP9u5jKrYQei76kYCudXNgPCmGE005d47QHvd70YAoGR7ZvsaQ+6i/ehGey0Y
         hEjlB5n1O7dZ3f9rPeEATxlgHhuy/6oPQpzWoTBCIcryzUUIvf3tSiHLmq9lrp5yxXBo
         NFoFxiR486MiWEtHdJ1UPn9rHeEVk5fh2yh783wvy73H39kcmHfY9CBleE+NS7Y35D9r
         ArPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=q7EgyTKkBwCKENlJl+P4FiMkN5L+S2Lq9VbdUR33+dI=;
        b=S25YsoOCKVl3N06rNB+lhDgLQMOVvp6qYC/YP/spLFqALJp/R1RTikSTZZJ9a+/rHh
         vXh3CN4QQ5H0pR84xwaGcFAxZ1E5vdLSegZ8/TuHtjy6ZTVT7pamJV9+p5rZW9D4X6wA
         htjfmFacxPSGlTlxw9MkEC8T9BsBOn0bZm7Dxlv3tMD3siAydvpKjtcc+3cFWf9NroJL
         oSSdx/oK+u5SwcS/knshNpmlt32y0Q19rVDOUbcjq3W2uGFEMDDhSmL18JB8suC3+6JH
         vfOziqj/JXaUFBOc6Dlpr9zhI25uZndL5xXMelSZylQEVgnsyoxtiBcqBsap6+YD/6Tt
         oZcA==
X-Gm-Message-State: APjAAAXlt3tcH70KrlLugejte72q+QPKhTx7GrMYaRsnb5882gVdzpV5
        iGPaYmXzma/S0oUfucVYIeaFNQ==
X-Google-Smtp-Source: APXvYqx2ApC9Ka/qjOXmF09vmAZsU6Nz2YoUaT9KO0tMBguw+S7Lk6IrSoXS1bGmWu6FsyEE4mTKwA==
X-Received: by 2002:a2e:5d88:: with SMTP id v8mr11484224lje.150.1552129338883;
        Sat, 09 Mar 2019 03:02:18 -0800 (PST)
Received: from localhost (89-233-230-99.cust.bredband2.com. [89.233.230.99])
        by smtp.gmail.com with ESMTPSA id q2sm36232ljq.19.2019.03.09.03.02.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 09 Mar 2019 03:02:18 -0800 (PST)
Date:   Sat, 9 Mar 2019 12:02:17 +0100
From:   Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@ragnatech.se>
To:     Kangjie Lu <kjlu@umn.edu>
Cc:     pakki001@umn.edu, Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: rcar-vin: fix a potential NULL pointer dereference
Message-ID: <20190309110217.GA5281@bigcity.dyn.berto.se>
References: <20190309070527.2657-1-kjlu@umn.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190309070527.2657-1-kjlu@umn.edu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Kangjie,

Thanks for your patch.

On 2019-03-09 01:05:27 -0600, Kangjie Lu wrote:
> In case of_match_node cannot find a match, the fix returns
> -EINVAL to avoid NULL pointer dereference.
> 
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>
> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> index f0719ce24b97..a058e2023ca8 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -266,6 +266,8 @@ static int rvin_group_init(struct rvin_group *group, struct rvin_dev *vin)
>  
>  	match = of_match_node(vin->dev->driver->of_match_table,
>  			      vin->dev->of_node);
> +	if (unlikely(!match))
> +		return -EINVAL;

I don't think this is needed. The driver depends on selects OF and if we 
get this far we it is because we had a match already. The reason to call 
of_match_node() here is simply to retrieve which of the possible 
compatible strings was matched.

Am I missing something? What scenario do you see where this can fail?

>  
>  	strscpy(mdev->driver_name, KBUILD_MODNAME, sizeof(mdev->driver_name));
>  	strscpy(mdev->model, match->compatible, sizeof(mdev->model));
> -- 
> 2.17.1
> 

-- 
Regards,
Niklas Söderlund
