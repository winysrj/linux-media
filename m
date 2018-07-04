Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:33386 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752147AbeGDASy (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Jul 2018 20:18:54 -0400
MIME-Version: 1.0
In-Reply-To: <20180703184117.GC5611@w540>
References: <CAMty3ZAMjCKv1BtLnobRZUzp=9Xu1gY5+R3Zi-JuobAJZQrXxg@mail.gmail.com>
 <20180531190659.xdp4q2cjro33aihq@pengutronix.de> <CAMty3ZCeR3uEx8oy18-Ur7ma7pciKUf_myDk6_SpWvxc6DvygQ@mail.gmail.com>
 <CAOMZO5AOpOSAx=L4tOU1Na6hm8Tex3PHNxCYDB81C0+NPHzTZQ@mail.gmail.com> <20180703184117.GC5611@w540>
From: Fabio Estevam <festevam@gmail.com>
Date: Tue, 3 Jul 2018 21:18:52 -0300
Message-ID: <CAOMZO5AP1b-XaFC2VdGE_hX77y4jOpwS5nqhjySW6ieieEB0pg@mail.gmail.com>
Subject: Re: i.MX6 MIPI-CSI2 OV5640 Camera testing on Mainline Linux
To: jacopo mondi <jacopo@jmondi.org>
Cc: Jagan Teki <jagan@amarulasolutions.com>,
        Philipp Zabel <pza@pengutronix.de>,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Discussion of the development of and with GStreamer
        <gstreamer-devel@lists.freedesktop.org>,
        linux-media <linux-media@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On Tue, Jul 3, 2018 at 3:41 PM, jacopo mondi <jacopo@jmondi.org> wrote:

> I've been able to test on the same platform where Jagan has reported
> this issue, and the CSI-2 bus still fails to startup properly...

Last time I heard from Jagan he reported that the LP11 timeout issue
was caused by:

commit 476dec012f4c6545b0b7599cd9adba2ed819ad3b
Author: Maxime Ripard <maxime.ripard@bootlin.com>
Date:   Mon Apr 16 08:36:55 2018 -0400

    media: ov5640: Add horizontal and vertical totals

    All the initialization arrays are changing the horizontal and vertical
    totals for some value.

    In order to clean up the driver, and since we're going to need that value
    later on, let's introduce in the ov5640_mode_info structure the horizontal
    and vertical total sizes, and move these out of the bytes array.

    Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
    Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

Thanks
