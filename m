Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44960 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751405AbdJEG3F (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Oct 2017 02:29:05 -0400
Date: Thu, 5 Oct 2017 09:29:02 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Leon Luo <leonl@leopardimaging.com>
Cc: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        hans.verkuil@cisco.com, sakari.ailus@linux.intel.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, soren.brinkmann@xilinx.com
Subject: Re: [PATCH v8 2/2] media:imx274 V4l2 driver for Sony imx274 CMOS
 sensor
Message-ID: <20171005062901.ofexwxfnun45linq@valkosipuli.retiisi.org.uk>
References: <20171005000621.27841-1-leonl@leopardimaging.com>
 <20171005000621.27841-2-leonl@leopardimaging.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20171005000621.27841-2-leonl@leopardimaging.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 04, 2017 at 05:06:21PM -0700, Leon Luo wrote:
> The imx274 is a Sony CMOS image sensor that has 1/2.5 image size.
> It supports up to 3840x2160 (4K) 60fps, 1080p 120fps. The interface
> is 4-lane MIPI CSI-2 running at 1.44Gbps each.
> 
> This driver has been tested on Xilinx ZCU102 platform with a Leopard
> LI-IMX274MIPI-FMC camera board.
> 
> Support for the following features:
> -Resolutions: 3840x2160, 1920x1080, 1280x720
> -Frame rate: 3840x2160 : 5 – 60fps
>             1920x1080 : 5 – 120fps
>             1280x720 : 5 – 120fps
> -Exposure time: 16 – (frame interval) micro-seconds
> -Gain: 1x - 180x
> -VFLIP: enable/disabledrivers/media/i2c/imx274.c
> -Test pattern: 12 test patterns
> 
> Signed-off-by: Leon Luo <leonl@leopardimaging.com>
> Tested-by: Sören Brinkmann <soren.brinkmann@xilinx.com>
> Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

Thanks!

Applied with MEDIA_CAMERA_SUPPORT dependency to Kconfig.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
