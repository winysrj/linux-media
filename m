Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38818 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750773AbdEDIuz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 4 May 2017 04:50:55 -0400
Date: Thu, 4 May 2017 11:50:22 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
Cc: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        jian.xu.zheng@intel.com, rajmohan.mani@intel.com,
        hyungwoo.yang@intel.com
Subject: Re: [PATCH] ov5670: Add Omnivision OV5670 5M sensor support
Message-ID: <20170504085021.GU7456@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170504084850.GT7456@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 04, 2017 at 11:48:51AM +0300, Sakari Ailus wrote:
> On Wed, May 03, 2017 at 03:06:52PM -0700, Chiranjeevi Rapolu wrote:
> > Provides single source pad with up to 2576x1936 pixels at 10-bit raw
> > bayer format over MIPI CSI2 two lanes at 640Mbps/lane.
> > Supports up to 30fps at 5M pixels, up to 60fps at 1080p.
> > 
> > Signed-off-by: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
> > ---
> >  drivers/media/i2c/Kconfig  |   11 +
> >  drivers/media/i2c/Makefile |    1 +
> >  drivers/media/i2c/ov5670.c | 3890 ++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 3902 insertions(+)
> >  create mode 100644 drivers/media/i2c/ov5670.c
> > 
> > diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
> > index cee1dae..ded8485 100644
> > --- a/drivers/media/i2c/Kconfig
> > +++ b/drivers/media/i2c/Kconfig
> > @@ -531,6 +531,17 @@ config VIDEO_OV2659
> >  	  To compile this driver as a module, choose M here: the
> >  	  module will be called ov2659.
> >  
> > +config VIDEO_OV5670
> > +	tristate "OmniVision OV5670 sensor support"
> > +	depends on I2C && VIDEO_V4L2
> > +	depends on MEDIA_CAMERA_SUPPORT

select V4L2_FWNODE

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
