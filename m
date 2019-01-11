Return-Path: <SRS0=SCQz=PT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 468B8C43387
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 20:13:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1CC102177B
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 20:13:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ndufresne-ca.20150623.gappssmtp.com header.i=@ndufresne-ca.20150623.gappssmtp.com header.b="F2gukzoI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389268AbfAKUNu (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 11 Jan 2019 15:13:50 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:33389 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387951AbfAKUNu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Jan 2019 15:13:50 -0500
Received: by mail-qt1-f196.google.com with SMTP id l11so20257422qtp.0
        for <linux-media@vger.kernel.org>; Fri, 11 Jan 2019 12:13:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ndufresne-ca.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:date:in-reply-to:references:user-agent
         :mime-version:content-transfer-encoding;
        bh=mVadURPdmQXC45QOiIuo+BZzmYj3CJIU6mXYM2cQfWA=;
        b=F2gukzoIU3AM/y01fi/lZX6WXtwYN3SkziCEkOH2CZbwHqACxRGeonDu5RvPgdgyqI
         byMDURfcZkQiT9xgtwaJHXJoHkkpAWxBbkD1vzTEZQPpWCzRQ8pj7oCS1wqhIrkbh2GK
         n+CgRWrreB6tuyRckpdWd1o9ffTAwc7PDsHFxwz2blbOjj52t6pMMXiSf3diuxD45+k7
         MfI7O00izW7op4/a2XUVm6DwIypFYddoxp6Ns/DMxdzR0hjhv8Owk7Ol42eUKw0cLYm7
         2LwDLoavMJIGQdjI2TB2+I0AeDWNbnbKuQKn4rdsm40wM6gDUtie1q79IR15NeAryfhW
         UyEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=mVadURPdmQXC45QOiIuo+BZzmYj3CJIU6mXYM2cQfWA=;
        b=qphjkLKrGKqad5LJSyw/F6KaYRGo8jHU8tHR4vzOeaZyY1EXoT1FqeGyrPkZ+XG24h
         yB+kNZGmRCgR3Dc/ccX1/uKvTknpwZMD4jRoiaHZPIEL642wGd5VUCpEDfX1qS1b3yHc
         VjPKEUSy3l4R/qhxE6YI8YewK3kThiMGJXieLQiYIUoUwoxzYUmwNs3Wcn4ofybqRqS2
         fxadLP5C3Iq2hOdJA1VxFgCzAEuzVrugt+aIGdwPvTkeoyBt7/vbCQ8MtRL7vCQki5SG
         pTBnsozgNCiddjA/kC4dwzRAXaI9Szj969Z4/py5cK4euTAM5Ij4lJO2PjoJiouVH3CE
         Qc0g==
X-Gm-Message-State: AJcUukdVwsQ/mu8nsx/p5OE6msc+cyGL1nDe5BJLsAh1vPYz+Yoxalig
        pXRPwOejwoQnG/bTluJd1WOyIA==
X-Google-Smtp-Source: ALg8bN6+R3mtTeN5jmmnLPgSrUT0yIdImtsoRBSHRvZB56HAuUGITN8+G+/qT6dJxO0W/jCU8lc6dA==
X-Received: by 2002:ac8:65c7:: with SMTP id t7mr14913028qto.143.1547237629209;
        Fri, 11 Jan 2019 12:13:49 -0800 (PST)
Received: from skullcanyon ([192.222.193.21])
        by smtp.gmail.com with ESMTPSA id j38sm51298470qtj.72.2019.01.11.12.13.47
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 11 Jan 2019 12:13:47 -0800 (PST)
Message-ID: <e51b9648691804cc97868a79d56e713df8e938c5.camel@ndufresne.ca>
Subject: Re: [PATCH] vivid: do not implement VIDIOC_S_PARM for output streams
From:   Nicolas Dufresne <nicolas@ndufresne.ca>
To:     Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Date:   Fri, 11 Jan 2019 15:13:46 -0500
In-Reply-To: <fc0e18f4-b499-60b4-d750-12beb06f98ce@xs4all.nl>
References: <fc0e18f4-b499-60b4-d750-12beb06f98ce@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.3 (3.30.3-1.fc29) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Le vendredi 11 janvier 2019 à 12:37 +0100, Hans Verkuil a écrit :
> v4l2_compliance gave a warning for the S_PARM test for output streams:
> 
> warn: v4l2-test-formats.cpp(1235): S_PARM is supported for buftype 2, but not for ENUM_FRAMEINTERVALS
> 
> The reason is that vivid mapped s_parm for output streams to g_parm. But if
> S_PARM doesn't actually change anything, then it shouldn't be enabled at all.

Though now, a vivid output reflect even less an output HW, for which I
would expect S_PARM to be used to configure the HW transmission clock.

> 
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> ---
> diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
> index c931f007e5b0..7da5720b47a2 100644
> --- a/drivers/media/platform/vivid/vivid-core.c
> +++ b/drivers/media/platform/vivid/vivid-core.c
> @@ -371,7 +371,7 @@ static int vidioc_s_parm(struct file *file, void *fh,
> 
>  	if (vdev->vfl_dir == VFL_DIR_RX)
>  		return vivid_vid_cap_s_parm(file, fh, parm);
> -	return vivid_vid_out_g_parm(file, fh, parm);
> +	return -ENOTTY;
>  }
> 
>  static int vidioc_log_status(struct file *file, void *fh)

