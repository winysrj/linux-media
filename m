Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:42667 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752231AbdKWE1O (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Nov 2017 23:27:14 -0500
Received: by mail-wm0-f50.google.com with SMTP id l188so12410624wma.1
        for <linux-media@vger.kernel.org>; Wed, 22 Nov 2017 20:27:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4048cb21-c65c-6282-a1d7-81ad9a0d7cfa@xs4all.nl>
References: <1510253136-14153-1-git-send-email-tharvey@gateworks.com>
 <1510253136-14153-4-git-send-email-tharvey@gateworks.com> <4048cb21-c65c-6282-a1d7-81ad9a0d7cfa@xs4all.nl>
From: Tim Harvey <tharvey@gateworks.com>
Date: Wed, 22 Nov 2017 20:27:12 -0800
Message-ID: <CAJ+vNU0q4Ab-1sFsyQv3JRMd54ntMU3=Er6yCNiY=tLCN1N5VQ@mail.gmail.com>
Subject: Re: [PATCH 3/5] media: i2c: Add TDA1997x HDMI receiver driver
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

On Mon, Nov 20, 2017 at 7:39 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Tim,
>
> Some more review comments:
>
> On 11/09/2017 07:45 PM, Tim Harvey wrote:
>> Add support for the TDA1997x HDMI receivers.
<snip>
>> + */
>> +struct color_matrix_coefs {
>> +     const char *name;
>> +     /* Input offsets */
>> +     s16 offint1;
>> +     s16 offint2;
>> +     s16 offint3;
>> +     /* Coeficients */
>> +     s16 p11coef;
>> +     s16 p12coef;
>> +     s16 p13coef;
>> +     s16 p21coef;
>> +     s16 p22coef;
>> +     s16 p23coef;
>> +     s16 p31coef;
>> +     s16 p32coef;
>> +     s16 p33coef;
>> +     /* Output offsets */
>> +     s16 offout1;
>> +     s16 offout2;
>> +     s16 offout3;
>> +};
>> +
>> +enum {
>> +     ITU709_RGBLIMITED,
>> +     ITU709_RGBFULL,
>> +     ITU601_RGBLIMITED,
>> +     ITU601_RGBFULL,
>> +     RGBLIMITED_RGBFULL,
>> +     RGBLIMITED_ITU601,
>> +     RGBFULL_ITU601,
>
> This can't be right.
>ITU709_RGBLIMITED
> You have these conversions:
>
> ITU709_RGBFULL
> ITU601_RGBFULL
> RGBLIMITED_RGBFULL
> RGBLIMITED_ITU601
> RGBFULL_ITU601
> RGBLIMITED_ITU709
> RGBFULL_ITU709
>
> I.e. on the HDMI receiver side you can receive RGB full/limited or ITU601/709.
> On the output side you have RGB full or ITU601/709.
>
> So something like ITU709_RGBLIMITED makes no sense.
>

I misunderstood the V4L2_CID_DV_RX_RGB_RANGE thinking that it allowed
you to configure the output range. If output to the SoC is only ever
full quant range for RGB then I can drop the
ITU709_RGBLIMITED/ITU601_RGBLIMITED conversions.

However, If the output is YUV how do I know if I need to convert to
ITU709 or ITU601 and what are my conversion matrices for
RGBLIMITED_ITU709/RGBFULL_ITU709?

Sorry for all the questions, the colorspace/colorimetry options
confuse the heck out of me.

>> +};
>> +
<snip>
>> +
>> +/* parse an infoframe and do some sanity checks on it */
>> +static unsigned int
>> +tda1997x_parse_infoframe(struct tda1997x_state *state, u16 addr)
>> +{
>> +     struct v4l2_subdev *sd = &state->sd;
>> +     union hdmi_infoframe frame;
>> +     u8 buffer[40];
>> +     u8 reg;
>> +     int len, err;
>> +
>> +     /* read data */
>> +     len = io_readn(sd, addr, sizeof(buffer), buffer);
>> +     err = hdmi_infoframe_unpack(&frame, buffer);
>> +     if (err) {
>> +             v4l_err(state->client,
>> +                     "failed parsing %d byte infoframe: 0x%04x/0x%02x\n",
>> +                     len, addr, buffer[0]);
>> +             return err;
>> +     }
>> +     hdmi_infoframe_log(KERN_INFO, &state->client->dev, &frame);
>> +     switch (frame.any.type) {
>> +     /* Audio InfoFrame: see HDMI spec 8.2.2 */
>> +     case HDMI_INFOFRAME_TYPE_AUDIO:
>> +             /* sample rate */
>> +             switch (frame.audio.sample_frequency) {
>> +             case HDMI_AUDIO_SAMPLE_FREQUENCY_32000:
>> +                     state->audio_samplerate = 32000;
>> +                     break;
>> +             case HDMI_AUDIO_SAMPLE_FREQUENCY_44100:
>> +                     state->audio_samplerate = 44100;
>> +                     break;
>> +             case HDMI_AUDIO_SAMPLE_FREQUENCY_48000:
>> +                     state->audio_samplerate = 48000;
>> +                     break;
>> +             case HDMI_AUDIO_SAMPLE_FREQUENCY_88200:
>> +                     state->audio_samplerate = 88200;
>> +                     break;
>> +             case HDMI_AUDIO_SAMPLE_FREQUENCY_96000:
>> +                     state->audio_samplerate = 96000;
>> +                     break;
>> +             case HDMI_AUDIO_SAMPLE_FREQUENCY_176400:
>> +                     state->audio_samplerate = 176400;
>> +                     break;
>> +             case HDMI_AUDIO_SAMPLE_FREQUENCY_192000:
>> +                     state->audio_samplerate = 192000;
>> +                     break;
>> +             default:
>> +             case HDMI_AUDIO_SAMPLE_FREQUENCY_STREAM:
>> +                     break;
>> +             }
>> +
>> +             /* sample size */
>> +             switch (frame.audio.sample_size) {
>> +             case HDMI_AUDIO_SAMPLE_SIZE_16:
>> +                     state->audio_samplesize = 16;
>> +                     break;
>> +             case HDMI_AUDIO_SAMPLE_SIZE_20:
>> +                     state->audio_samplesize = 20;
>> +                     break;
>> +             case HDMI_AUDIO_SAMPLE_SIZE_24:
>> +                     state->audio_samplesize = 24;
>> +                     break;
>> +             case HDMI_AUDIO_SAMPLE_SIZE_STREAM:
>> +             default:
>> +                     break;
>> +             }
>> +
>> +             /* Channel Count */
>> +             state->audio_channels = frame.audio.channels;
>> +             if (frame.audio.channel_allocation &&
>> +                 frame.audio.channel_allocation != state->audio_ch_alloc) {
>> +                     /* use the channel assignment from the infoframe */
>> +                     state->audio_ch_alloc = frame.audio.channel_allocation;
>> +                     tda1997x_configure_audout(sd, state->audio_ch_alloc);
>> +                     /* reset the audio FIFO */
>> +                     tda1997x_hdmi_info_reset(sd, RESET_AUDIO, false);
>> +             }
>> +             break;
>> +
>> +     /* Auxiliary Video information (AVI) InfoFrame: see HDMI spec 8.2.1 */
>> +     case HDMI_INFOFRAME_TYPE_AVI:
>> +             state->colorspace = frame.avi.colorspace;
>> +             state->colorimetry = frame.avi.colorimetry;
>> +             state->range = frame.avi.quantization_range;
>
> This should be ignored if it is overridden by the RGB Quantization Range
> control, or am I missing something?
>

Ok. Sounds like I should only use the range from the infoframe if
range == V4L2_DV_RGB_RANGE_AUTO:

                /* Quantization Range */
                if (state->range == V4L2_DV_RGB_RANGE_AUTO)
                        state->range = frame.avi.quantization_range;
                if (state->range == HDMI_QUANTIZATION_RANGE_DEFAULT) {
                        if (frame.avi.video_code <= 1)
                                state->range = HDMI_QUANTIZATION_RANGE_FULL;
                        else
                                state->range = HDMI_QUANTIZATION_RANGE_LIMITED;
                }


>> +             state->content = frame.avi.content_type;
>> +             /*
>> +              * If colorimetry not specified, conversion depends on res type:
>> +              *  - SDTV: ITU601 for SD (480/576/240/288 line resolution)
>> +              *  - HDTV: ITU709 for HD (720/1080 line resolution)
>> +              *  -   PC: sRGB
>> +              * see HDMI specification section 6.7
>> +              */
>> +             if ((state->colorspace == HDMI_COLORSPACE_YUV422 ||
>> +                  state->colorspace == HDMI_COLORSPACE_YUV444) &&
>> +                 (state->colorimetry == HDMI_COLORIMETRY_EXTENDED ||
>> +                  state->colorimetry == HDMI_COLORIMETRY_NONE)) {
>> +                     switch (state->timings.bt.height) {
>> +                     case 480:
>> +                     case 576:
>> +                     case 240:
>> +                     case 288:
>> +                             state->colorimetry = HDMI_COLORIMETRY_ITU_601;
>> +                             break;
>> +                     case 720:
>> +                     case 1080:
>> +                             state->colorimetry = HDMI_COLORIMETRY_ITU_709;
>> +                             break;
>> +                     default:
>> +                             state->colorimetry = HDMI_COLORIMETRY_NONE;
>> +                             break;
>> +                     }
>> +             }
>> +             /* if range not specified */
>> +             if (state->range == HDMI_QUANTIZATION_RANGE_DEFAULT) {
>> +                     if (frame.avi.video_code == 0)
>
> This should be:
>
>                         if (frame.avi.video_code <= 1)
>
> VIC code 1 (VGA) is also full range. It's an exception to the rule.

ok

Thanks,

Tim
