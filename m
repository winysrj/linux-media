Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:64807 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271Ab2GPJv4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jul 2012 05:51:56 -0400
Date: Mon, 16 Jul 2012 11:51:54 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
cc: linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, b.zolnierkie@samsung.com
Subject: Re: [RFC/PATCH 12/13] media: s5p-fimc: Add device tree based sensors
 registration
In-Reply-To: <1337975573-27117-12-git-send-email-s.nawrocki@samsung.com>
Message-ID: <Pine.LNX.4.64.1207161149230.12302@axis700.grange>
References: <4FBFE1EC.9060209@samsung.com> <1337975573-27117-1-git-send-email-s.nawrocki@samsung.com>
 <1337975573-27117-12-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 25 May 2012, Sylwester Nawrocki wrote:

> Add parsing of 'sensor' nodes specified as 'camera' child nodes.
> Each 'sensor' node should contain a phandle indicating sensor I2C
> client device. Sensors with SPI control bus are not yet supported.
> 
> Additionally it is required that the I2C client node (child node
> of I2C bus controller node) contains 'clock-frequency' and
> 'video-bus-type' properties. These properties allow the host
> controller to switch to proper video bus and set proper master
> clock frequency for a sensor.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
> 
> We might need something like this as a V4L2 core function.
> But I wanted to have something settled first until proposing
> any addtions to the V4L2 core modules.
> ---
>  .../bindings/camera/soc/samsung-fimc.txt           |   22 ++++
>  drivers/media/video/s5p-fimc/fimc-mdevice.c        |  114 +++++++++++++++++++-
>  2 files changed, 133 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/camera/soc/samsung-fimc.txt b/Documentation/devicetree/bindings/camera/soc/samsung-fimc.txt
> index b459da2..ffe09ac 100644
> --- a/Documentation/devicetree/bindings/camera/soc/samsung-fimc.txt
> +++ b/Documentation/devicetree/bindings/camera/soc/samsung-fimc.txt
> @@ -54,6 +54,28 @@ Required properties:
>  - cell-index : FIMC-LITE IP instance index;
>  
>  
> +The 'sensor' nodes
> +------------------
> +
> +Required properties:
> +
> + - i2c-client : a phandle to an image sensor I2C client device;
> +
> +Optional properties:
> +
> +- samsung,camif-mux-id : FIMC video multiplexer input index; for camera
> +			 port A, B, C the indexes are 0, 1, 0 respectively.
> +			 If this property is not specified a default 0
> +			 value will be used by driver.

Isn't it possible to have several clients connected to different mux 
inputs and switch between them at run-time? Even if only one of them can 
be active at any time? That's why I've introduced link nodes in my RFC to 
specify exactly which pads are connected.

> +
> +- samsung,fimc-camclk-id : the SoC CAM_MCLK clock output index. These clocks
> +			   are master clocks for external image processors.
> +			   If this property is not specified a default 0 value
> +			   will be used by driver.
> +
> + "video-bus-type" and "clock-frequency" properties must be specified at the
> + node referenced by 'i2c-client' phandle.
> +
>  Example:
>  
>  	fimc0: fimc@11800000 {

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
