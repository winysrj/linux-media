Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41800 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752047AbdHIHss (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 Aug 2017 03:48:48 -0400
Date: Wed, 9 Aug 2017 10:48:44 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: i2c: add KConfig dependencies
Message-ID: <20170809074844.3elw7posdcohjaiy@valkosipuli.retiisi.org.uk>
References: <20170725153735.239734-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170725153735.239734-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arnd,

Thanks for the patch.

On Tue, Jul 25, 2017 at 05:36:45PM +0200, Arnd Bergmann wrote:
> @@ -618,8 +618,9 @@ config VIDEO_OV6650
>  
>  config VIDEO_OV5670
>  	tristate "OmniVision OV5670 sensor support"
> -	depends on I2C && VIDEO_V4L2
> +	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
>  	depends on MEDIA_CAMERA_SUPPORT
> +	depends on MEDIA_CONTROLLER
>  	select V4L2_FWNODE
>  	---help---
>  	  This is a Video4Linux2 sensor-level driver for the OmniVision

Applied, with dropping explicit MEDIA_CONTROLLER. VIDEO_V4L2_SUBDEV_API
already depends on MEDIA_CONTROLLER.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
