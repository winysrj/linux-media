Return-Path: <SRS0=g7QC=O6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FROM,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CA2AC43387
	for <linux-media@archiver.kernel.org>; Fri, 21 Dec 2018 20:06:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56F6D21928
	for <linux-media@archiver.kernel.org>; Fri, 21 Dec 2018 20:06:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VoDu4eqP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391841AbeLUUGM (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 21 Dec 2018 15:06:12 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:44074 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729924AbeLUUGL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Dec 2018 15:06:11 -0500
Received: by mail-io1-f67.google.com with SMTP id r200so4571110iod.11;
        Fri, 21 Dec 2018 12:06:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4l8asYMZk02NpiE8YpmE6pXQlvO2A4l3Ah8g716jLKE=;
        b=VoDu4eqPBM77Jc7vS2MkgZpSnCIJgScOlXvEcBUt2NxLTP39yJbgE+k37gitgA7BnJ
         TSdi24sos3kbsmySfwEyFZ/se0SnEMqR8bpG3BWYkmkuTyQdPAUlv4T91gJ+sU0uc+H6
         agjFgPaNxWZnXWpnE/WRDmRN5gUwR6oGjFezlSQismS/5zEDBnA2KEExNYqCsPAhxl/1
         SMI63ewqG0M1HAjK3S44t5I5FrFmKhBKBvtjl74UJAlnxGZI3bTtj2+Im9eANeuTmzMS
         gWHBiBaKZ0atpDk+t6zxL9steukRgrbhu04+rpEchF21B6YEaiwdUnax90UsKj2/J2TB
         AxOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4l8asYMZk02NpiE8YpmE6pXQlvO2A4l3Ah8g716jLKE=;
        b=CVJclqeiwWiU7s4vj5N6oNQMUJgDJ8gwMRntBSrdSIbbsv+hp3tOstILuaZsWuZdxt
         3m2cA4AlW+dGSLozyz8+kOc099MWxnUhGVWqgZo4QzFpHQYxJSM6fiYiAr4SeaQjwugy
         s8Gujjk9a3KoTJ9fiNb0Dxjn1GY5FkvBCs2FQk32AOechk7UoN2O13JTx7SNeyVmhPP4
         pa/iXDg3JAZvliRgV3obCauaVwcTgl4zUuF67jnZ0PwQAeG+3TnYlcpMekcMpWWSW6Wd
         R1Hs6V0hd830oQyheS/PedguGBq/UNXxCJ9KKCZrqemsD/Gi8NbVx3UNBG2XukG8Sl+Q
         C+tw==
X-Gm-Message-State: AJcUukf3gtVPf2o9qUpgTTf3mlNOS0N2hDhK+O/zsEPlZUQ+TfSNjAt1
        PLnV9gGHFzEtkMxH47B6Ht2+iz9zO23Lxz1y9tg=
X-Google-Smtp-Source: ALg8bN6KbqJdxzTw+SCHsfE0A5+t6J/c0mHV+GUvDA75ldxsor8BiG4/RfDnjUCekI3qlXY2cMT2/DTOKSl9NXs+O0M=
X-Received: by 2002:a5e:a708:: with SMTP id b8mr2582606iod.126.1545422769450;
 Fri, 21 Dec 2018 12:06:09 -0800 (PST)
MIME-Version: 1.0
References: <20181221011752.25627-1-sre@kernel.org> <20181221011752.25627-2-sre@kernel.org>
In-Reply-To: <20181221011752.25627-2-sre@kernel.org>
From:   Adam Ford <aford173@gmail.com>
Date:   Fri, 21 Dec 2018 14:05:57 -0600
Message-ID: <CAHCN7x+5hq65LpF+G7rsiK89E7F+9fFiukgBA-u3RZZ6ov3xHg@mail.gmail.com>
Subject: Re: [PATCH 01/14] ARM: dts: LogicPD Torpedo: Add WiLink UART node
To:     Sebastian Reichel <sre@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Tony Lindgren <tony@atomide.com>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Machek <pavel@ucw.cz>,
        "open list:BLUETOOTH DRIVERS" <linux-bluetooth@vger.kernel.org>,
        linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sebastian Reichel <sebastian.reichel@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Dec 20, 2018 at 7:18 PM Sebastian Reichel <sre@kernel.org> wrote:
>
> From: Sebastian Reichel <sebastian.reichel@collabora.com>
>
> Add a node for the UART part of WiLink chip.
>
> Cc: Adam Ford <aford173@gmail.com>
> Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
> ---
> This is compile tested only!


I have tried this a few times, unfortunately, I cannot get the wl1283
to load the BT Firmware without timing out.  The btwilink driver is
the only option that works for me.

[   22.809600] Bluetooth: hci0: command 0xfd1c tx timeout
[   31.206390] Bluetooth: hci0: send command failed
[   31.211334] Bluetooth: hci0: download firmware failed, retrying...
[   31.367767] Bluetooth: hci0: change remote baud rate command in firmware
[   38.166351] Bluetooth: hci0: command 0xfd1c tx timeout
[   46.566375] Bluetooth: hci0: send command failed
[   46.571289] Bluetooth: hci0: download firmware failed, retrying...
[   46.738250] Bluetooth: hci0: change remote baud rate command in firmware
[   53.526336] Bluetooth: hci0: command 0xfd1c tx timeout

It times out, and tries again....and again....

Unless there is a driver fix to the BT UART, I don't think this should
be applied since I don't know what will happen if/when I try to use
the btwilink driver.

Having said that, I have no issues with the wl18xx and a wl127x on
other boards who don't need the btwilink driver.  I think it's somehow
related to the wl1283

adam

> ---
>  arch/arm/boot/dts/logicpd-torpedo-37xx-devkit.dts | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/arch/arm/boot/dts/logicpd-torpedo-37xx-devkit.dts b/arch/arm/boot/dts/logicpd-torpedo-37xx-devkit.dts
> index 9d5d53fbe9c0..2699da12dc2d 100644
> --- a/arch/arm/boot/dts/logicpd-torpedo-37xx-devkit.dts
> +++ b/arch/arm/boot/dts/logicpd-torpedo-37xx-devkit.dts
> @@ -54,6 +54,14 @@
>         };
>  };
>
> +&uart2 {
> +       bluetooth {
> +               compatible = "ti,wl1283-st";
> +               enable-gpios = <&gpio6 2 GPIO_ACTIVE_HIGH>; /* gpio 162 */
> +               max-speed = <3000000>;
> +       };
> +};
> +
>  &omap3_pmx_core {
>         mmc3_pins: pinmux_mm3_pins {
>                 pinctrl-single,pins = <
> --
> 2.19.2
>
