Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:36596
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751942AbdAaMm6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jan 2017 07:42:58 -0500
Date: Tue, 31 Jan 2017 10:42:48 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@iki.fi>,
        Tuukka Toivonen <tuukkat76@gmail.com>,
        Pavel Machek <pavel@ucw.cz>
Cc: linux-media@vger.kernel.org
Subject: Re: [GIT PULL FOR v4.11] Add et8ek8 driver
Message-ID: <20170131104248.4e0f0bd8@vento.lan>
In-Reply-To: <20170125140745.GH7139@valkosipuli.retiisi.org.uk>
References: <20170125140745.GH7139@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 25 Jan 2017 16:07:45 +0200
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Mauro,
> 
> This pull request adds the sensor et8ek8 driver which is used on the Nokia
> N900. Please pull.
> 
> 
> The following changes since commit 40eca140c404505c09773d1c6685d818cb55ab1a:
> 
>   [media] mn88473: add DVB-T2 PLP support (2016-12-27 14:00:15 -0200)
> 
> are available in the git repository at:
> 
>   ssh://linuxtv.org/git/sailus/media_tree.git et8ek8
> 
> for you to fetch changes up to 1d26b93d5341d36cdd45b4d801f85d6c35128385:
> 
>   mark myself as mainainer for camera on N900 (2017-01-25 15:49:45 +0200)
> 
> ----------------------------------------------------------------
> Pavel Machek (3):
>       media: et8ek8: add device tree binding documentation
>       media: Driver for Toshiba et8ek8 5MP sensor
>       mark myself as mainainer for camera on N900
> 
>  .../bindings/media/i2c/toshiba,et8ek8.txt          |   48 +
>  MAINTAINERS                                        |    8 +
>  drivers/media/i2c/Kconfig                          |    1 +
>  drivers/media/i2c/Makefile                         |    1 +
>  drivers/media/i2c/et8ek8/Kconfig                   |    6 +
>  drivers/media/i2c/et8ek8/Makefile                  |    2 +
>  drivers/media/i2c/et8ek8/et8ek8_driver.c           | 1515 ++++++++++++++++++++
>  drivers/media/i2c/et8ek8/et8ek8_mode.c             |  587 ++++++++
>  drivers/media/i2c/et8ek8/et8ek8_reg.h              |   96 ++
>  9 files changed, 2264 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/toshiba,et8ek8.txt
>  create mode 100644 drivers/media/i2c/et8ek8/Kconfig
>  create mode 100644 drivers/media/i2c/et8ek8/Makefile
>  create mode 100644 drivers/media/i2c/et8ek8/et8ek8_driver.c
>  create mode 100644 drivers/media/i2c/et8ek8/et8ek8_mode.c
>  create mode 100644 drivers/media/i2c/et8ek8/et8ek8_reg.h
> 

That added a new warning:

drivers/media/i2c/et8ek8/et8ek8_driver.c: In function 'et8ek8_registered':
drivers/media/i2c/et8ek8/et8ek8_driver.c:1262:29: warning: variable 'format' set but not used [-Wunused-but-set-variable]
  struct v4l2_mbus_framefmt *format;
                             ^~~~~~
compilation succeeded


The driver is calling this function and storing it on a var
that is not used:

        format = __et8ek8_get_pad_format(sensor, NULL, 0,
                                         V4L2_SUBDEV_FORMAT_ACTIVE);
        return 0;

Please send a fixup patch.

Thanks,
Mauro
