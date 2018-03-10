Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:44427 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932407AbeCJSUs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Mar 2018 13:20:48 -0500
Date: Sat, 10 Mar 2018 19:20:42 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
        mchehab@kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] Renesas CEU: SH7724 ECOVEC + Aptina mt9t112
Message-ID: <20180310182042.GK4023@w540>
References: <1520008541-3961-1-git-send-email-jacopo+renesas@jmondi.org>
 <f783d586-3f6b-0dad-a130-c2c52ce42634@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f783d586-3f6b-0dad-a130-c2c52ce42634@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Sat, Mar 10, 2018 at 06:57:17PM +0100, Hans Verkuil wrote:
> Hi Jacopo,
>
> On 02/03/18 17:35, Jacopo Mondi wrote:
> > Hello,
> >    now that CEU has been picked up for inclusion in v4.17, we can start moving
> > users of old sh_mobile_ceu_camera driver to use the newly introduced one.
> >
> > Migo-R has been first, now it's SH7724 ECOVEC board turn.
> >
> > ECOVEC has a camera board with two MT9T112 image sensor and one TW9910 video
> > decoder input. This series moves the mt9t112 driver away from soc_camera
> > framework and remove dependencies on it in mach-ecovec board code.
> >
> > As per Migo-R, memory for CEU is reserved using memblocks APIs and declared
> > as DMA-capable in board code, power up/down routines have been removed from
> > board code, and GPIOs lookup table registered for sensor drivers.
> >
> > As in the previous series, still no code has been removed or changed in
> > drivers/media/i2c/soc_camera/ until we do not remove all dependencies on it
> > in all board files.
> >
> > Hans, since you asked me to add frame rate interval support for ov772x I expect
> > to receive the same request for mt9t112. Unfortunately I do not have access to
> > register level documentation, nor can perform any testing as I don't have the
> > camera modules. For the same reason I cannot run any v4l2-compliance test on
> > that driver, but just make sure the ECOVEC boots cleanly with the new board
> > file. I'm in favour of moving the driver to staging if you think that's the case.
> >
> > Series based on media-tree master, and as per Migo-R I would ask SH arch/
> > changes to go through media tree as SH maintainers are un-responsive.
>
> When compiling this series I get this error:
>
> drivers/media/i2c/soc_camera/mt9t112.c: In function ‘mt9t112_init_pll’:
> drivers/media/i2c/soc_camera/mt9t112.c:426:16: error: dereferencing pointer to incomplete type ‘struct mt9t112_camera_info’
>       priv->info->divider.m,
>                 ^~
>
> Can you take a look?

Ups, changing the driver interface ofc breaks the soc_camera version
of the driver (I didn't notice as I've compiled soc_camera out in my
tests).

As the old driver is the only user of that interface this series
doesn't touch[1] I'll rename the old 'struct mt9t112_camera_info' to
the newly introduced 'struct mt9t112_platform_data' (and I've made
sure nobody uses the flag definitions I have removed).

I'll pile another patch on top of the one just sent to add the TODO
note at driver's beginning.

Sorry about that
   j

[1]
$git grep "media/i2c/mt9t112.h" .
MAINTAINERS:F:  include/media/i2c/mt9t112.h
arch/sh/boards/mach-ecovec24/setup.c:#include <media/i2c/mt9t112.h>
drivers/media/i2c/mt9t112.c:#include <media/i2c/mt9t112.h>
drivers/media/i2c/soc_camera/mt9t112.c:#include <media/i2c/mt9t112.h>

>
> Regards,
>
> 	Hans
>
> >
> > Thanks
> >   j
> >
> > Jacopo Mondi (5):
> >   media: i2c: Copy mt9t112 soc_camera sensor driver
> >   media: i2c: mt9t112: Remove soc_camera dependencies
> >   media: i2c: mt9t112: Fix code style issues
> >   arch: sh: ecovec: Use new renesas-ceu camera driver
> >   media: MAINTAINERS: Add entry for Aptina MT9T112
> >
> >  MAINTAINERS                            |    7 +
> >  arch/sh/boards/mach-ecovec24/setup.c   |  338 +++++-----
> >  arch/sh/kernel/cpu/sh4a/clock-sh7724.c |    4 +-
> >  drivers/media/i2c/Kconfig              |   11 +
> >  drivers/media/i2c/Makefile             |    1 +
> >  drivers/media/i2c/mt9t112.c            | 1136 ++++++++++++++++++++++++++++++++
> >  include/media/i2c/mt9t112.h            |   17 +-
> >  7 files changed, 1333 insertions(+), 181 deletions(-)
> >  create mode 100644 drivers/media/i2c/mt9t112.c
> >
> > --
> > 2.7.4
> >
>
