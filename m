Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57109 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932073Ab2IMNAt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Sep 2012 09:00:49 -0400
Message-ID: <5051D8DA.1070905@redhat.com>
Date: Thu, 13 Sep 2012 10:00:10 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: javier Martin <javier.martin@vista-silicon.com>
CC: linux-media@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	brijohn@gmail.com, Hans de Goede <hdegoede@redhat.com>
Subject: Re: Improving ov7670 sensor driver.
References: <CACKLOr22AvmWhXmj2SrMGO4y39ESHfyh_HPnLr6nmQGkUv2+zg@mail.gmail.com>
In-Reply-To: <CACKLOr22AvmWhXmj2SrMGO4y39ESHfyh_HPnLr6nmQGkUv2+zg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

I'm not too familiar with soc_camera and ov7670 drivers, so my comments
reflects my understanding of the question, without taking into account
drivers specifics.

Em 13-09-2012 06:48, javier Martin escreveu:
> Hi,
> our new i.MX27 based platform (Visstrim-SM20) uses an ov7675 sensor
> attached to the CSI interface. Apparently, this sensor is fully
> compatible with the old ov7670. For this reason, it seems rather
> sensible that they should share the same driver: ov7670.c
> One of the challenges we have to face is that capture video support
> for our platform is mx2_camera.c, which is a soc-camera host driver;
> while ov7670.c was developed for being used as part of a more complex
> video card.
> 
> Here is the list of current users of ov7670:
> 
> http://lxr.linux.no/#linux+v3.5.3/drivers/media/video/gspca/ov519.c
> http://lxr.linux.no/#linux+v3.5.3/drivers/media/video/gspca/sn9c20x.c
> http://lxr.linux.no/#linux+v3.5.3/drivers/media/video/gspca/vc032x.c
> http://lxr.linux.no/#linux+v3.5.3/drivers/media/video/via-camera.c
> http://lxr.linux.no/#linux+v3.5.3/drivers/media/video/marvell-ccic/mcam-core.c

In order to avoid breakages on those drivers, we need to be sure that
none of the changes will alter the register settings used there.

(C/C Hans de Goede, as he is the gspca maintainer)

> 
> These are basically the improvements we need to make to this driver in
> order to satisfy our needs:
> 
> 1.- Adapt v4l2 controls to the subvevice control framework, with a
> proper ctrl handler, etc...
> 2.- Add the possibility to bypass PLL and clkrc preescaler.
> 3.- Adjust vstart/vstop in order to remove an horizontal green line.
> 4.- Disable pixclk during horizontal blanking.
> 5.- min_height, min_width should be respected in try_fmt().
> 6.- Pass platform data when used with a soc-camera host driver.
> 7.- Add V4L2_CID_POWER_LINE_FREQUENCY ctrl.

Doing one patch per change helps to review the changes individually.
I suspect that it will needed to be tested with the above drivers,
anyway.

> I will try to summarize below why we need to accomplish each of the
> previous tasks and what solution we propose for them:
> 
> 1.- Adapt v4l2 controls to the subvevice control framework, with a
> proper ctrl handler, etc...
> 
> Why? Because soc-camera needs to inherit v4l2 subdevice controls in
> order to expose them to user space.
> How? Something like the following, incomplete, patch:
> 
> ---
> @@ -190,6 +196,7 @@ MODULE_PARM_DESC(debug, "Debug level (0-1)");
>  struct ov7670_format_struct;  /* coming later */
>  struct ov7670_info {
>         struct v4l2_subdev sd;
> +       struct v4l2_ctrl_handler hdl;
>         struct ov7670_format_struct *fmt;  /* Current format */
>         unsigned char sat;              /* Saturation value */
>         int hue;                        /* Hue value */
> 
> 
> @@ -1480,10 +1518,14 @@ static int ov7670_s_register(struct
> v4l2_subdev *sd, struct v4l2_dbg_register *r
> 
>  /* ----------------------------------------------------------------------- */
> 
> +static const struct v4l2_ctrl_ops ov7670_ctrl_ops = {
> +       .s_ctrl = ov7670_s_ctrl,
> +};
> +
>  static const struct v4l2_subdev_core_ops ov7670_core_ops = {
>         .g_chip_ident = ov7670_g_chip_ident,
> -       .g_ctrl = ov7670_g_ctrl,
> -       .s_ctrl = ov7670_s_ctrl,
> +       .g_ctrl = v4l2_subdev_g_ctrl,
> +       .s_ctrl = v4l2_subdev_s_ctrl,
>         .queryctrl = ov7670_queryctrl,
>         .reset = ov7670_reset,
>         .init = ov7670_init,
> 
> @@ -1551,6 +1600,16 @@ static int ov7670_probe(struct i2c_client *client,
>         v4l_info(client, "chip found @ 0x%02x (%s)\n",
>                         client->addr << 1, client->adapter->name);
> 
> +       v4l2_ctrl_handler_init(&info->hdl, 1);
> +       v4l2_ctrl_new_std(&info->hdl, &ov7670_ctrl_ops,
> V4L2_CID_VFLIP, 0, 1, 1, 0);
> ...
> ...
> +       sd->ctrl_handler = &info->hdl;
> +       if (info->hdl.error) {
> +               v4l2_ctrl_handler_free(&info->hdl);
> +               kfree(info);
> +               return info->hdl.error;
> +       }
> +       v4l2_ctrl_handler_setup(&info->hdl);
> +
> ---

Tests are required here, but I don't think this would break anything.
> 
> 2.- Add the possibility to bypass PLL and clkrc preescaler.
> 
> Why? The formula to get the desired frame rate in this chip in YUV is
> the following: fps = fpclk / (2 * 510 * 784) This means that for a
> desired fps = 30 we need fpclk = 24MHz. For that reason we have a
> clean 24MHz xvclk input that comes from an oscillator. If we enable
> the PLL it internally transforms the 24MHz in 22MHz and thus fps is
> not 30 but 27. In order to get 30fps we need to bypass the PLL.
> How? Defining a platform flag 'direct_clk' or similar that allows
> xvclk being used directly as the pixel clock.

As this should be a new platform data, provided that the old behavior
is to use the old formula, this shouldn't break anything.

> 
> 3.- Adjust vstart/vstop in order to remove an horizontal green line.
> 
> Why? Currently, in the driver, for VGA, vstart =  10 and vstop = 490.
>>From our tests we found out that vstart = 14, vstop = 494 in order to
> remove a disgusting horizontal green line in ov7675.
> How? It seems these sensor aren't provided with a version register or
> anything similar so I can't think of a clean solution for this yet.
> Suggestions will be much appreciated.

If it is not possible to differentiate between ov7670 and ov7675, just
add a platform data flag, in order to identify the ov7675

> 4.- Disable pixclk during horizontal blanking.
> 
> Why? Otherwise i.MX27 will capture wrong pixels during blanking periods.
> How? Through a private V4L2 control.

Hmm... I'm assuming that there is a register that controls pixclk disable
during horizontal blanking. In this case, the better is to add support for
it also via platform data.

> 
> 5.- min_height, min_width should be respected in try_fmt().
> Why? Otherwise you are telling the user you are going to use a
> different size than the one you are going to use.
> How? With a patch similar to this:
> 
> ---
> @@ -759,8 +772,10 @@ static int ov7670_try_fmt_internal(struct v4l2_subdev *sd,
>                 struct ov7670_format_struct **ret_fmt,
>                 struct ov7670_win_size **ret_wsize)
>  {
> -       int index;
> +       int index, i;
> +       int win_sizes_limit = N_WIN_SIZES;
>         struct ov7670_win_size *wsize;
> +       struct ov7670_info *info = to_state(sd);
> 
>         for (index = 0; index < N_OV7670_FMTS; index++)
>                 if (ov7670_formats[index].mbus_code == fmt->code)
> @@ -776,15 +791,30 @@ static int ov7670_try_fmt_internal(struct v4l2_subdev *sd,
>          * Fields: the OV devices claim to be progressive.
>          */
>         fmt->field = V4L2_FIELD_NONE;
> +
> +       /*
> +        * Don't consider values that don't match min_height and min_width
> +        * constraints.
> +        */
> +       if (info->min_width || info->min_height)
> +               for (i=0; i < N_WIN_SIZES; i++) {
> +                       wsize = ov7670_win_sizes + i;
> +
> +                       if (wsize->width < info->min_width ||
> +                           wsize->height < info->min_height) {
> +                               win_sizes_limit = i;
> +                               break;
> +                       }
> +               }
>         /*
>          * Round requested image size down to the nearest
>          * we support, but not below the smallest.
>          */
> -       for (wsize = ov7670_win_sizes; wsize < ov7670_win_sizes + N_WIN_SIZES;
> +       for (wsize = ov7670_win_sizes; wsize < ov7670_win_sizes +
> win_sizes_limit;
>              wsize++)
>                 if (fmt->width >= wsize->width && fmt->height >= wsize->height)
>                         break;
> -       if (wsize >= ov7670_win_sizes + N_WIN_SIZES)
> +       if (wsize >= ov7670_win_sizes + win_sizes_limit)
>                 wsize--;   /* Take the smallest one */
>         if (ret_wsize != NULL)
>                 *ret_wsize = wsize;

Of course, patch need to be tested, but that change looks fine on my eyes.

> ---
> 
> 6.- Pass platform data when used with a soc-camera host driver.
> Why? We need to set several platform data like 'min_height',
> 'min_width' and others.
> How? This is an old subject we discussed in January. We agreed that
> some soc-camera core changes were needed, but I couldn't find the time
> and I think nobody else has addressed it either. Please, correct me if
> I am wrong:http://patchwork.linuxtv.org/patch/8860/

Hmm... patch 8860 is related to s_input logic, and not to pass platform data.

For sure passing platform data is needed, as different boards may require
different sensor configurations. If soc_camera doesn't support it yet,
this needs to be added there.

> 
> 7.- Add V4L2_CID_POWER_LINE_FREQUENCY ctrl.
> Why? Because the platform will be used in several countries.
> How? As long as point 1 is solved this is quite trivial.
> 
> 
> The reason of this e-mail is to discuss whether you find these
> solution suitable or not and, more important, whether you think the
> suggested changes could break existing drivers.
> 
> Regards.
> 

Regards,
Mauro

