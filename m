Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:48518 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753256AbcFGOWp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jun 2016 10:22:45 -0400
Date: Tue, 7 Jun 2016 11:22:35 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Tiffany Lin <tiffany.lin@mediatek.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	<daniel.thompson@linaro.org>, Rob Herring <robh+dt@kernel.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>,
	Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	<devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>, <PoChun.Lin@mediatek.com>
Subject: Re: [PATCH v3 0/9] Add MT8173 Video Decoder Driver
Message-ID: <20160607112235.475c2e4c@recife.lan>
In-Reply-To: <1464611363-14936-1-git-send-email-tiffany.lin@mediatek.com>
References: <1464611363-14936-1-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 30 May 2016 20:29:14 +0800
Tiffany Lin <tiffany.lin@mediatek.com> escreveu:

> ==============
>  Introduction
> ==============
> 
> The purpose of this series is to add the driver for video codec hw embedded in the Mediatek's MT8173 SoCs.
> Mediatek Video Codec is able to handle video decoding of in a range of formats.
> 
> This patch series add Mediatek block format V4L2_PIX_FMT_MT21, the decoder driver will decoded bitstream to
> V4L2_PIX_FMT_MT21 format.
> 
> This patch series rely on MTK VPU driver in patch series "Add MT8173 Video Encoder Driver and VPU Driver"[1]
> and patch "CHROMIUM: v4l: Add V4L2_PIX_FMT_VP9 definition"[2] for VP9 support.
> Mediatek Video Decoder driver rely on VPU driver to load, communicate with VPU.
> 
> Internally the driver uses videobuf2 framework and MTK IOMMU and MTK SMI both have been merged in v4.6-rc1.
> 
> [1]https://patchwork.linuxtv.org/patch/33734/
> [2]https://chromium-review.googlesource.com/#/c/245241/

Hmm... I'm not seeing the firmware for this driver at the
linux-firmware tree:
	https://git.kernel.org/cgit/linux/kernel/git/firmware/linux-firmware.git/log/

Nor I'm seeing any pull request for them. Did you send it?
I'll only merge the driver upstream after seeing such pull request.

Regards,
Mauro

