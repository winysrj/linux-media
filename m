Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor4.renesas.com ([210.160.252.174]:64737 "EHLO
        relmlie3.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1757537AbeAHUyY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 Jan 2018 15:54:24 -0500
From: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
To: Hugues Fruchet <hugues.fruchet@st.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "Benjamin Gaignard" <benjamin.gaignard@linaro.org>
Subject: RE: [PATCH v5 0/5] Add OV5640 parallel interface and RGB565/YUYV
 support
Date: Mon, 8 Jan 2018 20:54:18 +0000
Message-ID: <TY1PR06MB0895C74B45AF75CEB9F7AA4BC0130@TY1PR06MB0895.apcprd06.prod.outlook.com>
References: <1514973452-10464-1-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1514973452-10464-1-git-send-email-hugues.fruchet@st.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hugues,

thank you for the patch series.
I am having a go with your patches, and although they seem alright, I don't=
 seem to be able to grab a non-black picture on the iWave iwg20d in plain D=
VP mode, but if I switch to BT656 just by setting register 0x4730 to 0x01 (=
I know, it's a nasty hack...) I can get something sensible out.

At the moment there is no proper BT656 support in the driver, I was wonderi=
ng if you have any plans to enhance the ov5640 driver a little bit further =
to add proper BT656 support as it may be convenient.

Do you know if someone else was able to get DVP to work by means of this pa=
tch series on a non-STM32 platform?

Thanks,
Fabrizio


> Subject: [PATCH v5 0/5] Add OV5640 parallel interface and RGB565/YUYV sup=
port
>
> Enhance OV5640 CSI driver to support also DVP parallel interface.
> Add RGB565 (LE & BE) and YUV422 YUYV format in addition to existing
> YUV422 UYVY format.
> Some other improvements on chip identifier check and removal
> of warnings in powering phase around gpio handling.
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =3D history =3D
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> version 5:
>   - Refine bindings as per Sakari suggestion:
>     https://www.mail-archive.com/linux-media@vger.kernel.org/msg124048.ht=
ml
>
> version 4:
>   - Refine bindings as per Sakari suggestion:
>     https://www.mail-archive.com/linux-media@vger.kernel.org/msg123609.ht=
ml
>   - Parallel port control lines polarity can now be configured through
>     devicetree
>
> version 3:
>   - Move chip identifier check at probe according to Fabio Estevam commen=
t:
>     https://www.mail-archive.com/linux-media@vger.kernel.org/msg122575.ht=
ml
>   - Use 16 bits register read for this check as per Steve Longerbeam comm=
ent:
>     https://www.mail-archive.com/linux-media@vger.kernel.org/msg122692.ht=
ml
>   - Update bindings to document parallel mode support as per Fabio Esteva=
m comment:
>     https://www.mail-archive.com/linux-media@vger.kernel.org/msg122576.ht=
ml
>   - Enable the whole 10 bits parallel output and document 8/10 bits suppo=
rt
>     in ov5640_set_stream_dvp() to answer to Steve Longerbeam comment:
>     https://www.mail-archive.com/linux-media@vger.kernel.org/msg122693.ht=
ml
>
> version 2:
>   - Fix comments from Sakari Ailus:
>     https://www.mail-archive.com/linux-media@vger.kernel.org/msg122259.ht=
ml
>   - Revisit ov5640_set_stream_dvp() to only configure DVP at streamon
>   - Revisit ov5640_set_stream_dvp() implementation with fewer register se=
ttings
>
> version 1:
>   - Initial submission
>
> Hugues Fruchet (5):
>   media: ov5640: switch to gpiod_set_value_cansleep()
>   media: ov5640: check chip id
>   media: dt-bindings: ov5640: refine CSI-2 and add parallel interface
>   media: ov5640: add support of DVP parallel interface
>   media: ov5640: add support of RGB565 and YUYV formats
>
>  .../devicetree/bindings/media/i2c/ov5640.txt       |  46 ++-
>  drivers/media/i2c/ov5640.c                         | 325 +++++++++++++++=
+++---
>  2 files changed, 324 insertions(+), 47 deletions(-)
>
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



Renesas Electronics Europe Ltd, Dukes Meadow, Millboard Road, Bourne End, B=
uckinghamshire, SL8 5FH, UK. Registered in England & Wales under Registered=
 No. 04586709.
