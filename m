Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f196.google.com ([209.85.217.196]:34657 "EHLO
        mail-ua0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751298AbeCLHcy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Mar 2018 03:32:54 -0400
Received: by mail-ua0-f196.google.com with SMTP id m43so6150527uah.1
        for <linux-media@vger.kernel.org>; Mon, 12 Mar 2018 00:32:54 -0700 (PDT)
Received: from mail-ua0-f169.google.com (mail-ua0-f169.google.com. [209.85.217.169])
        by smtp.gmail.com with ESMTPSA id m33sm3832293uai.42.2018.03.12.00.32.52
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Mar 2018 00:32:52 -0700 (PDT)
Received: by mail-ua0-f169.google.com with SMTP id c40so6142179uae.2
        for <linux-media@vger.kernel.org>; Mon, 12 Mar 2018 00:32:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1520784098-5593-1-git-send-email-andy.yeh@intel.com>
References: <1520784098-5593-1-git-send-email-andy.yeh@intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Mon, 12 Mar 2018 16:32:31 +0900
Message-ID: <CAAFQd5DmRi20duX2TR1=OjnScP_sNH1z1JH7HmU1=DqyFpRyUA@mail.gmail.com>
Subject: Re: [PATCH v7] media: imx258: Add imx258 camera sensor driver
To: Andy Yeh <andy.yeh@intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Chen, JasonX Z" <jasonx.z.chen@intel.com>,
        Alan Chiang <alanx.chiang@intel.com>,
        "Lai, Jim" <jim.lai@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

On Mon, Mar 12, 2018 at 1:01 AM, Andy Yeh <andy.yeh@intel.com> wrote:
> Add a V4L2 sub-device driver for the Sony IMX258 image sensor.
> This is a camera sensor using the I2C bus for control and the
> CSI-2 bus for data.
>
> Signed-off-by: Jason Chen <jasonx.z.chen@intel.com>
> Signed-off-by: Alan Chiang <alanx.chiang@intel.com>
> ---
> since v2:
> -- Update the streaming function to remove SW_STANDBY in the beginning.
> -- Adjust the delay time from 1ms to 12ms before set stream-on register.
> since v3:
> -- fix the sd.entity to make code be compiled on the mainline kernel.
> since v4:
> -- Enabled AG, DG, and Exposure time control correctly.
> since v5:
> -- Sensor vendor provided a new setting to fix different CLK issue
> -- Add one more resolution for 1048x780, used for VGA streaming
> since v6:
> -- improved i2c read/write function to support writing 2 registers
> -- modified i2c reg read/write function with a more portable way
> -- utilized v4l2_find_nearest_size instead of the local find_best_fit function
> -- defined an enum for the link freq entries for explicit indexing

Thanks for the patch. Looks almost good now. Just two new comments inline.

[snip]
> +       /* Set Orientation be 180 degree */
> +       ret = imx258_write_reg(imx258, REG_MIRROR_FLIP_CONTROL,
> +                               IMX258_REG_VALUE_08BIT, REG_CONFIG_MIRROR_FLIP);
> +       if (ret) {
> +               dev_err(&client->dev, "%s failed to set orientation\n",
> +                       __func__);
> +               return ret;
> +       }
> +
> +       /* Apply customized values from user */
> +       ret =  __v4l2_ctrl_handler_setup(imx258->sd.ctrl_handler);
> +       if (ret)
> +               return ret;
> +
> +       /*
> +        * Per sensor datasheet:
> +        * These are the minimum 12ms delays for accessing the sensor through
> +        * I2C and enabling streaming after lifting the device from reset.
> +        */
> +       usleep_range(12000, 13000);

Hmm, the code above already accesses the sensor through I2C. If this
works, is this sleep perhaps already done by ACPI code or it is only
needed for streaming?

[snip]
> +/* Initialize control handlers */
> +static int imx258_init_controls(struct imx258 *imx258)
> +{
> +       struct i2c_client *client = v4l2_get_subdevdata(&imx258->sd);
> +       struct v4l2_ctrl_handler *ctrl_hdlr;
> +       s64 exposure_max;
> +       s64 vblank_def;
> +       s64 vblank_min;
> +       s64 pixel_rate_min;
> +       s64 pixel_rate_max;
> +       int ret;
> +
> +       ctrl_hdlr = &imx258->ctrl_handler;
> +       ret = v4l2_ctrl_handler_init(ctrl_hdlr, 8);
> +       if (ret)
> +               return ret;
> +
> +       mutex_init(&imx258->mutex);
> +       ctrl_hdlr->lock = &imx258->mutex;
> +       imx258->link_freq = v4l2_ctrl_new_int_menu(ctrl_hdlr,
> +                               &imx258_ctrl_ops,
> +                               V4L2_CID_LINK_FREQ,
> +                               ARRAY_SIZE(link_freq_menu_items) - 1,
> +                               0,
> +                               link_freq_menu_items);
> +
> +       if (!imx258->link_freq) {
> +               ret = -EINVAL;
> +               goto error;
> +       }
> +
> +       imx258->link_freq->flags |= V4L2_CTRL_FLAG_READ_ONLY;

nit: As discussed earlier with Sakari, I think we agreed on making
this, and other controls that need dereferencing here, as follows:

        imx258->link_freq = v4l2_ctrl_new_int_menu(ctrl_hdlr,
                                &imx258_ctrl_ops,
                                V4L2_CID_LINK_FREQ,
                                ARRAY_SIZE(link_freq_menu_items) - 1,
                                0,
                                link_freq_menu_items);
        if (imx258->link_freq)
                imx258->link_freq->flags |= V4L2_CTRL_FLAG_READ_ONLY;

The error will be reported at the end of this function, through the
check for ctrl_hdlr->error.

Best regards,
Tomasz
