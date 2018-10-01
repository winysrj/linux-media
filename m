Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36256 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728921AbeJASxg (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 1 Oct 2018 14:53:36 -0400
Received: by mail-wr1-f68.google.com with SMTP id y16so5434722wrw.3
        for <linux-media@vger.kernel.org>; Mon, 01 Oct 2018 05:16:05 -0700 (PDT)
MIME-Version: 1.0
References: <20180928142816.4311-1-mjourdan@baylibre.com> <cfb89cf9-4fce-7fab-48e1-a0311b80d993@xs4all.nl>
In-Reply-To: <cfb89cf9-4fce-7fab-48e1-a0311b80d993@xs4all.nl>
From: Maxime Jourdan <mjourdan@baylibre.com>
Date: Mon, 1 Oct 2018 14:15:53 +0200
Message-ID: <CAMO6nayt+3e7m5AkTbsJJHzO-uyc-Jh66i3kG97CX5FabwHUOA@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] Add Amlogic video decoder driver
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le lun. 1 oct. 2018 =C3=A0 12:29, Hans Verkuil <hverkuil@xs4all.nl> a =C3=
=A9crit :
>
> On 09/28/2018 04:28 PM, Maxime Jourdan wrote:
> > Hi everyone,
> >
> > This patch series adds support for the Amlogic video decoder,
> > as well as the corresponding dt bindings for GXBB/GXL/GXM chips.
> >
> > It features decoding for the following formats:
> > - MPEG 1
> > - MPEG 2
> >
> > The following formats will be added in future patches:
> > - MJPEG
> > - MPEG 4 (incl. Xvid, H.263)
> > - H.264
> > - HEVC (incl. 10-bit)
> >
> > The following formats' development has still not started, but they are
> > supported by the hardware:
> > - VC1
> > - VP9
> >
> > The code was made in such a way to allow easy inclusion of those format=
s
> > in the future.
> >
> > The decoder is single instance.
> >
> > Files:
> >  - vdec.c handles the V4L2 M2M logic
> >  - esparser.c manages the hardware bitstream parser
> >  - vdec_helpers.c provides helpers to DONE the dst buffers as well as
> >  various common code used by the codecs
> >  - vdec_1.c manages the VDEC_1 block of the vdec IP
> >  - codec_mpeg12.c enables decoding for MPEG 1/2.
> >  - vdec_platform.c links codec units with vdec units
> >  (e.g vdec_1 with codec_mpeg12) and lists all the available
> >  src/dst formats and requirements (max width/height, etc.),
> >  per compatible chip.
> >
> > Firmwares are necessary to run the vdec. They can currently be found at=
:
> > https://github.com/chewitt/meson-firmware
>
> Are you trying to get this into the linux-firmware repository?
>
> I believe that Mauro requires that before he will merge this driver.
>
> So I think this driver will be ready to be merged once v4 is posted,
> dt-bindings is Acked and the firmware is merged to the linux-firmware rep=
o.

It was planned indeed to get the firmwares into linux-firmware, I'll
speed this up.

dt-bindings was reviewed by Rob but I forgot to add it in v3, I'll fix
that in v4.

Cheers,
Maxime

> Regards,
>
>         Hans
