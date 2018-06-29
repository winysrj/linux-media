Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:34949 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752549AbeF2Vqk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Jun 2018 17:46:40 -0400
MIME-Version: 1.0
In-Reply-To: <CAMty3ZCeR3uEx8oy18-Ur7ma7pciKUf_myDk6_SpWvxc6DvygQ@mail.gmail.com>
References: <CAMty3ZAMjCKv1BtLnobRZUzp=9Xu1gY5+R3Zi-JuobAJZQrXxg@mail.gmail.com>
 <20180531190659.xdp4q2cjro33aihq@pengutronix.de> <CAMty3ZCeR3uEx8oy18-Ur7ma7pciKUf_myDk6_SpWvxc6DvygQ@mail.gmail.com>
From: Fabio Estevam <festevam@gmail.com>
Date: Fri, 29 Jun 2018 18:46:39 -0300
Message-ID: <CAOMZO5AOpOSAx=L4tOU1Na6hm8Tex3PHNxCYDB81C0+NPHzTZQ@mail.gmail.com>
Subject: Re: i.MX6 MIPI-CSI2 OV5640 Camera testing on Mainline Linux
To: Jagan Teki <jagan@amarulasolutions.com>,
        jacopo mondi <jacopo@jmondi.org>
Cc: Philipp Zabel <pza@pengutronix.de>,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Discussion of the development of and with GStreamer
        <gstreamer-devel@lists.freedesktop.org>,
        linux-media <linux-media@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jagan,

On Fri, Jun 1, 2018 at 2:19 AM, Jagan Teki <jagan@amarulasolutions.com> wrote:

> I actually tried even on video0 which I forgot to post the log [4].
> Now I understand I'm trying for wrong device to capture look like
> video0 which is ipu1 prepenc firing kernel oops. I'm trying to debug
> this and let me know if have any suggestion to look into.
>
> [   56.800074] imx6-mipi-csi2: LP-11 timeout, phy_state = 0x000002b0
> [   57.369660] ipu1_ic_prpenc: EOF timeout
> [   57.849692] ipu1_ic_prpenc: wait last EOF timeout
> [   57.855703] ipu1_ic_prpenc: pipeline start failed with -110

Could you please test this series from Jacopo?
https://www.mail-archive.com/linux-media@vger.kernel.org/msg133191.html

It seems that it would fix this problem.

Thanks
