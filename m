Return-Path: <SRS0=mDsK=O7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A1EFC43387
	for <linux-media@archiver.kernel.org>; Sat, 22 Dec 2018 20:36:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54FAE21934
	for <linux-media@archiver.kernel.org>; Sat, 22 Dec 2018 20:36:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gk6zb+cg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731920AbeLVUgr (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 22 Dec 2018 15:36:47 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:37268 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725440AbeLVUgr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 22 Dec 2018 15:36:47 -0500
Received: by mail-io1-f68.google.com with SMTP id r7so1176405iog.4;
        Sat, 22 Dec 2018 12:36:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7Xa8t8ZE6d1wfwc95ofwTBS+BfsLbq4eXBVPERHKUjc=;
        b=gk6zb+cgJ3EEJ6wg8PFtpL1/z8rUpznrY3d8Ynqq1FENCm4K/Fm8tHLAqR5YIGfChx
         K2tZSJcUFdMSgdoy32+3cw4EnXYcOQdhPpgyumA6vH1o6Nk7Ju9qkDmXFUd1aDUjHZD5
         wl0/rgyDdMCfguakTTktKxEphLa65+KhGC5iaCzeU3o80YATvjerX/gxysbHEH0Pjdci
         agxsnOMHY+QHSdxNDPByc9+pHCzZngiBKvBSXamwir7piCqugHEQdk3XnRiml+eo4ZIF
         Ckh0uwTeaQNDFltKClZVHtFwNs8AkbHSBOG3GCk9/5fyljvbWdUP3fMjuBv/YY2vuxOQ
         sh9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7Xa8t8ZE6d1wfwc95ofwTBS+BfsLbq4eXBVPERHKUjc=;
        b=Y7juHwB29noSdnxOVWl1W/DoqGfMQ2CDN3DDxZFVBwCpgUkLdi0Bum12uhT8PiEsbh
         193rIkSkl91+u54eikMBd70t7tS9a6rz0m+0+IEp7HQ2snqwI/G1ZVa3+RJZAROduRO9
         RkSgqP7kq4jPS0duWA0Inyy8U7/KphFe9/k/bj2tIVwgSV5HRsiRgYw6zU8s5A9BpVgr
         d/ORcp4gpz2whLUSuZ8iAEBMR2naKDvFCoUTLUrf1Kg24kYzCYvgWv5+Bd60W2dhCgz5
         5w2SEll9ZfsTyG6nAjYhp6VH3wmKoEj9Jyuv+5+b//WTpb3b2jFx4B6f/m5LIf6bswWM
         aXqQ==
X-Gm-Message-State: AJcUukfUEKrbiXiDRGcGeYw0nSPDbdpX9gLzMrrzprGJu3nJqQHGxQjK
        +XTvH6Hx/lLustQjak5P+ow1xzsim5l8S38goyA=
X-Google-Smtp-Source: ALg8bN7naKJl/KgXDs9c+1IcHtrcta1/IaSCwbB5tFmKwEI5gehgCZ6fSw0wq+D/ws+kr7SN8pWgTfwfjsKtsF2sKzs=
X-Received: by 2002:a5e:a708:: with SMTP id b8mr5137270iod.126.1545511005513;
 Sat, 22 Dec 2018 12:36:45 -0800 (PST)
MIME-Version: 1.0
References: <20181221011752.25627-1-sre@kernel.org> <20181221180205.GH6707@atomide.com>
In-Reply-To: <20181221180205.GH6707@atomide.com>
From:   Adam Ford <aford173@gmail.com>
Date:   Sat, 22 Dec 2018 14:36:34 -0600
Message-ID: <CAHCN7xK-qnRp_s9MQ2-doGqPrfC_OOgciOKHYTC9L5eiTwzT9A@mail.gmail.com>
Subject: Re: [PATCH 00/14] Add support for FM radio in hcill and kill TI_ST
To:     Tony Lindgren <tony@atomide.com>
Cc:     Sebastian Reichel <sre@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Machek <pavel@ucw.cz>,
        "open list:BLUETOOTH DRIVERS" <linux-bluetooth@vger.kernel.org>,
        linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Sat, Dec 22, 2018 at 11:09 AM Tony Lindgren <tony@atomide.com> wrote:
>
> * Sebastian Reichel <sre@kernel.org> [181221 01:18]:
> > The new code has been tested on the Motorola Droid 4. For testing the audio
> > should be configured to route Ext to Speaker or Headphone. Then you need to
> > plug headphone, since its cable is used as antenna. For testing there is a
> > 'radio' utility packages in Debian. When you start the utility you need to
> > specify a frequency, since initial get_frequency returns an error:
>
> Nice, good to see that ti-st kim stuff gone :) I gave this a quick

Tony,

As much as I'd like to see the ti-st kim stuff go, I am not able to
load the Bluetooth on the Torpedo board (wl1283).  The hooks on a
different, wl18xx and 127x board work fine.  I am not sure if there is
anything different about the wl1283, but I don't have any other boards
other than the Logic PD Torpedo kit.  Do you have any wl1283 boards to
test?  I'd like to see this BT timeout stuff resolved before we dump
the ti-st kim stuff, otherwise, I'll forever be porting drivers.  :-(

adam

> try using fmtools.git and fmscan works just fine. No luck yet with
> fm though, it gives VIDIOC_G_CTRL: Not a tty error somehow so
> maybe I'm missing some options, patch below for omap2plus_defconfig.
>
> Hmm so looks like nothing to configure for the clocks or
> CPCAP_BIT_ST_L_TIMESLOT bits for cap for the EXT? So the
> wl12xx audio is wired directly to cpcap EXT then and not a
> TDM slot on the mcbsp huh?
>
> > Merry Christmas!
>
> Same to you!
>
> Tony
>
> 8< --------------------------------
> From tony Mon Sep 17 00:00:00 2001
> From: Tony Lindgren <tony@atomide.com>
> Date: Fri, 21 Dec 2018 07:57:09 -0800
> Subject: [PATCH] ARM: omap2plus_defconfig: Add RADIO_WL128X as a loadable
>  module
>
> This allows using the FM radio in the wl12xx chips after modprobe
> fm_drv using radio from xawt, or fmtools.
>
> Note that the firmware placed into /lib/firmware/ti-connectivity
> directory:
>
> fm_rx_ch8_1283.2.bts
> fmc_ch8_1283.2.bts
>
> Signed-off-by: Tony Lindgren <tony@atomide.com>
> ---
>  arch/arm/configs/omap2plus_defconfig | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/arch/arm/configs/omap2plus_defconfig b/arch/arm/configs/omap2plus_defconfig
> --- a/arch/arm/configs/omap2plus_defconfig
> +++ b/arch/arm/configs/omap2plus_defconfig
> @@ -126,6 +126,7 @@ CONFIG_AF_RXRPC=m
>  CONFIG_RXKAD=y
>  CONFIG_CFG80211=m
>  CONFIG_MAC80211=m
> +CONFIG_RFKILL=m
>  CONFIG_DEVTMPFS=y
>  CONFIG_DEVTMPFS_MOUNT=y
>  CONFIG_DMA_CMA=y
> @@ -343,12 +344,14 @@ CONFIG_IR_GPIO_TX=m
>  CONFIG_IR_PWM_TX=m
>  CONFIG_MEDIA_SUPPORT=m
>  CONFIG_MEDIA_CAMERA_SUPPORT=y
> +CONFIG_MEDIA_RADIO_SUPPORT=y
>  CONFIG_MEDIA_CEC_SUPPORT=y
>  CONFIG_MEDIA_CONTROLLER=y
>  CONFIG_VIDEO_V4L2_SUBDEV_API=y
>  CONFIG_V4L_PLATFORM_DRIVERS=y
>  CONFIG_VIDEO_OMAP3=m
>  CONFIG_CEC_PLATFORM_DRIVERS=y
> +CONFIG_RADIO_WL128X=m
>  # CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set
>  CONFIG_VIDEO_TVP5150=m
>  CONFIG_DRM=m
> --
> 2.19.2
