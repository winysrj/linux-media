Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:51875 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbbAMPGE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jan 2015 10:06:04 -0500
Message-ID: <54B53455.9050407@atmel.com>
Date: Tue, 13 Jan 2015 16:05:57 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
MIME-Version: 1.0
To: Josh Wu <josh.wu@atmel.com>, <devicetree@vger.kernel.org>
CC: <grant.likely@linaro.org>, <galak@codeaurora.org>,
	<rob@landley.net>, <robh+dt@kernel.org>,
	<ijc+devicetree@hellion.org.uk>, <pawel.moll@arm.com>,
	<linux-arm-kernel@lists.infradead.org>, <voice.shen@atmel.com>,
	<laurent.pinchart@ideasonboard.com>,
	<alexandre.belloni@free-electrons.com>, <plagnioj@jcrosoft.com>,
	<boris.brezillon@free-electrons.com>,
	<linux-media@vger.kernel.org>, <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v2 0/8] ARM: at91: dts: sama5d3: add dt support for atmel
 isi and ov2640 sensor
References: <1420362153-500-1-git-send-email-josh.wu@atmel.com>
In-Reply-To: <1420362153-500-1-git-send-email-josh.wu@atmel.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le 04/01/2015 10:02, Josh Wu a écrit :
> This patch series add ISI and ov2640 support on dts files.
> 
> As the ov2640 driver dt is still in review. The patch is in: https://patchwork.linuxtv.org/patch/27554/
> So I want to send this dt patch early for a review.
> 
> v1 -> v2:
>   1. add one more patch to change the pin name of ISI_MCK
>   2. rewrite the commit [4/8] ARM: at91: dts: sama5d3: change name of pinctrl_isi_{power,reset}.
>   3. move the common chip parts of ISI node to sama5d3.dtsi.
> 
> Bo Shen (3):
>   ARM: at91: dts: sama5d3: split isi pinctrl
>   ARM: at91: dts: sama5d3: add missing pins of isi
>   ARM: at91: dts: sama5d3: move the isi mck pin to mb
> 
> Josh Wu (5):
>   ARM: at91: dts: sama5d3: add isi clock
>   ARM: at91: dts: sama5d3: change name of pinctrl_isi_{power,reset}
>   ARM: at91: dts: sama5d3: change name of pinctrl of ISI_MCK
>   ARM: at91: dts: sama5d3: add ov2640 camera sensor support
>   ARM: at91: sama5: enable atmel-isi and ov2640 in defconfig

Josh,

It seems that this patch doesn't show up in the series: I only received
up to 6/8 patches (2 missing?). Can you please send it(them?)?

Bye,

>  arch/arm/boot/dts/sama5d3.dtsi    | 24 ++++++++++++++++++-----
>  arch/arm/boot/dts/sama5d3xmb.dtsi | 40 +++++++++++++++++++++++++++++++++++----
>  arch/arm/configs/sama5_defconfig  |  6 ++++++
>  3 files changed, 61 insertions(+), 9 deletions(-)
> 


-- 
Nicolas Ferre
