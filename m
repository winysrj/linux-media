Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:40250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751449AbdDKIhE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Apr 2017 04:37:04 -0400
MIME-Version: 1.0
In-Reply-To: <E1cxc0o-0003RE-PP@www.linuxtv.org>
References: <E1cxc0o-0003RE-PP@www.linuxtv.org>
From: Krzysztof Kozlowski <krzk@kernel.org>
Date: Tue, 11 Apr 2017 10:36:58 +0200
Message-ID: <CAJKOXPfbJpFu6r9rS8oCqxTH+s7y2wYKx9+TzGrv4Cd8DYaKew@mail.gmail.com>
Subject: Re: [git:media_tree/master] [media] ARM: dts: exynos: add HDMI
 controller phandle to exynos4.dtsi
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linuxtv-commits@linuxtv.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 10, 2017 at 6:12 PM, Mauro Carvalho Chehab
<mchehab@s-opensource.com> wrote:
> This is an automatic generated email to let you know that the following patch were queued:
>
> Subject: [media] ARM: dts: exynos: add HDMI controller phandle to exynos4.dtsi
> Author:  Hans Verkuil <hans.verkuil@cisco.com>
> Date:    Tue Dec 13 12:37:16 2016 -0200
>
> Add the new hdmi phandle to exynos4.dtsi. This phandle is needed by the
> s5p-cec driver to initialize the CEC notifier framework.
>
> Tested with my Odroid U3.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
> CC: linux-samsung-soc@vger.kernel.org
> CC: devicetree@vger.kernel.org
> CC: Krzysztof Kozlowski <krzk@kernel.org>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
>
>  arch/arm/boot/dts/exynos4.dtsi | 1 +
>  1 file changed, 1 insertion(+)
>

Mauro, you should not apply it. It is already going through samsung-soc [1].
if you need this patch for bisectability or any other reasons, I
provided a tag with it here:
https://www.spinics.net/lists/devicetree/msg171182.html

Please drop the patch because now it will get duplicated.

Best regards,
Krzysztof

[1] https://www.spinics.net/lists/arm-kernel/msg575229.html
