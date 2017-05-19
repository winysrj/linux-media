Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f44.google.com ([74.125.83.44]:35053 "EHLO
        mail-pg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756066AbdESXmH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 May 2017 19:42:07 -0400
Received: by mail-pg0-f44.google.com with SMTP id q125so44356110pgq.2
        for <linux-media@vger.kernel.org>; Fri, 19 May 2017 16:42:07 -0700 (PDT)
From: Kevin Hilman <khilman@baylibre.com>
To: Neil Armstrong <narmstrong@baylibre.com>
Cc: carlo@caione.org, linux-amlogic@lists.infradead.org,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM64: defconfig: enable IR core, decoders and Meson IR device
References: <1493105980-19724-1-git-send-email-narmstrong@baylibre.com>
Date: Fri, 19 May 2017 16:42:03 -0700
In-Reply-To: <1493105980-19724-1-git-send-email-narmstrong@baylibre.com> (Neil
        Armstrong's message of "Tue, 25 Apr 2017 09:39:40 +0200")
Message-ID: <m28tls4do4.fsf@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Neil Armstrong <narmstrong@baylibre.com> writes:

> This patch enables the MEDIA Infrared RC Decoders and Meson Infrared
> decoder for ARM64 defconfig.
> These drivers are selected as modules by default.
>
> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
> ---
>  arch/arm64/configs/defconfig | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
> index c021aefa..59c400f 100644
> --- a/arch/arm64/configs/defconfig
> +++ b/arch/arm64/configs/defconfig
> @@ -321,6 +321,11 @@ CONFIG_MEDIA_CAMERA_SUPPORT=y
>  CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
>  CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
>  CONFIG_MEDIA_CONTROLLER=y
> +CONFIG_MEDIA_RC_SUPPORT=y
> +CONFIG_RC_CORE=y

This one should be a module too.

With that fixed, applied to v4.13/defconfig

Kevin

> +CONFIG_RC_DEVICES=y
> +CONFIG_RC_DECODERS=y
> +CONFIG_IR_MESON=m
>  CONFIG_VIDEO_V4L2_SUBDEV_API=y
>  # CONFIG_DVB_NET is not set
>  CONFIG_V4L_MEM2MEM_DRIVERS=y
