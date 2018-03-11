Return-path: <linux-media-owner@vger.kernel.org>
Received: from guitar.tcltek.co.il ([192.115.133.116]:56433 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932080AbeCKG6L (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 11 Mar 2018 01:58:11 -0500
Date: Sun, 11 Mar 2018 08:58:05 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Jacob Chen <jacob-chen@iotwrt.com>
Cc: linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, mchehab@kernel.org,
        linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com, tfiga@chromium.org, zhengsq@rock-chips.com,
        laurent.pinchart@ideasonboard.com, zyc@rock-chips.com,
        eddie.cai.linux@gmail.com, jeffy.chen@rock-chips.com,
        devicetree@vger.kernel.org, heiko@sntech.de,
        Jacob Chen <jacob2.chen@rock-chips.com>,
        Jacob Chen <cc@rock-chips.com>,
        Allon Huang <allon.huang@rock-chips.com>
Subject: Re: [PATCH v6 09/17] media: rkisp1: add rockchip isp1 core driver
Message-ID: <20180311065805.ezrjm4wn5mnorvgg@sapphire.tkos.co.il>
References: <20180308094807.9443-1-jacob-chen@iotwrt.com>
 <20180308094807.9443-10-jacob-chen@iotwrt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180308094807.9443-10-jacob-chen@iotwrt.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacob,

On Thu, Mar 08, 2018 at 05:47:59PM +0800, Jacob Chen wrote:
> +config VIDEO_ROCKCHIP_ISP1
> +	tristate "Rockchip Image Signal Processing v1 Unit driver"
> +	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
> +	depends on ARCH_ROCKCHIP || COMPILE_TEST
> +	select VIDEOBUF2_DMA_CONTIG
> +	select V4L2_FWNODE
> +	default n
> +	---help---
> +	  Support for ISP1 on the rockchip SoC.

I added 'select VIDEOBUF2_VMALLOC' here to fix link failure:

drivers/media/platform/rockchip/isp1/isp_stats.o: In function `rkisp1_register_stats_vdev':
isp_stats.c:(.text+0x80c): undefined reference to `vb2_vmalloc_memops'
isp_stats.c:(.text+0x814): undefined reference to `vb2_vmalloc_memops'
drivers/media/platform/rockchip/isp1/isp_params.o: In function `rkisp1_register_params_vdev':
isp_params.c:(.text+0x29b4): undefined reference to `vb2_vmalloc_memops'
isp_params.c:(.text+0x29bc): undefined reference to `vb2_vmalloc_memops'

baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
