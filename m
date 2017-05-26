Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:12293 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1946470AbdEZBVx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 May 2017 21:21:53 -0400
From: "Rapolu, Chiranjeevi" <chiranjeevi.rapolu@intel.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Yang, Hyungwoo" <hyungwoo.yang@intel.com>
Subject: RE: [PATCH] ov5670: Add Omnivision OV5670 5M sensor support
Date: Fri, 26 May 2017 01:21:52 +0000
Message-ID: <8408A4B5C50F354EA5F62D9FC805153D018D4DF1@ORSMSX115.amr.corp.intel.com>
References: <20170504084850.GT7456@valkosipuli.retiisi.org.uk>
 <20170504085021.GU7456@valkosipuli.retiisi.org.uk>
In-Reply-To: <20170504085021.GU7456@valkosipuli.retiisi.org.uk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sakari,
V2 patch selects V4L2_FWNODE.

-----Original Message-----
From: Sakari Ailus [mailto:sakari.ailus@iki.fi] 
Sent: Thursday, May 4, 2017 1:50 AM
To: Rapolu, Chiranjeevi <chiranjeevi.rapolu@intel.com>
Cc: linux-media@vger.kernel.org; sakari.ailus@linux.intel.com; Zheng, Jian Xu <jian.xu.zheng@intel.com>; Mani, Rajmohan <rajmohan.mani@intel.com>; Yang, Hyungwoo <hyungwoo.yang@intel.com>
Subject: Re: [PATCH] ov5670: Add Omnivision OV5670 5M sensor support

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
> >  drivers/media/i2c/ov5670.c | 3890 
> > ++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 3902 insertions(+)  create mode 100644 
> > drivers/media/i2c/ov5670.c
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
