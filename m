Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f172.google.com ([209.85.128.172]:34494 "EHLO
        mail-wr0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751323AbeAYQPf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 Jan 2018 11:15:35 -0500
Received: by mail-wr0-f172.google.com with SMTP id 36so8271411wrh.1
        for <linux-media@vger.kernel.org>; Thu, 25 Jan 2018 08:15:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1e65ee61-f282-4b53-dd03-68a89a91da8e@xs4all.nl>
References: <1514491789-8697-1-git-send-email-tharvey@gateworks.com>
 <1514491789-8697-5-git-send-email-tharvey@gateworks.com> <1e65ee61-f282-4b53-dd03-68a89a91da8e@xs4all.nl>
From: Tim Harvey <tharvey@gateworks.com>
Date: Thu, 25 Jan 2018 08:15:32 -0800
Message-ID: <CAJ+vNU1ysHuzqOnL4sf3hFZrU5kyGnQ0dFkRObVjCa=NyLsJug@mail.gmail.com>
Subject: Re: [PATCH v6 4/6] media: i2c: Add TDA1997x HDMI receiver driver
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
        alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shawn Guo <shawnguo@kernel.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 15, 2018 at 4:56 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 12/28/2017 09:09 PM, Tim Harvey wrote:
>> Add support for the TDA1997x HDMI receivers.
>>
>
> This looks good.
>
> But there is one corner case that isn't handled in this driver: what if there
> is no AVI InfoFrame (e.g. you receive a DVI signal)?
>
> The CTA-861 spec says that in the absence of an AVI InfoFrame you should use
> limited range for CE formats and full range for IT formats. However, without
> an AVI InfoFrame it is hard to detect a CE format since there is no VIC code.
> In addition, a real DVI source will always transmit full range.
>
> I would recommend that in the absence of an AVI InfoFrame you fall back to
> sRGB with full range quantization. Not quite according to the spec but more
> likely to work in practice.
>

Hans,

Sounds like we are just talking about the default settings which would
be used in the case of no infoframes. I'll default the struct
v4l2_hdmi_colorimetry I store in the state struct as:

+       /*
+        * default to SRGB full range quantization
+        * (in case we don't get an infoframe such as DVI signal
+        */
+       state->colorimetry.colorspace = V4L2_COLORSPACE_SRGB;
+       state->colorimetry.quantization = V4L2_QUANTIZATION_FULL_RANGE;
+


>> <snip>
>> +static int tda1997x_enum_mbus_code(struct v4l2_subdev *sd,
>> +                               struct v4l2_subdev_pad_config *cfg,
>> +                               struct v4l2_subdev_mbus_code_enum *code)
>> +{
>> +     struct tda1997x_state *state = to_state(sd);
>> +
>> +     if (code->index > 0)
>> +             return -EINVAL;
>> +
>> +     code->code = state->code;
>
> Hmm. This receiver supports multiple output formats, but you advertise only one.
> That looks wrong. If nothing else, you should be able to switch between RGB and
> YUV 4:4:4 since they use the same port config.
>
> It's a common use-case that you want to switch between RGB and YUV depending on
> the source material (i.e. if you receive a desktop/graphics then RGB is best, if
> you receive video then YUV 4:2:2 or 4:2:0 is best).
>
> Hardcoding just one format won't do.
>

I've been thinking about this a bit. I had hard-coded a single format
for now because I haven't had any good ideas on how to deal with the
fact that the port mappings would need to differ if you change from
the RGB888/YUV444 (I think these are referred to as 'planar' formats?)
to YUV422 (semi-planar) and BT656 formats. It is true though that the
36bit (TDA19973) RGB888/YUV444 and 24bit (TDA19971/2) formats can both
be supported with the same port mappings / pinout.

For example the GW5400 has a TDA19971 mapped to IMX6 CSI_DATA[19:4]
(16bit) for YUV422. However if you want to use BT656 you have to shift
the TDA19971 port mappings to get the YCbCr pins mapped to
CSI_DATA[19:x] and those pin groups are at the bottom of the bus for
the RGB888/YUV444 format.

I suppose however that perhaps for the example above if I have a 16bit
width required to support YUV422 there would never be a useful case
for supporting 8-bit/10-bit/12-bit BT656 on the same board?

Maybe I can define an array of mbus_codes in the state structure then
fill in the possible states per bit width during init like this:

        switch (state->info->type) {
        case TDA19973:
                switch (pdata->vidout_bus_width) {
                case 36:
                        /* 36bit YUV */
                        state->mbus_codes[0] = MEDIA_BUS_FMT_YUV12_1X36;
                        /* 36bit RGB */
                        state->mbus_codes[1] = MEDIA_BUS_FMT_RGB121212_1X36;
                        break;
                case 24:
                        /* 24bit BT656 (YUV422 semi-planar: 1-cycle) */
                        state->mbus_codes[0] = MEDIA_BUS_FMT_UYVY12_1X24;
                        /* 24bit YUV */
                        state->mbus_codes[1] = MEDIA_BUS_FMT_YUV8_1X24;
                        break;
                case 12:
                        /* 12bit BT656 (2-cycle) */
                        state->mbus_codes[0] = MEDIA_BUS_FMT_UYVY12_2X12;
                        break;
                }
                break;
        case TDA19971:
                switch (pdata->vidout_bus_width) {
                case 24:
                        /* 24bit YUV */
                        state->mbus_codes[0] = MEDIA_BUS_FMT_YUV8_1X24;
                        /* 24bit RGB */
                        state->mbus_codes[1] = MEDIA_BUS_FMT_RGB888_1X24;
                        break;
                case 20: /* 20bit YUV422 */
                        state->mbus_codes[0] = MEDIA_BUS_FMT_UYVY10_1X20;
                        break;
                case 16: /* 16bit BT656 (YUV422 semi-planar: 1-cycle) */
                        state->mbus_codes[0] = MEDIA_BUS_FMT_UYVY8_1X16;
                        break;
                case 12: /* 12bit BT656 (2-cycle) */
                        state->mbus_codes[0] = MEDIA_BUS_FMT_UYVY12_2X12;
                        break;
                case 10: /* 10bit BT656 (2-cycle) */
                        state->mbus_codes[0] = MEDIA_BUS_FMT_UYVY10_2X10;
                        break;
                case 8: /* 8bit BT656 (2-cycle) */
                        state->mbus_codes[0] = MEDIA_BUS_FMT_UYVY8_2X8;
                        break;
                }
        }
        /* default format */
        state->mbus_code = state->mbus_codes[0];

This doesn't support the fact for example that a 20bit bus can also
support the 8/10/12bit BT656 formats.

>> +
>> +     return 0;
>> +}
>> +
>> +static int tda1997x_fill_format(struct tda1997x_state *state,
>> +                             struct v4l2_mbus_framefmt *format)
>> +{
>> +     const struct v4l2_bt_timings *bt;
>> +
>> +     v4l_dbg(1, debug, state->client, "%s\n", __func__);
>> +
>> +     if (!state->detected_timings)
>> +             return -EINVAL;
>> +
>> +     memset(format, 0, sizeof(*format));
>> +     bt = &state->detected_timings->bt;
>> +     format->width = bt->width;
>> +     format->height = bt->height;
>> +     format->colorspace = state->colorimetry.colorspace;
>> +
>> +     return 0;
>> +}
>> +
>> +static int tda1997x_get_pad_format(struct v4l2_subdev *sd,
>> +                                struct v4l2_subdev_pad_config *cfg,
>> +                                struct v4l2_subdev_format *format)
>> +{
>> +     struct tda1997x_state *state = to_state(sd);
>> +
>> +     v4l_dbg(1, debug, state->client, "%s\n", __func__);
>> +     if (format->pad != TDA1997X_PAD_SOURCE)
>> +             return -EINVAL;
>> +
>> +     tda1997x_fill_format(state, &format->format);
>> +
>> +     if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
>> +             struct v4l2_mbus_framefmt *fmt;
>> +
>> +             fmt = v4l2_subdev_get_try_format(sd, cfg, format->pad);
>> +             format->format.code = format->format.code;
>> +     } else
>> +             format->format.code = state->code;
>
> No need to mess around with TRY vs ACTIVE. The behavior is the same for
> both.

only if I have a single bus format though right?

>
>> +
>> +     return 0;
>> +}
>> +
>> +static int tda1997x_set_pad_format(struct v4l2_subdev *sd,
>> +                                struct v4l2_subdev_pad_config *cfg,
>> +                                struct v4l2_subdev_format *format)
>> +{
>> +     struct v4l2_mbus_framefmt *fmt;
>> +
>> +     if (format->pad != TDA1997X_PAD_SOURCE)
>> +             return -EINVAL;
>> +
>> +     if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
>> +             return tda1997x_get_pad_format(sd, cfg, format);
>
> Same here, just call return tda1997x_get_pad_format(sd, cfg, format);
>
> But note that it makes no sense to support only one possible mbus code
> when it is clearly possible to switch between multiple output formats.
>
> I'm not sure why I didn't see that earlier...
>

But once I add in the multiple mbus formats then I need the try vs
active correct?

Regards,

Tim
