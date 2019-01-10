Return-Path: <SRS0=KIs1=PS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E347C43387
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 21:06:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 116F2208E3
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 21:06:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Du1ks/mb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728748AbfAJVGC (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 10 Jan 2019 16:06:02 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34787 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727846AbfAJVGC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Jan 2019 16:06:02 -0500
Received: by mail-wm1-f68.google.com with SMTP id y185so557961wmd.1
        for <linux-media@vger.kernel.org>; Thu, 10 Jan 2019 13:06:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=CLRHygBVCs6aOHVFkGYZ8t276oPzFy7Aze3GAyXtbq0=;
        b=Du1ks/mbV2rl70mbKreZCdvIlC5w2m2CFMmyTYT3veJkLEpnJxo96TScTjJfjv1NgC
         25L7lQhQHNihp6tu3jjLe/UEkI5lQ8zxvhot+ynhYv/Q1w8pdxHP8fCFGPOUnyYNOjqF
         6t5FsnAfL6SxiBg6xan06c5HGEXouYLwYAUJel6bZQmfq9cn9kVXG7Qm0WzU2WrR1ppQ
         CNqay1uT3Okr8+OpRZrLUBZc2YTuqNPFqECUPJdmxo+oLUeBfdSQ9t6selY2ybSoJpbN
         s3L0FDDdMAuakQQKY6vwl3tP84Iq1vALaq37OoHUTyjUGgIoU4Gy9KXS9ywBFCXHrhbn
         beFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=CLRHygBVCs6aOHVFkGYZ8t276oPzFy7Aze3GAyXtbq0=;
        b=U0iWiok6eC4g5O9cwDlFneqip6kqSjydMOAkeOBDfOCu6sUYFH47mvte9ofIy7S6/r
         ydxvyKtvuGH9FQcEt4HtlVGNcXuzIN8pOfvwRWO01ztMfynYZeyk0QJsMq0ZBuPyWqjd
         n4sRkL1edOQ91/SFB6FRw36M5H4TNFMCDd2BlNIRqvc1ydmngorkxmNsKKSjzRcjtD5F
         ZPUrKxpGCYNMi2g/y0/E7PnqAx2HF3xuxd0BtXdStctGDrsJBq6/ul9B8vvOMcFn8w+e
         8zE/8GMwKFoeSHThcUPJZwQCdCfK0qkVu33ZBAoLYMv/sgW8AhrfJ2QsI4tfz/ZOc64j
         Ecjg==
X-Gm-Message-State: AJcUukc6SpTOKvdQQ5MpRLFQijRr13Utz8VqC2nam8MrLIydlj0sWiin
        gpsTt6zpenKRcg8MowUrLho=
X-Google-Smtp-Source: ALg8bN73pY/MGwkltoUmfsid1M/Dp5xRLRSkffYESUNCvmaidMcXlXNbycj5MSyhplW7EBJwFyMN7w==
X-Received: by 2002:a1c:2d42:: with SMTP id t63mr347611wmt.9.1547154359430;
        Thu, 10 Jan 2019 13:05:59 -0800 (PST)
Received: from [172.30.90.4] (sjewanfw1-nat.mentorg.com. [139.181.7.34])
        by smtp.gmail.com with ESMTPSA id x81sm18150476wmg.17.2019.01.10.13.05.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Jan 2019 13:05:58 -0800 (PST)
Subject: Re: [PATCH v2 3/3] media: imx: lift CSI and PRP ENC/VF width
 alignment restriction
To:     Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, kernel@pengutronix.de
References: <20190109110831.23395-1-p.zabel@pengutronix.de>
 <20190109110831.23395-3-p.zabel@pengutronix.de>
 <fe63e40b-08ae-5ff1-c222-f5a624b83569@gmail.com>
 <1547117681.8943.3.camel@pengutronix.de>
From:   Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <1b5c7e7b-bfb0-6d4d-8707-a40850f90acd@gmail.com>
Date:   Thu, 10 Jan 2019 13:05:54 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <1547117681.8943.3.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



On 1/10/19 2:54 AM, Philipp Zabel wrote:
> On Wed, 2019-01-09 at 11:21 -0800, Steve Longerbeam wrote:
>> <snip>
>>
>> why not just use "if (priv->active_output_pad == CSI_SRC_PAD_DIRECT) ..." ?
> While both source pad links are disabled, whether or not IC burst
> alignment is applied would depend on hidden state. This should be
> consistent, regardless of previously enabled source pad links.

Yes good point.

>
> We could achieve that with your suggested change if csi_link_setup()
> would always set active_output_pad = CSI_SRC_PAD_IDMAC when disabling
> source pad links:
>
> ----------8<----------
> diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
> index dd911313fca2..e593fd7774ff 100644
> --- a/drivers/staging/media/imx/imx-media-csi.c
> +++ b/drivers/staging/media/imx/imx-media-csi.c
> @@ -1000,6 +1000,8 @@ static int csi_link_setup(struct media_entity *entity,
>   		v4l2_ctrl_handler_free(&priv->ctrl_hdlr);
>   		v4l2_ctrl_handler_init(&priv->ctrl_hdlr, 0);
>   		priv->sink = NULL;
> +		/* do not apply IC burst alignment in csi_try_crop */
> +		priv->active_output_pad = CSI_SRC_PAD_IDMAC;

Yes that will work. But I also notice priv->active_output_pad is not 
even being initialized. Do you mind including that as well, e.g 
initialize to CSI_SRC_PAD_IDMAC in imx_csi_probe().

Thanks Philipp.

Steve

