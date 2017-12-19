Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36167 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752936AbdLSRBO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 12:01:14 -0500
Received: by mail-wm0-f66.google.com with SMTP id b76so5045413wmg.1
        for <linux-media@vger.kernel.org>; Tue, 19 Dec 2017 09:01:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <3ae0ee4d-e754-1e97-33ed-d1fedf442dfb@xs4all.nl>
References: <1513447230-30948-1-git-send-email-tharvey@gateworks.com>
 <1513447230-30948-5-git-send-email-tharvey@gateworks.com> <3ae0ee4d-e754-1e97-33ed-d1fedf442dfb@xs4all.nl>
From: Tim Harvey <tharvey@gateworks.com>
Date: Tue, 19 Dec 2017 09:01:12 -0800
Message-ID: <CAJ+vNU34fBjBos4g9vxv7UkcJOm1YJux7NM2=iUKBjOrxZeMBA@mail.gmail.com>
Subject: Re: [PATCH v5 4/6] media: i2c: Add TDA1997x HDMI receiver driver
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
        alsa-devel@alsa-project.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 19, 2017 at 3:12 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 16/12/17 19:00, Tim Harvey wrote:
>> +
>> +static int tda1997x_fill_format(struct tda1997x_state *state,
>> +                             struct v4l2_mbus_framefmt *format)
>> +{
>> +     const struct v4l2_bt_timings *bt;
>> +     struct v4l2_hdmi_colorimetry c;
>> +
>> +     v4l_dbg(1, debug, state->client, "%s\n", __func__);
>> +
>> +     if (!state->detected_timings)
>> +             return -EINVAL;
>> +     bt = &state->detected_timings->bt;
>> +     memset(format, 0, sizeof(*format));
>> +     c = v4l2_hdmi_rx_colorimetry(&state->avi_infoframe, NULL, bt->height);
>> +     format->width = bt->width;
>> +     format->height = bt->height;
>> +     format->field = (bt->interlaced) ?
>> +             V4L2_FIELD_ALTERNATE : V4L2_FIELD_NONE;
>> +     format->colorspace = c.colorspace;
>> +     format->ycbcr_enc = c.ycbcr_enc;
>> +     format->quantization = c.quantization;
>> +     format->xfer_func = c.xfer_func;
>
> This is wrong. v4l2_hdmi_rx_colorimetry returns what arrives on the HDMI link,
> that's not the same as is output towards the SoC. You need to take limited/full
> range conversions and 601/709 conversions into account since that's what ends
> up in memory.
>
> Also note: you are still parsing the colorimetry information from avi_infoframe
> in the infoframe parse function. There is no need to do that, just call
> v4l2_hdmi_rx_colorimetry and let that function parse and interpret all this.
>
> Otherwise we still have two places that try to interpret that information.

Hans,

Ok so v4l2_hdmi_rx_colorimetry() handles parsing the source avi
infoframe and deals with enforcing the detailed rules and returns
'v4l2' enums:

tda1997x_parse_infoframe(...)
...
        case HDMI_INFOFRAME_TYPE_AVI:
                state->avi_infoframe = frame.avi; /* hold on to avi
infoframe for later use in logging etc */
                /* parse avi infoframe colorimetry data for v4l2
colorspace/ycbcr_encoding/quantization/xfer_func */
                state->hdmi_colorimetry = v4l2_hdmi_rx_colorimetry(&frame.avi,
                                                NULL,
                                                state->timings.bt.height);

Also here I still need to override the quant range passed from the
source avi infoframe per the user control (if not auto) and set per
vic if default:

                /* Quantization Range */
                switch (state->rgb_quantization_range) {
                case V4L2_DV_RGB_RANGE_AUTO:
                        state->range = frame.avi.quantization_range;
                        break;
                case V4L2_DV_RGB_RANGE_LIMITED:
                        state->range = HDMI_QUANTIZATION_RANGE_LIMITED;
                        break;
                case V4L2_DV_RGB_RANGE_FULL:
                        state->range = HDMI_QUANTIZATION_RANGE_FULL;
                        break;
                }
                if (state->range == HDMI_QUANTIZATION_RANGE_DEFAULT) {
                        if (frame.avi.video_code <= 1)
                                state->range = HDMI_QUANTIZATION_RANGE_FULL;
                        else
                                state->range = HDMI_QUANTIZATION_RANGE_LIMITED;
                }


Then tda1997x_fill_format() then needs to fill in details of what's on
the bus so I should be filling in only width/height/field/colorspace
and use colorspace based on my csc conversion chosen output
(V4L2_COLORSPACE_SRGB|V4L2_COLORSPACE_SMPTE170M|V4L2_COLORSPACE_REC709)
and I don't need to set ycbcr_enc/quantization/xfer_func.

does this sound right?

Thanks,

Tim
