Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f169.google.com ([209.85.128.169]:45848 "EHLO
        mail-wr0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752329AbdKDAR5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Nov 2017 20:17:57 -0400
Received: by mail-wr0-f169.google.com with SMTP id y9so3861691wrb.2
        for <linux-media@vger.kernel.org>; Fri, 03 Nov 2017 17:17:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ+vNU2a8qtL4hbg5FQamF3WanQG1610QsJv=2cCxpD8OsiQ6w@mail.gmail.com>
References: <1507783506-3884-1-git-send-email-tharvey@gateworks.com>
 <1507783506-3884-4-git-send-email-tharvey@gateworks.com> <230ceb18-1d69-7fa8-acb0-c810094f8e50@xs4all.nl>
 <CAJ+vNU0Z988G+wTfpiSXXOM9QsPj-eRvH=F1b9__8kJ+18xk4g@mail.gmail.com>
 <a5bd27c9-10e4-b9f5-f0ac-293528fa570e@xs4all.nl> <CAJ+vNU2yHKDf5tCVyj6iw83z0sDuV0ZsZ-=sLfa+fTFbtjVo0A@mail.gmail.com>
 <5c68003a-380d-d339-718f-47bce64cdae8@xs4all.nl> <CAJ+vNU2a8qtL4hbg5FQamF3WanQG1610QsJv=2cCxpD8OsiQ6w@mail.gmail.com>
From: Tim Harvey <tharvey@gateworks.com>
Date: Fri, 3 Nov 2017 17:17:55 -0700
Message-ID: <CAJ+vNU1ipKzm5AX4HY0ckrBM3aMC1mn0Dp7nQfsjzJcEYgBV5Q@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] media: i2c: Add TDA1997x HDMI receiver driver
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

On Mon, Oct 23, 2017 at 10:05 AM, Tim Harvey <tharvey@gateworks.com> wrote:
>
> On Fri, Oct 20, 2017 at 9:23 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> >>
> >> I see the AVI infoframe has hdmi_quantization_range and
> >> hdmi_ycc_quantization_range along with vid_code.
> >>
> >> I'm not at all clear what to do with this information. Is there
> >> anything you see in the datasheet [1] that points to something I need
> >> to be doing?
> >
> > You can ignore hdmi_ycc_quantization_range, it is the hdmi_quantization_range
> > that you need to read out.
> >
> > The TDA can receive the following formats:
> >
> > RGB Full Range
> > RGB Limited Range
> > YUV Bt.601 (aka SMPTE 170M)
> > YUV Rec.709
> >
> > The YUV formats are always limited range.
> >
> > The TDA can transmit RGB and YUV to the SoC. You want RGB to be full range and
> > YUV to be limited range. YUV can be either 601 or 709.
> >
> > So if the TDA transmits RGB then you need to support the following conversions:
> >
> > RGB Full -> RGB Full
> > RGB Limited -> RGB Full
> > YUV 601 -> RGB Full
> > YUV 709 -> RGB Full
> >
> > And if the TDA transmits YUV then you need these conversions:
> >
> > RGB Full -> YUV601 or YUV709
> > RGB Limited -> YUV601 or YUV709
> > YUV601 -> YUV601
> > YUV709 -> YUV709
> >
> > For the RGB to YUV conversion you have a choice of converting to YUV601 or 709.
> > I recommend to either always convert to YUV601 or to let it depend on the resolution
> > (SDTV YUV601, HDTV YUV709).
> >
>
> Ok - this is a good explanation that I should be able to follow. I
> will make sure to take into account hdmi_quantization_range when I
> setup the colorspace conversion matrix for v3.

Hans,

I'm having trouble figuring out the conversion matrix to use between
limited and full.

Currently I have the following conversion matrices, the values which
came from some old vendor code:

        /* Colorspace conversion matrix coefficients and offsets */
        struct color_matrix_coefs {
                /* Input offsets */
                s16 offint1;
                s16 offint2;
                s16 offint3;
                /* Coeficients */
                s16 p11coef;
                s16 p12coef;
                s16 p13coef;
                s16 p21coef;
                s16 p22coef;
                s16 p23coef;
                s16 p31coef;
                s16 p32coef;
                s16 p33coef;
                /* Output offsets */
                s16 offout1;
                s16 offout2;
                s16 offout3;
        };
        /* Conversion matrixes */
        enum {
                ITU709_RGBLIMITED,
                ITU601_RGBLIMITED,
                RGBLIMITED_ITU601,
       };
       static const struct color_matrix_coefs conv_matrix[] = {
                /* ITU709 -> RGBLimited */
                {
                        -256, -2048,  -2048,
                        4096, -1875,   -750,
                        4096,  6307,      0,
                        4096,     0,   7431,
                         256,   256,    256,
                },
                /* YUV601 limited -> RGB limited */
                {
                        -256, -2048,  -2048,
                        4096, -2860,  -1378,
                        4096,  5615,      0,
                        4096,     0,   7097,
                        256,    256,    256,
                },
                /* RGB limited -> ITU601 */
                {
                        -256,  -256,   -256,
                        2404,  1225,    467,
                        -1754, 2095,   -341,
                        -1388, -707,   2095,
                        256,   2048,   2048,
                },
        };

Assuming the above are correct this leaves me missing RGB limitted ->
RGB full, YUV601 -> RGB full, YUV709 -> RGB full, and RGB Full ->
YUV601.

I don't have documentation for the registers but I'm assuming the
input offset is applied first, then the multiplication by the coef,
then the output offset is applied. I'm looking over
https://en.wikipedia.org/wiki/YUV for colorspace conversion matrices
but I'm unable to figure out how to apply those to the above. Any
ideas?

Thanks,

Tim
