Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:43576 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751290AbdFEK0u (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Jun 2017 06:26:50 -0400
Subject: Re: [PATCH 7/9] [media] s5p-jpeg: Change sclk_jpeg to 166MHz for
 Exynos5250
To: Thierry Escande <thierry.escande@collabora.com>
Cc: Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <2b94d31d-7a76-53b7-e8eb-b516cdfea2fc@samsung.com>
Date: Mon, 05 Jun 2017 12:26:43 +0200
MIME-version: 1.0
In-reply-to: <4e77fd32-5805-d1f5-2ddd-3196cc978ef2@gmail.com>
Content-type: text/plain; charset="utf-8"; format="flowed"
Content-language: en-GB
Content-transfer-encoding: 7bit
References: <1496419376-17099-1-git-send-email-thierry.escande@collabora.com>
        <1496419376-17099-8-git-send-email-thierry.escande@collabora.com>
        <CGME20170602215851epcas3p3fa42ac06f8c815020d09a879a6538a68@epcas3p3.samsung.com>
        <4e77fd32-5805-d1f5-2ddd-3196cc978ef2@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/02/2017 11:58 PM, Jacek Anaszewski wrote:
> On 06/02/2017 06:02 PM, Thierry Escande wrote:
>> From: henryhsu<henryhsu@chromium.org>
>>
>> The default clock parent of jpeg on Exynos5250 is fin_pll, which is
>> 24MHz. We have to change the clock parent to CPLL, which is 333MHz,
>> and set sclk_jpeg to 166MHz.

There is no need to patch the driver for these platform specific clock
settings, it can be specified in the device tree with the "assigned-clocks"
properties. There is an example in mainline for exynos3250 SoC already [1].

-- 
Thanks,
Sylwester

[1] 
http://elixir.free-electrons.com/linux/v4.6/source/arch/arm/boot/dts/exynos3250.dtsi#L263
