Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f66.google.com ([209.85.208.66]:39403 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbeH1TAz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Aug 2018 15:00:55 -0400
Received: by mail-ed1-f66.google.com with SMTP id h4-v6so1641089edi.6
        for <linux-media@vger.kernel.org>; Tue, 28 Aug 2018 08:08:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1534328897-14957-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1534328897-14957-1-git-send-email-jacopo+renesas@jmondi.org>
From: Loic Poulain <loic.poulain@linaro.org>
Date: Tue, 28 Aug 2018 17:08:07 +0200
Message-ID: <CAMZdPi9rdO88=m3BXtUZFUheAaS__Jx58NhYwi7L+sCmhx8apA@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] media: i2c: ov5640: Re-work MIPI startup sequence
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Sam Bobrowicz <sam@elite-embedded.com>,
        jagan@amarulasolutions.com, festevam@gmail.com, pza@pengutronix.de,
        steve_longerbeam@mentor.com,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Daniel Mack <daniel@zonque.org>, linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 15 August 2018 at 12:28, Jacopo Mondi <jacopo+renesas@jmondi.org> wrote:
> Hello ov5640 people,
>    this driver has received a lot of attention recently, and this series aims
> to fix the CSI-2 interface startup on i.Mx6Q platforms.
>
> Please refer to the v2 cover letters for more background informations:
> https://www.mail-archive.com/linux-media@vger.kernel.org/msg133420.html
>
> This two patches alone allows the MIPI interface to startup properly, but in
> order to capture good images (good as in 'not completely black') exposure and
> gain handling should be fixed too.
> Hugues Fruchet has a series in review that fixes that issues:
> [PATCH v2 0/5] Fix OV5640 exposure & gain
>
> And I have re-based it on top of this two fixes here:
> git://jmondi.org/linux ov5640/timings_exposure
>
> Steve Longerbeam tested that branch on his I.MX6q SabreSD board and confirms he
> can now capture frames (I added his Tested-by tag to this patches). I have
> verified the same on Engicam iCore I.MX6q and an Intel Atom based board.
>
> Ideally I would like to have these two fixes merged, and Hugues' ones then
> applied on top. Of course, more testing on other platforms using CSI-2 is very
> welcome.
>
> Thanks
>    j
>
> v2 -> v3:
> - patch [2/2] was originally sent in a different series, compared to v2 it
>   removes entries from the blob array instead of adding more.
>
> Jacopo Mondi (2):
>   media: ov5640: Re-work MIPI startup sequence
>   media: ov5640: Fix timings setup code
>
>  drivers/media/i2c/ov5640.c | 141 +++++++++++++++++++++++++++++----------------
>  1 file changed, 92 insertions(+), 49 deletions(-)
>
> --
> 2.7.4
>

Thanks for this work.
I've just tested this with a dragonboard-410c (MICPI/CSI) + OV5640 sensor.
It works on my side for 1280*720, 1920*1080 and 2592*1944 formats.

Tested-by: Loic Poulain <loic.poulain@linaro.org>
