Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:35699 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755024AbcJNQpJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 12:45:09 -0400
Message-ID: <1476463506.11834.78.camel@pengutronix.de>
Subject: Re: [16/22] ARM: dts: nitrogen6x: Add dtsi for BD_HDMI_MIPI HDMI to
 MIPI CSI-2 receiver board
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Gary Bisson <gary.bisson@boundarydevices.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Marek Vasut <marex@denx.de>, kernel@pengutronix.de
Date: Fri, 14 Oct 2016 18:45:06 +0200
In-Reply-To: <20161010154831.gyopknmklf4sxdt6@t450s.lan>
References: <20161007160107.5074-17-p.zabel@pengutronix.de>
         <20161010154831.gyopknmklf4sxdt6@t450s.lan>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gary,

Am Montag, den 10.10.2016, 17:48 +0200 schrieb Gary Bisson:
> Hi Philipp, All,
> 
> On Fri, Oct 07, 2016 at 06:01:01PM +0200, Philipp Zabel wrote:
> > Add device tree nodes for the BD_HDMI_MIPI HDMI to MIPI CSI-2 receiver
> > board with a TC358743 connected to the Nitrogen6X MIPI CSI-2 input
> > connector.
> 
> I've tested this series on my Nitrogen6x + BD_HDMI_MIPI daughter board
> and have a few questions.
> 
> First, why is the tc358743 node in a separate dtsi file? Is this in
> order to avoid a failed probe during bootup if the daughter board is
> not present? Is this what should be done for every capture device that
> targets this platform (like the OV5640 or OV5642)?
> 
> Can you provide some details on your testing procedure? In my case I've
> reached a point where I get the same 'media-ctl --print-dot' output as
> the one from your cover letter but I can't seem to set the EDID nor to
> have a gstreamer pipeline (to fakesink).

If I force EDID on the sender, it also works without setting EDID on the
tc358743:

# Make the detected dv timings current on TC358743
media-ctl --set-dv '"tc358743 1-000f":0'

# Enable link between TC358743 and MIPI CSI-2 receiver, set format
media-ctl --links '"tc358743 1-000f":0->"mipi-csi2":0[1]'
media-ctl --set-v4l2 '"tc358743 1-000f":0[fmt:UYVY/1920x1080]'

# Enable link between MIPI CSI-2 receiver and mux, set format,
# this switches the mux input to MIPI CSI-2
media-ctl --links '"mipi-csi2":1->"mipi_ipu1_mux":0[1]'
media-ctl --set-v4l2 '"mipi-csi2":1[fmt:UYVY/1920x1080]'

# Enable link between mux and CSI, set format
media-ctl --links '"mipi_ipu1_mux":2->"IPU0 CSI0":0[1]'
media-ctl --set-v4l2 '"mipi_ipu1_mux":2[fmt:UYVY/1920x1080]'
# this disables frame skipping and sets the nominal frame interval
# that will be returned by v4l2-ctl --get-parm
media-ctl --set-v4l2 '"IPU0 CSI0":0[fmt:UYVY/1920x1080@1/60]'

# Set capture format at CSI output
media-ctl --set-v4l2 '"IPU0 CSI0":1[fmt:UYVY2X8/960x540]'

I'd like to handle this format propagation in libv4l2.

# Capture
gst-launch-1.0 v4l2src device=/dev/video0 io-mode=dmabuf ! video/x-raw,format=YUY2,framerate=30/1 ! kmssink

>  All the EDID v4l2-ctl commands
> return "Inappropriate ioctl for device".

The capture driver currently does not collect its subdevices' controls
to present them on the main video device. Also this would only work for
controls that appear only once in the configured pipeline.

I once hacked v4l2-ctl to allow it to directly set subdev controls on
the /dev/v4l2-subdev nodes: https://patchwork.kernel.org/patch/6097201/
but the correct solution seems to be to have a subdevice specific
QUERYCAP alternative.

> Do not hesitate to CC me to Boundary Devices related patches so I can
> test them and give some feedback.

I'll do that, thanks in advance for testing.

regards
Philipp

