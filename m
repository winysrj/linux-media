Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:36728 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751516AbdHGHL1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 Aug 2017 03:11:27 -0400
MIME-Version: 1.0
In-Reply-To: <1500950041-5449-1-git-send-email-jacob-chen@iotwrt.com>
References: <1500950041-5449-1-git-send-email-jacob-chen@iotwrt.com>
From: Jacob Chen <jacobchen110@gmail.com>
Date: Mon, 7 Aug 2017 15:11:25 +0800
Message-ID: <CAFLEztQHYWAk39+gQCD0XkKPVqmUY5kPZydWgw8+zu53+D2_pA@mail.gmail.com>
Subject: Re: [PATCH] media: i2c: OV5647: gate clock lane before stream on
To: "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>
Cc: linux-kernel@vger.kernel.org, roliveir@synopsys.com,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        vladimir_zapolskiy@mentor.com,
        Hans Verkuil <hans.verkuil@cisco.com>,
        sakari.ailus@linux.intel.com, Jacob Chen <jacob-chen@iotwrt.com>,
        p.zabel@pengutronix.de, slongerbeam@gmail.com, robh+dt@kernel.org,
        lolivei@synopsys.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

2017-07-25 10:34 GMT+08:00 Jacob Chen <jacob-chen@iotwrt.com>:
> According to datasheet, BIT5 in reg-0x4800 are used to
> enable/disable clock lane gate.
>
> It's wrong to make clock lane free running before
> sensor stream on was called, while the mipi phy
> are not initialized.
>
> Signed-off-by: Jacob Chen <jacob-chen@iotwrt.com>
> ---
>  drivers/media/i2c/ov5647.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/i2c/ov5647.c b/drivers/media/i2c/ov5647.c
> index 95ce90f..d3e6fd0 100644
> --- a/drivers/media/i2c/ov5647.c
> +++ b/drivers/media/i2c/ov5647.c
> @@ -253,6 +253,10 @@ static int ov5647_stream_on(struct v4l2_subdev *sd)
>  {
>         int ret;
>
> +       ret = ov5647_write(sd, 0x4800, 0x04);
> +       if (ret < 0)
> +               return ret;
> +
>         ret = ov5647_write(sd, 0x4202, 0x00);
>         if (ret < 0)
>                 return ret;
> @@ -264,6 +268,10 @@ static int ov5647_stream_off(struct v4l2_subdev *sd)
>  {
>         int ret;
>
> +       ret = ov5647_write(sd, 0x4800, 0x25);
> +       if (ret < 0)
> +               return ret;
> +
>         ret = ov5647_write(sd, 0x4202, 0x0f);
>         if (ret < 0)
>                 return ret;
> @@ -320,7 +328,7 @@ static int __sensor_init(struct v4l2_subdev *sd)
>                         return ret;
>         }
>
> -       return ov5647_write(sd, 0x4800, 0x04);
> +       return ov5647_stream_off(sd);
>  }
>
>  static int ov5647_sensor_power(struct v4l2_subdev *sd, int on)
> --
> 2.7.4
>

Can anyone comment on it?

I saw there is a same discussion in  https://patchwork.kernel.org/patch/9569031/
There is a comment in i.MX CSI2 driver.
"
Configure MIPI Camera Sensor to put all Tx lanes in LP-11 state.
This must be carried out by the MIPI sensor's s_power(ON) subdev
op.
"
That's what this patch do, sensor driver should make sure that clock
lanes are in stop state while not streaming.
