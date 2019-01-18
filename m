Return-Path: <SRS0=Cp5C=P2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD99AC07EBF
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 19:15:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 995132087E
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 19:15:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WqPv2zra"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729266AbfARTPv (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 18 Jan 2019 14:15:51 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37025 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729230AbfARTPu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Jan 2019 14:15:50 -0500
Received: by mail-wr1-f66.google.com with SMTP id s12so16404489wrt.4
        for <linux-media@vger.kernel.org>; Fri, 18 Jan 2019 11:15:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=4UcYRln9hXtoROuzLYCrujdBYu3PKfpbXHxWB96iLvw=;
        b=WqPv2zrabMhAw5IdLtnpaf2uCs+aC7mryiXelpjOSluiyyOQ3YVn5vNvG5WNteZOIL
         +pvAh75/oo1UVoZZMqtO5kqYcEcxEKwm4lYd2X/5XZ7p2Xfja4l3t4oxj1mpwqH4Sncb
         5nuiwRVBSLVBtNh2xlxExBYZMSaXD7E9QvYo/C0SYj/HrnoJmIcFaoamcqcv8K/Y5feB
         NjYrdh+CMd5fxAGk5oIEoYQ8C948y9MWbg+Whalkin+XHGwR70glKNxZpjeFvIzir+Sq
         9NsnoIyzA8+VCDzZyFp+syq/usVzlK9jkXNiKd5y7ej43TWC/TVi3QYlVVkUc8Yh+zLJ
         2JaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=4UcYRln9hXtoROuzLYCrujdBYu3PKfpbXHxWB96iLvw=;
        b=eodTCJNSbKnNzBBSOTSbZo7RpgYTPrhV5YQZKCD+G7xXW3O9OZSAELvvxfg7cm7Wvq
         rI2Aq3TC/prAFgz/OV/CyWtp+5i1NUdE/DaGcEnnqTjOPAYVs/mjH4GYokuMk3s6iWqO
         aAzE3O7p0Rmg1LiylIy6HDdj4w+t95aM6owXmq429yOmGK4fAVm5L8nH+C+RRpELOmZ0
         NUGipmuBSxIXib27MUl+LkRBf28NGExN+bd4ZVpXXRhWb12YfQ8llzT56Wv1StFRLSSO
         Rlp+RCK5pYQ1v6W4PVbcMqNjcpsuFYooy5SEsOlJRnN42WesQ26LKR5LAbDOZmYery6E
         TKqQ==
X-Gm-Message-State: AJcUukfDy8VDheN89rA4DeFGGz9OsoiZ85GJo1XHfeBnrawLUU0tCW8B
        mu+0BqpU4XzxAnSDPSL5dCDxoJ4L
X-Google-Smtp-Source: ALg8bN65dgiyGtA7tFzWz9I/Ux+F1PPgmHt1/e9SrEq+NxCXg6gHoGHjXHnVO42xlmCTya6WbtAReQ==
X-Received: by 2002:a5d:504f:: with SMTP id h15mr17913277wrt.83.1547838948717;
        Fri, 18 Jan 2019 11:15:48 -0800 (PST)
Received: from [172.30.88.68] (sjewanfw1-nat.mentorg.com. [139.181.7.34])
        by smtp.gmail.com with ESMTPSA id y138sm49570221wmc.16.2019.01.18.11.15.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Jan 2019 11:15:48 -0800 (PST)
Subject: Re: [v2,1/2] media: imx: csi: Disable CSI immediately after last EOF
To:     Peter Seiderer <ps.report@gmx.net>
Cc:     linux-media@vger.kernel.org
References: <20190118180321.2789f7a2@gmx.net>
From:   Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <9d7263bb-9556-e7a4-82b5-02778a1468a2@gmail.com>
Date:   Fri, 18 Jan 2019 11:15:45 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190118180321.2789f7a2@gmx.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Peter,

Thanks for the suggestion. My patch introduces some inconsistency in the 
code, and your solution fixes those issues and is much simpler. It seems 
the fix is to silence the video data stream entering the IDMAC channel 
before disabling the channel, and that can be done either by disabling 
the SMFC or the CSI.

I'm testing your patch on the SabreAuto reference board. If it looks 
good, I can either make you the author or the Suggested-by:, whichever 
you prefer, let me know.

Steve


On 1/18/19 9:03 AM, Peter Seiderer wrote:
> Hello Steve,
>
> On Thu, Jan 17, 2019 at 6:15 PM Steve Longerbeam <slongerbeam@gmail.com> wrote:
>> Disable the CSI immediately after receiving the last EOF before stream
>> off (and thus before disabling the IDMA channel).
>>
>> This fixes a complete system hard lockup on the SabreAuto when streaming
>> from the ADV7180, by repeatedly sending a stream off immediately followed
>> by stream on:
>>
>> while true; do v4l2-ctl  -d4 --stream-mmap --stream-count=3; done
>>
>> Eventually this either causes the system lockup or EOF timeouts at all
>> subsequent stream on, until a system reset.
>>
>> The lockup occurs when disabling the IDMA channel at stream off. Disabling
>> the CSI before disabling the IDMA channel appears to be a reliable fix for
>> the hard lockup.
>>
>> Fixes: 4a34ec8e470cb ("[media] media: imx: Add CSI subdev driver")
> [...]
>
> Similar lockup observed on a custom i.mx6 board, fixed locally by the following
> patch/workaround:
>
> diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
> index 555aa45e02e3..f04d1695f7a4 100644
> --- a/drivers/staging/media/imx/imx-media-csi.c
> +++ b/drivers/staging/media/imx/imx-media-csi.c
> @@ -560,8 +560,8 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
>   static void csi_idmac_unsetup(struct csi_priv *priv,
>                                enum vb2_buffer_state state)
>   {
> -       ipu_idmac_disable_channel(priv->idmac_ch);
>          ipu_smfc_disable(priv->smfc);
> +       ipu_idmac_disable_channel(priv->idmac_ch);
>
>          csi_idmac_unsetup_vb2_buf(priv, state);
>   }
>
> Will test your patch the next days...
>
> Regards,
> Peter
>
> [Sorry for missing some of the CC and Message-Id, not fully subscribed to linux-media]

