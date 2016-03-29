Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f194.google.com ([209.85.214.194]:36605 "EHLO
	mail-ob0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbcC2G0e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Mar 2016 02:26:34 -0400
MIME-Version: 1.0
In-Reply-To: <1458911416-47981-2-git-send-email-hverkuil@xs4all.nl>
References: <1458911416-47981-1-git-send-email-hverkuil@xs4all.nl>
	<1458911416-47981-2-git-send-email-hverkuil@xs4all.nl>
Date: Tue, 29 Mar 2016 15:26:33 +0900
Message-ID: <CAJKOXPd=upXq5m2WitT37_XYi5+rciA9HVYWFoE4u_wPnWaWJQ@mail.gmail.com>
Subject: Re: [PATCHv14 01/18] dts: exynos4*: add HDMI CEC pin definition to pinctrl
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-samsung-soc@vger.kernel.org, linux-input@vger.kernel.org,
	lars@opdenkamp.eu, linux@arm.linux.org.uk,
	Kamil Debski <kamil@wypas.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 25, 2016 at 10:09 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Kamil Debski <kamil@wypas.org>
>
> Add pinctrl nodes for the HDMI CEC device to the Exynos4210 and
> Exynos4x12 SoCs. These are required by the HDMI CEC device.
>
> Signed-off-by: Kamil Debski <kamil@wypas.org>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  arch/arm/boot/dts/exynos4210-pinctrl.dtsi | 7 +++++++
>  arch/arm/boot/dts/exynos4x12-pinctrl.dtsi | 7 +++++++
>  2 files changed, 14 insertions(+)

Applied for v4.7 with a little bit different subject:
https://git.kernel.org/cgit/linux/kernel/git/krzk/linux.git/log/?h=next/dt
(but tell me if you need to base on this so I would prepare a tag)

Best regards,
