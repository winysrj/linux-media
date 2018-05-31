Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:59677 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754089AbeEaTHG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 May 2018 15:07:06 -0400
Date: Thu, 31 May 2018 21:06:59 +0200
From: Philipp Zabel <pza@pengutronix.de>
To: Jagan Teki <jagan@amarulasolutions.com>
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Discussion of the development of and with GStreamer
        <gstreamer-devel@lists.freedesktop.org>,
        linux-media@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: i.MX6 MIPI-CSI2 OV5640 Camera testing on Mainline Linux
Message-ID: <20180531190659.xdp4q2cjro33aihq@pengutronix.de>
References: <CAMty3ZAMjCKv1BtLnobRZUzp=9Xu1gY5+R3Zi-JuobAJZQrXxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMty3ZAMjCKv1BtLnobRZUzp=9Xu1gY5+R3Zi-JuobAJZQrXxg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jagan,

On Thu, May 31, 2018 at 08:39:20PM +0530, Jagan Teki wrote:
> Hi All,
> 
> I'm trying to verify MIPI-CSI2 OV5640 camera on i.MX6 platform with
> Mainline Linux.
> 
> I've followed these[1] instructions to configure MC links and pads
> based on the probing details from dmesg and trying to capture
> ipu1_ic_prpenc capture (/dev/video1) but it's not working.
> 
> Can anyone help me to verify whether I configured all the details
> properly if not please suggest.
> 
> I'm pasting full log here, so-that anyone can comment in line and dt
> changes are at [2]
> 
> Log:
> -----
[...]
> # media-ctl -l "'ov5640 2-003c':0 -> 'imx6-mipi-csi2':0[1]"
> # media-ctl -l "'imx6-mipi-csi2':2 -> 'ipu1_csi1':0[1]"
> # media-ctl -l "'ipu1_csi1':1 -> 'ipu1_ic_prp':0[1]"
> # media-ctl -l "'ipu1_ic_prp':1 -> 'ipu1_ic_prpenc':0[1]"
> # media-ctl -l "'ipu1_ic_prpenc':1 -> 'ipu1_ic_prpenc capture':0[1]"

Here you configure a pipeline that ends at ipu1 prpenc capture ...

> # med# media-ctl -p
[...]
> - entity 18: ipu1_ic_prpenc capture (1 pad, 1 link)
>              type Node subtype V4L flags 0
>              device node name /dev/video0

... which is /dev/video0 ...

[...]
> - entity 27: ipu1_ic_prpvf capture (1 pad, 1 link)
>              type Node subtype V4L flags 0
>              device node name /dev/video1

... not /dev/video1 ...

[...]
> # GST_DEBUG="v4l2*:5" gst-launch-1.0 -v v4l2src device=/dev/video1 ! \
> > autovideosink

... and then you try to capture from prpvf, which is not part of a
configured pipeline.

regards
Philipp
