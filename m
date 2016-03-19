Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:33808 "EHLO
	mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565AbcCSCuq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Mar 2016 22:50:46 -0400
Date: Sat, 19 Mar 2016 11:50:40 +0900
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-samsung-soc@vger.kernel.org, linux-input@vger.kernel.org,
	lars@opdenkamp.eu, linux@arm.linux.org.uk,
	Kamil Debski <kamil@wypas.org>, krzk@kernel.org
Subject: Re: [PATCHv13 01/17] dts: exynos4*: add HDMI CEC pin definition to
 pinctrl
Message-ID: <20160319025040.GA7289@kozik-lap>
References: <1458310036-19252-1-git-send-email-hans.verkuil@cisco.com>
 <1458310036-19252-2-git-send-email-hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1458310036-19252-2-git-send-email-hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 18, 2016 at 03:07:00PM +0100, Hans Verkuil wrote:
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

Hi Hans,

I see you have been carrying these three patches for a long time.
Initially I thought that there are some dependencies... but maybe there
are not?

Can I take these Exynos DTS patches to samsung-soc?

Best regards,
Krzysztof
