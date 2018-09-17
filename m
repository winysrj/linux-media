Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:40662 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729429AbeIREWI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Sep 2018 00:22:08 -0400
Received: by mail-it0-f68.google.com with SMTP id h23-v6so551600ita.5
        for <linux-media@vger.kernel.org>; Mon, 17 Sep 2018 15:52:43 -0700 (PDT)
MIME-Version: 1.0
References: <1533712560-17357-1-git-send-email-ping-chung.chen@intel.com> <20180914114131.jqq737k3qug2tdff@paasikivi.fi.intel.com>
In-Reply-To: <20180914114131.jqq737k3qug2tdff@paasikivi.fi.intel.com>
From: Grant Grundler <grundler@chromium.org>
Date: Mon, 17 Sep 2018 15:52:30 -0700
Message-ID: <CANEJEGsP7hYtpEVpJrDSjUML_Xja2kj4+oFb98S2ZXn8C+CLNw@mail.gmail.com>
Subject: Re: [PATCH v5] media: imx208: Add imx208 camera sensor driver
To: sakari.ailus@linux.intel.com
Cc: ping-chung.chen@intel.com, linux-media@vger.kernel.org,
        andy.yeh@intel.com, jim.lai@intel.com, tfiga@chromium.org,
        Grant Grundler <grundler@chromium.org>, rajmohan.mani@intel.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 14, 2018 at 4:41 AM Sakari Ailus
<sakari.ailus@linux.intel.com> wrote:
>
> Hi Ping-chung,
>
> My apologies for the late review.

Yeah...I had the impression this was already accepted. Though it
should be straight forward to fix up additional things as normal
patches.

[sorry pruning heavily]
...
> > +/* HBLANK control - read only */
> > +#define IMX208_PPL_384MHZ            2248
> > +#define IMX208_PPL_96MHZ             2248
>
> Does this generally depend on the link frequency?

This was discussed in earlier patch version: in a nutshell, yes.

...
> > +/* Configurations for supported link frequencies */
> > +#define IMX208_MHZ                   (1000*1000ULL)
> > +#define IMX208_LINK_FREQ_384MHZ              (384ULL * IMX208_MHZ)
> > +#define IMX208_LINK_FREQ_96MHZ               (96ULL * IMX208_MHZ)
>
> You could simply write these as 384000000 and 96000000.

The original code did that. I agree IMX208_MHZ makes this much easier to read.

...
> > +     /* Current mode */
> > +     const struct imx208_mode *cur_mode;
> > +
> > +     /*
> > +      * Mutex for serialized access:
> > +      * Protect sensor set pad format and start/stop streaming safely.
> > +      * Protect access to sensor v4l2 controls.
> > +      */
> > +     struct mutex imx208_mx;
>
> How about calling it simply e.g. a "mutex"? The struct is already specific
> to imx208.

I specifically asked the code not use "mutex" because trying to find
this specific use of "mutex" with cscope (ctags) is impossible.

Defining "mutex" in multiple name spaces is asking for trouble even
though technically it's "safe" to do.

...
> > +static int imx208_set_pad_format(struct v4l2_subdev *sd,
> > +                    struct v4l2_subdev_pad_config *cfg,
> > +                    struct v4l2_subdev_format *fmt)
> > +{
> > +     struct imx208 *imx208 = to_imx208(sd);
> > +     const struct imx208_mode *mode;
> > +     s32 vblank_def;
> > +     s32 vblank_min;
> > +     s64 h_blank;
> > +     s64 pixel_rate;
> > +     s64 link_freq;
> > +
> > +     mutex_lock(&imx208->imx208_mx);
> > +
> > +     fmt->format.code = imx208_get_format_code(imx208);
> > +     mode = v4l2_find_nearest_size(
> > +             supported_modes, ARRAY_SIZE(supported_modes), width, height,
> > +             fmt->format.width, fmt->format.height);
> > +     imx208_mode_to_pad_format(imx208, mode, fmt);
> > +     if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
> > +             *v4l2_subdev_get_try_format(sd, cfg, fmt->pad) = fmt->format;
> > +     } else {
> > +             imx208->cur_mode = mode;
> > +             __v4l2_ctrl_s_ctrl(imx208->link_freq, mode->link_freq_index);
> > +             link_freq = link_freq_menu_items[mode->link_freq_index];
>
> Same as on the imx319 driver --- the link frequencies that are available
> need to reflect what is specified in firmware.

<Someone needs to comment here.>  :)

...
> > +static int imx208_set_stream(struct v4l2_subdev *sd, int enable)
> > +{
> > +     struct imx208 *imx208 = to_imx208(sd);
> > +     struct i2c_client *client = v4l2_get_subdevdata(sd);
> > +     int ret = 0;
> > +
> > +     mutex_lock(&imx208->imx208_mx);
> > +     if (imx208->streaming == enable) {
> > +             mutex_unlock(&imx208->imx208_mx);
> > +             return 0;
> > +     }
> > +
> > +     if (enable) {
> > +             ret = pm_runtime_get_sync(&client->dev);
> > +             if (ret < 0)
> > +                     goto err_rpm_put;
> > +
> > +             /*
> > +              * Apply default & customized values
> > +              * and then start streaming.
> > +              */
> > +             ret = imx208_start_streaming(imx208);
> > +             if (ret)
> > +                     goto err_rpm_put;
> > +     } else {
> > +             imx208_stop_streaming(imx208);
> > +             pm_runtime_put(&client->dev);
> > +     }
> > +
> > +     imx208->streaming = enable;
> > +     mutex_unlock(&imx208->imx208_mx);
> > +
> > +     /* vflip and hflip cannot change during streaming */
> > +     v4l2_ctrl_grab(imx208->vflip, enable);
> > +     v4l2_ctrl_grab(imx208->hflip, enable);
>
> Please grab before releasing the lock; use __v4l2_ctrl_grab() here:
>
> <URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=unlocked-ctrl-grab>

Is the current implementation not correct or is this just the
preferred way to "grab"?

(And thanks for pointing at the patch which adds the new "API")

(and I'm ignoring the remaining nit on the assumption it can be
addressed in the next patch)

cheers,
grant
