Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:41633 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751537AbdKWII6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Nov 2017 03:08:58 -0500
Subject: Re: [PATCH 3/5] media: i2c: Add TDA1997x HDMI receiver driver
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
References: <1510253136-14153-1-git-send-email-tharvey@gateworks.com>
 <1510253136-14153-4-git-send-email-tharvey@gateworks.com>
 <4048cb21-c65c-6282-a1d7-81ad9a0d7cfa@xs4all.nl>
 <CAJ+vNU0q4Ab-1sFsyQv3JRMd54ntMU3=Er6yCNiY=tLCN1N5VQ@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <0f5227cb-913b-1d55-0b1a-5c41d68f5bf9@xs4all.nl>
Date: Thu, 23 Nov 2017 09:08:51 +0100
MIME-Version: 1.0
In-Reply-To: <CAJ+vNU0q4Ab-1sFsyQv3JRMd54ntMU3=Er6yCNiY=tLCN1N5VQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/23/2017 05:27 AM, Tim Harvey wrote:
> On Mon, Nov 20, 2017 at 7:39 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> Hi Tim,
>>
>> Some more review comments:
>>
>> On 11/09/2017 07:45 PM, Tim Harvey wrote:
>>> Add support for the TDA1997x HDMI receivers.
> <snip>
>>> + */
>>> +struct color_matrix_coefs {
>>> +     const char *name;
>>> +     /* Input offsets */
>>> +     s16 offint1;
>>> +     s16 offint2;
>>> +     s16 offint3;
>>> +     /* Coeficients */
>>> +     s16 p11coef;
>>> +     s16 p12coef;
>>> +     s16 p13coef;
>>> +     s16 p21coef;
>>> +     s16 p22coef;
>>> +     s16 p23coef;
>>> +     s16 p31coef;
>>> +     s16 p32coef;
>>> +     s16 p33coef;
>>> +     /* Output offsets */
>>> +     s16 offout1;
>>> +     s16 offout2;
>>> +     s16 offout3;
>>> +};
>>> +
>>> +enum {
>>> +     ITU709_RGBLIMITED,
>>> +     ITU709_RGBFULL,
>>> +     ITU601_RGBLIMITED,
>>> +     ITU601_RGBFULL,
>>> +     RGBLIMITED_RGBFULL,
>>> +     RGBLIMITED_ITU601,
>>> +     RGBFULL_ITU601,
>>
>> This can't be right.
>> ITU709_RGBLIMITED
>> You have these conversions:
>>
>> ITU709_RGBFULL
>> ITU601_RGBFULL
>> RGBLIMITED_RGBFULL
>> RGBLIMITED_ITU601
>> RGBFULL_ITU601
>> RGBLIMITED_ITU709
>> RGBFULL_ITU709
>>
>> I.e. on the HDMI receiver side you can receive RGB full/limited or ITU601/709.
>> On the output side you have RGB full or ITU601/709.
>>
>> So something like ITU709_RGBLIMITED makes no sense.
>>
> 
> I misunderstood the V4L2_CID_DV_RX_RGB_RANGE thinking that it allowed
> you to configure the output range. If output to the SoC is only ever
> full quant range for RGB then I can drop the
> ITU709_RGBLIMITED/ITU601_RGBLIMITED conversions.

Output for RGB is always full range. The reason is simply that the V4L2 API
has no way of selecting the quantization range it wants to receive. I made
a patch for that a few years back, but there really is no demand for it (yet).
Userspace expects full range RGB and limited range YUV.

> 
> However, If the output is YUV how do I know if I need to convert to
> ITU709 or ITU601 and what are my conversion matrices for
> RGBLIMITED_ITU709/RGBFULL_ITU709?

You can choose yourself whether you convert to YUV 601 or 709. I would
recommend to use 601 for SDTV resolutions (i.e. width/height <= 720x576)
and 709 for HDTV.

I made a little program that calculates the values for RGB lim/full to
YUV 601/709:

-------------------------------------
#include <stdlib.h>
#include <stdio.h>

#define COEFF(v, r) ((v) * (r) * 16.0)

static const double bt601[3][3] = {
	{ COEFF(0.299, 219),   COEFF(0.587, 219),   COEFF(0.114, 219)   },
	{ COEFF(-0.1687, 224), COEFF(-0.3313, 224), COEFF(0.5, 224)     },
	{ COEFF(0.5, 224),     COEFF(-0.4187, 224), COEFF(-0.0813, 224) },
};
static const double rec709[3][3] = {
	{ COEFF(0.2126, 219),  COEFF(0.7152, 219),  COEFF(0.0722, 219)  },
	{ COEFF(-0.1146, 224), COEFF(-0.3854, 224), COEFF(0.5, 224)     },
	{ COEFF(0.5, 224),     COEFF(-0.4542, 224), COEFF(-0.0458, 224) },
};

int main(int argc, char **argv)
{
	int i, j;
	int mapi[] = { 0, 2, 1 };
	int mapj[] = { 1, 0, 2 };

	printf("rgb full -> 601\n");
	printf("    0,     0,     0,\n");
	for (i = 0; i < 3; i++) {
		for (j = 0; j < 3; j++) {
			printf("%5d, ",  (int)(0.5 + bt601[mapi[i]][mapj[j]]));
		}
		printf("\n");
	}
	printf("  256,  2048,  2048,\n\n");

	printf("rgb lim -> 601\n");
	printf(" -256,  -256,  -256,\n");
	for (i = 0; i < 3; i++) {
		for (j = 0; j < 3; j++) {
			printf("%5d, ",  (int)(0.5 + 255.0 / 219.0 * bt601[mapi[i]][mapj[j]]));
		}
		printf("\n");
	}
	printf("  256,  2048,  2048,\n\n");

	printf("rgb full -> 709\n");
	printf("    0,     0,     0,\n");
	for (i = 0; i < 3; i++) {
		for (j = 0; j < 3; j++) {
			printf("%5d, ",  (int)(0.5 + rec709[mapi[i]][mapj[j]]));
		}
		printf("\n");
	}
	printf("  256,  2048,  2048,\n\n");

	printf("rgb lim -> 709\n");
	printf(" -256,  -256,  -256,\n");
	for (i = 0; i < 3; i++) {
		for (j = 0; j < 3; j++) {
			printf("%5d, ",  (int)(0.5 + 255.0 / 219.0 * rec709[mapi[i]][mapj[j]]));
		}
		printf("\n");
	}
	printf("  256,  2048,  2048,\n\n");
	return 0;
}
-------------------------------------

This should give you the needed matrices. It's up to you whether to keep the
existing matrices for 601 or replace them with these. Probably best to keep
them.

> 
> Sorry for all the questions, the colorspace/colorimetry options
> confuse the heck out of me.
> 
>>> +};
>>> +
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
>>> +             state->range = frame.avi.quantization_range;
>>
>> This should be ignored if it is overridden by the RGB Quantization Range
>> control, or am I missing something?
>>
> 
> Ok. Sounds like I should only use the range from the infoframe if
> range == V4L2_DV_RGB_RANGE_AUTO:
> 
>                 /* Quantization Range */
>                 if (state->range == V4L2_DV_RGB_RANGE_AUTO)
>                         state->range = frame.avi.quantization_range;

Huh? You're mixing V4L2_DV_RGB_* defines with HDMI_QUANTIZATION_RANGE_*
defines.

You probably mean to check the control value here.

>                 if (state->range == HDMI_QUANTIZATION_RANGE_DEFAULT) {
>                         if (frame.avi.video_code <= 1)
>                                 state->range = HDMI_QUANTIZATION_RANGE_FULL;
>                         else
>                                 state->range = HDMI_QUANTIZATION_RANGE_LIMITED;
>                 }
> 
> 
>>> +             state->content = frame.avi.content_type;
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
>>> +                             break;
>>> +                     }
>>> +             }
>>> +             /* if range not specified */
>>> +             if (state->range == HDMI_QUANTIZATION_RANGE_DEFAULT) {
>>> +                     if (frame.avi.video_code == 0)
>>
>> This should be:
>>
>>                         if (frame.avi.video_code <= 1)
>>
>> VIC code 1 (VGA) is also full range. It's an exception to the rule.
> 
> ok
> 
> Thanks,
> 
> Tim
> 

Regards,

	Hans
