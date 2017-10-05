Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:48469 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751178AbdJERGI (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Oct 2017 13:06:08 -0400
Received: by mail-wm0-f52.google.com with SMTP id i124so3320235wmf.3
        for <linux-media@vger.kernel.org>; Thu, 05 Oct 2017 10:06:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171004211411.27gxy5wnaymdcm3z@rob-hp-laptop>
References: <1506119053-21828-1-git-send-email-tharvey@gateworks.com>
 <1506119053-21828-3-git-send-email-tharvey@gateworks.com> <20171004211411.27gxy5wnaymdcm3z@rob-hp-laptop>
From: Tim Harvey <tharvey@gateworks.com>
Date: Thu, 5 Oct 2017 10:06:06 -0700
Message-ID: <CAJ+vNU2+7FWqPjBrKBcuKo8y4BKNnRNGhp8NkA3rJOGApaOdoQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] media: dt-bindings: Add bindings for TDA1997X
To: Rob Herring <robh@kernel.org>
Cc: linux-media <linux-media@vger.kernel.org>,
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

On Wed, Oct 4, 2017 at 2:14 PM, Rob Herring <robh@kernel.org> wrote:
> On Fri, Sep 22, 2017 at 03:24:11PM -0700, Tim Harvey wrote:
>> Signed-off-by: Tim Harvey <tharvey@gateworks.com>
>

Hi Rob, thanks for the review!

I will add a commit message, vendor prefix to non-standard props, and
remove '_' in the next revision.

>
>> +
>> +Optional Properties:
>> + - max-pixel-rate  : Maximum pixel rate supported by the SoC (MP/sec)
>> + - audio-port      : parameters defining audio output port connection
>
> That description is meaningless to me.
>
<snip>>
>> +The Audio output port consists of A_CLK, A_WS, AP0, AP1, AP2, and AP3 pins
>> +and can support up to 8-chanenl audio using the following audio bus DAI formats:
>> + - I2S16
>> + - I2S32
>> + - SPDIF
>> + - OBA (One-Bit-Audio)
>> + - I2S16_HBR_STRAIGHT (High Bitrate straight through)
>> + - I2S16_HBR_DEMUX (High Bitrate demuxed)
>> + - I2S32_HBR_DEMUX (High Bitrate demuxed)
>> + - DST (Direct Stream Transfer)
>
> This either should be a standard, common property or not be in DT.
> Practically every system is going to have at least one end of the
> connection that is configurable. The kernel should be able to get lists
> of supported modes and pick one.
>

I struggled with 'audio-port' property quite a bit.

Looking at the datasheet a bit closer
(http://dev.gateworks.com/datasheets/TDA19971-datasheet-rev3.pdf) I
see that the audio output port consisting of WS, AP[0:3], CLK really
only supports I2S and S/PDIF output modes. The AP[0:3] provide support
for up to 8 audio channels. The way these pins are used is defined in
Table 5/6/7 in the datasheet but I think that the dt perhaps only
needs to number of data lines (1-4) (which could also be represented
as channels (1-8)), and a clock multiplier which could be described as
a 'mclk-fs' multiplication factor like simple-audio bindings does.

What would your recommendation be here?

>> +
<snip>
>> +             max-pixel-rate = <180>; /* IMX6 CSI max pixel rate 180MP/sec */
>
> That's a constraint that belongs in the i.MX CSI node or driver.

right - that makes sense. I'll talk to the maintainer of the i.MX CSI
driver to see what they think.

>
>> +
>> +             port@0 {
>> +                     reg = <0>;
>> +             };
>> +             port@1 {
>
> You need to describe how many ports and what they are.

ok. My example was a mistake anyway and I propose a single output port such as:

The device node must contain one 'port' child node for its digital output
video port, in accordance with the video interface bindings defined in
Documentation/devicetree/bindings/media/video-interfaces.txt.

Example:
                port {
                        tda1997x_to_ipu1_csi0_mux: endpoint {
                                remote-endpoint =
<&ipu1_csi0_mux_from_parallel_sensor>;
                                bus-width = <16>;
                                hsync-active = <1>;
                                vsync-active = <1>;
                                data-active = <1>;
                        };
                };

>
>> +                     reg = <1>;
>> +                     hdmi_in: endpoint {
>> +                             remote-endpoint = <&ccdc_in>;
>> +                     };
>> +             };
>> +     };
>> + - VP[15:8] connected to IMX6 CSI_DATA[19:12] for 8bit BT656
>> +   16bit I2S layout0 with a 128*fs clock (A_WS, AP0, A_CLK pins)
>
> Do you really need 2 examples? It should be possible to figure out other
> configurations with better descriptions above.
>

Perhaps, but I feel like the vidout-portcfg is pretty confusing and
wanted to provide some different mappings as examples. The
vidout-portcfg property allows you to shift the bits around on the
output pins per 4-bit groups as well as reverse their order and
different defines are used depending on RGB444/YUV444/YUV422/BT656. I
could provide just portcfg examples above the full dts example though
under the short description of 'nxp,vidout-portcfg'.

Regards,

Tim
