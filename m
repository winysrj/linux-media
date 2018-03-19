Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:53311 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932793AbeCSNLu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Mar 2018 09:11:50 -0400
Received: by mail-wm0-f67.google.com with SMTP id e194so15010121wmd.3
        for <linux-media@vger.kernel.org>; Mon, 19 Mar 2018 06:11:49 -0700 (PDT)
Subject: Re: [PATCH 3/3] arm64: dts: meson-gxl-s905x-libretech-cc: add
 cec-disable
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-amlogic@lists.infradead.org,
        devicetree@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <20180319114345.29837-1-hverkuil@xs4all.nl>
 <20180319114345.29837-4-hverkuil@xs4all.nl>
From: Neil Armstrong <narmstrong@baylibre.com>
Message-ID: <e74c5b99-760e-fad5-a1f2-a3a7ccfc1391@baylibre.com>
Date: Mon, 19 Mar 2018 14:11:47 +0100
MIME-Version: 1.0
In-Reply-To: <20180319114345.29837-4-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 19/03/2018 12:43, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This board has two CEC controllers: the DesignWare controller and
> a meson-specific controller. Disable the DW controller since the
> CEC line is hooked up to the meson controller.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  arch/arm64/boot/dts/amlogic/meson-gxl-s905x-libretech-cc.dts | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm64/boot/dts/amlogic/meson-gxl-s905x-libretech-cc.dts b/arch/arm64/boot/dts/amlogic/meson-gxl-s905x-libretech-cc.dts
> index 9671f1e3c74a..271bd486fd65 100644
> --- a/arch/arm64/boot/dts/amlogic/meson-gxl-s905x-libretech-cc.dts
> +++ b/arch/arm64/boot/dts/amlogic/meson-gxl-s905x-libretech-cc.dts
> @@ -155,6 +155,7 @@
>  	status = "okay";
>  	pinctrl-0 = <&hdmi_hpd_pins>, <&hdmi_i2c_pins>;
>  	pinctrl-names = "default";
> +	cec-disable;
>  };
>  
>  &hdmi_tx_tmds_port {
> 

Acked-by: Neil Armstrong <narmstrong@baylibre.com>
