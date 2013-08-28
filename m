Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f177.google.com ([209.85.215.177]:34170 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253Ab3H1VyJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Aug 2013 17:54:09 -0400
Received: by mail-ea0-f177.google.com with SMTP id f15so3244307eak.36
        for <linux-media@vger.kernel.org>; Wed, 28 Aug 2013 14:54:07 -0700 (PDT)
Message-ID: <521E717C.6010602@gmail.com>
Date: Wed, 28 Aug 2013 23:54:04 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	=?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 3/3] V4L2: em28xx: register a V4L2 clock source
References: <1377696508-3190-1-git-send-email-g.liakhovetski@gmx.de> <1377696508-3190-4-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1377696508-3190-4-git-send-email-g.liakhovetski@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On 08/28/2013 03:28 PM, Guennadi Liakhovetski wrote:
> Camera sensors usually require a master clock for data sampling. This patch
> registers such a clock source for em28xx cameras. This fixes the currently
> broken em28xx ov2640 camera support and can also be used by other camera
> sensors.
>
> Signed-off-by: Guennadi Liakhovetski<g.liakhovetski@gmx.de>
> ---
>
> Actually after thinking a bit more, it'd probably be better to register a
> clock only for the ov2640 based camera, not for all cameras. If all agree,
> I'll redo this.

Not sure, I'd assume it's better to have this clock for all the subdevs.
Currently there are only two sensors handled through regular subdev drivers
though.

>   drivers/media/usb/em28xx/em28xx-camera.c |   41 ++++++++++++++++++++++-------
>   drivers/media/usb/em28xx/em28xx-cards.c  |    3 ++
>   drivers/media/usb/em28xx/em28xx.h        |    1 +
>   3 files changed, 35 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/media/usb/em28xx/em28xx-camera.c b/drivers/media/usb/em28xx/em28xx-camera.c
> index 73cc50a..2f451e4 100644
> --- a/drivers/media/usb/em28xx/em28xx-camera.c
> +++ b/drivers/media/usb/em28xx/em28xx-camera.c
> @@ -22,6 +22,7 @@
>   #include<linux/i2c.h>
>   #include<media/soc_camera.h>
>   #include<media/mt9v011.h>
> +#include<media/v4l2-clk.h>
>   #include<media/v4l2-common.h>
>
>   #include "em28xx.h"
> @@ -325,13 +326,24 @@ int em28xx_detect_sensor(struct em28xx *dev)
>
>   int em28xx_init_camera(struct em28xx *dev)
>   {
> +	char clk_name[V4L2_SUBDEV_NAME_SIZE];
> +	struct i2c_client *client =&dev->i2c_client[dev->def_i2c_bus];
> +	struct i2c_adapter *adap =&dev->i2c_adap[dev->def_i2c_bus];
> +	int ret = 0;
> +
> +	v4l2_clk_name_i2c(clk_name, sizeof(clk_name),
> +			  i2c_adapter_id(adap), client->addr);
> +	dev->clk = v4l2_clk_register_fixed(clk_name, "mclk", -EINVAL);

Or maybe we could also create even more easy to use helper function, e.g.

v4l2_clk_register_i2c_fixed(int adap_id, unsigned int i2c_addr,
				char *clk_name);

Then clk_name (hmm, actually it's the device name ?) would be filled
inside the helper ?

--
Regards,
Sylwester
