Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34572 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab1CSNhL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Mar 2011 09:37:11 -0400
Received: by wwa36 with SMTP id 36so5855041wwa.1
        for <linux-media@vger.kernel.org>; Sat, 19 Mar 2011 06:37:10 -0700 (PDT)
Message-ID: <4D84B183.7020709@gmail.com>
Date: Sat, 19 Mar 2011 14:37:07 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: "Kim, Heungjun" <riverful.kim@samsung.com>
CC: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] Add support for M-5MOLS 8 Mega Pixel camera
References: <1300282723-31536-1-git-send-email-riverful.kim@samsung.com>
In-Reply-To: <1300282723-31536-1-git-send-email-riverful.kim@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi HeungJun,

On 03/16/2011 02:38 PM, Kim, Heungjun wrote:
> Add I2C/V4L2 subdev driver for M-5MOLS camera sensor with integrated
> image signal processor.
> 
> Signed-off-by: Heungjun Kim<riverful.kim@samsung.com>
> Signed-off-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
> ---
> 
> Hi Hans and everyone,
> 
> This is sixth version of M-5MOLS 8 Mega Pixel camera sensor. And, if you see

Would be good to indicate the version in the subject too.

> previous version, you can find at:
> http://www.spinics.net/lists/linux-media/msg29350.html
> 
> This driver patch is fixed several times, and the important issues is almost
> corrected. And, I hope that this is the last version one merged for 2.6.39.
> I look forward to be reviewed one more time.
> 
> The summary of this version's feature is belows:
> 
> 1. Add focus control
> 	: I've suggest menu type focus control, but I agreed this version is
> 	not yet the level accepted. So, I did not use focus control which
> 	I suggest.
> 	The M-5MOLS focus routine takes some time to execute. But, the user
> 	application calling v4l2 control, should not hanged while streaming
> 	using q/dqbuf. So, I use workqueue. I want to discuss the focus
> 	subject on mailnglist next time.
> 
> 2. Add irq routine
> 	: M-5MOLS can issues using GPIO pin, and I insert the basic routine
> 	of irq. This version handles only the Auto focus interrupt source.
> 	It shows only lens focusing status, don't any action now.
> 
> 3. Speed-up whole I2C operation
> 	: I've tested several times for decreasing the stabilization time
> 	while I2C communication, and I have find proper time. Of course,
> 	it's more faster than previous version.

That sounds good. Do you think the delays before I2C read/write could
be avoided in some (if not all) cases by using some status registers
polling?

> 
> 4. Let streamon() be called once at the streamming
> 	: It might be an issue, videobuf2 framework calls streamon when
> 	qbuf() for enqueueing. It means, the driver's streamon() function

No, that's not really the case. At last videobuf2 buf_queue op might be
called in response to VIDIOC_STREAMON. Certainly there must be some bug
in the host driver if subdev's s_stream is being called repeatedly.

> 	might be callled continuously if there is no proper handling in the
> 	subdev driver, and low the framerate by adding unneeded I2C operation.
> 	The M-5MOLS sensor needs command one time for streaming. If commands
> 	once, this sensor streams continuously, and this version handles it.
> 
> 5. Update FW
> 	: It's a little tricky. Originally, the v4l2 frame provide load_fw(),
> 	but, there is the occasion which should do in openning the videonode,
> 	and it's the same occasion with us. So, if it's not wrong or it makes
> 	any problem, we hope to insert m5mols_update_fw() with weak attribute.
> 	And, I'm sorry that the fw updating code is confidential. unserstand
> 	by favor, plz.
> 
> And, as always, this driver is tested on s5pc210 board using s5p-fimc driver.
> 
> I'll wait for reviewing.
> 
> Thanks and Regards,
> 	Heungjun Kim
> 	Samsung Electronics DMC R&D Center
> 
>   drivers/media/video/Kconfig                  |    2 +
>   drivers/media/video/Makefile                 |    1 +
>   drivers/media/video/m5mols/Kconfig           |    5 +
>   drivers/media/video/m5mols/Makefile          |    3 +
>   drivers/media/video/m5mols/m5mols.h          |  251 ++++++
>   drivers/media/video/m5mols/m5mols_controls.c |  213 +++++
>   drivers/media/video/m5mols/m5mols_core.c     | 1062 ++++++++++++++++++++++++++
>   drivers/media/video/m5mols/m5mols_reg.h      |  218 ++++++
>   include/media/m5mols.h                       |   35 +
>   9 files changed, 1790 insertions(+), 0 deletions(-)
>   create mode 100644 drivers/media/video/m5mols/Kconfig
>   create mode 100644 drivers/media/video/m5mols/Makefile
>   create mode 100644 drivers/media/video/m5mols/m5mols.h
>   create mode 100644 drivers/media/video/m5mols/m5mols_controls.c
>   create mode 100644 drivers/media/video/m5mols/m5mols_core.c
>   create mode 100644 drivers/media/video/m5mols/m5mols_reg.h
>   create mode 100644 include/media/m5mols.h
> 
...
> diff --git a/drivers/media/video/m5mols/m5mols_controls.c b/drivers/media/video/m5mols/m5mols_controls.c
> new file mode 100644
> index 0000000..784b764
> --- /dev/null
> +++ b/drivers/media/video/m5mols/m5mols_controls.c
> @@ -0,0 +1,213 @@
> +/*
> + * Controls for M-5MOLS 8M Pixel camera sensor with ISP
> + *
> + * Copyright (C) 2011 Samsung Electronics Co., Ltd
> + * Author: HeungJun Kim, riverful.kim@samsung.com
> + *
> + * Copyright (C) 2009 Samsung Electronics Co., Ltd
> + * Author: Dongsoo Nathaniel Kim, dongsoo45.kim@samsung.com
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#include<linux/i2c.h>
> +#include<linux/delay.h>
> +#include<linux/videodev2.h>
> +#include<media/v4l2-ctrls.h>
> +
> +#include "m5mols.h"
> +#include "m5mols_reg.h"
> +
> +/* The externing camera control functions */


> +int m5mols_lock_ae(struct m5mols_info *info, bool lock)
> +{
> +	struct v4l2_subdev *sd =&info->sd;
> +
> +	return i2c_w8_ae(sd, CAT3_AE_LOCK, !!(info->lock_ae = lock));

Shouldn't be info->lock_ae assigned a new value only in case I2C write
succeeds?

> +}
> +
> +int m5mols_lock_awb(struct m5mols_info *info, bool lock)
> +{
> +	struct v4l2_subdev *sd =&info->sd;
> +
> +	info->lock_awb = lock;
> +
> +	return i2c_w8_wb(sd, CAT6_AWB_LOCK, !!(info->lock_awb = lock));

Ditto.

> +/*
> + * m5mols_sensor_armboot() - booting M-5MOLS internal ARM core-controller.
> + *
> + * It makes to ready M-5MOLS for I2C&  MIPI interface. After it's powered up,
> + * it activates if it gets armboot command for I2C interface. After getting
> + * cmd, it must wait about least 520ms referenced by M-5MOLS datasheet.
> + */
> +static int m5mols_sensor_armboot(struct v4l2_subdev *sd)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	u32 reg;
> +	int ret;
> +
> +	/* ARM(M-5MOLS core) booting */
> +	ret = i2c_w8_flash(sd, CATF_CAM_START, true);
> +	if (ret<  0)
> +		return ret;
> +
> +	msleep(520);

Don't you consider using a waitqueue and a relevant interrupt
generated by the ISP when it has completed booting?
This would allow to decrease the delay to an optimal minimum.

--
Regards,
Sylwester Nawrocki
