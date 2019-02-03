Return-Path: <SRS0=0n2Q=QK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E09FC169C4
	for <linux-media@archiver.kernel.org>; Sun,  3 Feb 2019 19:37:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A832217D9
	for <linux-media@archiver.kernel.org>; Sun,  3 Feb 2019 19:37:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H8LZ7Z3a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbfBCThU (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 3 Feb 2019 14:37:20 -0500
Received: from mail-wr1-f54.google.com ([209.85.221.54]:40603 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726637AbfBCThU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 3 Feb 2019 14:37:20 -0500
Received: by mail-wr1-f54.google.com with SMTP id p4so12276730wrt.7
        for <linux-media@vger.kernel.org>; Sun, 03 Feb 2019 11:37:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=WxxMl4VrTz/RHZfgZWSRRX0gBZnQZAgGxSJAYqJwoaI=;
        b=H8LZ7Z3aGEJwLWHaPfCoEFTpFkTiEXW6NPvVhvkqx1GfJx3TjMdGcKCuN7AMYfETEJ
         M9aGts/ZOGlu+FQBeRf2Lyzl/0Oa6AGDuTY+LdUy/t4gohgaXTJzohUcKgue/jkGn4v2
         DiiFWIckXV52naN/tbyht0HwXFmFMBsZ+aCnUYhGvPtexjeTKRqcihmN3WvqKyhocsZ/
         nrID4yBy6YQT6cjLGw/OBi/LhUMB9e79Upq3aRIiHg0p7JeDasYXHO37aUW62gnYBcuX
         cKqsiBYJig2xsECeBLJfL7NJfNqdfsgUAsOSrFGQQ7Jli+2+g4dZ69Fwc1QrrTy7IXDA
         0qqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=WxxMl4VrTz/RHZfgZWSRRX0gBZnQZAgGxSJAYqJwoaI=;
        b=bpzdg+suuIfZ66dza1jNYmjKbysz49Ny4a9S5nLk6OgcW5aZwklnjoTlTkxufwi7vY
         zCs/zY0ji75W9bHIAEE4BJDoOmUjtJCbReP7bB7x1qmiEl1DlwtEgphIz8E+ItMI4WN4
         /YFcxH+P+77ldgNUczxCaWhMrpjgkYaEQ4S3WFRCPrJXGsKj/pXqJlhpyyR/iFY6R3iI
         unuW9cNN1WU1Zj1iBepV1mE5udJ87kWXkitKpsVlYo5Rpq/es47wrN9qTcn14HzwuPeb
         uy52glOKL/V1aVecY62qcN1txKA0J9Xh36aHWrF4H4vQauAxyptHn4GnjQ0TVfGhFgk5
         3b1g==
X-Gm-Message-State: AJcUukeEJUXQBvRA4I5+r8FMu6lopNONveexmeO8rU8nVGJI/Ra+7CfD
        eLvw4GJtWxMzIGPTboFK33lVLZjR
X-Google-Smtp-Source: ALg8bN40jgeUlNHI64033LpWXO1r2VhW0rcO+27XkCUQQeZ2UqScslvOTG1DMzbl2moaYEfBpIq8Ug==
X-Received: by 2002:adf:f903:: with SMTP id b3mr48390161wrr.82.1549222638112;
        Sun, 03 Feb 2019 11:37:18 -0800 (PST)
Received: from [172.30.88.64] (sjewanfw1-nat.mentorg.com. [139.181.7.34])
        by smtp.gmail.com with ESMTPSA id j17sm8825017wrw.0.2019.02.03.11.37.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 03 Feb 2019 11:37:17 -0800 (PST)
Subject: Re: IMX CSI capture issues with tda1997x HDMI receiver
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     Tim Harvey <tharvey@gateworks.com>
Cc:     Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media <linux-media@vger.kernel.org>
References: <CAJ+vNU0ic=wzSC9V4hbmarN0JeQMs121MzD6tH5KQ+ezENUNfA@mail.gmail.com>
 <02e8680c-9fd5-ff54-f292-f6936c76583e@gmail.com>
 <CAJ+vNU0YQeiPaE8tapJnihoj3DtewCPTj05BZv5cJ65YkE9MeQ@mail.gmail.com>
 <db70e0f7-0ad4-62f5-e64c-49c04c089dd6@gmail.com>
 <CAJ+vNU3X6ywgobcV+wQxEupkNeNmiWaT85xUOtKF_U44OAfskg@mail.gmail.com>
 <7cfe3570-64e5-d5e3-aeaf-35253c0fa918@gmail.com>
Message-ID: <11700f2a-cc27-782a-2524-ecd8249fd65d@gmail.com>
Date:   Sun, 3 Feb 2019 11:37:11 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <7cfe3570-64e5-d5e3-aeaf-35253c0fa918@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Tim, cc: Philipp,

On 2/2/19 11:10 AM, Steve Longerbeam wrote:
>
> <snip>
> On 1/30/19 5:18 PM, Tim Harvey wrote:
>
>> # stream upscale via mem2mem then JPEG/RTP/UDP
>> gst-launch-1.0 v4l2src device=/dev/video4 ! \
>>    v4l2video8convert ! video/x-raw,width=1280,height=720 ! \
>>    jpegenc ! rtpjpegpay ! udpsink host=172.24.20.19 port=5000
>> ERROR: from element
>> /GstPipeline:pipeline0/v4l2video8convert:v4l2video8convert0: Device
>> '/dev/video8' does not support 2:4:7:1 colorimetry
>> # ^^^ fails because mem2mem doesn't support itu601
>> # stream H264/RTP/UDP
>> gst-launch-1.0 v4l2src device=/dev/video4 ! \
>>    v4l2h264enc output-io-mode=dmabuf-import ! \
>>    rtph264pay ! udpsink host=172.24.20.19 port=5001
>> ERROR: from element /GstPipeline:pipeline0/v4l2h264enc:v4l2h264enc0:
>> Device '/dev/video9' does not support 2:4:7:1 colorimetry
>> # ^^^ coda has same issue... can't del with itu601
>
> Well, just to see things working, try hacking 
> imx_media_fill_default_mbus_fields() to set Rec. 709 encoding:
>
> --- a/drivers/staging/media/imx/imx-media-utils.c
> +++ b/drivers/staging/media/imx/imx-media-utils.c
> @@ -571,7 +571,7 @@ void imx_media_fill_default_mbus_fields(struct 
> v4l2_mbus_framefmt *tryfmt,
>                 tryfmt->quantization = is_rgb ?
>                         V4L2_QUANTIZATION_FULL_RANGE :
>                         V4L2_QUANTIZATION_LIM_RANGE;
> -               tryfmt->ycbcr_enc = V4L2_YCBCR_ENC_601;
> +               tryfmt->ycbcr_enc = V4L2_YCBCR_ENC_709;
>         }
>  }
>  EXPORT_SYMBOL_GPL(imx_media_fill_default_mbus_fields);
>
>
> But of course that's not technically correct because the encoding in 
> ipu-ic.c is BT.601.
>
> The *real* way to fix this would be to allow programmable encodings in 
> ipu-ic.c. But unfortunately the encodings are hardcoded (grep for 
> ic_csc_rgb2ycbcr in ipu-ic.c).

I went ahead and implemented this!

The IC will now support both BT.601 and BT.709 encoding. I will post a 
patchset, please test!


>>
>> Am I perhaps missing a capsfilter to get the mem2mem driver to convert
>> the colorspace properly? If so, they the mem2mem driver could be used
>> to correct the colorspace to get IC output to coda working.
>
> Well, first I don't think the mem2mem driver is using the correct 
> encoding. The mem2mem driver is making use of the IC encoding so it 
> should be reporting and accepting only BT.601.

The mem2mem driver can now require BT.709 and/or BT.601 encoding with 
the above patchset.

Steve

