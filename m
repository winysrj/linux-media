Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:38973 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933728AbeGDG5Y (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Jul 2018 02:57:24 -0400
Received: by mail-io0-f195.google.com with SMTP id e13-v6so3939479iof.6
        for <linux-media@vger.kernel.org>; Tue, 03 Jul 2018 23:57:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMty3ZCWztkM2oEaKQRVmMkA0C1V6b9Oj59DBX9XAWAybZbRAw@mail.gmail.com>
References: <CAMty3ZAMjCKv1BtLnobRZUzp=9Xu1gY5+R3Zi-JuobAJZQrXxg@mail.gmail.com>
 <20180531190659.xdp4q2cjro33aihq@pengutronix.de> <CAMty3ZCeR3uEx8oy18-Ur7ma7pciKUf_myDk6_SpWvxc6DvygQ@mail.gmail.com>
 <CAOMZO5AOpOSAx=L4tOU1Na6hm8Tex3PHNxCYDB81C0+NPHzTZQ@mail.gmail.com>
 <20180703184117.GC5611@w540> <CAMty3ZCWztkM2oEaKQRVmMkA0C1V6b9Oj59DBX9XAWAybZbRAw@mail.gmail.com>
From: Jagan Teki <jagan@amarulasolutions.com>
Date: Wed, 4 Jul 2018 12:27:23 +0530
Message-ID: <CAMty3ZCLwqBs46z5TJ+rqtuWA+-ickBf94jrJpy+b-QA1pYGDw@mail.gmail.com>
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

On Wed, Jul 4, 2018 at 10:48 AM, Jagan Teki <jagan@amarulasolutions.com> wrote:
> On Wed, Jul 4, 2018 at 12:11 AM, jacopo mondi <jacopo@jmondi.org> wrote:
>> Hi Fabio,
>>   thanks for pointing Jagan to my series, but..
>>
>> On Fri, Jun 29, 2018 at 06:46:39PM -0300, Fabio Estevam wrote:
>>> Hi Jagan,
>>>
>>> On Fri, Jun 1, 2018 at 2:19 AM, Jagan Teki <jagan@amarulasolutions.com> wrote:
>>>
>>> > I actually tried even on video0 which I forgot to post the log [4].
>>> > Now I understand I'm trying for wrong device to capture look like
>>> > video0 which is ipu1 prepenc firing kernel oops. I'm trying to debug
>>> > this and let me know if have any suggestion to look into.
>>> >
>>> > [   56.800074] imx6-mipi-csi2: LP-11 timeout, phy_state = 0x000002b0
>>> > [   57.369660] ipu1_ic_prpenc: EOF timeout
>>> > [   57.849692] ipu1_ic_prpenc: wait last EOF timeout
>>> > [   57.855703] ipu1_ic_prpenc: pipeline start failed with -110
>>>
>>> Could you please test this series from Jacopo?
>>> https://www.mail-archive.com/linux-media@vger.kernel.org/msg133191.html
>
> Will verify this on my board and let you know the result.

I have similar issue, it doesn't work.
