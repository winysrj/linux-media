Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:56676 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751701AbdJSHjc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Oct 2017 03:39:32 -0400
Subject: Re: [PATCH v2 3/4] media: i2c: Add TDA1997x HDMI receiver driver
To: Tim Harvey <tharvey@gateworks.com>
Cc: linux-media <linux-media@vger.kernel.org>,
        alsa-devel@alsa-project.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <1507783506-3884-1-git-send-email-tharvey@gateworks.com>
 <1507783506-3884-4-git-send-email-tharvey@gateworks.com>
 <230ceb18-1d69-7fa8-acb0-c810094f8e50@xs4all.nl>
 <CAJ+vNU0Z988G+wTfpiSXXOM9QsPj-eRvH=F1b9__8kJ+18xk4g@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <a5bd27c9-10e4-b9f5-f0ac-293528fa570e@xs4all.nl>
Date: Thu, 19 Oct 2017 09:39:26 +0200
MIME-Version: 1.0
In-Reply-To: <CAJ+vNU0Z988G+wTfpiSXXOM9QsPj-eRvH=F1b9__8kJ+18xk4g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/19/2017 09:20 AM, Tim Harvey wrote:
> On Wed, Oct 18, 2017 at 5:04 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> Hi Tim,
>>
>> Here is my review of this v2:
>>
>> On 10/12/17 06:45, Tim Harvey wrote:
>>> Add support for the TDA1997x HDMI receivers.
>>>
> <snip>
>>> +
>>> +/*
>>> + * Video Input formats
>>> + */
>>> +struct vhref_values {
>>> +     u16 href_start;
>>> +     u16 href_end;
>>> +     u16 vref_f1_start;
>>> +     u8  vref_f1_width;
>>> +     u16 vref_f2_start;
>>> +     u8  vref_f2_width;
>>> +     u16 fieldref_f1_start;
>>> +     u8  fieldPolarity;
>>> +     u16 fieldref_f2_start;
>>
>> Since we don't support interlaced (yet) I'd just drop the 'f2' fields.
>> Ditto for fieldPolarity.
>>
>> Can't these href/vref values be calculated from the timings?
>>
> 
> The values in this struct are used to configure the tda1997x VHREF
> timing generator in tda1997x_configure_input_resolution() for
> generating the video output bus timings so I can't really drop them
> unless I can calculate them. Let me look into this - should be
> possible.
> 
>>> +};
>>> +
> <snip>
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
>>> +     if (debug > 1)
>>> +             hdmi_infoframe_log(KERN_INFO, &state->client->dev, &frame);
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
>>> +     /* Source Product Descriptor information (SPD) */
>>> +     case HDMI_INFOFRAME_TYPE_SPD:
>>> +             strncpy(frame.spd.vendor, state->vendor,
>>> +                     sizeof(frame.spd.vendor));
>>> +             strncpy(frame.spd.product, state->product,
>>> +                     sizeof(frame.spd.product));
>>> +             v4l_info(state->client, "Source Product Descriptor: %s %s\n",
>>> +                      state->vendor, state->product);
>>
>> Use hdmi_infoframe_log() for logging infoframes.
> 
> ok - I will always call hdmi_infoframe_log() above and refrain from
> outputs that just repeat those details.
> 
>>
>>> +             break;
>>> +
>>> +     /* Auxiliary Video information (AVI) InfoFrame: see HDMI spec 8.2.1 */
>>> +     case HDMI_INFOFRAME_TYPE_AVI:
>>> +             state->colorspace = frame.avi.colorspace;
>>> +             state->colorimetry = frame.avi.colorimetry;
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
>>> +                     switch (state->timings.bt.height) {
>>> +                     case 480:
>>> +                     case 576:
>>> +                     case 240:
>>> +                     case 288:
>>> +                             state->colorimetry = HDMI_COLORIMETRY_ITU_601;
>>> +                             break;
>>> +                     case 720:
>>> +                     case 1080:
>>> +                             state->colorimetry = HDMI_COLORIMETRY_ITU_709;
>>> +                             break;
>>> +                     default:
>>> +                             state->colorimetry = HDMI_COLORIMETRY_NONE;
>>
>> Missing break.
>>
> 
> oops - thanks
> 
>>> +                     }
>>> +             }
>>> +             v4l_dbg(1, debug, state->client,
>>> +                     "Colorspace=%d Colorimetry=%d\n",
>>> +                     state->colorspace, state->colorimetry);
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
>>> +             tda1997x_configure_conv(sd, state->colorspace,
>>> +                                     state->colorimetry);
>>
>> What I am missing here is handling of the RGB quantization range.
>> An HDMI receiver will typically send full range RGB or limited range YUV
>> to the SoC. The HDMI source can however send full or limited range RGB
>> or limited range YUV (full range YUV is theoretically possible, but nobody
>> does that).
>>
> 
> isn't this quantization range a function of the colorspace and
> colorimetry dictated by the AVI infoframe? I'm taking these into
> consideration when setting up the conversion matrix in
> tda1997x_configure_conv().

No, it's independent of that.

> 
>> For a Full HD receiver the rules when receiving RGB video are as follows:
>>
>> If the EDID supports selectable RGB Quantization Range, then check if the
>> source explicitly sets the RGB quantization range in the AVI InfoFrame and
>> use that value.
>>
>> Otherwise fall back to the default rules:
>>
>> if VIC == 0, then expect full range RGB, otherwise expect limited range RGB.
> 
> Are you referring to the video_code field of the AVI infoframe or vic
> from a vendor infoframe?

AVI InfoFrame.

The HDMI VIC codes in the vendor InfoFrame are only valid for 4k formats. And
that's not supported by this device, right?

> 
>>
>> It gets even more complicated with 4k video, but this is full HD only.
>>
>> In addition, you may also want to implement the V4L2_CID_DV_RX_RGB_RANGE control
>> to let userspace override the autodetection.
> 
> I'll add that as an additional patch. Are there other V4L2_CID's that
> I should be adding here?

V4L2_CID_DV_RX_POWER_PRESENT (if possible) and optionally V4L2_CID_DV_RX_IT_CONTENT_TYPE.

> 
>>
>> RGB Quantization Range handling is *the* biggest headache for HDMI receivers.
>>
>> If you happen to attend the Embedded Linux Conference Europe in Prague next
>> week, then attend my presentation on HDMI 4k Video on the Wednesday for all
>> the reasons why this is so tricky.
>>
>>> +             break;
>>> +     default:
>>> +             break;
>>> +     }
>>> +     return 0;
>>> +}
>>> +
> <snip>
>>> +static int tda1997x_query_dv_timings(struct v4l2_subdev *sd,
>>> +                                  struct v4l2_dv_timings *timings)
>>> +{
>>> +     struct tda1997x_state *state = to_state(sd);
>>> +     int ret;
>>> +
>>> +     v4l_dbg(1, debug, state->client, "%s\n", __func__);
>>> +     if (!timings)
>>> +             return -EINVAL;
>>> +
>>> +     memset(timings, 0, sizeof(struct v4l2_dv_timings));
>>> +     mutex_lock(&state->lock);
>>> +     ret = tda1997x_detect_std(state);
>>> +     if (ret)
>>> +             goto error;
>>> +     *timings = state->std->timings;
>>> +     mutex_unlock(&state->lock);
>>> +     return 0;
>>> +
>>> +error:
>>> +     mutex_unlock(&state->lock);
>>> +     return ret;
>>
>> This can be simplified:
>>
>>         ret = tda1997x_detect_std(state);
>>         if (!ret)
>>                 *timings = state->std->timings;
>>         mutex_unlock(&state->lock);
>>         return ret;
>>
> 
> yes, will do
> 
>>> +}
>>> +
> <snip>
>>> +
>>> +static int tda1997x_set_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
>>> +{
>>> +     struct tda1997x_state *state = to_state(sd);
>>> +     int i;
>>> +
>>> +     v4l_dbg(1, debug, state->client, "%s pad=%d\n", __func__, edid->pad);
>>> +     memset(edid->reserved, 0, sizeof(edid->reserved));
>>> +
>>> +     if (edid->start_block != 0)
>>> +             return -EINVAL;
>>> +
>>> +     if (edid->blocks == 0) {
>>> +             state->edid.blocks = 0;
>>> +             state->edid.present = 0;
>>> +             tda1997x_manual_hpd(&state->sd, HPD_LOW_BP);
>>> +             return 0;
>>> +     }
>>> +
>>> +     if (edid->blocks > 2) {
>>> +             edid->blocks = 2;
>>> +             return -E2BIG;
>>> +     }
>>> +
>>> +     /* write base EDID */
>>> +     for (i = 0; i < 128; i++)
>>> +             io_write(sd, REG_EDID_IN_BYTE0 + i, edid->edid[i]);
>>> +
>>> +     /* write CEA Extension */
>>> +     for (i = 0; i < 128; i++)
>>> +             io_write(sd, REG_EDID_IN_BYTE128 + i, edid->edid[i+128]);
>>> +
>>
>> Before updating the EDID pull the HPD low. Afterwards pull it up again.
>> The minimum time the HPD should remain low is 100 ms.
>>
> 
> ok - I will add a delayed work procedure to handle this.
> 
> By the way, how do I get/set EDID on a v4l2-subdev?

I have a patch for that adding support for this to v4l2-ctl, but it has not been
posted yet. I'll see if I can get it out today/tomorrow on the mailinglist.

> 
> root@ventana:~# v4l2-ctl -d4 --set-edid=pad=0,type=hdmi
> 
> CEA-861 Header
>   IT Formats Underscanned: yes
>   Audio:                   yes
>   YCbCr 4:4:4:             yes
>   YCbCr 4:2:2:             yes
> 
> Speaker Allocation Data Block
>   FL/FR:                   yes
>   LFE:                     no
>   FC:                      no
>   RL/RR:                   no
>   RC:                      no
>   FLC/FRC:                 no
>   RLC/RRC:                 no
>   FLW/FRW:                 no
>   FLH/FRH:                 no
>   TC:                      no
>   FCH:                     no
> 
> HDMI Vendor-Specific Data Block
>   Max TMDS Clock:          170 MHz
>   Physical Address:        1.0.0.0
>   YCbCr 4:4:4 Deep Color:  no
>   30-bit:                  no
>   36-bit:                  no
>   48-bit:                  no
>   Graphics:                yes
>   Photo:                   no
>   Cinema:                  no
>   Game:                    no
> 
> CEA-861 Video Capability Descriptor
>   RGB Quantization Range:  yes
>   YCC Quantization Range:  yes
>   PT:                      Always Underscanned
>   IT:                      Always Underscanned
>   CE:                      Always Underscanned
> 
> CEA-861 Colorimetry Data Block
>   xvYCC 601:               no
>   xvYCC 709:               no
>   sYCC:                    no
>   AdobeRGB:                no
>   AdobeYCC:                no
>   BT.2020 RGB:             no
>   BT.2020 YCC:             no
>   BT.2020 cYCC:            no
> 
> CEA-861 HDR Static Metadata Data Block
>   SDR (Traditional Gamma): yes
>   HDR (Traditional Gamma): no
>   SMPTE 2084:              no
> VIDIOC_S_EDID: failed: Inappropriate ioctl for device
> root@ventana:~#
> 
> I'm also not clear how to run v4l2-compliance on a v4l2-subdev, so I
> just ran it on one of the video devs from the capture driver I'm
> linked to via media-ctl.

Same problem with v4l2-ctl: no v4l-subdev support in v4l2-compliance yet.
Some work is done there as well.

> 
>>> +     return 0;
>>> +}
>>> +
>>> +static int tda1997x_get_dv_timings_cap(struct v4l2_subdev *sd,
>>> +                                    struct v4l2_dv_timings_cap *cap)
>>> +{
>>> +     *cap = tda1997x_dv_timings_cap;
>>> +     return 0;
>>> +}
>>> +
>>> +static int tda1997x_enum_dv_timings(struct v4l2_subdev *sd,
>>> +                                 struct v4l2_enum_dv_timings *timings)
>>> +{
>>> +     struct tda1997x_state *state = to_state(sd);
>>> +
>>> +     return v4l2_enum_dv_timings_cap(timings, &tda1997x_dv_timings_cap,
>>> +                                     tda1997x_check_dv_timings, state);
>>> +}
>>> +
>>> +static const struct v4l2_subdev_pad_ops tda1997x_pad_ops = {
>>> +     .enum_mbus_code = tda1997x_enum_mbus_code,
>>> +     .get_fmt = tda1997x_get_pad_format,
>>> +     .set_fmt = tda1997x_set_pad_format,
>>> +     .get_edid = tda1997x_get_edid,
>>> +     .set_edid = tda1997x_set_edid,
>>> +     .dv_timings_cap = tda1997x_get_dv_timings_cap,
>>> +     .enum_dv_timings = tda1997x_enum_dv_timings,
>>> +};
>>> +
>>> +/* -----------------------------------------------------------------------------
>>> + * v4l2_subdev_core_ops
>>> + */
>>> +
>>> +static int tda1997x_log_status(struct v4l2_subdev *sd)
>>> +{
>>> +     struct tda1997x_state *state = to_state(sd);
>>> +     const struct v4l2_dv_timings *timings = &state->timings;
>>> +
>>> +     v4l2_info(sd, "-----Signal status-----\n");
>>> +     if (!timings) {
>>
>> timings can never be NULL.
> 
> oops - yes, this should be if (!state->std) to detect signal status
> 
>>
>>> +             v4l2_info(sd, "no signal\n");
>>> +             return 0;
>>> +     }
>>> +     v4l2_info(sd, "resolution: %dx%d%c@%dHz\n",
>>> +               timings->bt.width, timings->bt.height,
>>> +               timings->bt.interlaced ? 'i' : 'p',
>>> +               state->fps);
>>> +     v4l2_print_dv_timings(sd->name, "Detected format: ",
>>> +                           timings, true);
>>> +     v4l2_info(sd, "colorspace: %d\n", state->colorspace);
>>> +     v4l2_info(sd, "colorimetry: %d\n", state->colorimetry);
>>> +     if (state->audio_channels)
>>> +             v4l2_info(sd, "audio: %dch %dHz\n", state->audio_channels,
>>> +                       state->audio_samplerate);
>>> +             else
>>> +                     v4l2_info(sd, "audio: none\n");
>>> +     v4l2_info(sd, "vendor: %s\n", state->vendor);
>>> +     v4l2_info(sd, "product: %s\n", state->product);
>>
>> If at all possible you should log the received InfoFrames here (hdmi_infoframe_log).
>> Also whether an EDID is loaded or not and the HPD state.
>>
>> If the hardware supports 5V detection, then you should log that too. In that case
>> also implement support for the V4L2_CID_DV_RX_POWER_PRESENT control.
>>
>> Also any information on the signal detection (clock lock, sync lock(s), whatever).
>>
>> This all helps enormously when debugging problems. It's important to spend some
>> time on this function. The adv7604.c source might be a good place to look for
>> inspiration.
> 
> ok - I will add what I can.
> 
> I can't figure out how to use log-status on a subdev either:
> 
> root@ventana:~# cat /sys/class/video4linux/v4l-subdev1/name
> tda19971 2-0048
> root@ventana:~# v4l2-ctl -d /dev/v4l-subdev1 --log-status
> VIDIOC_QUERYCAP: failed: Inappropriate ioctl for device
> /dev/v4l-subdev1: not a v4l2 node

Should be fixed once v4l-subdev support is added to v4l2-ctl.

> 
>>
>>> +
>>> +     return 0;
>>> +}
>>> +
> <snip>
>>> +
>>> +static int tda1997x_core_init(struct v4l2_subdev *sd)
>>> +{
>>> +     struct tda1997x_state *state = to_state(sd);
>>> +     struct tda1997x_platform_data *pdata = &state->pdata;
>>> +     u8 reg;
>>> +     int i;
>>> +
>>> +     /* disable HPD */
>>> +     io_write(sd, REG_HPD_AUTO_CTRL, HPD_AUTO_HPD_UNSEL);
>>> +     if (state->chip_revision == 0) {
>>> +             io_write(sd, REG_MAN_SUS_HDMI_SEL, MAN_DIS_HDCP | MAN_RST_HDCP);
>>> +             io_write(sd, REG_CGU_DBG_SEL, 1 << CGU_DBG_CLK_SEL_SHIFT);
>>> +     }
>>> +
>>> +     /* reset infoframe at end of start-up-sequencer */
>>> +     io_write(sd, REG_SUS_SET_RGB2, 0x06);
>>> +     io_write(sd, REG_SUS_SET_RGB3, 0x06);
>>> +
>>> +     /* Enable TMDS pull-ups */
>>> +     io_write(sd, REG_RT_MAN_CTRL, RT_MAN_CTRL_RT |
>>> +              RT_MAN_CTRL_RT_B | RT_MAN_CTRL_RT_A);
>>> +
>>> +     /* enable sync measurement timing */
>>> +     tda1997x_cec_write(sd, REG_PWR_CONTROL & 0xff, 0x04);
>>> +     /* adjust CEC clock divider */
>>> +     tda1997x_cec_write(sd, REG_OSC_DIVIDER & 0xff, 0x03);
>>> +     tda1997x_cec_write(sd, REG_EN_OSC_PERIOD_LSB & 0xff, 0xa0);
>>> +     io_write(sd, REG_TIMER_D, 0x54);
>>> +     /* enable power switch */
>>> +     reg = tda1997x_cec_read(sd, REG_CONTROL & 0xff);
>>> +     reg |= 0x20;
>>> +     tda1997x_cec_write(sd, REG_CONTROL & 0xff, reg);
>>> +     mdelay(50);
>>> +
>>> +     /* read the chip version */
>>> +     reg = io_read(sd, REG_VERSION);
>>> +     /* get the chip configuration */
>>> +     reg = io_read(sd, REG_CMTP_REG10);
>>> +
>>> +     /* enable interrupts we care about */
>>> +     io_write(sd, REG_INT_MASK_TOP,
>>> +              INTERRUPT_HDCP | INTERRUPT_AUDIO | INTERRUPT_INFO |
>>> +              INTERRUPT_RATE | INTERRUPT_SUS);
>>> +     /* config_mtp,fmt,sus_end,sus_st */
>>> +     io_write(sd, REG_INT_MASK_SUS, MASK_MPT | MASK_FMT | MASK_SUS_END);
>>> +     /* rate stability change for inputs A/B */
>>> +     io_write(sd, REG_INT_MASK_RATE, MASK_RATE_B_ST | MASK_RATE_A_ST);
>>> +     /* aud,spd,avi*/
>>> +     io_write(sd, REG_INT_MASK_INFO,
>>> +              MASK_AUD_IF | MASK_SPD_IF | MASK_AVI_IF);
>>> +     /* audio_freq,audio_flg,mute_flg,fifo_err */
>>> +     io_write(sd, REG_INT_MASK_AUDIO,
>>> +              MASK_AUDIO_FREQ_FLG | MASK_AUDIO_FLG | MASK_MUTE_FLG |
>>> +              MASK_ERROR_FIFO_PT);
>>> +     /* HDCP C5 state reached */
>>> +     io_write(sd, REG_INT_MASK_HDCP, MASK_STATE_C5);
>>> +     /* don't care about AFE/DDC/MODE */
>>> +     io_write(sd, REG_INT_MASK_AFE, 0);
>>> +     io_write(sd, REG_INT_MASK_DDC, 0);
>>> +     io_write(sd, REG_INT_MASK_MODE, 0);
>>> +
>>> +     /* clear all interrupts */
>>> +     io_write(sd, REG_INT_FLG_CLR_TOP, 0xff);
>>> +     io_write(sd, REG_INT_FLG_CLR_SUS, 0xff);
>>> +     io_write(sd, REG_INT_FLG_CLR_DDC, 0xff);
>>> +     io_write(sd, REG_INT_FLG_CLR_RATE, 0xff);
>>> +     io_write(sd, REG_INT_FLG_CLR_MODE, 0xff);
>>> +     io_write(sd, REG_INT_FLG_CLR_INFO, 0xff);
>>> +     io_write(sd, REG_INT_FLG_CLR_AUDIO, 0xff);
>>> +     io_write(sd, REG_INT_FLG_CLR_HDCP, 0xff);
>>> +     io_write(sd, REG_INT_FLG_CLR_AFE, 0xff);
>>> +
>>> +     /* init TMDS equalizer */
>>> +     if (state->chip_revision == 0)
>>> +             io_write(sd, REG_CGU_DBG_SEL, 1 << CGU_DBG_CLK_SEL_SHIFT);
>>> +     io_write24(sd, REG_CLK_MIN_RATE, CLK_MIN_RATE);
>>> +     io_write24(sd, REG_CLK_MAX_RATE, CLK_MAX_RATE);
>>> +     if (state->chip_revision == 0)
>>> +             io_write(sd, REG_WDL_CFG, WDL_CFG_VAL);
>>> +     /* DC filter */
>>> +     io_write(sd, REG_DEEP_COLOR_CTRL, DC_FILTER_VAL);
>>> +     /* disable test pattern */
>>> +     io_write(sd, REG_SVC_MODE, 0x00);
>>> +     /* update HDMI INFO CTRL */
>>> +     io_write(sd, REG_INFO_CTRL, 0xff);
>>> +     /* write HDMI INFO EXCEED value */
>>> +     io_write(sd, REG_INFO_EXCEED, 3);
>>> +
>>> +     if (state->chip_revision == 0)
>>> +             tda1997x_reset_n1(state);
>>> +
>>> +     /*
>>> +      * No HDCP acknowledge when HDCP is disabled
>>> +      * and reset SUS to force format detection
>>> +      */
>>> +     tda1997x_hdmi_info_reset(sd, NACK_HDCP, true);
>>> +
>>> +     /* Set HPD low */
>>> +     tda1997x_manual_hpd(sd, HPD_LOW_BP);
>>> +
>>> +     /* Configure receiver capabilities */
>>> +     io_write(sd, REG_HDCP_BCAPS, HDCP_HDMI | HDCP_FAST_REAUTH);
>>> +
>>> +     /* Configure HDMI: Auto HDCP mode, packet controlled mute */
>>> +     reg = HDMI_CTRL_MUTE_AUTO << HDMI_CTRL_MUTE_SHIFT;
>>> +     reg |= HDMI_CTRL_HDCP_AUTO << HDMI_CTRL_HDCP_SHIFT;
>>> +     io_write(sd, REG_HDMI_CTRL, reg);
>>> +
>>> +     /* reset start-up-sequencer to force format detection */
>>> +     tda1997x_hdmi_info_reset(sd, 0, true);
>>> +
>>> +     /* Set HPD high */
>>> +     tda1997x_manual_hpd(sd, HPD_HIGH_OTHER);
>>> +     tda1997x_manual_hpd(sd, HPD_HIGH_BP);
>>
>> How can you set the HPD high if there is no EDID? No EDID, no HPD.
>>
> 
> right - I'll remove this
> 
>>> +
>>> +     /* disable matrix conversion */
>>> +     reg = io_read(sd, REG_VDP_CTRL);
>>> +     reg |= VDP_CTRL_MATRIX_BP;
>>> +     io_write(sd, REG_VDP_CTRL, reg);
>>> +
> <snip>
>>> +
>>> +     ret = 0x34 + ((io_read(sd, REG_SLAVE_ADDR)>>4) & 0x03);
>>> +     state->client_cec = i2c_new_dummy(client->adapter, ret);
>>> +     v4l_info(client, "CEC slave address 0x%02x\n", ret);
>>> +
>>> +     ret = tda1997x_core_init(sd);
>>
>> Unless I missed it, I don't think state->timings has been initialized
>> to something valid. During probe the hdmi receiver has to be initialized
>> to something. The API expects that. Usually VGA or 720p60 or 1080p60 is
>> chosen for this.
> 
> you didn't miss it - I didn't know exactly what to do there.
> 
> I'll initialize it to VGA
> 
>>
>>> +     if (ret)
>>> +             goto err_free_mutex;
>>> +
> <snip>
>>>
>>
>> Regards,
>>
>>         Hans
> 
> Regarding video standard detection where this chip provides me with
> vertical-period, horizontal-period, and horizontal-pulse-width I
> should be able to detect the standard simply based off of
> vertical-period (framerate) and horizontal-period (line width
> including blanking) right? I wasn't sure if my method of matching
> these within 14% tolerance made sense. I will be removing the hsmatch
> logic from that as it seems the horizontal-pulse-width should be
> irrelevant.

For proper video detection you ideally need:

h/v sync size
h/v back/front porch size
h/v polarity
pixelclock (usually an approximation)

The v4l2_find_dv_timings_cap() helper can help you find the corresponding
timings, allowing for pixelclock variation.

That function assumes that the sync/back/frontporch values are all known.
But not all devices can actually discover those values. What can your
hardware detect? Can it tell front and backporch apart? Can it determine
the sync size?

I've been considering for some time to improve that helper function to be
able to handle hardware that isn't able separate sync/back/frontporch values.

Regards,

	Hans
