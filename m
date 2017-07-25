Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:42622 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750839AbdGYW6M (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Jul 2017 18:58:12 -0400
Date: Wed, 26 Jul 2017 01:58:09 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Petr Cvek <petr.cvek@tul.cz>, Pavel Machek <pavel@ucw.cz>,
        Sebastian Reichel <sre@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: v4l: use WARN_ON(1) instead of __WARN()
Message-ID: <20170725225808.r2oueqjdflyr6acq@valkosipuli.retiisi.org.uk>
References: <20170725154001.294864-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170725154001.294864-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 25, 2017 at 05:39:14PM +0200, Arnd Bergmann wrote:
> __WARN() cannot be used in portable code, since it is only
> available on some architectures and configurations:
> 
> drivers/media/platform/pxa_camera.c: In function 'pxa_mbus_config_compatible':
> drivers/media/platform/pxa_camera.c:642:3: error: implicit declaration of function '__WARN'; did you mean '__WALL'? [-Werror=implicit-function-declaration]
> 
> The common way to express an unconditional warning is WARN_ON(1),
> so let's use that here.
> 
> Fixes: 97bbdf02d905 ("media: v4l: Add support for CSI-1 and CCP2 busses")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/media/platform/pxa_camera.c              | 2 +-
>  drivers/media/platform/soc_camera/soc_mediabus.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
> index 3898a5cd8664..0d4af6d91ffc 100644
> --- a/drivers/media/platform/pxa_camera.c
> +++ b/drivers/media/platform/pxa_camera.c
> @@ -639,7 +639,7 @@ static unsigned int pxa_mbus_config_compatible(const struct v4l2_mbus_config *cf
>  					     V4L2_MBUS_CSI2_CONTINUOUS_CLOCK);
>  		return (!mipi_lanes || !mipi_clock) ? 0 : common_flags;
>  	default:
> -		__WARN();
> +		WARN_ON(1);
>  		return -EINVAL;
>  	}
>  	return 0;
> diff --git a/drivers/media/platform/soc_camera/soc_mediabus.c b/drivers/media/platform/soc_camera/soc_mediabus.c
> index 43192d80beef..0ad4b28266e4 100644
> --- a/drivers/media/platform/soc_camera/soc_mediabus.c
> +++ b/drivers/media/platform/soc_camera/soc_mediabus.c
> @@ -509,7 +509,7 @@ unsigned int soc_mbus_config_compatible(const struct v4l2_mbus_config *cfg,
>  					     V4L2_MBUS_CSI2_CONTINUOUS_CLOCK);
>  		return (!mipi_lanes || !mipi_clock) ? 0 : common_flags;
>  	default:
> -		__WARN();
> +		WARN_ON(1);
>  		return -EINVAL;
>  	}
>  	return 0;

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
