Return-Path: <SRS0=I7H+=PZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F2A3C43387
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 20:53:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E47320859
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 20:53:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="r6Brm40w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbfAQUxM (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 17 Jan 2019 15:53:12 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33461 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727300AbfAQUxM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Jan 2019 15:53:12 -0500
Received: by mail-wr1-f68.google.com with SMTP id c14so12631218wrr.0;
        Thu, 17 Jan 2019 12:53:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=f33YIsZV5aBLStuZXuOwiQYSbzeswEllPaxDJaLidLQ=;
        b=r6Brm40wQJkfkucd0Ig3gzeMToZxzQiwX/97ukO0WgnE9HVZ5lglu281OAZy5VpVWF
         Bew9ProIEfy2BJkK6rhFWB+4tvV4f/vOYD7wWPKv8GSzlm61K1EAEZUAuJlYCnuhwzt+
         6W75j/4BKk1Q1NP6SbyKegl9vxh/O4HE5aQdnxChflWhbPTlCLpzNK6Md0Ul4QZebdZt
         rOiVBYSZXtulDUkrlGcxl1Gkon9/CnUlV/Q/jP5PK/VsL28HtnI8Fuy6X+lgLBrEdwX6
         6LNqfc6bzY5v0Fz9PUcWI9JFG67IaBTM6UxCdSi6JOHEa3rh0AeC8KoaMeeBeba5mXMG
         2oNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=f33YIsZV5aBLStuZXuOwiQYSbzeswEllPaxDJaLidLQ=;
        b=N4qUwFKXWa4/OSdTCJy0aNwfjbRse8S7S7m7/T7sQEj5FXOm8jPnL936p8mrGtJ7Dd
         oAcRbvMX7aBcXpwsk0Dpcds+75JCIq3NpinOKjpVPMKqrOwpUB707T6yj1P7MII55My0
         m3kNAhkbEQLrFHSRp5FkmE9bX4/s7kNvOpYnheMzOERTeV9dTXl9q5UvjSVB09VtybGc
         J4Me2DIehy7W6t3In5alO+Ge1xSlztswU1yyErqcssF5zF0isQvDGMixDjrw82Tr+dTU
         Njv5KLXl74J+tMbfbMkwG83wCDveuR/cJo233tZiJdgUhDbz70uAOp4SGJy58cewsaQH
         XJ/Q==
X-Gm-Message-State: AJcUukcRWPyQp9FyKyJ5KIt7DV6NWcaMaQv+Vh3fcN8jbkhfLOodJilT
        nzl/uZqpVbYvX9dYmZjgyAcZerFe
X-Google-Smtp-Source: ALg8bN7u9B4XFGHHzHKh0FN9MdfeRmeWxfKamcb7R7ccsPl6vy10FCt/yeQpden3bXGQr8mDNd9aIg==
X-Received: by 2002:a05:6000:104b:: with SMTP id c11mr13798549wrx.303.1547758390138;
        Thu, 17 Jan 2019 12:53:10 -0800 (PST)
Received: from [172.30.90.213] (sjewanfw1-nat.mentorg.com. [139.181.7.34])
        by smtp.gmail.com with ESMTPSA id y145sm30663297wmd.30.2019.01.17.12.53.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Jan 2019 12:53:09 -0800 (PST)
Subject: Re: [PATCH] media: imx-csi: Input connections to CSI should be
 optional
To:     Tim Harvey <tharvey@gateworks.com>
Cc:     linux-media <linux-media@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20190109183448.20923-1-slongerbeam@gmail.com>
 <CAJ+vNU1dByOE8QM4Y0R0z9sSgvb6_73_xTyRiOZL4LXb9BgR3w@mail.gmail.com>
From:   Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <be53ba69-9ad3-80c1-d7f7-d2ff40c48e2b@gmail.com>
Date:   Thu, 17 Jan 2019 12:53:06 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <CAJ+vNU1dByOE8QM4Y0R0z9sSgvb6_73_xTyRiOZL4LXb9BgR3w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Tim,

On 1/15/19 8:42 AM, Tim Harvey wrote:
> On Wed, Jan 9, 2019 at 10:34 AM Steve Longerbeam <slongerbeam@gmail.com> wrote:
>> Some imx platforms do not have fwnode connections to all CSI input
>> ports, and should not be treated as an error. This includes the
>> imx6q SabreAuto, which has no connections to ipu1_csi1 and ipu2_csi0.
>> Return -ENOTCONN in imx_csi_parse_endpoint() so that v4l2-fwnode
>> endpoint parsing will not treat an unconnected CSI input port as
>> an error.
>>
>> Fixes: c893500a16baf ("media: imx: csi: Register a subdev notifier")
>>
>> Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
>> ---
>>   drivers/staging/media/imx/imx-media-csi.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
>> index 4223f8d418ae..30b1717982ae 100644
>> --- a/drivers/staging/media/imx/imx-media-csi.c
>> +++ b/drivers/staging/media/imx/imx-media-csi.c
>> @@ -1787,7 +1787,7 @@ static int imx_csi_parse_endpoint(struct device *dev,
>>                                    struct v4l2_fwnode_endpoint *vep,
>>                                    struct v4l2_async_subdev *asd)
>>   {
>> -       return fwnode_device_is_available(asd->match.fwnode) ? 0 : -EINVAL;
>> +       return fwnode_device_is_available(asd->match.fwnode) ? 0 : -ENOTCONN;
>>   }
>>
>>   static int imx_csi_async_register(struct csi_priv *priv)
>> --
>> 2.17.1
>>
> Steve,
>
> Thanks, this fixes adv7180 the capture regression on the Gateworks
> Ventana boards as well. This should go to stable to fix 4.20 so please
> add a 'Cc: stable@vger.kernel.org' if you re-submit (else we can send
> it to stable@vger.kernel.org later).
>
> Acked-by: Tim Harvey <tharvey@gateworks.com>

I will resubmit a non-functional v2 that adds the Cc: stable and your ack.

Steve

