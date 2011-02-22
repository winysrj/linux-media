Return-path: <mchehab@pedra>
Received: from ns.mm-sol.com ([213.240.235.226]:54412 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753754Ab1BVKjz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Feb 2011 05:39:55 -0500
From: Stanimir Varbanov <svarbanov@mm-sol.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, g.liakhovetski@gmx.de,
	saaguirre@ti.com, Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: [RFC/PATCH 0/1] New subdev sensor operation g_interface_parms
Date: Tue, 22 Feb 2011 12:31:52 +0200
Message-Id: <cover.1298368924.git.svarbanov@mm-sol.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This RFC patch adds a new subdev sensor operation named g_interface_parms.
It is planned as a not mandatory operation and it is driver's developer
decision to use it or not.

Please share your opinions and ideas.

---
It tries to create a common API for getting the sensor interface type
- serial or parallel, modes and interface clocks. The interface clocks
then are used in the host side to calculate it's configuration, check
that the clocks are not beyond host limitations etc.

"phy_rate" in serial interface (CSI DDR clk) is used to calculate
the CSI2 PHY receiver timing parameters: ths_settle, ths_term,
clk_settle and clk_term.

As the "phy_rate" depends on current sensor mode (configuration of the
sensor's PLL and internal clock domains) it can be treated as dynamic
parameter and can vary (could be different for viewfinder and still 
capture), in this context g_interface_parms should be called after
s_fmt.

"pix_clk" for parallel interface reflects the current sensor pixel
clock. With this clock the image data is clocked out of the sensor.

"pix_clk" for serial interface reflects the current sensor pixel
clock at which image date is read from sensor matrix.

"lanes" for serial interface reflects the number of PHY lanes used from
the sensor to output image data. This should be known from the host
side before the streaming is started. For some sensor modes it's
enough to use one lane, for bigger resolutions two lanes and more
are used.

"channel" for serial interface is also needed from host side to
configure it's PHY receiver at particular virtual channel.

---
Some background and inspiration.

- Currently in the OMAP3 ISP driver we use a set of platform data
callbacks to provide the above parameters and this comes to very
complicated platform code, driver implementation and unneeded 
sensor driver <-> host driver dependences. 

- In the present time we seeing growing count of sensor drivers and
host (bridge) drivers but without standard API's for communication.
Currently the subdev sensor operations have only one operation -
g_skip_top_lines.

Stanimir Varbanov (1):
  v4l: Introduce sensor operation for getting interface configuration

 include/media/v4l2-subdev.h |   42 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 42 insertions(+), 0 deletions(-)

