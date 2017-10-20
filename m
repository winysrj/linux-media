Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53762 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751014AbdJTGvW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Oct 2017 02:51:22 -0400
Date: Fri, 20 Oct 2017 09:51:19 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH 0/4] media: don't clear V4L2_SUBDEV_FL_IS_I2C
Message-ID: <20171020065118.mw4vag56kc6jsnyv@valkosipuli.retiisi.org.uk>
References: <1508430683-8674-1-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1508430683-8674-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 20, 2017 at 01:31:19AM +0900, Akinobu Mita wrote:
> The v4l2_i2c_subdev_init() sets V4L2_SUBDEV_FL_IS_I2C flag in the
> subdev->flags.  But some drivers overwrite subdev->flags immediately after
> calling v4l2_i2c_subdev_init().  So V4L2_SUBDEV_FL_IS_I2C is not set after
> all.
> 
> This patch series fixes the problem for each driver.
> 
> Side note: According to the comment in v4l2_device_unregister(), this is
> problematic only if the device is platform bus device.  Device tree or
> ACPI based devices are not affected.

Good catch, thanks!

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
