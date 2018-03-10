Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:36891 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750884AbeCJR5W (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Mar 2018 12:57:22 -0500
Subject: Re: [PATCH 0/5] Renesas CEU: SH7724 ECOVEC + Aptina mt9t112
To: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
        mchehab@kernel.org
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1520008541-3961-1-git-send-email-jacopo+renesas@jmondi.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <f783d586-3f6b-0dad-a130-c2c52ce42634@xs4all.nl>
Date: Sat, 10 Mar 2018 18:57:17 +0100
MIME-Version: 1.0
In-Reply-To: <1520008541-3961-1-git-send-email-jacopo+renesas@jmondi.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On 02/03/18 17:35, Jacopo Mondi wrote:
> Hello,
>    now that CEU has been picked up for inclusion in v4.17, we can start moving
> users of old sh_mobile_ceu_camera driver to use the newly introduced one.
> 
> Migo-R has been first, now it's SH7724 ECOVEC board turn.
> 
> ECOVEC has a camera board with two MT9T112 image sensor and one TW9910 video
> decoder input. This series moves the mt9t112 driver away from soc_camera
> framework and remove dependencies on it in mach-ecovec board code.
> 
> As per Migo-R, memory for CEU is reserved using memblocks APIs and declared
> as DMA-capable in board code, power up/down routines have been removed from
> board code, and GPIOs lookup table registered for sensor drivers.
> 
> As in the previous series, still no code has been removed or changed in
> drivers/media/i2c/soc_camera/ until we do not remove all dependencies on it
> in all board files.
> 
> Hans, since you asked me to add frame rate interval support for ov772x I expect
> to receive the same request for mt9t112. Unfortunately I do not have access to
> register level documentation, nor can perform any testing as I don't have the
> camera modules. For the same reason I cannot run any v4l2-compliance test on
> that driver, but just make sure the ECOVEC boots cleanly with the new board
> file. I'm in favour of moving the driver to staging if you think that's the case.
> 
> Series based on media-tree master, and as per Migo-R I would ask SH arch/
> changes to go through media tree as SH maintainers are un-responsive.

When compiling this series I get this error:

drivers/media/i2c/soc_camera/mt9t112.c: In function ‘mt9t112_init_pll’:
drivers/media/i2c/soc_camera/mt9t112.c:426:16: error: dereferencing pointer to incomplete type ‘struct mt9t112_camera_info’
      priv->info->divider.m,
                ^~

Can you take a look?

Regards,

	Hans

> 
> Thanks
>   j
> 
> Jacopo Mondi (5):
>   media: i2c: Copy mt9t112 soc_camera sensor driver
>   media: i2c: mt9t112: Remove soc_camera dependencies
>   media: i2c: mt9t112: Fix code style issues
>   arch: sh: ecovec: Use new renesas-ceu camera driver
>   media: MAINTAINERS: Add entry for Aptina MT9T112
> 
>  MAINTAINERS                            |    7 +
>  arch/sh/boards/mach-ecovec24/setup.c   |  338 +++++-----
>  arch/sh/kernel/cpu/sh4a/clock-sh7724.c |    4 +-
>  drivers/media/i2c/Kconfig              |   11 +
>  drivers/media/i2c/Makefile             |    1 +
>  drivers/media/i2c/mt9t112.c            | 1136 ++++++++++++++++++++++++++++++++
>  include/media/i2c/mt9t112.h            |   17 +-
>  7 files changed, 1333 insertions(+), 181 deletions(-)
>  create mode 100644 drivers/media/i2c/mt9t112.c
> 
> --
> 2.7.4
> 
