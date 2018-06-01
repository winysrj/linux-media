Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:34885 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751293AbeFALlS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Jun 2018 07:41:18 -0400
Received: by mail-it0-f66.google.com with SMTP id a3-v6so1466237itd.0
        for <linux-media@vger.kernel.org>; Fri, 01 Jun 2018 04:41:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180601095322.hdxcpmj4tfonaq4g@valkosipuli.retiisi.org.uk>
References: <CAMty3ZAMjCKv1BtLnobRZUzp=9Xu1gY5+R3Zi-JuobAJZQrXxg@mail.gmail.com>
 <20180531190659.xdp4q2cjro33aihq@pengutronix.de> <CAMty3ZCeR3uEx8oy18-Ur7ma7pciKUf_myDk6_SpWvxc6DvygQ@mail.gmail.com>
 <20180601095322.hdxcpmj4tfonaq4g@valkosipuli.retiisi.org.uk>
From: Jagan Teki <jagan@amarulasolutions.com>
Date: Fri, 1 Jun 2018 17:11:16 +0530
Message-ID: <CAMty3ZBCrrj=GJzGWR8tp5e2ZEAgADFT9OQ_THAALOW_Bay1LA@mail.gmail.com>
Subject: Re: i.MX6 MIPI-CSI2 OV5640 Camera testing on Mainline Linux
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Philipp Zabel <pza@pengutronix.de>,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Discussion of the development of and with GStreamer
        <gstreamer-devel@lists.freedesktop.org>,
        linux-media@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 1, 2018 at 3:23 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> On Fri, Jun 01, 2018 at 10:49:56AM +0530, Jagan Teki wrote:
>> Hi Philipp,
>>
>> On Fri, Jun 1, 2018 at 12:36 AM, Philipp Zabel <pza@pengutronix.de> wrote:
>> > Hi Jagan,
>> >
>> > On Thu, May 31, 2018 at 08:39:20PM +0530, Jagan Teki wrote:
>> >> Hi All,
>> >>
>> >> I'm trying to verify MIPI-CSI2 OV5640 camera on i.MX6 platform with
>> >> Mainline Linux.
>> >>
>> >> I've followed these[1] instructions to configure MC links and pads
>> >> based on the probing details from dmesg and trying to capture
>> >> ipu1_ic_prpenc capture (/dev/video1) but it's not working.
>> >>
>> >> Can anyone help me to verify whether I configured all the details
>> >> properly if not please suggest.
>> >>
>> >> I'm pasting full log here, so-that anyone can comment in line and dt
>> >> changes are at [2]
>> >>
>> >> Log:
>> >> -----
>> > [...]
>> >> # media-ctl -l "'ov5640 2-003c':0 -> 'imx6-mipi-csi2':0[1]"
>> >> # media-ctl -l "'imx6-mipi-csi2':2 -> 'ipu1_csi1':0[1]"
>> >> # media-ctl -l "'ipu1_csi1':1 -> 'ipu1_ic_prp':0[1]"
>> >> # media-ctl -l "'ipu1_ic_prp':1 -> 'ipu1_ic_prpenc':0[1]"
>> >> # media-ctl -l "'ipu1_ic_prpenc':1 -> 'ipu1_ic_prpenc capture':0[1]"
>> >
>> > Here you configure a pipeline that ends at ipu1 prpenc capture ...
>> >
>> >> # med# media-ctl -p
>> > [...]
>> >> - entity 18: ipu1_ic_prpenc capture (1 pad, 1 link)
>> >>              type Node subtype V4L flags 0
>> >>              device node name /dev/video0
>> >
>> > ... which is /dev/video0 ...
>> >
>> > [...]
>> >> - entity 27: ipu1_ic_prpvf capture (1 pad, 1 link)
>> >>              type Node subtype V4L flags 0
>> >>              device node name /dev/video1
>> >
>> > ... not /dev/video1 ...
>>
>> True, thanks for pointing it.
>>
>> I actually tried even on video0 which I forgot to post the log [4].
>> Now I understand I'm trying for wrong device to capture look like
>> video0 which is ipu1 prepenc firing kernel oops. I'm trying to debug
>> this and let me know if have any suggestion to look into.
>>
>> [   56.800074] imx6-mipi-csi2: LP-11 timeout, phy_state = 0x000002b0
>> [   57.369660] ipu1_ic_prpenc: EOF timeout
>> [   57.849692] ipu1_ic_prpenc: wait last EOF timeout
>> [   57.855703] ipu1_ic_prpenc: pipeline start failed with -110
>
> I don't have the hardware but this looks like the host cannot detect the
> LP-11 state on the sensor (both wires high?). Some sensors cannot do this
> without starting streaming at the same time. I'd expect the same if there
> are problems in lane configuration etc.

You mean the lane configurations in hardware? but this sensor is
working with imx kernel. what do you mean by wires here? lanes.

Jagan.

-- 
Jagan Teki
Senior Linux Kernel Engineer | Amarula Solutions
U-Boot, Linux | Upstream Maintainer
Hyderabad, India.
