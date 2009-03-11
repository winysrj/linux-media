Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2932 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbZCKKRJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2009 06:17:09 -0400
Message-ID: <12860.62.70.2.252.1236766618.squirrel@webmail.xs4all.nl>
Date: Wed, 11 Mar 2009 11:16:58 +0100 (CET)
Subject: Re: [PATCH 4/4] mt9v022: allow setting of bus width from board code
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Sascha Hauer" <s.hauer@pengutronix.de>
Cc: linux-media@vger.kernel.org,
	"Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
	"Sascha Hauer" <s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> This patch removes the phytec specific setting of the bus width
> and switches to the more generic query_bus_param/set_bus_param
> hooks
>
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> ---
>  drivers/media/video/Kconfig   |    7 ---
>  drivers/media/video/mt9v022.c |   97
> +++++------------------------------------
>  2 files changed, 11 insertions(+), 93 deletions(-)
>
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index 5fc1531..071d66f 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -729,6 +664,7 @@ static int mt9v022_video_probe(struct
> soc_camera_device *icd)
>  	/* Set monochrome or colour sensor type */
>  	if (sensor_type && (!strcmp("colour", sensor_type) ||
>  			    !strcmp("color", sensor_type))) {
> +	if (1) {
>  		ret = reg_write(icd, MT9V022_PIXEL_OPERATION_MODE, 4 | 0x11);
>  		mt9v022->model = V4L2_IDENT_MT9V022IX7ATC;
>  		icd->formats = mt9v022_colour_formats;

'if (1) {': some left-over debugging?

Regards,

     Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

