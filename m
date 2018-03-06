Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f45.google.com ([209.85.213.45]:32809 "EHLO
        mail-vk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750801AbeCFIwA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Mar 2018 03:52:00 -0500
Received: by mail-vk0-f45.google.com with SMTP id z130so11802521vkd.0
        for <linux-media@vger.kernel.org>; Tue, 06 Mar 2018 00:52:00 -0800 (PST)
Received: from mail-ua0-f182.google.com (mail-ua0-f182.google.com. [209.85.217.182])
        by smtp.gmail.com with ESMTPSA id b125sm9209047vkd.39.2018.03.06.00.51.57
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Mar 2018 00:51:58 -0800 (PST)
Received: by mail-ua0-f182.google.com with SMTP id c14so12485401uak.7
        for <linux-media@vger.kernel.org>; Tue, 06 Mar 2018 00:51:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180306084045.gabhdrsjks5m7htq@paasikivi.fi.intel.com>
References: <1520002549-6564-1-git-send-email-andy.yeh@intel.com>
 <CAAFQd5D1a1Wd0ns85rkg8cJwK+y9uYzaS=c46efOniuGhvFk+w@mail.gmail.com> <20180306084045.gabhdrsjks5m7htq@paasikivi.fi.intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Tue, 6 Mar 2018 17:51:36 +0900
Message-ID: <CAAFQd5AhfZRKM3sjO3vtbmfOV4RHSEL_AM8AS3FLZdYySiZhPg@mail.gmail.com>
Subject: Re: [PATCH v6] media: imx258: Add imx258 camera sensor driver
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Andy Yeh <andy.yeh@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "Chen, JasonX Z" <jasonx.z.chen@intel.com>,
        Alan Chiang <alanx.chiang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 6, 2018 at 5:40 PM, Sakari Ailus
<sakari.ailus@linux.intel.com> wrote:
> Hi Tomasz and Andy,
>
> On Sat, Mar 03, 2018 at 12:43:59AM +0900, Tomasz Figa wrote:
> ...
>> > +static int imx258_set_ctrl(struct v4l2_ctrl *ctrl)
>> > +{
>> > +       struct imx258 *imx258 =
>> > +               container_of(ctrl->handler, struct imx258, ctrl_handler);
>> > +       struct i2c_client *client = v4l2_get_subdevdata(&imx258->sd);
>> > +       int ret = 0;
>> > +       /*
>> > +        * Applying V4L2 control value only happens
>> > +        * when power is up for streaming
>> > +        */
>> > +       if (pm_runtime_get_if_in_use(&client->dev) <= 0)
>> > +               return 0;
>>
>> I thought we decided to fix this to handle disabled runtime PM properly.
>
> Good point. I bet this is a problem in a few other drivers, too. How would
> you fix that? Check for zero only?
>

bool need_runtime_put;

ret = pm_runtime_get_if_in_use(&client->dev);
if (ret <= 0 && ret != -EINVAL)
        return ret;
need_runtime_put = ret > 0;

// Do stuff ...

if (need_runtime_put)
       pm_runtime_put(&client->dev);

I don't like how ugly it is, but it appears to be the only way to
handle this correctly.

> ...
>
>> [snip]
>> > +/* Initialize control handlers */
>> > +static int imx258_init_controls(struct imx258 *imx258)
>> > +{
>> > +       struct i2c_client *client = v4l2_get_subdevdata(&imx258->sd);
>> > +       struct v4l2_ctrl_handler *ctrl_hdlr;
>> > +       s64 exposure_max;
>> > +       s64 vblank_def;
>> > +       s64 vblank_min;
>> > +       s64 pixel_rate_min;
>> > +       s64 pixel_rate_max;
>> > +       int ret;
>> > +
>> > +       ctrl_hdlr = &imx258->ctrl_handler;
>> > +       ret = v4l2_ctrl_handler_init(ctrl_hdlr, 8);
>> > +       if (ret)
>>
>> Missing error message.
>>
>> > +               return ret;
>> > +
>> > +       mutex_init(&imx258->mutex);
>> > +       ctrl_hdlr->lock = &imx258->mutex;
>> > +       imx258->link_freq = v4l2_ctrl_new_int_menu(ctrl_hdlr,
>> > +                               &imx258_ctrl_ops,
>> > +                               V4L2_CID_LINK_FREQ,
>> > +                               ARRAY_SIZE(link_freq_menu_items) - 1,
>> > +                               0,
>> > +                               link_freq_menu_items);
>> > +
>> > +       if (!imx258->link_freq) {
>> > +               ret = -EINVAL;
>>
>> Missing error message.
>
> I wouldn't add an error message here. Typically you'd need that information
> at development time only, never after that. v4l2_ctrl_new_int_menu(), as
> other control framework functions creating new controls, can fail due to
> memory allocation failure (which is already vocally reported) or due to bad
> parameters (that are constants).
>
> I'd rather do:
>
> if (!imx258->link_freq)
>         ... |= ...;
>
> It simplifies error handling and removes the need for goto.

Hmm, I'm not sure I understand your suggestion. Do you perhaps mean

if (imx258->link_freq) {
        // Do stuff that dereferences imx258->link_freq
}

// ...

if (ctrl_hdlr->error) {
        // Check for error only here, at the end of control initialization.
}

then it would be better indeed.

>
>>
>> > +               goto error;
>> > +       }
>> > +
>> > +       imx258->link_freq->flags |= V4L2_CTRL_FLAG_READ_ONLY;
>> > +
>> > +       pixel_rate_max = link_freq_to_pixel_rate(link_freq_menu_items[0]);
>> > +       pixel_rate_min = link_freq_to_pixel_rate(link_freq_menu_items[1]);
>> > +       /* By default, PIXEL_RATE is read only */
>> > +       imx258->pixel_rate = v4l2_ctrl_new_std(ctrl_hdlr, &imx258_ctrl_ops,
>> > +                                       V4L2_CID_PIXEL_RATE,
>> > +                                       pixel_rate_min, pixel_rate_max,
>> > +                                       1, pixel_rate_max);
>> > +
>> > +
>> > +       vblank_def = imx258->cur_mode->vts_def - imx258->cur_mode->height;
>> > +       vblank_min = imx258->cur_mode->vts_min - imx258->cur_mode->height;
>> > +       imx258->vblank = v4l2_ctrl_new_std(
>> > +                               ctrl_hdlr, &imx258_ctrl_ops, V4L2_CID_VBLANK,
>> > +                               vblank_min,
>> > +                               IMX258_VTS_MAX - imx258->cur_mode->height, 1,
>> > +                               vblank_def);
>> > +
>> > +       imx258->hblank = v4l2_ctrl_new_std(
>> > +                               ctrl_hdlr, &imx258_ctrl_ops, V4L2_CID_HBLANK,
>> > +                               IMX258_PPL_650MHZ - imx258->cur_mode->width,
>> > +                               IMX258_PPL_650MHZ - imx258->cur_mode->width,
>> > +                               1,
>> > +                               IMX258_PPL_650MHZ - imx258->cur_mode->width);
>> > +
>> > +       if (!imx258->hblank) {
>> > +               ret = -EINVAL;
>> > +               goto error;
>> > +       }
>>
>> Why checking hblank, but not other controls? I think in this case just
>> the general check for ctrl_hdlr->error should be enough.
>
> There's no need to access most other controls (except blank and link_freq).
> The flags field is set for hblank below, therefore the check.

Ah, right, I missed the dereference.

>
>>
>> > +
>> > +       imx258->hblank->flags |= V4L2_CTRL_FLAG_READ_ONLY;
>> > +
>> > +       exposure_max = imx258->cur_mode->vts_def - 8;
>> > +       imx258->exposure = v4l2_ctrl_new_std(
>> > +                               ctrl_hdlr, &imx258_ctrl_ops,
>> > +                               V4L2_CID_EXPOSURE, IMX258_EXPOSURE_MIN,
>> > +                               IMX258_EXPOSURE_MAX, IMX258_EXPOSURE_STEP,
>> > +                               IMX258_EXPOSURE_DEFAULT);
>> > +
>> > +       v4l2_ctrl_new_std(ctrl_hdlr, &imx258_ctrl_ops, V4L2_CID_ANALOGUE_GAIN,
>> > +                               IMX258_ANA_GAIN_MIN, IMX258_ANA_GAIN_MAX,
>> > +                               IMX258_ANA_GAIN_STEP, IMX258_ANA_GAIN_DEFAULT);
>> > +
>> > +       v4l2_ctrl_new_std(ctrl_hdlr, &imx258_ctrl_ops, V4L2_CID_DIGITAL_GAIN,
>> > +                               IMX258_DGTL_GAIN_MIN, IMX258_DGTL_GAIN_MAX,
>> > +                               IMX258_DGTL_GAIN_STEP, IMX258_DGTL_GAIN_DEFAULT);
>> > +
>> > +       v4l2_ctrl_new_std_menu_items(ctrl_hdlr, &imx258_ctrl_ops,
>> > +                                    V4L2_CID_TEST_PATTERN,
>> > +                                    ARRAY_SIZE(imx258_test_pattern_menu) - 1,
>> > +                                    0, 0, imx258_test_pattern_menu);
>> > +
>> > +       if (ctrl_hdlr->error) {
>> > +               ret = ctrl_hdlr->error;
>> > +               dev_err(&client->dev, "%s control init failed (%d)\n",
>> > +                       __func__, ret);
>> > +               goto error;
>> > +       }
>> > +
>> > +       imx258->sd.ctrl_handler = ctrl_hdlr;
>> > +
>> > +       return 0;
>> > +
>> > +error:
>> > +       v4l2_ctrl_handler_free(ctrl_hdlr);
>> > +       mutex_destroy(&imx258->mutex);
>> > +
>> > +       return ret;
>> > +}
>> > +
>> > +static void imx258_free_controls(struct imx258 *imx258)
>> > +{
>> > +       v4l2_ctrl_handler_free(imx258->sd.ctrl_handler);
>> > +       mutex_destroy(&imx258->mutex);
>> > +}
>> > +
>> > +static int imx258_probe(struct i2c_client *client)
>> > +{
>> > +       struct imx258 *imx258;
>> > +       int ret;
>> > +       u32 val = 0;
>> > +
>> > +       device_property_read_u32(&client->dev, "clock-frequency", &val);
>> > +       if (val != 19200000)
>>
>> Would be nice to print some error.
>>
>> > +               return -EINVAL;
>> > +
>> > +       imx258 = devm_kzalloc(&client->dev, sizeof(*imx258), GFP_KERNEL);
>> > +       if (!imx258)
>> > +               return -ENOMEM;
>> > +
>> > +       /* Initialize subdev */
>> > +       v4l2_i2c_subdev_init(&imx258->sd, client, &imx258_subdev_ops);
>> > +
>> > +       /* Check module identity */
>> > +       ret = imx258_identify_module(imx258);
>> > +       if (ret)
>> > +               return ret;
>> > +
>> > +       /* Set default mode to max resolution */
>> > +       imx258->cur_mode = &supported_modes[0];
>> > +
>> > +       ret = imx258_init_controls(imx258);
>> > +       if (ret)
>> > +               return ret;
>> > +
>> > +       /* Initialize subdev */
>> > +       imx258->sd.internal_ops = &imx258_internal_ops;
>> > +       imx258->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
>> > +       imx258->sd.entity.function = MEDIA_ENT_F_CAM_SENSOR;
>> > +
>> > +       /* Initialize source pad */
>> > +       imx258->pad.flags = MEDIA_PAD_FL_SOURCE;
>> > +
>> > +       ret = media_entity_pads_init(&imx258->sd.entity, 1, &imx258->pad);
>> > +       if (ret) {
>> > +               dev_err(&client->dev, "%s failed:%d\n", __func__, ret);
>>
>> This isn't a very useful error message. "media_entity_pads_init()
>> failed: %d\n" would make more sense.
>
> Considering media_entity_pads_init() only fails due to bad parameters and
> those would not change during the operation of the driver, IMO any error
> message here is not useful.

I guess it's a personal preference. I don't mind removing it, though.

Best regards,
Tomasz
