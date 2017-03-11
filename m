Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:56688 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932817AbdCKReG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 11 Mar 2017 12:34:06 -0500
Date: Sat, 11 Mar 2017 17:32:54 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Steve Longerbeam <slongerbeam@gmail.com>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, mchehab@kernel.org, nick@shmanahar.org,
        markus.heiser@darmarIT.de, p.zabel@pengutronix.de,
        laurent.pinchart+renesas@ideasonboard.com, bparrot@ti.com,
        geert@linux-m68k.org, arnd@arndb.de, sudipm.mukherjee@gmail.com,
        minghsiu.tsai@mediatek.com, tiffany.lin@mediatek.com,
        jean-christophe.trotin@st.com, horms+renesas@verge.net.au,
        niklas.soderlund+renesas@ragnatech.se, robert.jarzmik@free.fr,
        songjun.wu@microchip.com, andrew-ct.chen@mediatek.com,
        gregkh@linuxfoundation.org, shuah@kernel.org,
        sakari.ailus@linux.intel.com, pavel@ucw.cz,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH v4 14/36] [media] v4l2-mc: add a function to inherit
 controls from a pipeline
Message-ID: <20170311173254.GC21222@n2100.armlinux.org.uk>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
 <1487211578-11360-15-git-send-email-steve_longerbeam@mentor.com>
 <20170302160257.GK3220@valkosipuli.retiisi.org.uk>
 <20170303230645.GR21222@n2100.armlinux.org.uk>
 <20170304131329.GV3220@valkosipuli.retiisi.org.uk>
 <a7b8e095-a95c-24bd-b1e9-e983f18061c4@xs4all.nl>
 <20170310120902.1daebc7b@vento.lan>
 <5e1183f4-774f-413a-628a-96e0df321faf@xs4all.nl>
 <20170311101408.272a9187@vento.lan>
 <20170311153229.yrdjmggb3p2suhdw@ihha.localdomain>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="FCuugMFkClbJLl1L"
Content-Disposition: inline
In-Reply-To: <20170311153229.yrdjmggb3p2suhdw@ihha.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Mar 11, 2017 at 05:32:29PM +0200, Sakari Ailus wrote:
> My understanding of the i.MX6 case is the hardware is configurable enough
> to warrant the use of the Media controller API. Some patches indicate
> there are choices to be made in data routing.

The iMX6 does have configurable data routing, but in some scenarios
(eg, when receiving bayer data) there's only one possible routing.

> Steve: could you enlighten us on the topic, by e.g. doing media-ctl
> --print-dot and sending the results to the list? What kind of different IP
> blocks are there and what do they do? A pointer to hardware documentation
> wouldn't hurt either (if it's available).

Attached for the imx219 camera.  Note that although the CSI2 block has
four outputs, each output is dedicated to a CSI virtual channel, so
they can not be arbitarily assigned without configuring the sensor.

Since the imx219 only produces bayer, the graph is also showing the
_only_ possible routing for the imx219 configured for CSI virtual
channel 0.

The iMX6 manuals are available on the 'net.

	https://community.nxp.com/docs/DOC-101840

There are several chapters that cover the capture side:

* MIPI CSI2
* IPU CSI2 gasket
* IPU

The IPU not only performs capture, but also display as well.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.

--FCuugMFkClbJLl1L
Content-Type: text/vnd.graphviz; charset=us-ascii
Content-Disposition: attachment; filename="imx219.dot"

digraph board {
	rankdir=TB
	n00000001 [label="{{<port0> 0 | <port1> 1} | ipu1_csi0_mux\n/dev/v4l-subdev0 | {<port2> 2}}", shape=Mrecord, style=filled, fillcolor=green]
	n00000001:port2 -> n00000044:port0
	n00000005 [label="{{<port0> 0 | <port1> 1} | ipu2_csi1_mux\n/dev/v4l-subdev1 | {<port2> 2}}", shape=Mrecord, style=filled, fillcolor=green]
	n00000005:port2 -> n00000068:port0 [style=dashed]
	n00000009 [label="{{<port0> 0 | <port1> 1} | ipu1_vdic\n/dev/v4l-subdev2 | {<port2> 2}}", shape=Mrecord, style=filled, fillcolor=green]
	n00000009:port2 -> n00000011:port0 [style=dashed]
	n0000000d [label="{{<port0> 0 | <port1> 1} | ipu2_vdic\n/dev/v4l-subdev3 | {<port2> 2}}", shape=Mrecord, style=filled, fillcolor=green]
	n0000000d:port2 -> n00000027:port0 [style=dashed]
	n00000011 [label="{{<port0> 0} | ipu1_ic_prp\n/dev/v4l-subdev4 | {<port1> 1 | <port2> 2}}", shape=Mrecord, style=filled, fillcolor=green]
	n00000011:port1 -> n00000015:port0 [style=dashed]
	n00000011:port2 -> n0000001e:port0 [style=dashed]
	n00000015 [label="{{<port0> 0} | ipu1_ic_prpenc\n/dev/v4l-subdev5 | {<port1> 1}}", shape=Mrecord, style=filled, fillcolor=green]
	n00000015:port1 -> n00000018 [style=dashed]
	n00000018 [label="ipu1_ic_prpenc capture\n/dev/video0", shape=box, style=filled, fillcolor=yellow]
	n0000001e [label="{{<port0> 0} | ipu1_ic_prpvf\n/dev/v4l-subdev6 | {<port1> 1}}", shape=Mrecord, style=filled, fillcolor=green]
	n0000001e:port1 -> n00000021 [style=dashed]
	n00000021 [label="ipu1_ic_prpvf capture\n/dev/video1", shape=box, style=filled, fillcolor=yellow]
	n00000027 [label="{{<port0> 0} | ipu2_ic_prp\n/dev/v4l-subdev7 | {<port1> 1 | <port2> 2}}", shape=Mrecord, style=filled, fillcolor=green]
	n00000027:port1 -> n0000002b:port0 [style=dashed]
	n00000027:port2 -> n00000034:port0 [style=dashed]
	n0000002b [label="{{<port0> 0} | ipu2_ic_prpenc\n/dev/v4l-subdev8 | {<port1> 1}}", shape=Mrecord, style=filled, fillcolor=green]
	n0000002b:port1 -> n0000002e [style=dashed]
	n0000002e [label="ipu2_ic_prpenc capture\n/dev/video2", shape=box, style=filled, fillcolor=yellow]
	n00000034 [label="{{<port0> 0} | ipu2_ic_prpvf\n/dev/v4l-subdev9 | {<port1> 1}}", shape=Mrecord, style=filled, fillcolor=green]
	n00000034:port1 -> n00000037 [style=dashed]
	n00000037 [label="ipu2_ic_prpvf capture\n/dev/video3", shape=box, style=filled, fillcolor=yellow]
	n0000003d [label="{{<port1> 1} | imx219 0-0010\n/dev/v4l-subdev11 | {<port0> 0}}", shape=Mrecord, style=filled, fillcolor=green]
	n0000003d:port0 -> n00000058:port0
	n00000040 [label="{{} | imx219 pixel 0-0010\n/dev/v4l-subdev10 | {<port0> 0}}", shape=Mrecord, style=filled, fillcolor=green]
	n00000040:port0 -> n0000003d:port1 [style=bold]
	n00000044 [label="{{<port0> 0} | ipu1_csi0\n/dev/v4l-subdev12 | {<port1> 1 | <port2> 2}}", shape=Mrecord, style=filled, fillcolor=green]
	n00000044:port2 -> n00000048
	n00000044:port1 -> n00000011:port0 [style=dashed]
	n00000044:port1 -> n00000009:port0 [style=dashed]
	n00000048 [label="ipu1_csi0 capture\n/dev/video4", shape=box, style=filled, fillcolor=yellow]
	n0000004e [label="{{<port0> 0} | ipu1_csi1\n/dev/v4l-subdev13 | {<port1> 1 | <port2> 2}}", shape=Mrecord, style=filled, fillcolor=green]
	n0000004e:port2 -> n00000052 [style=dashed]
	n0000004e:port1 -> n00000011:port0 [style=dashed]
	n0000004e:port1 -> n00000009:port0 [style=dashed]
	n00000052 [label="ipu1_csi1 capture\n/dev/video5", shape=box, style=filled, fillcolor=yellow]
	n00000058 [label="{{<port0> 0} | imx6-mipi-csi2\n/dev/v4l-subdev14 | {<port1> 1 | <port2> 2 | <port3> 3 | <port4> 4}}", shape=Mrecord, style=filled, fillcolor=green]
	n00000058:port1 -> n00000001:port0
	n00000058:port2 -> n0000004e:port0 [style=dashed]
	n00000058:port3 -> n0000005e:port0 [style=dashed]
	n00000058:port4 -> n00000005:port0 [style=dashed]
	n0000005e [label="{{<port0> 0} | ipu2_csi0\n/dev/v4l-subdev15 | {<port1> 1 | <port2> 2}}", shape=Mrecord, style=filled, fillcolor=green]
	n0000005e:port2 -> n00000062 [style=dashed]
	n0000005e:port1 -> n00000027:port0 [style=dashed]
	n0000005e:port1 -> n0000000d:port0 [style=dashed]
	n00000062 [label="ipu2_csi0 capture\n/dev/video6", shape=box, style=filled, fillcolor=yellow]
	n00000068 [label="{{<port0> 0} | ipu2_csi1\n/dev/v4l-subdev16 | {<port1> 1 | <port2> 2}}", shape=Mrecord, style=filled, fillcolor=green]
	n00000068:port2 -> n0000006c [style=dashed]
	n00000068:port1 -> n00000027:port0 [style=dashed]
	n00000068:port1 -> n0000000d:port0 [style=dashed]
	n0000006c [label="ipu2_csi1 capture\n/dev/video7", shape=box, style=filled, fillcolor=yellow]
}


--FCuugMFkClbJLl1L--
