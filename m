Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:54195 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726023AbeICQiO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Sep 2018 12:38:14 -0400
Subject: Re: [PATCH 00/14] staging: media: tegra-vdea: Add Tegra124 support
To: Thierry Reding <thierry.reding@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Osipenko <digetx@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-media@vger.kernel.org, linux-tegra@vger.kernel.org,
        devel@driverdev.osuosl.org
References: <20180813145027.16346-1-thierry.reding@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <ddf04f92-f82f-75bf-90a0-102437e3787f@xs4all.nl>
Date: Mon, 3 Sep 2018 14:18:15 +0200
MIME-Version: 1.0
In-Reply-To: <20180813145027.16346-1-thierry.reding@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Thierry, Dmitry,

Dmitry found some issues, so I'll wait for a v2.

Anyway, this driver is in staging with this TODO:

- Implement V4L2 API once it gains support for stateless decoders.

I just wanted to mention that the Request API is expected to be merged
for 4.20. A topic branch is here:

https://git.linuxtv.org/media_tree.git/log/?h=request_api

This patch series is expected to be added to the topic branch once
everyone agrees:

https://www.spinics.net/lists/linux-media/msg139713.html

The first Allwinner driver that will be using this API is here:

https://lwn.net/Articles/763589/

It's expected to be merged for 4.20 as well.

Preliminary H264 work for the Allwinner driver is here:

https://lkml.org/lkml/2018/6/13/399

But this needs more work.

HEVC support, on the other hand, is almost ready:

https://lkml.org/lkml/2018/8/28/229

I hope these links give a good overview of the current status.

Regards,

	Hans

On 08/13/2018 04:50 PM, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> Hi,
> 
> this set of patches perform a bit of cleanup and extend support to the
> VDE implementation found on Tegra114 and Tegra124. This requires adding
> handling for a clock and a reset for the BSEV block that is separate
> from the main VDE block. The new VDE revision also supports reference
> picture marking, which requires that the BSEV writes out some related
> data to a memory location. Since the supported tiling layouts have been
> changed in Tegra124, which supports only block-linear and no pitch-
> linear layouts, a new way is added to request a specific layout for the
> decoded frames. Both of the above changes require breaking the ABI to
> accomodate for the new data in the custom IOCTL.
> 
> Finally this set also adds support for dealing with an IOMMU, which
> makes it more convenient to deal with imported buffers since they no
> longer need to be physically contiguous.
> 
> Userspace changes for the updated ABI are available here:
> 
> 	https://cgit.freedesktop.org/~tagr/libvdpau-tegra/commit/
> 
> Mauro, I'm sending the device tree changes as part of the series for
> completeness, but I expect to pick those up into the Tegra tree once
> this has been reviewed and you've applied the driver changes.
> 
> Thanks,
> Thierry
> 
> Thierry Reding (14):
>   staging: media: tegra-vde: Support BSEV clock and reset
>   staging: media: tegra-vde: Support reference picture marking
>   staging: media: tegra-vde: Prepare for interlacing support
>   staging: media: tegra-vde: Use DRM/KMS framebuffer modifiers
>   staging: media: tegra-vde: Properly mark invalid entries
>   staging: media: tegra-vde: Print out invalid FD
>   staging: media: tegra-vde: Add some clarifying comments
>   staging: media: tegra-vde: Track struct device *
>   staging: media: tegra-vde: Add IOMMU support
>   staging: media: tegra-vde: Keep VDE in reset when unused
>   ARM: tegra: Enable VDE on Tegra124
>   ARM: tegra: Add BSEV clock and reset for VDE on Tegra20
>   ARM: tegra: Add BSEV clock and reset for VDE on Tegra30
>   ARM: tegra: Enable SMMU for VDE on Tegra124
> 
>  arch/arm/boot/dts/tegra124.dtsi             |  42 ++
>  arch/arm/boot/dts/tegra20.dtsi              |  10 +-
>  arch/arm/boot/dts/tegra30.dtsi              |  10 +-
>  drivers/staging/media/tegra-vde/tegra-vde.c | 528 +++++++++++++++++---
>  drivers/staging/media/tegra-vde/uapi.h      |   6 +-
>  5 files changed, 511 insertions(+), 85 deletions(-)
> 
