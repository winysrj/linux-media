Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:38482 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751605AbdJaJyd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Oct 2017 05:54:33 -0400
Date: Tue, 31 Oct 2017 07:51:50 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [GIT PULL for 4.15] Yet more sensor driver patches
Message-ID: <20171031074943.1fc240dc@vento.lan>
In-Reply-To: <20171026090255.2oe6a24qugrngj3o@valkosipuli.retiisi.org.uk>
References: <20171026090255.2oe6a24qugrngj3o@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 26 Oct 2017 12:02:55 +0300
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Mauro,
> 
> Here's the final set of sensor driver patches for 4.15.
> 
> Please pull.

Hi Sakari,

Could you please rebase this series on the top of master? The first
patch started with a merge conflict, and you sent some v2 and RESEND
git pull requests without marking the previous pull request as superseded
at patchwork. 

So, I likely applied the earlier version. My mistake. In my defense,
my usual review process uses 3 big screens. When I'm traveling, I need 
to live with a single small one, with is not ideal. That's why I opted to
only apply patches while traveling from subsystem maintainers.

Regards,
Mauro

> 
> 
> The following changes since commit 61065fc3e32002ba48aa6bc3816c1f6f9f8daf55:
> 
>   Merge commit '3728e6a255b5' into patchwork (2017-10-17 17:22:20 -0700)
> 
> are available in the git repository at:
> 
>   ssh://linuxtv.org/git/sailus/media_tree.git for-4.15-4
> 
> for you to fetch changes up to fc8d24b85bc230afe66e9aece38350384c9b65f8:
> 
>   media: ov9650: remove unnecessary terminated entry in menu items array (2017-10-25 19:08:43 +0300)
> 
> ----------------------------------------------------------------
> Akinobu Mita (5):
>       media: adv7180: don't clear V4L2_SUBDEV_FL_IS_I2C
>       media: max2175: don't clear V4L2_SUBDEV_FL_IS_I2C
>       media: ov2640: don't clear V4L2_SUBDEV_FL_IS_I2C
>       media: ov5640: don't clear V4L2_SUBDEV_FL_IS_I2C
>       media: ov9650: remove unnecessary terminated entry in menu items array
> 
> Jacob Chen (2):
>       media: i2c: OV5647: ensure clock lane in LP-11 state before streaming on
>       media: i2c: OV5647: change to use macro for the registers
> 
> Philipp Zabel (1):
>       tc358743: validate lane count
> 
> Wenyou Yang (3):
>       media: ov7670: Add entity pads initialization
>       media: ov7670: Add the get_fmt callback
>       media: ov7670: Add the ov7670_s_power function
> 
>  drivers/media/i2c/adv7180.c  |   2 +-
>  drivers/media/i2c/max2175.c  |   2 +-
>  drivers/media/i2c/ov2640.c   |   2 +-
>  drivers/media/i2c/ov5640.c   |   2 +-
>  drivers/media/i2c/ov5647.c   |  51 ++++++++++++-----
>  drivers/media/i2c/ov7670.c   | 129 ++++++++++++++++++++++++++++++++++++++++---
>  drivers/media/i2c/ov9650.c   |   1 -
>  drivers/media/i2c/tc358743.c |   5 ++
>  8 files changed, 167 insertions(+), 27 deletions(-)
> 


-- 
Thanks,
Mauro
