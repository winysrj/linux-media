Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:45026 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754066AbeDXJ3r (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 05:29:47 -0400
Subject: Re: [PATCH v3 0/7] TDA998x CEC support
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org
References: <20180409121529.GA31403@n2100.armlinux.org.uk>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <a3c8c61a-83fa-5363-0065-fe22c6bf77fe@xs4all.nl>
Date: Tue, 24 Apr 2018 11:29:42 +0200
MIME-Version: 1.0
In-Reply-To: <20180409121529.GA31403@n2100.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/09/18 14:15, Russell King - ARM Linux wrote:
> Hi,
> 
> This patch series adds CEC support to the DRM TDA998x driver.  The
> TDA998x family of devices integrate a TDA9950 CEC at a separate I2C
> address from the HDMI encoder.
> 
> Implementation of the CEC part is separate to allow independent CEC
> implementations, or independent HDMI implementations (since the
> TDA9950 may be a separate device.)

Reviewed, looks good.

Thanks!

	Hans

> 
>  .../devicetree/bindings/display/bridge/tda998x.txt |   3 +
>  drivers/gpu/drm/i2c/Kconfig                        |   6 +
>  drivers/gpu/drm/i2c/Makefile                       |   1 +
>  drivers/gpu/drm/i2c/tda9950.c                      | 509 +++++++++++++++++++++
>  drivers/gpu/drm/i2c/tda998x_drv.c                  | 242 ++++++++--
>  include/linux/platform_data/tda9950.h              |  16 +
>  6 files changed, 750 insertions(+), 27 deletions(-)
>  create mode 100644 drivers/gpu/drm/i2c/tda9950.c
>  create mode 100644 include/linux/platform_data/tda9950.h
> 
> v3: addressed most of Hans comments in v2
> v2: updated DT property.
>  
> 
