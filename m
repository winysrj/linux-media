Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:34403 "EHLO
        mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750979AbeDPXWk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 19:22:40 -0400
Received: by mail-io0-f180.google.com with SMTP id d6so20175813iog.1
        for <linux-media@vger.kernel.org>; Mon, 16 Apr 2018 16:22:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180416123701.15901-1-maxime.ripard@bootlin.com>
References: <20180416123701.15901-1-maxime.ripard@bootlin.com>
From: Samuel Bobrowicz <sam@elite-embedded.com>
Date: Mon, 16 Apr 2018 16:22:39 -0700
Message-ID: <CAFwsNOF6t-AAXr8gEBLnCx2OF-PjAWALhsJRVYHSdnaP9hswWA@mail.gmail.com>
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

I've been digging around the ov5640.c code for a few weeks now, these
look like some solid improvements. I'll give them a shot and let you
know how they work.

On that note, I'm bringing up a module that uses dual lane MIPI with a
12MHz fixed oscillator for xclk (Digilent's Pcam 5c). The mainline
version of the driver seems to only support xclk of 22MHz (or maybe
24MHz), despite allowing xclk values from 6-24MHz. Will any of these
patches add support for a 12MHz xclk while in MIPI mode?

Sam
-----------------------
Sam Bobrowicz
Elite Embedded Consulting LLC
elite-embedded.com


On Mon, Apr 16, 2018 at 5:36 AM, Maxime Ripard
<maxime.ripard@bootlin.com> wrote:
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
