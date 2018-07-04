Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:36571 "EHLO
        mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751826AbeGDFSd (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Jul 2018 01:18:33 -0400
Received: by mail-it0-f49.google.com with SMTP id j185-v6so6037937ite.1
        for <linux-media@vger.kernel.org>; Tue, 03 Jul 2018 22:18:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180703184117.GC5611@w540>
References: <CAMty3ZAMjCKv1BtLnobRZUzp=9Xu1gY5+R3Zi-JuobAJZQrXxg@mail.gmail.com>
 <20180531190659.xdp4q2cjro33aihq@pengutronix.de> <CAMty3ZCeR3uEx8oy18-Ur7ma7pciKUf_myDk6_SpWvxc6DvygQ@mail.gmail.com>
 <CAOMZO5AOpOSAx=L4tOU1Na6hm8Tex3PHNxCYDB81C0+NPHzTZQ@mail.gmail.com> <20180703184117.GC5611@w540>
From: Jagan Teki <jagan@amarulasolutions.com>
Date: Wed, 4 Jul 2018 10:48:32 +0530
Message-ID: <CAMty3ZCWztkM2oEaKQRVmMkA0C1V6b9Oj59DBX9XAWAybZbRAw@mail.gmail.com>
Subject: Re: i.MX6 MIPI-CSI2 OV5640 Camera testing on Mainline Linux
To: jacopo mondi <jacopo@jmondi.org>
Cc: Fabio Estevam <festevam@gmail.com>,
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

On Wed, Jul 4, 2018 at 12:11 AM, jacopo mondi <jacopo@jmondi.org> wrote:
> Hi Fabio,
>   thanks for pointing Jagan to my series, but..
>
> On Fri, Jun 29, 2018 at 06:46:39PM -0300, Fabio Estevam wrote:
>> Hi Jagan,
>>
>> On Fri, Jun 1, 2018 at 2:19 AM, Jagan Teki <jagan@amarulasolutions.com> wrote:
>>
>> > I actually tried even on video0 which I forgot to post the log [4].
>> > Now I understand I'm trying for wrong device to capture look like
>> > video0 which is ipu1 prepenc firing kernel oops. I'm trying to debug
>> > this and let me know if have any suggestion to look into.
>> >
>> > [   56.800074] imx6-mipi-csi2: LP-11 timeout, phy_state = 0x000002b0
>> > [   57.369660] ipu1_ic_prpenc: EOF timeout
>> > [   57.849692] ipu1_ic_prpenc: wait last EOF timeout
>> > [   57.855703] ipu1_ic_prpenc: pipeline start failed with -110
>>
>> Could you please test this series from Jacopo?
>> https://www.mail-archive.com/linux-media@vger.kernel.org/msg133191.html

Will verify this on my board and let you know the result.

>>
>> It seems that it would fix this problem.
>
> ... unfortunately it does not :(
>
> I've been able to test on the same platform where Jagan has reported
> this issue, and the CSI-2 bus still fails to startup properly...
>
> I do not have CSI-2 receiver driver documentation for the other platform
> I am testing on and where my patches improved stability, but the i.MX6 error
> reported by Jagan could be useful to help debugging what's wrong with the
> serial bus initialization on that platform.
>
> The error comes from register MIPI_CSI_PHY_STATE of the i.MX6 MIPI_CSI-2
> interface and reads as:
>
> 0x2b0 : BIT(9) -> clock in ULPS state
>         BIT(7) -> lane3 in stop state
>         BIT(5) -> lane1 in stop state
>         BIT(4) -> lane0 in stop state
>
> The i.MX6 driver wants instead that register to be:
>
> 0x430 : BIT(10) -> clock in stop state
>         BIT(5) -> lane1 in stop state
>         BIT(4) -> lane0 in stop state
>
> So indeed it represents a useful debugging tool to have an idea of what's going
> on there.
>
> I'm a bit puzzled by the BIT(7) as lane3 is not connected, as ov5640 is a 2
> lanes sensor, and I would have a question for Jagan here: has the sensor been
> validated with BSP/vendor kernels on that platform? There's a flat cable
> connecting the camera module to the main board, and for high speed
> differential signals that's maybe not the best possible solution...

Yes, I've validated through engicam Linux, [1] before verifying to
Mainline. I have similar board which posted on the website on J5 point
20-Polig connector attached to bus to sensor[2]

[1] https://github.com/engicam-stable/engicam-kernel-4.1.15/blob/som_release/arch/arm/boot/dts/icoremx6q-icore-mipi.dts
[2] https://www.engicam.com/vis-prod/101145

Jagan.

-- 
Jagan Teki
Senior Linux Kernel Engineer | Amarula Solutions
U-Boot, Linux | Upstream Maintainer
Hyderabad, India.
