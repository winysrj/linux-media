Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40992 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750740AbeFAJxY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Jun 2018 05:53:24 -0400
Date: Fri, 1 Jun 2018 12:53:22 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jagan Teki <jagan@amarulasolutions.com>
Cc: Philipp Zabel <pza@pengutronix.de>,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Discussion of the development of and with GStreamer
        <gstreamer-devel@lists.freedesktop.org>,
        linux-media@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: i.MX6 MIPI-CSI2 OV5640 Camera testing on Mainline Linux
Message-ID: <20180601095322.hdxcpmj4tfonaq4g@valkosipuli.retiisi.org.uk>
References: <CAMty3ZAMjCKv1BtLnobRZUzp=9Xu1gY5+R3Zi-JuobAJZQrXxg@mail.gmail.com>
 <20180531190659.xdp4q2cjro33aihq@pengutronix.de>
 <CAMty3ZCeR3uEx8oy18-Ur7ma7pciKUf_myDk6_SpWvxc6DvygQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMty3ZCeR3uEx8oy18-Ur7ma7pciKUf_myDk6_SpWvxc6DvygQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 01, 2018 at 10:49:56AM +0530, Jagan Teki wrote:
> Hi Philipp,
> 
> On Fri, Jun 1, 2018 at 12:36 AM, Philipp Zabel <pza@pengutronix.de> wrote:
> > Hi Jagan,
> >
> > On Thu, May 31, 2018 at 08:39:20PM +0530, Jagan Teki wrote:
> >> Hi All,
> >>
> >> I'm trying to verify MIPI-CSI2 OV5640 camera on i.MX6 platform with
> >> Mainline Linux.
> >>
> >> I've followed these[1] instructions to configure MC links and pads
> >> based on the probing details from dmesg and trying to capture
> >> ipu1_ic_prpenc capture (/dev/video1) but it's not working.
> >>
> >> Can anyone help me to verify whether I configured all the details
> >> properly if not please suggest.
> >>
> >> I'm pasting full log here, so-that anyone can comment in line and dt
> >> changes are at [2]
> >>
> >> Log:
> >> -----
> > [...]
> >> # media-ctl -l "'ov5640 2-003c':0 -> 'imx6-mipi-csi2':0[1]"
> >> # media-ctl -l "'imx6-mipi-csi2':2 -> 'ipu1_csi1':0[1]"
> >> # media-ctl -l "'ipu1_csi1':1 -> 'ipu1_ic_prp':0[1]"
> >> # media-ctl -l "'ipu1_ic_prp':1 -> 'ipu1_ic_prpenc':0[1]"
> >> # media-ctl -l "'ipu1_ic_prpenc':1 -> 'ipu1_ic_prpenc capture':0[1]"
> >
> > Here you configure a pipeline that ends at ipu1 prpenc capture ...
> >
> >> # med# media-ctl -p
> > [...]
> >> - entity 18: ipu1_ic_prpenc capture (1 pad, 1 link)
> >>              type Node subtype V4L flags 0
> >>              device node name /dev/video0
> >
> > ... which is /dev/video0 ...
> >
> > [...]
> >> - entity 27: ipu1_ic_prpvf capture (1 pad, 1 link)
> >>              type Node subtype V4L flags 0
> >>              device node name /dev/video1
> >
> > ... not /dev/video1 ...
> 
> True, thanks for pointing it.
> 
> I actually tried even on video0 which I forgot to post the log [4].
> Now I understand I'm trying for wrong device to capture look like
> video0 which is ipu1 prepenc firing kernel oops. I'm trying to debug
> this and let me know if have any suggestion to look into.
> 
> [   56.800074] imx6-mipi-csi2: LP-11 timeout, phy_state = 0x000002b0
> [   57.369660] ipu1_ic_prpenc: EOF timeout
> [   57.849692] ipu1_ic_prpenc: wait last EOF timeout
> [   57.855703] ipu1_ic_prpenc: pipeline start failed with -110

I don't have the hardware but this looks like the host cannot detect the
LP-11 state on the sensor (both wires high?). Some sensors cannot do this
without starting streaming at the same time. I'd expect the same if there
are problems in lane configuration etc.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
