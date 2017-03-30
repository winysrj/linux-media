Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:33508 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933392AbdC3Ve3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 17:34:29 -0400
Date: Fri, 31 Mar 2017 00:34:23 +0300
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Daniel Vetter <daniel.vetter@intel.com>,
        Russell King <linux@armlinux.org.uk>,
        dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
        Inki Dae <inki.dae@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        devicetree@vger.kernel.org
Subject: Re: [PATCHv5 05/11] ARM: dts: exynos: add HDMI controller phandle to
 exynos4.dtsi
Message-ID: <20170330213423.eklb2zgmud6sigig@kozik-lap>
References: <20170329141543.32935-1-hverkuil@xs4all.nl>
 <20170329141543.32935-6-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20170329141543.32935-6-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 29, 2017 at 04:15:37PM +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
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
> ---
>  arch/arm/boot/dts/exynos4.dtsi | 1 +
>  1 file changed, 1 insertion(+)
>

Thanks, applied. Now I noticed that you need it for maintaining the
bisectability for this driver (although it is a staging driver). In that
case, if anyone needs this as well then:


The following changes since commit c1ae3cfa0e89fa1a7ecc4c99031f5e9ae99d9201:

  Linux 4.11-rc1 (2017-03-05 12:59:56 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/krzk/linux.git tags/samsung-dt-hdmi-cec-4.12

for you to fetch changes up to 192c1df4a75499a6ab70aca38c6a7e5e40013d77:

  ARM: dts: exynos: add HDMI controller phandle to exynos4.dtsi (2017-03-31 00:21:18 +0300)

----------------------------------------------------------------
Add to hdmi-cec node a phandle to hdmi node for new hdmi-cec notifier.

----------------------------------------------------------------
Hans Verkuil (1):
      ARM: dts: exynos: add HDMI controller phandle to exynos4.dtsi

 arch/arm/boot/dts/exynos4.dtsi | 1 +
 1 file changed, 1 insertion(+)


Best regards,
Krzysztof
