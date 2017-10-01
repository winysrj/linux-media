Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f174.google.com ([209.85.216.174]:57333 "EHLO
        mail-qt0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751005AbdJAKcz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 1 Oct 2017 06:32:55 -0400
MIME-Version: 1.0
In-Reply-To: <1506265198-13384-1-git-send-email-d.filoni@ubuntu.com>
References: <1506265198-13384-1-git-send-email-d.filoni@ubuntu.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Sun, 1 Oct 2017 13:32:53 +0300
Message-ID: <CAHp75VeqFjTz-V9F3U==J5cpTFCSWq5iG_EG8Ti0nStzZJ36Rw@mail.gmail.com>
Subject: Re: [PATCH v2] staging: atomisp: add a driver for ov5648 camera sensor
To: Devid Antonio Floni <d.filoni@ubuntu.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        =?UTF-8?B?SsOpcsOpbXkgTGVmYXVyZQ==?= <jeremy.lefaure@lse.epita.fr>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        devel@driverdev.osuosl.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Sep 24, 2017 at 5:59 PM, Devid Antonio Floni
<d.filoni@ubuntu.com> wrote:
> The ov5648 5-megapixel camera sensor from OmniVision supports up to 2592x1944
> resolution and MIPI CSI-2 interface. Output format is raw sRGB/Bayer with
> 10 bits per colour (SGRBG10_1X10).
>
> This patch is a port of ov5648 driver after applying following
> 01org/ProductionKernelQuilts patches:
>  - 0004-ov2680-ov5648-Fork-lift-source-from-CTS.patch
>  - 0005-ov2680-ov5648-gminification.patch
>  - 0006-ov5648-Focus-support.patch
>  - 0007-Fix-resolution-issues-on-rear-camera.patch
>  - 0008-ov2680-ov5648-Enabled-the-set_exposure-functions.patch
>  - 0010-IRDA-cameras-mode-list-cleanup-unification.patch
>  - 0012-ov5648-Add-1296x972-binned-mode.patch
>  - 0014-ov5648-Adapt-to-Atomisp2-Gmin-VCM-framework.patch
>  - 0015-dw9714-Gmin-Atomisp-specific-VCM-driver.patch
>  - 0017-ov5648-Fix-deadlock-on-I2C-error.patch
>  - 0018-gc2155-Fix-deadlock-on-error.patch
>  - 0019-ov5648-Add-1280x960-binned-mode.patch
>  - 0020-ov5648-Make-1280x960-as-default-video-resolution.patch
>  - 0021-MALATA-Fix-testCameraToSurfaceTextureMetadata-CTS.patch
>  - 0023-OV5648-Added-5MP-video-resolution.patch
>
> New changes introduced during the port:
>  - Rename entity types to entity functions
>  - Replace v4l2_subdev_fh by v4l2_subdev_pad_config
>  - Make use of media_bus_format enum
>  - Rename media_entity_init function to media_entity_pads_init
>  - Replace try_mbus_fmt by set_fmt
>  - Replace s_mbus_fmt by set_fmt
>  - Replace g_mbus_fmt by get_fmt
>  - Use s_ctrl/g_volatile_ctrl instead of ctrl core ops
>  - Update gmin platform API path
>  - Constify acpi_device_id
>  - Add "INT5648" value to acpi_device_id
>  - Fix some checkpatch errors and warnings
>  - Remove FSF's mailing address from the sample GPL notice
>
> Changes in v2:
>  - Fix indentation
>  - Add atomisp prefix to Kconfig option

I discussed with Sakari about my review and we agreed that two things
that I have mentioned (converting to smbus calls and regulator
framework) would be a material for future changes.
Other than that, please, address the rest of comments and we will be fine.

You may also refer to my last patch series WRT atomisp driver where I
tried to address my own comments to the rest of the code.

-- 
With Best Regards,
Andy Shevchenko
