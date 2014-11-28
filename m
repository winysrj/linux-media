Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59861 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751799AbaK1RKz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Nov 2014 12:10:55 -0500
Date: Fri, 28 Nov 2014 19:10:52 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-media@vger.kernel.org, m.chehab@samsung.com,
	gjasny@googlemail.com, hdegoede@redhat.com, hans.verkuil@cisco.com,
	b.zolnierkie@samsung.com, kyungmin.park@samsung.com,
	sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH/RFC v4 07/11] media-ctl: libv4l2subdev: add VYUY8_2X8
 mbus code
Message-ID: <20141128171052.GP8907@valkosipuli.retiisi.org.uk>
References: <1416586480-19982-1-git-send-email-j.anaszewski@samsung.com>
 <1416586480-19982-8-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416586480-19982-8-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 21, 2014 at 05:14:36PM +0100, Jacek Anaszewski wrote:
> The VYUY8_2X8 media bus format is the only one supported
> by the S5C73M3 camera sensor, that is a part of the media
> device on the Exynos4412-trats2 board.
> 
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  utils/media-ctl/libv4l2subdev.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/utils/media-ctl/libv4l2subdev.c b/utils/media-ctl/libv4l2subdev.c
> index 4c5fb12..a96ed7a 100644
> --- a/utils/media-ctl/libv4l2subdev.c
> +++ b/utils/media-ctl/libv4l2subdev.c
> @@ -704,6 +704,7 @@ static struct {
>  	{ "YUYV", V4L2_MBUS_FMT_YUYV8_1X16 },
>  	{ "YUYV1_5X8", V4L2_MBUS_FMT_YUYV8_1_5X8 },
>  	{ "YUYV2X8", V4L2_MBUS_FMT_YUYV8_2X8 },
> +	{ "VYUY8_2X8", V4L2_MBUS_FMT_VYUY8_2X8 },
>  	{ "UYVY", V4L2_MBUS_FMT_UYVY8_1X16 },
>  	{ "UYVY1_5X8", V4L2_MBUS_FMT_UYVY8_1_5X8 },
>  	{ "UYVY2X8", V4L2_MBUS_FMT_UYVY8_2X8 },

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
