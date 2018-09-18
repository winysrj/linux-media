Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga12.intel.com ([192.55.52.136]:53035 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727228AbeIRQ3i (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Sep 2018 12:29:38 -0400
Date: Tue, 18 Sep 2018 13:52:59 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Grant Grundler <grundler@chromium.org>
Cc: ping-chung.chen@intel.com, linux-media@vger.kernel.org,
        andy.yeh@intel.com, jim.lai@intel.com, tfiga@chromium.org,
        rajmohan.mani@intel.com
Subject: Re: [PATCH v5] media: imx208: Add imx208 camera sensor driver
Message-ID: <20180918105258.vmnfkenpzlieycxq@paasikivi.fi.intel.com>
References: <1533712560-17357-1-git-send-email-ping-chung.chen@intel.com>
 <20180914114131.jqq737k3qug2tdff@paasikivi.fi.intel.com>
 <CANEJEGsP7hYtpEVpJrDSjUML_Xja2kj4+oFb98S2ZXn8C+CLNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANEJEGsP7hYtpEVpJrDSjUML_Xja2kj4+oFb98S2ZXn8C+CLNw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Grant,

On Mon, Sep 17, 2018 at 03:52:30PM -0700, Grant Grundler wrote:
> On Fri, Sep 14, 2018 at 4:41 AM Sakari Ailus
> <sakari.ailus@linux.intel.com> wrote:
> >
> > Hi Ping-chung,
> >
> > My apologies for the late review.
> 
> Yeah...I had the impression this was already accepted. Though it
> should be straight forward to fix up additional things as normal
> patches.

The remaining issues are rather small and there's still time to get the
driver to v4.20, so I see no need to postpone these either.

> 
> [sorry pruning heavily]
> ...
> > > +/* HBLANK control - read only */
> > > +#define IMX208_PPL_384MHZ            2248
> > > +#define IMX208_PPL_96MHZ             2248
> >
> > Does this generally depend on the link frequency?
> 
> This was discussed in earlier patch version: in a nutshell, yes.
> 
> ...
> > > +/* Configurations for supported link frequencies */
> > > +#define IMX208_MHZ                   (1000*1000ULL)
> > > +#define IMX208_LINK_FREQ_384MHZ              (384ULL * IMX208_MHZ)
> > > +#define IMX208_LINK_FREQ_96MHZ               (96ULL * IMX208_MHZ)
> >
> > You could simply write these as 384000000 and 96000000.
> 
> The original code did that. I agree IMX208_MHZ makes this much easier to read.

It is not customary to add driver specific defines for that sort of things;
mostly if you need a plain number you do write a plain number. A sort of an
exception are the SZ_* macros.

The above breaks grep, too.

> 
> ...
> > > +     /* Current mode */
> > > +     const struct imx208_mode *cur_mode;
> > > +
> > > +     /*
> > > +      * Mutex for serialized access:
> > > +      * Protect sensor set pad format and start/stop streaming safely.
> > > +      * Protect access to sensor v4l2 controls.
> > > +      */
> > > +     struct mutex imx208_mx;
> >
> > How about calling it simply e.g. a "mutex"? The struct is already specific
> > to imx208.
> 
> I specifically asked the code not use "mutex" because trying to find
> this specific use of "mutex" with cscope (ctags) is impossible.

The mutex is local to the driver, and in this case also to the file.
Mutexes are commonly called either "mutex" or "lock".

> 
> Defining "mutex" in multiple name spaces is asking for trouble even
> though technically it's "safe" to do.
> 
> ...
> > > +static int imx208_set_pad_format(struct v4l2_subdev *sd,
> > > +                    struct v4l2_subdev_pad_config *cfg,
> > > +                    struct v4l2_subdev_format *fmt)
> > > +{
> > > +     struct imx208 *imx208 = to_imx208(sd);
> > > +     const struct imx208_mode *mode;
> > > +     s32 vblank_def;
> > > +     s32 vblank_min;
> > > +     s64 h_blank;
> > > +     s64 pixel_rate;
> > > +     s64 link_freq;
> > > +
> > > +     mutex_lock(&imx208->imx208_mx);
> > > +
> > > +     fmt->format.code = imx208_get_format_code(imx208);
> > > +     mode = v4l2_find_nearest_size(
> > > +             supported_modes, ARRAY_SIZE(supported_modes), width, height,
> > > +             fmt->format.width, fmt->format.height);
> > > +     imx208_mode_to_pad_format(imx208, mode, fmt);
> > > +     if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
> > > +             *v4l2_subdev_get_try_format(sd, cfg, fmt->pad) = fmt->format;
> > > +     } else {
> > > +             imx208->cur_mode = mode;
> > > +             __v4l2_ctrl_s_ctrl(imx208->link_freq, mode->link_freq_index);
> > > +             link_freq = link_freq_menu_items[mode->link_freq_index];
> >
> > Same as on the imx319 driver --- the link frequencies that are available
> > need to reflect what is specified in firmware.
> 
> <Someone needs to comment here.>  :)
> 
> ...
> > > +static int imx208_set_stream(struct v4l2_subdev *sd, int enable)
> > > +{
> > > +     struct imx208 *imx208 = to_imx208(sd);
> > > +     struct i2c_client *client = v4l2_get_subdevdata(sd);
> > > +     int ret = 0;
> > > +
> > > +     mutex_lock(&imx208->imx208_mx);
> > > +     if (imx208->streaming == enable) {
> > > +             mutex_unlock(&imx208->imx208_mx);
> > > +             return 0;
> > > +     }
> > > +
> > > +     if (enable) {
> > > +             ret = pm_runtime_get_sync(&client->dev);
> > > +             if (ret < 0)
> > > +                     goto err_rpm_put;
> > > +
> > > +             /*
> > > +              * Apply default & customized values
> > > +              * and then start streaming.
> > > +              */
> > > +             ret = imx208_start_streaming(imx208);
> > > +             if (ret)
> > > +                     goto err_rpm_put;
> > > +     } else {
> > > +             imx208_stop_streaming(imx208);
> > > +             pm_runtime_put(&client->dev);
> > > +     }
> > > +
> > > +     imx208->streaming = enable;
> > > +     mutex_unlock(&imx208->imx208_mx);
> > > +
> > > +     /* vflip and hflip cannot change during streaming */
> > > +     v4l2_ctrl_grab(imx208->vflip, enable);
> > > +     v4l2_ctrl_grab(imx208->hflip, enable);
> >
> > Please grab before releasing the lock; use __v4l2_ctrl_grab() here:
> >
> > <URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=unlocked-ctrl-grab>
> 
> Is the current implementation not correct or is this just the
> preferred way to "grab"?

The problem with the above is that the controls have not been grabbed
before the lock is released, therefore allowing them to be changed just
after starting streaming.

> (And thanks for pointing at the patch which adds the new "API")
> 
> (and I'm ignoring the remaining nit on the assumption it can be
> addressed in the next patch)

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
