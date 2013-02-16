Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qe0-f42.google.com ([209.85.128.42]:63769 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161Ab3BPNUv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Feb 2013 08:20:51 -0500
Received: by mail-qe0-f42.google.com with SMTP id 2so1859955qeb.29
        for <linux-media@vger.kernel.org>; Sat, 16 Feb 2013 05:20:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <054d4fd3b99e30480c6e40d368579bfad2053e5e.1361006882.git.hans.verkuil@cisco.com>
References: <a9599acc7829c431d88b547de87c500968ccb86a.1361006882.git.hans.verkuil@cisco.com>
 <1361006901-16103-1-git-send-email-hverkuil@xs4all.nl> <054d4fd3b99e30480c6e40d368579bfad2053e5e.1361006882.git.hans.verkuil@cisco.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Sat, 16 Feb 2013 18:42:40 +0530
Message-ID: <CA+V-a8t7DDkTQR-d-YBhg2hUJsea=L_ddA2rD+cMMOpzPDg2XQ@mail.gmail.com>
Subject: Re: [RFC PATCH 02/18] tvp7002: use dv_timings structs instead of presets.
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Sat, Feb 16, 2013 at 2:58 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> In the functions tvp7002_mbus_fmt(), tvp7002_log_status and tvp7002_probe()
> we should use the dv_timings data structures instead of dv_preset data
> structures and functions.
>
> This is the second step towards removing the deprecated preset support of this
> driver.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>

Acked-by: Lad, Prabhakar <prabhakar.lad@ti.com>

Regards,
--Prabhakar

> ---
>  drivers/media/i2c/tvp7002.c |   54 ++++++++++++++-----------------------------
>  1 file changed, 17 insertions(+), 37 deletions(-)
>
> diff --git a/drivers/media/i2c/tvp7002.c b/drivers/media/i2c/tvp7002.c
> index 7995eeb..d7a08bc 100644
> --- a/drivers/media/i2c/tvp7002.c
> +++ b/drivers/media/i2c/tvp7002.c
> @@ -677,16 +677,10 @@ static int tvp7002_s_ctrl(struct v4l2_ctrl *ctrl)
>  static int tvp7002_mbus_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *f)
>  {
>         struct tvp7002 *device = to_tvp7002(sd);
> -       struct v4l2_dv_enum_preset e_preset;
> -       int error;
> -
> -       /* Calculate height and width based on current standard */
> -       error = v4l_fill_dv_preset_info(device->current_timings->preset, &e_preset);
> -       if (error)
> -               return error;
> +       const struct v4l2_bt_timings *bt = &device->current_timings->timings.bt;
>
> -       f->width = e_preset.width;
> -       f->height = e_preset.height;
> +       f->width = bt->width;
> +       f->height = bt->height;
>         f->code = V4L2_MBUS_FMT_YUYV10_1X20;
>         f->field = device->current_timings->scanmode;
>         f->colorspace = device->current_timings->color_space;
> @@ -896,35 +890,21 @@ static int tvp7002_s_stream(struct v4l2_subdev *sd, int enable)
>   */
>  static int tvp7002_log_status(struct v4l2_subdev *sd)
>  {
> -       const struct tvp7002_timings_definition *timings = tvp7002_timings;
>         struct tvp7002 *device = to_tvp7002(sd);
> -       struct v4l2_dv_enum_preset e_preset;
> -       struct v4l2_dv_preset detected;
> -       int i;
> +       const struct v4l2_bt_timings *bt;
> +       int detected;
>
> -       detected.preset = V4L2_DV_INVALID;
> -       /* Find my current standard*/
> -       tvp7002_query_dv_preset(sd, &detected);
> +       /* Find my current timings */
> +       tvp7002_query_dv(sd, &detected);
>
> -       /* Print standard related code values */
> -       for (i = 0; i < NUM_TIMINGS; i++, timings++)
> -               if (timings->preset == detected.preset)
> -                       break;
> -
> -       if (v4l_fill_dv_preset_info(device->current_timings->preset, &e_preset))
> -               return -EINVAL;
> -
> -       v4l2_info(sd, "Selected DV Preset: %s\n", e_preset.name);
> -       v4l2_info(sd, "   Pixels per line: %u\n", e_preset.width);
> -       v4l2_info(sd, "   Lines per frame: %u\n\n", e_preset.height);
> -       if (i == NUM_TIMINGS) {
> -               v4l2_info(sd, "Detected DV Preset: None\n");
> +       bt = &device->current_timings->timings.bt;
> +       v4l2_info(sd, "Selected DV Timings: %ux%u\n", bt->width, bt->height);
> +       if (detected == NUM_TIMINGS) {
> +               v4l2_info(sd, "Detected DV Timings: None\n");
>         } else {
> -               if (v4l_fill_dv_preset_info(timings->preset, &e_preset))
> -                       return -EINVAL;
> -               v4l2_info(sd, "Detected DV Preset: %s\n", e_preset.name);
> -               v4l2_info(sd, "  Pixels per line: %u\n", e_preset.width);
> -               v4l2_info(sd, "  Lines per frame: %u\n\n", e_preset.height);
> +               bt = &tvp7002_timings[detected].timings.bt;
> +               v4l2_info(sd, "Detected DV Timings: %ux%u\n",
> +                               bt->width, bt->height);
>         }
>         v4l2_info(sd, "Streaming enabled: %s\n",
>                                         device->streaming ? "yes" : "no");
> @@ -1019,7 +999,7 @@ static int tvp7002_probe(struct i2c_client *c, const struct i2c_device_id *id)
>  {
>         struct v4l2_subdev *sd;
>         struct tvp7002 *device;
> -       struct v4l2_dv_preset preset;
> +       struct v4l2_dv_timings timings;
>         int polarity_a;
>         int polarity_b;
>         u8 revision;
> @@ -1080,8 +1060,8 @@ static int tvp7002_probe(struct i2c_client *c, const struct i2c_device_id *id)
>                 return error;
>
>         /* Set registers according to default video mode */
> -       preset.preset = device->current_timings->preset;
> -       error = tvp7002_s_dv_preset(sd, &preset);
> +       timings = device->current_timings->timings;
> +       error = tvp7002_s_dv_timings(sd, &timings);
>
>         v4l2_ctrl_handler_init(&device->hdl, 1);
>         v4l2_ctrl_new_std(&device->hdl, &tvp7002_ctrl_ops,
> --
> 1.7.10.4
>
