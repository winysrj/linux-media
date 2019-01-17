Return-Path: <SRS0=I7H+=PZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21C1CC43387
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 20:22:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1C5B20868
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 20:22:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kyqB5I8u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729450AbfAQUWh (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 17 Jan 2019 15:22:37 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51169 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729356AbfAQUWh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Jan 2019 15:22:37 -0500
Received: by mail-wm1-f66.google.com with SMTP id n190so2451297wmd.0;
        Thu, 17 Jan 2019 12:22:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=TvIqlaWvOQqsbMKPshcCR2uTFXyMf2wrdRHxcefFmck=;
        b=kyqB5I8uIVX1SaesrD3AISJ3TSTkP4dpt3omJEoHCa5iVBxgCPKVTBJj63nZ31wAaz
         SkBxit4oK/9NV02wCuDrqLrPZGhtJP87TT2QWwhrbSWn96mJ3ZD+u3Rfsng+DE19vuWl
         O5Dm4oPDV5lh8AmObLdTefDScV10GUMD9+7k6eWWZCIK3LhrWsU5jfCUD0cfR3NYi8MK
         8jmn4m5IRO6yEpFWRR8WmpGteSdDlxe/1pW122+JXvbA3zdI0z6xiY/WtqxVcQ1glrOI
         Rh32mIoLHqgzTxAtOnHweOnbsmqOvNVpqBFjbi7CUZ9W3yPIvZP0A+1AmYQI6R1oQyhP
         hkCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=TvIqlaWvOQqsbMKPshcCR2uTFXyMf2wrdRHxcefFmck=;
        b=N77+uty98ApMXSRcv0Wv7xSpNguIuqBL4oT5IyEcgJ/hZtC1qLi4+5VKFvmUbZisI4
         UkzP2fFDM+vEzVZFMrgXXmPzxy/tOQTvURc0UkfQWEKB5CbHXisu6pkCJYWMHyLKeLOk
         +9DB4LPFUEwWn6y+VpokOhLXQfvSBnoVRFmFlKUvR2m6w09gzdXHPP+Lrl9GBKENqWPY
         jHqef+6t4XL1swaGH/FgmQWvpK2m6aEAzQ71wslyrKUGgetS0l7fowXWzO6gBWzYW7mR
         /rNJeU98YR1TgyAx/DEwLaem2xpvr+Xr5kz8GhPJjH4Qte7sSrzR7lBPWrfISIbZ8Kka
         rTPg==
X-Gm-Message-State: AJcUukd0uPh82M6FoqnDs3+7RNx3g7zKO1aEwfiR+JgcY2ajYfugn8d/
        PolbMhfbtlacwFEAiN/ZlG4=
X-Google-Smtp-Source: ALg8bN5aZD1V2HV12Rvogwklru/npDrHQu9PqYnUoh2VZCoyPksmG6W7mHK8jfvMFQv595DlycYPIw==
X-Received: by 2002:a1c:7a16:: with SMTP id v22mr12148603wmc.131.1547756554167;
        Thu, 17 Jan 2019 12:22:34 -0800 (PST)
Received: from [172.30.90.213] (sjewanfw1-nat.mentorg.com. [139.181.7.34])
        by smtp.gmail.com with ESMTPSA id o4sm76513349wrq.66.2019.01.17.12.22.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Jan 2019 12:22:33 -0800 (PST)
Subject: Re: [PATCH 1/2] media: imx: csi: Disable CSI immediately after last
 EOF
To:     Fabio Estevam <festevam@gmail.com>
Cc:     linux-media <linux-media@vger.kernel.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <20190117201347.27347-1-slongerbeam@gmail.com>
 <20190117201347.27347-2-slongerbeam@gmail.com>
 <CAOMZO5BtS_iLcUH0zO1u_L+jVCena-WzRJgR3NUif7UoxQAYVw@mail.gmail.com>
From:   Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <788352ec-dc51-605f-6ca3-115d1163b0b2@gmail.com>
Date:   Thu, 17 Jan 2019 12:22:30 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <CAOMZO5BtS_iLcUH0zO1u_L+jVCena-WzRJgR3NUif7UoxQAYVw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Fabio, thanks for the review.

On 1/17/19 12:20 PM, Fabio Estevam wrote:
> Hi Steve,
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
>> Reported-by: Gaël PORTAY <gael.portay@collabora.com>
>> Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
> Thanks. Since this fixes a lockup, maybe it is worth adding a Fixes
> tag and Cc stable?

Right, forgot. I will do that and resubmit.


>
>> ---
>>   drivers/staging/media/imx/imx-media-csi.c | 7 ++++---
>>   1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
>> index e18f58f56dfb..9218372cb997 100644
>> --- a/drivers/staging/media/imx/imx-media-csi.c
>> +++ b/drivers/staging/media/imx/imx-media-csi.c
>> @@ -681,6 +681,8 @@ static void csi_idmac_stop(struct csi_priv *priv)
>>          if (ret == 0)
>>                  v4l2_warn(&priv->sd, "wait last EOF timeout\n");
>>
>> +       ipu_csi_disable(priv->csi);
>> +
>>          devm_free_irq(priv->dev, priv->eof_irq, priv);
>>          devm_free_irq(priv->dev, priv->nfb4eof_irq, priv);
>>
>> @@ -793,11 +795,10 @@ static void csi_stop(struct csi_priv *priv)
>>                  /* stop the frame interval monitor */
>>                  if (priv->fim)
>>                          imx_media_fim_set_stream(priv->fim, NULL, false);
>> +       } else {
>> +               ipu_csi_disable(priv->csi);
>>          }
>> -
>> -       ipu_csi_disable(priv->csi);
>>   }
>> -
> Unneeded line removal.

Will fix.

Steve

