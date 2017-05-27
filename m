Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52672 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750737AbdE0Tal (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 27 May 2017 15:30:41 -0400
Date: Sat, 27 May 2017 22:30:35 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: mchehab@kernel.org, laurent.pinchart+renesas@ideasonboard.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: Re: [PATCH] Doc*/media/uapi: fix control name
Message-ID: <20170527193035.GW29527@valkosipuli.retiisi.org.uk>
References: <20170527081239.GA9484@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170527081239.GA9484@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, May 27, 2017 at 10:12:40AM +0200, Pavel Machek wrote:
> V4L2_CID_EXPOSURE_BIAS does not exist, fix documentation.
> 
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 
> diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
> index abb1057..76c5b1a 100644
> --- a/Documentation/media/uapi/v4l/extended-controls.rst
> +++ b/Documentation/media/uapi/v4l/extended-controls.rst
> @@ -2019,7 +2019,7 @@ enum v4l2_exposure_auto_type -
>      dynamically vary the frame rate. By default this feature is disabled
>      (0) and the frame rate must remain constant.
>  
> -``V4L2_CID_EXPOSURE_BIAS (integer menu)``
> +``V4L2_CID_AUTO_EXPOSURE_BIAS (integer menu)``
>      Determines the automatic exposure compensation, it is effective only
>      when ``V4L2_CID_EXPOSURE_AUTO`` control is set to ``AUTO``,
>      ``SHUTTER_PRIORITY`` or ``APERTURE_PRIORITY``. It is expressed in
> 

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Generally linux-media is enough, for other lists such as LKML this is just
noise.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
