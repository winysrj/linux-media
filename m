Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:59693
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753007AbdDSODV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Apr 2017 10:03:21 -0400
Date: Wed, 19 Apr 2017 11:03:12 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Pali =?UTF-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>,
        Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>,
        Todor Tomov <todor.tomov@linaro.org>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Bhumika Goyal <bhumirks@gmail.com>
Subject: Re: [PATCH] [media] ov2640: make GPIOLIB an optional dependency
Message-ID: <20170419110300.2dbbf784@vento.lan>
In-Reply-To: <20170419132339.GA31747@amd>
References: <a463ea990d2138ca93027b006be96a0324b77fe4.1492602584.git.mchehab@s-opensource.com>
        <20170419132339.GA31747@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 19 Apr 2017 15:23:39 +0200
Pavel Machek <pavel@ucw.cz> escreveu:

> Hi!
> 
> > As warned by kbuild test robot:
> > 	warning: (VIDEO_EM28XX_V4L2) selects VIDEO_OV2640 which has unmet direct dependencies (MEDIA_SUPPORT && VIDEO_V4L2 && I2C && GPIOLIB && MEDIA_CAMERA_SUPPORT)
> > 
> > The em28xx driver can use ov2640, but it doesn't depend
> > (or use) the GPIOLIB in order to power off/on the sensor.
> > 
> > So, as we want to allow both usages with and without
> > GPIOLIB, make its dependency optional.  
> 
> Umm. The driver will not work too well with sensor powered off, no?
> Will this result in some tricky-to-debug situations?
> 
> >  config VIDEO_OV2640
> >  	tristate "OmniVision OV2640 sensor support"
> > -	depends on VIDEO_V4L2 && I2C && GPIOLIB
> > +	depends on VIDEO_V4L2 && I2C
> >  	depends on MEDIA_CAMERA_SUPPORT
> >  	help
> >  	  This is a Video4Linux2 sensor-level driver for the
> >  	OmniVision  
> 
> Better solution would be for VIDEO_EM28XX_V4L2 to depend on GPIOLIB,
> too, no? If not, should there be BUG_ON(priv->pwdn_gpio);
> BUG_ON(priv->resetb_gpio);?

Pavel,

The em28xx driver was added upstream several years the gpio driver. 
It controls GPIO using a different logic. It makes no sense to make
it dependent on GPIOLIB, except if someone converts it to use it.

Besides that, I won't doubt that, at least on some em28xx webcams,
the sensor is always on.

Converting it to use the gpiolib not an easy task, as it supports a
hundred different device models and several different types of devices:
webcams, analog TV, digital TV, hybrid devices (plus devices with FM
radio too).

Too much work for no gain and a high risk of regressions.


Thanks,
Mauro
