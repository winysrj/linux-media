Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f169.google.com ([209.85.128.169]:43751 "EHLO
        mail-wr0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751565AbeERR4f (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 13:56:35 -0400
Received: by mail-wr0-f169.google.com with SMTP id v15-v6so10018840wrm.10
        for <linux-media@vger.kernel.org>; Fri, 18 May 2018 10:56:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <m3fu2oswjh.fsf@t19.piap.pl>
References: <m37eobudmo.fsf@t19.piap.pl> <b6e7ba76-09a4-2b6a-3c73-0e3ef92ca8bf@gmail.com>
 <m3tvresqfw.fsf@t19.piap.pl> <08726c4a-fb60-c37a-75d3-9a0ca164280d@gmail.com> <m3fu2oswjh.fsf@t19.piap.pl>
From: Tim Harvey <tharvey@gateworks.com>
Date: Fri, 18 May 2018 10:56:33 -0700
Message-ID: <CAJ+vNU3WxSPe9jHRnajU0CNurMS4vMVakh4W0vb197caQhKP7g@mail.gmail.com>
Subject: Re: i.MX6 IPU CSI analog video input on Ventana
To: =?UTF-8?Q?Krzysztof_Ha=C5=82asa?= <khalasa@piap.pl>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media <linux-media@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 18, 2018 at 10:28 AM, Krzysztof Ha=C5=82asa <khalasa@piap.pl> w=
rote:
> Steve Longerbeam <slongerbeam@gmail.com> writes:
>
>> Yes, the CSI on i.MX6 does not deal well with unstable bt.656 sync codes=
,
>> which results in vertical sync issues (scrolling or split images). The
>> ADV7180
>> will often shift the sync codes around in various situations (initial
>> power on,
>> see below, also when there is an interruption of the input analog CVBS
>> signal).
>
> I'm not convinced it's the sync code issue. I've compared the key
> registers (both 4.2 + your old driver vs 4.16) and this is what I got:
>
> "adv7180 2-0020":0 [fmt:UYVY2X8/720x576 field:interlaced]
> "ipu2_csi1_mux":1  [fmt:UYVY2X8/720x576 field:interlaced]
> "ipu2_csi1_mux":2  [fmt:UYVY2X8/720x576 field:interlaced]
> "ipu2_csi1":0      [fmt:UYVY2X8/720x576 field:interlaced]
> "ipu2_csi1":2      [fmt:AYUV32/720x576 field:none]
>
> There is H sync but no V sync. The encoding is wrong (I'm using NV12 but
> what I get from /dev/video* isn't NV12).
>
> IPU2_CSI1 registers are:
>                 0        4        8 C 10       14       18       1C
> 2a38000: 04000A20 023F02CF 023F02CF 0  0 00040030 00000000 00FF0000
> vs the old driver:
>          04000A30 027002CF 023F02CF 0  0 01040596 000D07DF 00FF0000
>
> 0: CSI1 Sensor Configuration (IPUx_CSI1_SENS_CONF)
> The new driver uses progressive mode while the old one - interlaced
> mode.
>
> 4: CSI1 Sense Frame Size Register (IPUx_CSI1_SENS_FRM_SIZE)
> The new driver uses 575 lines in place of 624 (this probably needs to be
> checked with the ADV7180 docs, though the old version works fine).
>
> 14, 18: CSI1 CCIR Code Register 1 and 2 (IPUx_CSI1_CCIR_CODE_[12])
> The new driver doesn't use "Error detection and correction" and it seems
> the codes are set for progressive mode. I think this can't work.
>
>
> With:
> "adv7180 2-0020":0 [fmt:UYVY2X8/720x576 field:interlaced]
> "ipu2_csi1_mux":1  [fmt:UYVY2X8/720x576 field:none]
> "ipu2_csi1_mux":2  [fmt:UYVY2X8/720x576 field:none]
> "ipu2_csi1":0      [fmt:UYVY2X8/720x576 field:none]
> "ipu2_csi1":2      [fmt:AYUV32/720x576 field:none]
>
> Still, V sync but no H sync. The Y/colors are good, except that
> there are two consecutive images on the screen.
> 2a38000: 04000A20 023F02CF 023F02CF 0  0 00040030 00000000 00FF0000
> CSI set to progressive again. Setting the registers manually (SENS_CONF
> and SAV/EAV codes) makes the image stabilize, though there are still two
> images (split in the middle). Apparently something is simply appending
> the two field images, instead of merging them properly.
>
>
> With:
> "adv7180 2-0020":0 [fmt:UYVY2X8/720x576 field:interlaced]
> "ipu2_csi1_mux":1  [fmt:UYVY2X8/720x576 field:interlaced]
> "ipu2_csi1_mux":2  [fmt:UYVY2X8/720x576 field:interlaced]
> "ipu2_csi1":0      [fmt:UYVY2X8/720x576 field:interlaced]
> "ipu2_csi1":2      [fmt:AYUV32/720x576 field:interlaced]
>
> 2a38000: 04000A30 027002CF 023F02CF 0  0 01040596 000D07DF 00FF0000
> the CSI is set for interlaced mode, and there are two stable images
> (both fields concatenated).
>
>
> The first case again (all except ipu2_csi1 set to interlaced). I've
> manually set the CSI registers and now the image is synchronized and
> stable (one complete frame this time). The problem is it's not NV12
> (nor YUV420), the colors are all green and the Y lines comes in pairs -
> valid then invalid (probably color) and so on.
>
>
> Could it be a DTS problem? I'm using imx6q-gw53xx.dtb file,
> the 8-bit ADV7180 (40 pin version) is connected to the IPU2 CSI1 DATA,
> EIM_EB3 =3D HSYNC, EIM_A16 =3D PIXCLK and EIM_D29 =3D VSYNC. HSYNC and VS=
YNC
> aren't currently used, though.
>
> I Guess I have to compare all IPU registers.

Krzysztof,

What version of kernel are you using and what specific board model do
you have (full board model and/or serial number so I know if you've
got an IMX6DL or an IMX6Q) and have you modified the device-tree? I
tested the adv7180 a couple of months ago but I don't know if I hit
your specific combination. I was using NTSC but if your not getting
VSYNC then yes I would like to make sure the pinmux is correct for
your situation.

Thanks,

Tim
