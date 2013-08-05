Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:54782 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754782Ab3HEHOb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Aug 2013 03:14:31 -0400
Received: by mail-la0-f50.google.com with SMTP id fn20so1754323lab.23
        for <linux-media@vger.kernel.org>; Mon, 05 Aug 2013 00:14:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51FB90C5.9060101@samsung.com>
References: <1375355972-25276-1-git-send-email-vikas.sajjan@linaro.org>
 <5151790.EBRlE0cTxf@flatron> <CAF6AEGvmd20MJ_=69kYahkeTySVbhc2GgiUNwCDFXuDWgeGAfQ@mail.gmail.com>
 <CAD025yRZBDh6ssSUbY-mo2mo-WqrUS3R56bD-QrBvaBbWX_HMQ@mail.gmail.com>
 <CAAQKjZNBPxBxR-4PXbhOdX0V1inMkauE-xZ+0kwnfVTgqpCEVg@mail.gmail.com>
 <CAD025yR9Xd0G81WdLDxKyu-RVZPPJAUOKZ+0b5oKUxYOe7q_pQ@mail.gmail.com> <51FB90C5.9060101@samsung.com>
From: Vikas Sajjan <vikas.sajjan@linaro.org>
Date: Mon, 5 Aug 2013 12:44:10 +0530
Message-ID: <CAD025yS1Y0pqDnGJamm4y5SpL2d8LT58Kx2uh9U=NeqKDELa5w@mail.gmail.com>
Subject: Re: [PATCH] drm/exynos: Add check for IOMMU while passing physically
 continous memory flag
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Inki Dae <inki.dae@samsung.com>, Rob Clark <robdclark@gmail.com>,
	Tomasz Figa <tomasz.figa@gmail.com>,
	"linux-samsung-soc@vger.kernel.org"
	<linux-samsung-soc@vger.kernel.org>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	linux-media@vger.kernel.org, "kgene.kim" <kgene.kim@samsung.com>,
	"arun.kk" <arun.kk@samsung.com>,
	Patch Tracking <patches@linaro.org>,
	linaro-kernel@lists.linaro.org, sunil joshi <joshi@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	"m.szyprowski" <m.szyprowski@samsung.com>,
	devicetree <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On 2 August 2013 16:28, Sylwester Nawrocki <s.nawrocki@samsung.com> wrote:
> Hi Vikas,
>
> On 08/02/2013 12:10 PM, Vikas Sajjan wrote:
>> yeah, we could not allocate CMA region for FIMD, because the function
>> dma_declare_contiguous() needs "dev" as the first argument and we have
>> access to "dev" node only if it is NON-DT way of probing like the way
>> it is done in arch/arm/mach-davinci/devices-da8xx.c
>> But now, since the probing is through DT way, there is NO way ( Let me
>> know if something is newly added ) to call dma_declare_contiguous()
>> and reserve CMA region .
>
> See this patch series [1]. We have have been using this kind of bindings
> for assigning physically contiguous memory regions to the Exynos
> multimedia devices, instead of what's currently in mainline where same
> physical addresses are repeated in dts for various boards without much
> thought. And where custom device specific parsing code is required at
> arch side.
>
> $ git grep mfc\-[lr] arch/arm/boot/dts
>
> arch/arm/boot/dts/exynos4210-origen.dts:     samsung,mfc-r = <0x43000000 0x800000>;
> arch/arm/boot/dts/exynos4210-origen.dts:     samsung,mfc-l = <0x51000000 0x800000>;
> arch/arm/boot/dts/exynos4210-smdkv310.dts:   samsung,mfc-r = <0x43000000 0x800000>;
> arch/arm/boot/dts/exynos4210-smdkv310.dts:   samsung,mfc-l = <0x51000000 0x800000>;
> arch/arm/boot/dts/exynos4412-origen.dts:     samsung,mfc-r = <0x43000000 0x800000>;
> arch/arm/boot/dts/exynos4412-origen.dts:     samsung,mfc-l = <0x51000000 0x800000>;
> arch/arm/boot/dts/exynos4412-smdk4412.dts:   samsung,mfc-r = <0x43000000 0x800000>;
> arch/arm/boot/dts/exynos4412-smdk4412.dts:   samsung,mfc-l = <0x51000000 0x800000>;
> arch/arm/boot/dts/exynos5250-arndale.dts:    samsung,mfc-r = <0x43000000 0x800000>;
> arch/arm/boot/dts/exynos5250-arndale.dts:    samsung,mfc-l = <0x51000000 0x800000>;
> arch/arm/boot/dts/exynos5250-smdk5250.dts:   samsung,mfc-r = <0x43000000 0x800000>;
> arch/arm/boot/dts/exynos5250-smdk5250.dts:   samsung,mfc-l = <0x51000000 0x800000>;
>
>
> [1] http://www.spinics.net/lists/arm-kernel/msg263130.html
>


Thanks, its good that now we have a new way to reserve CMA region.


> Regards,
> Sylwester



-- 
Thanks and Regards
 Vikas Sajjan
