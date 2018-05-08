Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:55429 "EHLO
        mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751647AbeEHBA5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 May 2018 21:00:57 -0400
Received: by mail-it0-f43.google.com with SMTP id 144-v6so14215270iti.5
        for <linux-media@vger.kernel.org>; Mon, 07 May 2018 18:00:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180416123701.15901-1-maxime.ripard@bootlin.com>
References: <20180416123701.15901-1-maxime.ripard@bootlin.com>
From: Sam Bobrowicz <sam@elite-embedded.com>
Date: Mon, 7 May 2018 18:00:55 -0700
Message-ID: <CAFwsNOGBYxJUKpWCLacBJ04Da2-q3vnSjY4shuV3xExHN4Fqpg@mail.gmail.com>
Subject: Re: [PATCH v2 00/12] media: ov5640: Misc cleanup and improvements
To: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hugues Fruchet <hugues.fruchet@st.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Hi,
>
> Here is a "small" series that mostly cleans up the ov5640 driver code,
> slowly getting rid of the big data array for more understandable code
> (hopefully).
>
> The biggest addition would be the clock rate computation at runtime,
> instead of relying on those arrays to setup the clock tree
> properly. As a side effect, it fixes the framerate that was off by
> around 10% on the smaller resolutions, and we now support 60fps.
>
> This also introduces a bunch of new features.
>
> Let me know what you think,
> Maxime
>
> Changes from v1:
>   - Integrated Hugues' suggestions to fix v4l2-compliance
>   - Fixed the bus width with JPEG
>   - Dropped the clock rate calculation loops for something simpler as
>     suggested by Sakari
>   - Cache the exposure value instead of using the control value
>   - Rebased on top of 4.17
>
> Maxime Ripard (10):
>   media: ov5640: Don't force the auto exposure state at start time
>   media: ov5640: Init properly the SCLK dividers
>   media: ov5640: Change horizontal and vertical resolutions name
>   media: ov5640: Add horizontal and vertical totals
>   media: ov5640: Program the visible resolution
>   media: ov5640: Adjust the clock based on the expected rate
>   media: ov5640: Compute the clock rate at runtime
>   media: ov5640: Enhance FPS handling
>   media: ov5640: Add 60 fps support
>   media: ov5640: Remove duplicate auto-exposure setup
>
> Myl=C3=A8ne Josserand (2):
>   media: ov5640: Add auto-focus feature
>   media: ov5640: Add light frequency control
>
>  drivers/media/i2c/ov5640.c | 752 +++++++++++++++++++++----------------
>  1 file changed, 422 insertions(+), 330 deletions(-)
>
> --
> 2.17.0
>

As discussed, MIPI required some additional work. Please see the
patches here which add support for MIPI:
https://www.dropbox.com/s/73epty7808yzq1t/ov5640_mipi_fixes.zip?dl=3D0

The first 3 patches are fixes I believe should be made to earlier
patches prior to submitting v2 of this series. The remaining 4 patches
should probably just be added onto the end of this series as-is (or
with feedback incorporated if needed).

I will note that this is still not working correctly on my system for
any resolution that requires a 672 Mbps mipi rate. This includes
1080p@30hz, full@15hz, and 720p@60hz. My CSI2 receiver is reporting
CRC errors though, so this could be an integrity issue on my module.
I'm curious to hear if others have success at these resolutions.

Please try this out on other MIPI and DVP platforms with as many
different resolutions as possible and let me know if it works.

I'd also recommend that someone add a patch to the series that enables
720p@60hz. I didn't have time to do it yet, but it should be really
easy.

Sam
