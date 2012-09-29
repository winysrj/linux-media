Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:40563 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964897Ab2I2CWJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Sep 2012 22:22:09 -0400
Received: by lbon3 with SMTP id n3so2585951lbo.19
        for <linux-media@vger.kernel.org>; Fri, 28 Sep 2012 19:22:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1209281420420.5428@axis700.grange>
References: <1345799431-29426-4-git-send-email-agust@denx.de>
 <1348783527-22997-1-git-send-email-agust@denx.de> <Pine.LNX.4.64.1209281413220.5428@axis700.grange>
 <Pine.LNX.4.64.1209281420420.5428@axis700.grange>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Sat, 29 Sep 2012 10:21:48 +0800
Message-ID: <CAMPhdO9-SH_xR0ptt819vv9ztHY-f4ffbZcH9XhJ5CxAXPTu1w@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] mt9v022: set y_skip_top field to zero as default
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Anatolij Gustschin <agust@denx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 28, 2012 at 8:21 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> Hi Eric
>
> On Fri, 28 Sep 2012, Guennadi Liakhovetski wrote:
>
>> Hi Anatolij
>>
>> I can take this patch, but we need an ack from a PXA / ARM maintainer.
>
> Could we have your ack, please?

Yes, this looks completely good to me. Sorry for the delay.

Acked-by: Eric Miao <eric.y.miao@gmail.com>

>
> Thanks
> Guennadi
>
>> On Fri, 28 Sep 2012, Anatolij Gustschin wrote:
>>
>> > Set "y_skip_top" to zero and revise comment as I do not see this line
>> > corruption on two different mt9v022 setups. The first read-out line
>> > is perfectly fine. Add mt9v022 platform data configuring y_skip_top
>> > for platforms that have issues with the first read-out line. Set
>> > y_skip_top to 1 for pcm990 board.
>> >
>> > Signed-off-by: Anatolij Gustschin <agust@denx.de>
>> > ---
>> > Changes since first version:
>> >  - add platform data to mt9v022 with only one parameter to initialise
>> >    y_skip_top, use 0 as default and set it to 1 on pcm990-baseboard.c
>> >  - revise commit log
>> >  - rebase on staging/for_v3.7 branch
>> >
>> >  arch/arm/mach-pxa/pcm990-baseboard.c   |    6 ++++++
>> >  drivers/media/i2c/soc_camera/mt9v022.c |    8 +++++---
>> >  include/media/mt9v022.h                |   16 ++++++++++++++++
>> >  3 files changed, 27 insertions(+), 3 deletions(-)
>> >  create mode 100644 include/media/mt9v022.h
>> >
>> > diff --git a/arch/arm/mach-pxa/pcm990-baseboard.c b/arch/arm/mach-pxa/pcm990-baseboard.c
>> > index cb723e8..e2973f2 100644
>> > --- a/arch/arm/mach-pxa/pcm990-baseboard.c
>> > +++ b/arch/arm/mach-pxa/pcm990-baseboard.c
>> > @@ -26,6 +26,7 @@
>> >  #include <linux/i2c/pxa-i2c.h>
>> >  #include <linux/pwm_backlight.h>
>> >
>> > +#include <media/mt9v022.h>
>> >  #include <media/soc_camera.h>
>> >
>> >  #include <mach/camera.h>
>> > @@ -468,6 +469,10 @@ static struct i2c_board_info __initdata pcm990_i2c_devices[] = {
>> >     },
>> >  };
>> >
>> > +static struct mt9v022_platform_data mt9v022_pdata = {
>> > +   .y_skip_top = 1,
>> > +};
>> > +
>> >  static struct i2c_board_info pcm990_camera_i2c[] = {
>> >     {
>> >             I2C_BOARD_INFO("mt9v022", 0x48),
>> > @@ -480,6 +485,7 @@ static struct soc_camera_link iclink[] = {
>> >     {
>> >             .bus_id                 = 0, /* Must match with the camera ID */
>> >             .board_info             = &pcm990_camera_i2c[0],
>> > +           .priv                   = &mt9v022_pdata,
>> >             .i2c_adapter_id         = 0,
>> >             .query_bus_param        = pcm990_camera_query_bus_param,
>> >             .set_bus_param          = pcm990_camera_set_bus_param,
>> > diff --git a/drivers/media/i2c/soc_camera/mt9v022.c b/drivers/media/i2c/soc_camera/mt9v022.c
>> > index e0f4cb4..8feaddc 100644
>> > --- a/drivers/media/i2c/soc_camera/mt9v022.c
>> > +++ b/drivers/media/i2c/soc_camera/mt9v022.c
>> > @@ -15,6 +15,7 @@
>> >  #include <linux/log2.h>
>> >  #include <linux/module.h>
>> >
>> > +#include <media/mt9v022.h>
>> >  #include <media/soc_camera.h>
>> >  #include <media/soc_mediabus.h>
>> >  #include <media/v4l2-subdev.h>
>> > @@ -849,6 +850,7 @@ static int mt9v022_probe(struct i2c_client *client,
>> >     struct mt9v022 *mt9v022;
>> >     struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
>> >     struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
>> > +   struct mt9v022_platform_data *pdata = icl->priv;
>> >     int ret;
>> >
>> >     if (!icl) {
>> > @@ -912,10 +914,10 @@ static int mt9v022_probe(struct i2c_client *client,
>> >     mt9v022->chip_control = MT9V022_CHIP_CONTROL_DEFAULT;
>> >
>> >     /*
>> > -    * MT9V022 _really_ corrupts the first read out line.
>> > -    * TODO: verify on i.MX31
>> > +    * On some platforms the first read out line is corrupted.
>> > +    * Workaround it by skipping if indicated by platform data.
>> >      */
>> > -   mt9v022->y_skip_top     = 1;
>> > +   mt9v022->y_skip_top     = pdata ? pdata->y_skip_top : 0;
>> >     mt9v022->rect.left      = MT9V022_COLUMN_SKIP;
>> >     mt9v022->rect.top       = MT9V022_ROW_SKIP;
>> >     mt9v022->rect.width     = MT9V022_MAX_WIDTH;
>> > diff --git a/include/media/mt9v022.h b/include/media/mt9v022.h
>> > new file mode 100644
>> > index 0000000..4056180
>> > --- /dev/null
>> > +++ b/include/media/mt9v022.h
>> > @@ -0,0 +1,16 @@
>> > +/*
>> > + * mt9v022 sensor
>> > + *
>> > + * This program is free software; you can redistribute it and/or modify
>> > + * it under the terms of the GNU General Public License version 2 as
>> > + * published by the Free Software Foundation.
>> > + */
>> > +
>> > +#ifndef __MT9V022_H__
>> > +#define __MT9V022_H__
>> > +
>> > +struct mt9v022_platform_data {
>> > +   unsigned short y_skip_top;      /* Lines to skip at the top */
>> > +};
>> > +
>> > +#endif
>> > --
>> > 1.7.1
>> >
>>
>> ---
>> Guennadi Liakhovetski, Ph.D.
>> Freelance Open-Source Software Developer
>> http://www.open-technology.de/
>>
>
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
