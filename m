Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:51757 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993AbcBOPz1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2016 10:55:27 -0500
Date: Mon, 15 Feb 2016 17:55:24 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	gjasny@googlemail.com, hdegoede@redhat.com, hverkuil@xs4all.nl
Subject: Re: [PATCH 07/15] mediactl: libv4l2subdev: add VYUY8_2X8 mbus code
Message-ID: <20160215155523.GB1639@paasikivi.fi.intel.com>
References: <1453133860-21571-1-git-send-email-j.anaszewski@samsung.com>
 <1453133860-21571-8-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1453133860-21571-8-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

On Mon, Jan 18, 2016 at 05:17:32PM +0100, Jacek Anaszewski wrote:
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
> index 069ded6..5175188 100644
> --- a/utils/media-ctl/libv4l2subdev.c
> +++ b/utils/media-ctl/libv4l2subdev.c
> @@ -780,6 +780,7 @@ static struct {
>  	{ "YUYV", MEDIA_BUS_FMT_YUYV8_1X16 },
>  	{ "YUYV1_5X8", MEDIA_BUS_FMT_YUYV8_1_5X8 },
>  	{ "YUYV2X8", MEDIA_BUS_FMT_YUYV8_2X8 },
> +	{ "VYUY8_2X8", V4L2_MBUS_FMT_VYUY8_2X8 },
>  	{ "UYVY", MEDIA_BUS_FMT_UYVY8_1X16 },
>  	{ "UYVY1_5X8", MEDIA_BUS_FMT_UYVY8_1_5X8 },
>  	{ "UYVY2X8", MEDIA_BUS_FMT_UYVY8_2X8 },

I have a patch taking the codes directly from media-bus-fmt.h; it's here:

<URL:http://www.spinics.net/lists/linux-media/msg96651.html>

Could you use the definition from that one instead? (I think all you need to
do is to drop the patch.)

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
