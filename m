Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:32861 "EHLO
	smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbcF0R5t (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jun 2016 13:57:49 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	laurent.pinchart@ideasonboard.com
Cc: ulrich.hecht+renesas@gmail.com, hans.verkuil@cisco.com,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Subject: [RFC 0/2] [media] i2c: adv7482: add adv7482 driver
Date: Mon, 27 Jun 2016 19:56:55 +0200
Message-Id: <20160627175657.25391-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This is a RFC for the Analog Devices ADV7482 driver.

It is based on top of the media_tree and depends on the series '[PATCH 
0/2] move s_stream from v4l2_subdev_video_ops to move s_stream from 
v4l2_subdev_pad_ops'. It's tested on a Renesas Salvator-X board.

The driver is not ready for upstream and contains a few hard-coded 
restrictions and hacks. The restrictions are in large part deepening on 
from what I see as limitations to the v4l2 framework. The ADV7482 
supports two video pipelines which can run (almost) independent of each 
other, each pipeline terminates in a CSI-2 output TXA and TXB.

TXA is a 4-lane CSI-2 output which can be connected to ether a HDMI, 
CVBS or TTL input. TXB is a 1-lane CSI-2 output which can be connected 
to the CVBS input. To make things even more complex the datasheet states
that the TTL input can also be an output to which HDMI and CVBS inputs 
can be routed.

This RFC hard codes TXA to the HDMI input and TXB to the CVBS input 
since that is the only configuration I can test. It also do not consider 
the TTL port at all other then reserving a sink pad id for it.

I have modelled the driver with two source pads, one for TXA and one for 
TXB since I can't see any other way. And in this design I find 
limitations to the v4l2 framework, there are operations in struct 
v4l2_subdev_video_ops which now needs to know which source pad it should 
be acting on. I have tried to solve my immediate problem of the need for 
a pad aware s_stream in a separate series mention above but there are 
more operations that needs pad information.

I'm looking forward to trying to find solutions in v4l2 to thees 
problems but in this RFC there is a compile time define which decides 
which pad is the one used in such operations. Also some operations in 
struct v4l2_subdev_video_ops are context aware, for example g_std is 
only valid for TXB since it is connected to the CVBS input. But ofc one 
can call g_std from a driver hooked up to TXA (which is the HDMI) and 
would then get the standard for the CVBS. This results in lots of errors 
in v4l-compliance test. Things that I see needs to be figured out how to 
be pad aware are or extended in some other way are.

- g_std
- s_std
- querystd
- g_tvnorms
- g_input_status
- cropcap (needed for pixelaspect ratio)
- s_dv_timings
- g_dv_timings
- query_dv_timings
- Controlls, TXA and TXB both have a separate set of controls

Further more there are some hard-coded logic regarding which sink is 
connected to which source, this should be moved to s_routing. And 
default-input DT parameters should be added and acted upon. I did not 
want to spend time on this until I figured out how to best deal with the 
more pad aware operations.

Other limitations of the RFC that should be solved are:

- ADV7482 allows for most of its I2C slave addresses to be user 
  selectable. RFC uses hard coded values, thees should be moved to DT.

- EDID, get_edid and set_edid operations need to be added.

- Input format change interrupts like adv7180 have. Now one must
  call querystd or query_dv_timings for the driver to notice that the 
  format have changed.

Given all of the above issues the RFC do work and can deliver both HDMI 
and CVBS video simultaneously. It properly detects what source is 
connected to it and the two pipes can be independently started and 
stopped.

If anyone is interested to test on Salvator-X the following branch 
contains all the patches to grab video (rcar-vin for Gen3, rcar-cis2 and 
adv7482).

https://git.ragnatech.se/linux rcar-vin-gen3

Laurent Pinchart (1):
  media: entity: Add has_route entity operation

Niklas Söderlund (1):
  [media] i2c: adv7482: add adv7482 driver

 .../devicetree/bindings/media/i2c/adv7482.txt      |   62 +
 drivers/media/i2c/Kconfig                          |   10 +
 drivers/media/i2c/Makefile                         |    1 +
 drivers/media/i2c/adv7482.c                        | 1388 ++++++++++++++++++++
 include/media/media-entity.h                       |    5 +
 5 files changed, 1466 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/adv7482.txt
 create mode 100644 drivers/media/i2c/adv7482.c

-- 
2.8.3

