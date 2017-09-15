Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f171.google.com ([209.85.128.171]:45864 "EHLO
        mail-wr0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751164AbdIOX22 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Sep 2017 19:28:28 -0400
Received: by mail-wr0-f171.google.com with SMTP id m18so2820532wrm.2
        for <linux-media@vger.kernel.org>; Fri, 15 Sep 2017 16:28:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <67ab090e-955d-9399-e182-cca049a66f1a@gmail.com>
References: <CAJ+vNU3DPFEc6YnEfcYAv1=beJ96W5PSt=eBfoxCXqKnbNqfMg@mail.gmail.com>
 <67ab090e-955d-9399-e182-cca049a66f1a@gmail.com>
From: Tim Harvey <tharvey@gateworks.com>
Date: Fri, 15 Sep 2017 16:28:26 -0700
Message-ID: <CAJ+vNU3srz1u4x2wku4JKAOWGH8Gc8Wh0eo5aTEhACqoNeE1ow@mail.gmail.com>
Subject: Re: IMX6 ADV7180 no /dev/media
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Stephan Bauroth <der_steffi@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 15, 2017 at 3:26 PM, Steve Longerbeam <slongerbeam@gmail.com> wrote:
> Hi Tim,
>
>
> On 09/15/2017 02:26 PM, Tim Harvey wrote:
>>
>> Greetings,
>>
>> I'm testing Linux master built with imx_v6_v7_defconfig on a GW51xx which
>> has an ADV7180 analog video decoder and am not seeing the imx6 /dev/media
>> node get created:
>>
>> [    0.000000] OF: fdt: Machine model: Gateworks Ventana i.MX6 Dual/Quad
>> GW51XX
>> ...
>> [    6.089039] imx-media: Registered subdev ipu1_vdic
>> [    6.094505] imx-media: Registered subdev ipu2_vdic
>> [    6.099851] imx-media: Registered subdev ipu1_ic_prp
>> [    6.105074] imx-media: Registered subdev ipu1_ic_prpenc
>> [    6.111346] ipu1_ic_prpenc: Registered ipu1_ic_prpenc capture as
>> /dev/video0
>> [    6.119007] imx-media: Registered subdev ipu1_ic_prpvf
>> [    6.124733] ipu1_ic_prpvf: Registered ipu1_ic_prpvf capture as
>> /dev/video1
>> [    6.131867] imx-media: Registered subdev ipu2_ic_prp
>> [    6.137125] imx-media: Registered subdev ipu2_ic_prpenc
>> [    6.142921] ipu2_ic_prpenc: Registered ipu2_ic_prpenc capture as
>> /dev/video2
>> [    6.150226] imx-media: Registered subdev ipu2_ic_prpvf
>> [    6.155934] ipu2_ic_prpvf: Registered ipu2_ic_prpvf capture as
>> /dev/video3
>> [    6.164011] imx-media: Registered subdev ipu1_csi0
>> [    6.169768] ipu1_csi0: Registered ipu1_csi0 capture as /dev/video4
>> [    6.176281] imx-media: Registered subdev ipu1_csi1
>> [    6.181681] ipu1_csi1: Registered ipu1_csi1 capture as /dev/video5
>> [    6.188189] imx-media: Registered subdev ipu2_csi0
>> [    6.193680] ipu2_csi0: Registered ipu2_csi0 capture as /dev/video6
>> [    6.200108] imx-media: Registered subdev ipu2_csi1
>> [    6.205577] ipu2_csi1: Registered ipu2_csi1 capture as /dev/video7
>> ...
>> [   96.981117] adv7180 2-0020: chip found @ 0x20 (21a8000.i2c)
>> [   97.019674] imx-media: Registered subdev adv7180 2-0020
>> [   97.019712] imx-media capture-subsystem: Entity type for entity adv7180
>> 2-0020 was not initialized!
>>
>> I suspect the failure of the adv7180 is causing the issue. Steve mentioned
>> some time ago that this was an error that needed to be fixed upstream but
>> I'm not clear if that is still the case.
>>
>
> That does need fixing but is not the cause.
>
>> I haven't looked at IMX media drivers since they were accepted to mainline
>> a few months back. Perhaps I'm simply forgetting to enable something in the
>> kernel that imx_v6_v7_defconfig doesn't turn on?
>
>
> Yes, it looks like you are missing the video-mux. Enable CONFIG_VIDEO_MUX
> and CONFIG_MUX_MMIO.
>

Steve,

Indeed that was it! What clued you into that being the missing component?

Sounds like we need to enable that for imx_v6_v7_defconfig.

Thanks!

Tim
