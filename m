Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f68.google.com ([209.85.161.68]:38260 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbeISJrf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Sep 2018 05:47:35 -0400
Received: by mail-yw1-f68.google.com with SMTP id n21-v6so1751276ywh.5
        for <linux-media@vger.kernel.org>; Tue, 18 Sep 2018 21:11:36 -0700 (PDT)
Received: from mail-yw1-f49.google.com (mail-yw1-f49.google.com. [209.85.161.49])
        by smtp.gmail.com with ESMTPSA id k130-v6sm5614389ywe.29.2018.09.18.21.11.34
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Sep 2018 21:11:35 -0700 (PDT)
Received: by mail-yw1-f49.google.com with SMTP id j131-v6so1739664ywc.13
        for <linux-media@vger.kernel.org>; Tue, 18 Sep 2018 21:11:34 -0700 (PDT)
MIME-Version: 1.0
References: <1537163872-14567-1-git-send-email-bingbu.cao@intel.com>
In-Reply-To: <1537163872-14567-1-git-send-email-bingbu.cao@intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 19 Sep 2018 13:11:22 +0900
Message-ID: <CAAFQd5Cush43uMPfdp1FKJ+pwB-k573c7XQurbHVbVrKNmRTHA@mail.gmail.com>
Subject: Re: [PATCH v5] media: add imx319 camera sensor driver
To: Cao Bing Bu <bingbu.cao@intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        bingbu.cao@linux.intel.com,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bingbu,

On Mon, Sep 17, 2018 at 2:53 PM <bingbu.cao@intel.com> wrote:
[snip]
> +static int imx319_update_digital_gain(struct imx319 *imx319, u32 d_gain)
> +{
> +       int ret;
> +
> +       ret = imx319_write_reg(imx319, IMX319_REG_DPGA_USE_GLOBAL_GAIN, 1, 1);
> +       if (ret)
> +               return ret;
> +
> +       /* Digital gain = (d_gain & 0xFF00) + (d_gain & 0xFF)/256 times */

What's the unit here?

Is the equation above really correct? The range, besides ~0, would be
from 256.0 to 65280 + 255/256, which sounds strange.

> +       return imx319_write_reg(imx319, IMX319_REG_DIG_GAIN_GLOBAL, 2, d_gain);
> +}
> +
> +static int imx319_set_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +       struct imx319 *imx319 = container_of(ctrl->handler,
> +                                            struct imx319, ctrl_handler);
> +       struct i2c_client *client = v4l2_get_subdevdata(&imx319->sd);
> +       s64 max;
> +       int ret;
> +
> +       /* Propagate change of current control to all related controls */
> +       switch (ctrl->id) {
> +       case V4L2_CID_VBLANK:
> +               /* Update max exposure while meeting expected vblanking */
> +               max = imx319->cur_mode->height + ctrl->val - 18;
> +               __v4l2_ctrl_modify_range(imx319->exposure,
> +                                        imx319->exposure->minimum,
> +                                        max, imx319->exposure->step, max);
> +               break;
> +       }
> +
> +       /*
> +        * Applying V4L2 control value only happens
> +        * when power is up for streaming
> +        */
> +       if (pm_runtime_get_if_in_use(&client->dev) == 0)

nit: if (!pm_runtime_get_if_in_use(&client->dev)

> +               return 0;
> +
[snip]
> +/* Initialize control handlers */
> +static int imx319_init_controls(struct imx319 *imx319)
> +{
> +       struct i2c_client *client = v4l2_get_subdevdata(&imx319->sd);
> +       struct v4l2_ctrl_handler *ctrl_hdlr;
> +       s64 exposure_max;
> +       s64 vblank_def;
> +       s64 vblank_min;
> +       s64 hblank;
> +       s64 pixel_rate;
> +       const struct imx319_mode *mode;
> +       int ret;
> +
> +       ctrl_hdlr = &imx319->ctrl_handler;
> +       ret = v4l2_ctrl_handler_init(ctrl_hdlr, 10);
> +       if (ret)
> +               return ret;
> +
> +       ctrl_hdlr->lock = &imx319->mutex;
> +       imx319->link_freq = v4l2_ctrl_new_int_menu(ctrl_hdlr, &imx319_ctrl_ops,
> +                                                  V4L2_CID_LINK_FREQ, 0, 0,
> +                                                  imx319->pdata->link_freqs);
> +       if (imx319->link_freq)
> +               imx319->link_freq->flags |= V4L2_CTRL_FLAG_READ_ONLY;
> +
> +       /* pixel_rate = link_freq * 2 * nr_of_lanes / bits_per_sample */
> +       pixel_rate = (imx319->link_def_freq * 2 * 4) / 10;
> +       /* By default, PIXEL_RATE is read only */
> +       imx319->pixel_rate = v4l2_ctrl_new_std(ctrl_hdlr, &imx319_ctrl_ops,
> +                                              V4L2_CID_PIXEL_RATE, pixel_rate,
> +                                              pixel_rate, 1, pixel_rate);
> +
> +       /* Initialze vblank/hblank/exposure parameters based on current mode */
> +       mode = imx319->cur_mode;
> +       vblank_def = mode->fll_def - mode->height;
> +       vblank_min = mode->fll_min - mode->height;
> +       imx319->vblank = v4l2_ctrl_new_std(ctrl_hdlr, &imx319_ctrl_ops,
> +                                          V4L2_CID_VBLANK, vblank_min,
> +                                          IMX319_FLL_MAX - mode->height,
> +                                          1, vblank_def);
> +
> +       hblank = mode->llp - mode->width;
> +       imx319->hblank = v4l2_ctrl_new_std(ctrl_hdlr, &imx319_ctrl_ops,
> +                                          V4L2_CID_HBLANK, hblank, hblank,
> +                                          1, hblank);
> +       if (imx319->hblank)
> +               imx319->hblank->flags |= V4L2_CTRL_FLAG_READ_ONLY;
> +
> +       exposure_max = mode->fll_def - 18;
> +       imx319->exposure = v4l2_ctrl_new_std(ctrl_hdlr, &imx319_ctrl_ops,
> +                                            V4L2_CID_EXPOSURE,
> +                                            IMX319_EXPOSURE_MIN, exposure_max,
> +                                            IMX319_EXPOSURE_STEP,
> +                                            IMX319_EXPOSURE_DEFAULT);

Please explain how to interpret the exposure value in a comment.

> +
> +       imx319->hflip = v4l2_ctrl_new_std(ctrl_hdlr, &imx319_ctrl_ops,
> +                                         V4L2_CID_HFLIP, 0, 1, 1, 0);
> +       imx319->vflip = v4l2_ctrl_new_std(ctrl_hdlr, &imx319_ctrl_ops,
> +                                         V4L2_CID_VFLIP, 0, 1, 1, 0);
> +
> +       v4l2_ctrl_new_std(ctrl_hdlr, &imx319_ctrl_ops, V4L2_CID_ANALOGUE_GAIN,
> +                         IMX319_ANA_GAIN_MIN, IMX319_ANA_GAIN_MAX,
> +                         IMX319_ANA_GAIN_STEP, IMX319_ANA_GAIN_DEFAULT);

Please explain how the gain value and in what units is calculated in a comment.

> +
> +       /* Digital gain */
> +       v4l2_ctrl_new_std(ctrl_hdlr, &imx319_ctrl_ops, V4L2_CID_DIGITAL_GAIN,
> +                         IMX319_DGTL_GAIN_MIN, IMX319_DGTL_GAIN_MAX,
> +                         IMX319_DGTL_GAIN_STEP, IMX319_DGTL_GAIN_DEFAULT);
> +

Please explain how the gain value and in what units is calculated in
the comment.

Best regards,
Tomasz
