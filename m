Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:53226 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753279AbeGDG7L (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Jul 2018 02:59:11 -0400
Received: by mail-it0-f54.google.com with SMTP id p4-v6so6453686itf.2
        for <linux-media@vger.kernel.org>; Tue, 03 Jul 2018 23:59:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <588A2275-4D45-442D-8B38-7A17C27BED10@gmail.com>
References: <CAMty3ZAMjCKv1BtLnobRZUzp=9Xu1gY5+R3Zi-JuobAJZQrXxg@mail.gmail.com>
 <20180531190659.xdp4q2cjro33aihq@pengutronix.de> <CAMty3ZCeR3uEx8oy18-Ur7ma7pciKUf_myDk6_SpWvxc6DvygQ@mail.gmail.com>
 <CAOMZO5AOpOSAx=L4tOU1Na6hm8Tex3PHNxCYDB81C0+NPHzTZQ@mail.gmail.com>
 <20180703184117.GC5611@w540> <CAMty3ZCWztkM2oEaKQRVmMkA0C1V6b9Oj59DBX9XAWAybZbRAw@mail.gmail.com>
 <588A2275-4D45-442D-8B38-7A17C27BED10@gmail.com>
From: Jagan Teki <jagan@amarulasolutions.com>
Date: Wed, 4 Jul 2018 12:29:10 +0530
Message-ID: <CAMty3ZAkSTO-GXK7tjMMY6fjWV=R_mvT_Qe=wO5iJy5NvLwBEw@mail.gmail.com>
Subject: Re: i.MX6 MIPI-CSI2 OV5640 Camera testing on Mainline Linux
To: Discussion of the development of and with GStreamer
        <gstreamer-devel@lists.freedesktop.org>
Cc: jacopo mondi <jacopo@jmondi.org>,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Philipp Zabel <pza@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 4, 2018 at 12:14 PM, chain256 <tonu.jaansoo@gmail.com> wrote:
> Hi!
>
> Just to let you know, I have same sensor working on Variscite iMX6 DART.
> Using Yocto Morty release (
> http://variwiki.com/index.php?title=VAR-SOM-MX6_Yocto&release=RELEASE_MORTY_V1.0_VAR-SOM-MX6
> )
> Had to hack device tree abit and that was about it. Hope you find something
> useful on that page.

Thanks for the link. Can you confirm is your sensor working with
Mainline? we are trying to verify mainline ov5640 sensor here.
