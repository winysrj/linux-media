Return-Path: <SRS0=D6oO=QU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF8D4C282C2
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 08:52:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A34D2222B6
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 08:52:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RF0Ku8Jc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390847AbfBMIwh (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Feb 2019 03:52:37 -0500
Received: from mail-ed1-f42.google.com ([209.85.208.42]:36798 "EHLO
        mail-ed1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389921AbfBMIwg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Feb 2019 03:52:36 -0500
Received: by mail-ed1-f42.google.com with SMTP id o59so1236830edb.3
        for <linux-media@vger.kernel.org>; Wed, 13 Feb 2019 00:52:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TXiwjLIxHVTinCGW7tH91RfjEI+POgfO1dxxznaXzdU=;
        b=RF0Ku8JckD6llfVglFCWjI0f6xthIVd+DiUyhVfXG3fpo/lamOx/i2L6pgkEDJPybF
         GV7Pgq8hoIbn7UZb8evzhYI/4X/Nu5xG8ZJmqskuylUvifLS6Bwi0w5GjoJiAhWZdpkC
         L87/lPV1c5oUqA1TRcUPQ63OajqqY44MXD7DRpjVCzgE6V7Gwo4DCe8mKhWF9WpaiRcM
         YSt1CxFt9qTq4mFHkot4DqD5ZfcHZWybG2gwzIlzy6PVLu9rzQQqOpSYqJlNMekadCkE
         C4XnZ5grne4IW5s7/9DHWmC+0ZxlaKJ0waVaYhuo6wQWuyye5lpdSZccAOajFzkt6Xlc
         dZcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TXiwjLIxHVTinCGW7tH91RfjEI+POgfO1dxxznaXzdU=;
        b=IhsLIrMn2sjhPkPQogY3/RfbeTyPaIIlQGY649pIvPs8qMzXlaOGvqSnJOI97lXz/o
         It0/46a0cE8dMDIV7sdRNF9kpYh9NrtQrl1lw7NRye+fELNVNNaisdgh/r37srT+u/zL
         3JLv1+P+AFzdoj7bmFfYD7ZwBHtmktTqaMA6RBQk3Ub/2RerOjJ4yg/u0QVfYyPOCiZS
         gB94uKv91aB+6uNHGAitjPSYF8wZRz8/SHLPqLEeNT4vTWBLKEx47txCvm/+qYdCe11H
         SegLBOSwBYmVKtk32DNhMBrurw3fedVLQRlW0oykR4YxZp0F2BZ2PGkzlwlkkFblgmTP
         NWlg==
X-Gm-Message-State: AHQUAuaT3/2rSY0wZqSY19HRTUln+SU4eKjrBlf4/CM0OSRuwrxbyXm6
        gOo4WGWIaFzuD9O/qRSZBWr6nvnawgQCKsZpbYlW2P2AxEE=
X-Google-Smtp-Source: AHgI3IZl9W3vlh9N7wXUVPJZD4dacIUuanTGD2Qx7YWF7QntcTwdM8OO+ycrPYXx7RCK+qYiyncjD3N/rosD5AYjRqc=
X-Received: by 2002:a50:aed5:: with SMTP id f21mr6720277edd.120.1550047954982;
 Wed, 13 Feb 2019 00:52:34 -0800 (PST)
MIME-Version: 1.0
References: <633027a3-b6a9-4cf0-b1a8-9e4dbe3c824e@microchip.com>
In-Reply-To: <633027a3-b6a9-4cf0-b1a8-9e4dbe3c824e@microchip.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Wed, 13 Feb 2019 09:51:58 +0100
Message-ID: <CAMZdPi9OC7Exp=0mBJT-BusYm=fMj8=hVo80sJeSvpWdqRmwqg@mail.gmail.com>
Subject: Re: Issues with ov5640 sensor
To:     Eugen.Hristev@microchip.com
Cc:     linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Eugen,

On Wed, 13 Feb 2019 at 09:02, <Eugen.Hristev@microchip.com> wrote:
>
> Hello Loic,
>
> I am trying to make sensor Omnivision ov5640 work with our Atmel-isc
> controller, I saw you implemented RAW mode for this sensor in the
> driver, so I was hoping I can ask you some things:
>
> I cannot make the RAW bayer format work, BA81 / mbus
> MEDIA_BUS_FMT_SBGGR8_1X8 makes the photo look like a maze of colors...
>
> The sensor works for me in YUYV and RGB565 mode, so I assume the wiring
> is done correctly for my setup
>
> Anything special I need to do for this format to work ?

I definitely need to check with the latest driver version, many
changes have been integrated recently, including clock
autoconfiguration.
Moreover, AFAIU, you are connected via the parallel interface, I only
tested with MIPI/CSI.
I would suggest you adding debug in the ov5640 driver to retrieve
calculated pclk, sysclk, etc...
Also the following lines does'nt look correct anymore:

    /*
     * All the formats we support have 16 bits per pixel, seems to require
     * the same rate than YUV, so we can just use 16 bpp all the time.
     */
    rate = mode->vtot * mode->htot * 16;
    rate *= ov5640_framerates[sensor->current_fr];

With RAW8, we have 8 bits per pixel, maybe it would worth for testing
purpose to change 16 to 8 and see what happens.

>
> The same RAW BAYER configuration works for me on ov7670 for example...
>
> Unrelated: are you familiar with ov7740 ? This sensor looks to have
> stopped working in latest mediatree : failed to enable streaming.
> (worked perfectly in last stable for me - 4.14...)

No sorry.


Regards,
Loic
