Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:42838 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751422AbdLMXgB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Dec 2017 18:36:01 -0500
Received: by mail-wr0-f173.google.com with SMTP id s66so3610931wrc.9
        for <linux-media@vger.kernel.org>; Wed, 13 Dec 2017 15:36:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJ+vNU0NKZizung9+1zsd1RZBrDbBgk+A8mVJ76bQysjCUoaKw@mail.gmail.com>
References: <1511990397-27647-1-git-send-email-tharvey@gateworks.com>
 <1511990397-27647-4-git-send-email-tharvey@gateworks.com> <1a1be5d7-caed-6cba-c97a-dbb70e119fa3@xs4all.nl>
 <CAJ+vNU0NKZizung9+1zsd1RZBrDbBgk+A8mVJ76bQysjCUoaKw@mail.gmail.com>
From: Tim Harvey <tharvey@gateworks.com>
Date: Wed, 13 Dec 2017 15:35:58 -0800
Message-ID: <CAJ+vNU1L5MkP0DuiwjKXY75id3Brzq+9M9DfcZOXbvzVgaUdXQ@mail.gmail.com>
Subject: Re: [PATCH v4 3/5] media: i2c: Add TDA1997x HDMI receiver driver
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

On Mon, Dec 4, 2017 at 9:30 AM, Tim Harvey <tharvey@gateworks.com> wrote:
> On Mon, Dec 4, 2017 at 4:50 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> Hi Tim,
>>
>> Found a few more small issues. After that's fixed and you have the Ack for the
>> bindings this can be merged I think.
>
> Hans,
>
> Thanks. Can you weigh in on the bindings? Rob was hoping for some
> discussion on making some generic bus format types for video and I'm
> not familiar with the other video encoders/decoders enough to know if
> there is enough commonality.
>
>>
>> On 11/29/2017 10:19 PM, Tim Harvey wrote:
> <snip>
>>> +
>>> +/* parse an infoframe and do some sanity checks on it */
>>> +static unsigned int
>>> +tda1997x_parse_infoframe(struct tda1997x_state *state, u16 addr)
>>> +{
>>> +     struct v4l2_subdev *sd = &state->sd;
>>> +     union hdmi_infoframe frame;
>>> +     u8 buffer[40];
>>> +     u8 reg;
>>> +     int len, err;
>>> +
>>> +     /* read data */
>>> +     len = io_readn(sd, addr, sizeof(buffer), buffer);
>>> +     err = hdmi_infoframe_unpack(&frame, buffer);
>>> +     if (err) {
>>> +             v4l_err(state->client,
>>> +                     "failed parsing %d byte infoframe: 0x%04x/0x%02x\n",
>>> +                     len, addr, buffer[0]);
>>> +             return err;
>>> +     }
>>> +     hdmi_infoframe_log(KERN_INFO, &state->client->dev, &frame);
>>> +     switch (frame.any.type) {
>>> +     /* Audio InfoFrame: see HDMI spec 8.2.2 */
>>> +     case HDMI_INFOFRAME_TYPE_AUDIO:
>>> +             /* sample rate */
>>> +             switch (frame.audio.sample_frequency) {
>>> +             case HDMI_AUDIO_SAMPLE_FREQUENCY_32000:
>>> +                     state->audio_samplerate = 32000;
>>> +                     break;
>>> +             case HDMI_AUDIO_SAMPLE_FREQUENCY_44100:
>>> +                     state->audio_samplerate = 44100;
>>> +                     break;
>>> +             case HDMI_AUDIO_SAMPLE_FREQUENCY_48000:
>>> +                     state->audio_samplerate = 48000;
>>> +                     break;
>>> +             case HDMI_AUDIO_SAMPLE_FREQUENCY_88200:
>>> +                     state->audio_samplerate = 88200;
>>> +                     break;
>>> +             case HDMI_AUDIO_SAMPLE_FREQUENCY_96000:
>>> +                     state->audio_samplerate = 96000;
>>> +                     break;
>>> +             case HDMI_AUDIO_SAMPLE_FREQUENCY_176400:
>>> +                     state->audio_samplerate = 176400;
>>> +                     break;
>>> +             case HDMI_AUDIO_SAMPLE_FREQUENCY_192000:
>>> +                     state->audio_samplerate = 192000;
>>> +                     break;
>>> +             default:
>>> +             case HDMI_AUDIO_SAMPLE_FREQUENCY_STREAM:
>>> +                     break;
>>> +             }
>>> +
>>> +             /* sample size */
>>> +             switch (frame.audio.sample_size) {
>>> +             case HDMI_AUDIO_SAMPLE_SIZE_16:
>>> +                     state->audio_samplesize = 16;
>>> +                     break;
>>> +             case HDMI_AUDIO_SAMPLE_SIZE_20:
>>> +                     state->audio_samplesize = 20;
>>> +                     break;
>>> +             case HDMI_AUDIO_SAMPLE_SIZE_24:
>>> +                     state->audio_samplesize = 24;
>>> +                     break;
>>> +             case HDMI_AUDIO_SAMPLE_SIZE_STREAM:
>>> +             default:
>>> +                     break;
>>> +             }
>>> +
>>> +             /* Channel Count */
>>> +             state->audio_channels = frame.audio.channels;
>>> +             if (frame.audio.channel_allocation &&
>>> +                 frame.audio.channel_allocation != state->audio_ch_alloc) {
>>> +                     /* use the channel assignment from the infoframe */
>>> +                     state->audio_ch_alloc = frame.audio.channel_allocation;
>>> +                     tda1997x_configure_audout(sd, state->audio_ch_alloc);
>>> +                     /* reset the audio FIFO */
>>> +                     tda1997x_hdmi_info_reset(sd, RESET_AUDIO, false);
>>> +             }
>>> +             break;
>>> +
>>> +     /* Auxiliary Video information (AVI) InfoFrame: see HDMI spec 8.2.1 */
>>> +     case HDMI_INFOFRAME_TYPE_AVI:
>>> +             state->colorspace = frame.avi.colorspace;
>>> +             state->colorimetry = frame.avi.colorimetry;
>>> +             state->content = frame.avi.content_type;
>>> +             /* Quantization Range */
>>> +             switch (state->rgb_quantization_range) {
>>> +             case V4L2_DV_RGB_RANGE_AUTO:
>>> +                     state->range = frame.avi.quantization_range;
>>> +                     break;
>>> +             case V4L2_DV_RGB_RANGE_LIMITED:
>>> +                     state->range = HDMI_QUANTIZATION_RANGE_LIMITED;
>>> +                     break;
>>> +             case V4L2_DV_RGB_RANGE_FULL:
>>> +                     state->range = HDMI_QUANTIZATION_RANGE_FULL;
>>> +                     break;
>>> +             }
>>> +             if (state->range == HDMI_QUANTIZATION_RANGE_DEFAULT) {
>>> +                     if (frame.avi.video_code <= 1)
>>> +                             state->range = HDMI_QUANTIZATION_RANGE_FULL;
>>> +                     else
>>> +                             state->range = HDMI_QUANTIZATION_RANGE_LIMITED;
>>> +             }
>>> +             /*
>>> +              * If colorimetry not specified, conversion depends on res type:
>>> +              *  - SDTV: ITU601 for SD (480/576/240/288 line resolution)
>>> +              *  - HDTV: ITU709 for HD (720/1080 line resolution)
>>> +              *  -   PC: sRGB
>>> +              * see HDMI specification section 6.7
>>> +              */
>>> +             if ((state->colorspace == HDMI_COLORSPACE_YUV422 ||
>>> +                  state->colorspace == HDMI_COLORSPACE_YUV444) &&
>>> +                 (state->colorimetry == HDMI_COLORIMETRY_EXTENDED ||
>>> +                  state->colorimetry == HDMI_COLORIMETRY_NONE)) {
>>> +                     if (is_sd(state->timings.bt.height))
>>> +                             state->colorimetry = HDMI_COLORIMETRY_ITU_601;
>>> +                     else if (is_hd(state->timings.bt.height))
>>> +                             state->colorimetry = HDMI_COLORIMETRY_ITU_709;
>>> +                     else
>>> +                             state->colorimetry = HDMI_COLORIMETRY_NONE;
>>> +             }
>>> +             v4l_dbg(1, debug, state->client,
>>> +                     "colorspace=%d colorimetry=%d range=%d content=%d\n",
>>> +                     state->colorspace, state->colorimetry, state->range,
>>> +                     state->content);
>>> +
>>> +             /* configure upsampler: 0=bypass 1=repeatchroma 2=interpolate */
>>> +             reg = io_read(sd, REG_PIX_REPEAT);
>>> +             reg &= ~PIX_REPEAT_MASK_UP_SEL;
>>> +             if (state->colorspace == HDMI_COLORSPACE_YUV422)
>>> +                     reg |= (PIX_REPEAT_CHROMA << PIX_REPEAT_SHIFT);
>>> +             io_write(sd, REG_PIX_REPEAT, reg);
>>> +
>>> +             /* ConfigurePixelRepeater: repeat n-times each pixel */
>>> +             reg = io_read(sd, REG_PIX_REPEAT);
>>> +             reg &= ~PIX_REPEAT_MASK_REP;
>>> +             reg |= frame.avi.pixel_repeat;
>>> +             io_write(sd, REG_PIX_REPEAT, reg);
>>> +
>>> +             /* configure the receiver with the new colorspace */
>>> +             tda1997x_configure_csc(sd);
>>> +             break;
>>> +     default:
>>> +             break;
>>> +     }
>>> +     return 0;
>>> +}
>>> +
> <snip>
>>> +
>>> +static int tda1997x_fill_format(struct tda1997x_state *state,
>>> +                             struct v4l2_mbus_framefmt *format)
>>> +{
>>> +     const struct v4l2_bt_timings *bt;
>>> +
>>> +     v4l_dbg(1, debug, state->client, "%s\n", __func__);
>>> +
>>> +     if (!state->detected_timings)
>>> +             return -EINVAL;
>>> +     bt = &state->detected_timings->bt;
>>> +     memset(format, 0, sizeof(*format));
>>> +
>>> +     format->width = bt->width;
>>> +     format->height = bt->height;
>>> +     format->field = V4L2_FIELD_NONE;
>>> +     format->colorspace = V4L2_COLORSPACE_SRGB;
>>> +     if (bt->flags & V4L2_DV_FL_IS_CE_VIDEO)
>>> +             format->colorspace = (bt->height <= 576) ?
>>> +                     V4L2_COLORSPACE_SMPTE170M : V4L2_COLORSPACE_REC709;
>>
>> Close. What is missing is a check of the AVI InfoFrame: if it has an explicit
>> colorimetry then use that. E.g. check for HDMI_COLORIMETRY_ITU_601 or ITU_709
>> and set the colorspace accordingly. Otherwise fall back to what you have here.
>>
>
> This function currently matches adv7604/adv7842 where they don't look
> at colorimetry (but I do see a TODO in adv748x_hdmi_fill_format to
> look at this) so I don't have an example and may not understand.
>
> Do you mean:
>
>        format->colorspace = V4L2_COLORSPACE_SRGB;
>        if (bt->flags & V4L2_DV_FL_IS_CE_VIDEO) {
>                 if ((state->colorimetry == HDMI_COLORIMETRY_ITU_601) ||
>                     (state->colorimetry == HDMI_COLORIMETRY_ITU_709))
>                         format->colorspace = state->colorspace;
>                 else
>                         format->colorspace = is_sd(bt->height) ?
>                                 V4L2_COLORSPACE_SMPTE170M :
> V4L2_COLORSPACE_REC709;
>         }
>
> Also during more testing I've found that I'm not capturing interlaced
> properly and know I at least need:
>
> -        format->field = V4L2_FIELD_NONE;
> +        format->field = (bt->interlaced) ?
> +                V4L2_FIELD_ALTERNATE : V4L2_FIELD_NONE;
>
> I'm still not quite capturing interlaced yet but I think its an issue
> of setting up the media pipeline improperly.
>

Hans,

Did you see this question above? I'm not quite understanding what you
want me to do for filling in colorspace and don't see any examples in
the existing drivers that appear to look at colorimetry for this.

Regards,

Tim
