Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:50800 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752344AbeADWUZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Jan 2018 17:20:25 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: magnus.damm@gmail.com, geert@glider.be, mchehab@kernel.org,
        hverkuil@xs4all.nl, festevam@gmail.com, sakari.ailus@iki.fi,
        robh+dt@kernel.org, mark.rutland@arm.com,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 6/9] media: i2c: ov772x: Remove soc_camera dependencies
Date: Fri, 05 Jan 2018 00:20:47 +0200
Message-ID: <5414549.ap49M21qPk@avalon>
In-Reply-To: <1515081797-17174-7-git-send-email-jacopo+renesas@jmondi.org>
References: <1515081797-17174-1-git-send-email-jacopo+renesas@jmondi.org> <1515081797-17174-7-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thank you for the patch.

On Thursday, 4 January 2018 18:03:14 EET Jacopo Mondi wrote:
> Remove soc_camera framework dependencies from ov772x sensor driver.
> - Handle clock and gpios
> - Register async subdevice
> - Remove soc_camera specific g/s_mbus_config operations
> - Change image format colorspace from JPEG to SRGB as the two use the
>   same colorspace information but JPEG makes assumptions on color
>   components quantization that do not apply to the sensor
> - Remove sizes crop from get_selection as driver can't scale
> - Add kernel doc to driver interface header file
> - Adjust build system
> 
> This commit does not remove the original soc_camera based driver as long
> as other platforms depends on soc_camera-based CEU driver.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/i2c/Kconfig  |  11 +++
>  drivers/media/i2c/Makefile |   1 +
>  drivers/media/i2c/ov772x.c | 177 +++++++++++++++++++++++++++---------------
>  include/media/i2c/ov772x.h |   6 +-
>  4 files changed, 133 insertions(+), 62 deletions(-)

-- 
Regards,

Laurent Pinchart
