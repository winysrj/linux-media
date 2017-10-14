Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:55147 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751002AbdJNIXR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 14 Oct 2017 04:23:17 -0400
Subject: Re: [PATCH 0/3] Enable CEC on rk3399
To: Pierre-Hugues Husson <phh@phh.me>,
        linux-rockchip@lists.infradead.org
Cc: heiko@sntech.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
References: <20171013225337.5196-1-phh@phh.me>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <9833f103-769f-b9b9-05c7-4d75bd7e487c@xs4all.nl>
Date: Sat, 14 Oct 2017 10:23:12 +0200
MIME-Version: 1.0
In-Reply-To: <20171013225337.5196-1-phh@phh.me>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/14/2017 12:53 AM, Pierre-Hugues Husson wrote:
> Enable CEC on firefly-rk3399.
> Tested on a TV with cec-ctl --playback; cec-ctl -S
> 
> Pierre-Hugues Husson (3):
>   drm: bridge: synopsys/dw-hdmi: Enable cec clock
>   arm64: dts: rockchip: add the cec clk for dw-mipi-hdmi on rk3399
>   arm64: dts: rockchip: enable cec pin for rk3399 firefly
> 
>  arch/arm64/boot/dts/rockchip/rk3399-firefly.dts |  2 ++
>  arch/arm64/boot/dts/rockchip/rk3399.dtsi        |  8 ++++++--
>  drivers/gpu/drm/bridge/synopsys/dw-hdmi.c       | 16 ++++++++++++++++
>  3 files changed, 24 insertions(+), 2 deletions(-)
> 

Nice! I had a similar dw-hdmi.c patch pending but got around to posting it.

I'll brush off my old rk3288 patches and see if I can get CEC enabled
for my firefly-reload. I was close to getting it work, but I guess
missed the "enable cec pin" change.

Regards,

	Hans
