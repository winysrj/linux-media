Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:53138 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932989AbeCSNKx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Mar 2018 09:10:53 -0400
Received: by mail-wm0-f68.google.com with SMTP id l9so5928072wmh.2
        for <linux-media@vger.kernel.org>; Mon, 19 Mar 2018 06:10:53 -0700 (PDT)
Subject: Re: [PATCH 0/3] dw-hdmi: add property to disable CEC
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-amlogic@lists.infradead.org,
        devicetree@vger.kernel.org
References: <20180319114345.29837-1-hverkuil@xs4all.nl>
From: Neil Armstrong <narmstrong@baylibre.com>
Message-ID: <0d341d4b-64f4-2d6e-555c-43136e74807e@baylibre.com>
Date: Mon, 19 Mar 2018 14:10:50 +0100
MIME-Version: 1.0
In-Reply-To: <20180319114345.29837-1-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 19/03/2018 12:43, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Some boards (amlogic) have two CEC controllers: the DesignWare controller
> and their own CEC controller (meson ao-cec).
> 
> Since the CEC line is not hooked up to the DW controller we need a way
> to disable that controller. This patch series adds the cec-disable
> property for that purpose.
> 
> Neil, I have added cec-disable to meson-gxl-s905x-libretech-cc.dts
> only, but I suspect it is probably valid for all meson-glx devices?
> Should I move it to meson-gxl.dtsi?

It's valid on all GX devices, so you can add to meson-gx.dtsi

Neil

> 
> Regards,
> 
> 	Hans
> 
> Hans Verkuil (3):
>   dt-bindings: display: dw_hdmi.txt
>   drm: bridge: dw-hdmi: check the cec-disable property
>   arm64: dts: meson-gxl-s905x-libretech-cc: add cec-disable
> 
>  Documentation/devicetree/bindings/display/bridge/dw_hdmi.txt | 3 +++
>  arch/arm64/boot/dts/amlogic/meson-gxl-s905x-libretech-cc.dts | 1 +
>  drivers/gpu/drm/bridge/synopsys/dw-hdmi.c                    | 3 ++-
>  3 files changed, 6 insertions(+), 1 deletion(-)
> 
