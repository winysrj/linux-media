Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vn0-f47.google.com ([209.85.216.47]:41708 "EHLO
	mail-vn0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbbEED7Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 May 2015 23:59:24 -0400
MIME-Version: 1.0
In-Reply-To: <1430760785-1169-2-git-send-email-k.debski@samsung.com>
References: <1430760785-1169-1-git-send-email-k.debski@samsung.com>
	<1430760785-1169-2-git-send-email-k.debski@samsung.com>
Date: Tue, 5 May 2015 12:59:23 +0900
Message-ID: <CAJKOXPf+5QZXZo7hKKOuKkpZg-9hNT7cMa=4=1Y3ZFBTjBaiNg@mail.gmail.com>
Subject: Re: [PATCH v6 01/11] dts: exynos4*: add HDMI CEC pin definition to pinctrl
From: =?UTF-8?Q?Krzysztof_Koz=C5=82owski?= <k.kozlowski.k@gmail.com>
To: Kamil Debski <k.debski@samsung.com>
Cc: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	mchehab@osg.samsung.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, thomas@tommie-lie.de, sean@mess.org,
	dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, lars@opdenkamp.eu
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2015-05-05 2:32 GMT+09:00 Kamil Debski <k.debski@samsung.com>:
> Add pinctrl nodes for the HDMI CEC device to the Exynos4210 and
> Exynos4x12 SoCs. These are required by the HDMI CEC device.
>
> Signed-off-by: Kamil Debski <k.debski@samsung.com>

Acked-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Are there any objections to picking the DTS changes independently?

Best regards,
Krzysztof
