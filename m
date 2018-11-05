Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io1-f66.google.com ([209.85.166.66]:44166 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387974AbeKFHym (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Nov 2018 02:54:42 -0500
MIME-Version: 1.0
References: <20181022113306.GB2867@w540> <CAHCN7xJkc5RW73C0zruWBgyF7G0J3C5tLE=ZdfxTKbrUqs=-PQ@mail.gmail.com>
 <CAOMZO5ATm4BRzPEQOU+ZD6bHCP2Aqjp4raRYhuc+wNe0t4+C=w@mail.gmail.com>
 <CAHCN7x+csKEk25CF=teUv+F5_GoTe6_3Yqb5PODLn+AmCCm88w@mail.gmail.com>
 <d78877f8-2c23-2bf0-0a9c-cd98b855e95e@mentor.com> <CAHCN7xKhGAXs0jGv96CfOfLQfVubxzsdE9UjpDu+4NM6oLDGWw@mail.gmail.com>
 <bc034299-4a32-f248-d09a-0d1b5872a506@mentor.com> <CAHCN7xKVUgpyCb5k7s0PNXW-efySSwP25ZGMLdbFnohATPwKhg@mail.gmail.com>
 <20181023230259.GA3766@w540> <CAHCN7xJaY_916OLHvaN_q1FwM2vqH5UXzVxLAS4DuEV0icPUXg@mail.gmail.com>
 <20181024140820.GB3766@w540> <CAHCN7xKbAuTmic+L-a2o1NreSCmYBKzzvmHuUTGZtVHELFoirg@mail.gmail.com>
 <CAHCN7xLP13PDT_VhV_iQzRB+VS7N4AxY+BObtLpz4bJ6RfxfWg@mail.gmail.com> <CAOMZO5Dkwrv4k=KGit+4wFFSr=ec94OpjUW56_D_aamjNPQH6g@mail.gmail.com>
In-Reply-To: <CAOMZO5Dkwrv4k=KGit+4wFFSr=ec94OpjUW56_D_aamjNPQH6g@mail.gmail.com>
From: Adam Ford <aford173@gmail.com>
Date: Mon, 5 Nov 2018 16:32:33 -0600
Message-ID: <CAHCN7xKs=wO9dxVAo=yxjWm10jH6TmAfgYwAfAd=J2uBT3rK1w@mail.gmail.com>
Subject: Re: i.MX6 MIPI-CSI2 OV5640 Camera testing on Mainline Linux
To: Fabio Estevam <festevam@gmail.com>
Cc: jacopo@jmondi.org, steve_longerbeam@mentor.com,
        Jagan Teki <jagan@amarulasolutions.com>,
        p.zabel@pengutronix.de, Fabio Estevam <fabio.estevam@nxp.com>,
        gstreamer-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 29, 2018 at 8:49 AM Fabio Estevam <festevam@gmail.com> wrote:
>
> Hi Adam,
>
> On Sun, Oct 28, 2018 at 3:58 PM Adam Ford <aford173@gmail.com> wrote:
>
> > Does anyone know when the media branch get's merged into the mainline
> > kernel?  I assume we're in the merge window with 4.19 just having been
> > released.  Once these have been merged into the mainline, I'll go
> > through and start requesting they get pulled into 4.19 and/or 4.14
> > if/when appropriate.
>
> This should happen in 4.20-rc1, which will probably be out next  Sunday.
I sent an e-mail to stable with a list of a variety of patches for the
ov5640 to be applied to 4.19.y  So far all looks pretty good, but I
think I found on minor bug:

If I attempt to change just the resolution, it doesn't take.

Initial read
media-ctl --get-v4l2 "'ov5640 2-0010':0"
[fmt:UYVY8_2X8/640x480@1/30 field:none colorspace:srgb xfer:srgb
ycbcr:601 quantization:full-range]

Change resolution
# media-ctl --set-v4l2 "'ov5640 2-0010':0[fmt:UYVY2X8/720x480 field:none]"

Read it back
# media-ctl --get-v4l2 "'ov5640 2-0010':0"
[fmt:UYVY8_2X8/640x480@1/30 field:none colorspace:srgb xfer:srgb
ycbcr:601 quantization:full-range]

However, if I change the resolution AND the format to something other
than UYVY2x8, the resolution changes. I can then change the format
back to UYVY and capture and stream video at 1080p and 720x480.
I can work around this, but I thought I'd mention it.  I was trying to
figure out a patch to apply to the mailing list myself, but I wasn't
able to fix it quickly.

adam
adam
