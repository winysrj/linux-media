Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:50365 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab2KFJOi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Nov 2012 04:14:38 -0500
Date: Tue, 6 Nov 2012 10:14:23 +0100
From: Anatolij Gustschin <agust@denx.de>
To: linux-media@vger.kernel.org
Cc: Bastian Hecht <hechtb@gmail.com>
Subject: Using OV5642 sensor driver for CM8206-A500SA-E
Message-ID: <20121106101423.068bcd3e@wker>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm trying to use mainline ov5642 driver for ov5642 based camera
module CM8206-A500SA-E from TRULY. The driver loads and initializes
the sensor, but the initialization seems to be incomplete, the sensor
doesn't generate pixel clock and sync signals.

For a quick test I've replaced the default initialisation sequences
from ov5642_default_regs_init[] and ov5642_default_regs_finalise[]
with an init sequence in ov5642_setting_30fps_720P_1280_720[] taken
from Freescale ov5642 driver [1] and commented out ov5642_set_resolution()
in ov5642_s_power(). With these changes to the mainline driver the
sensor starts clocking out pixels and I receive 1280x720 image.

Is anyone using the mainline ov5642 driver for mentioned TRULY camera
module? Just wanted to ask before digging further to find out what
changes to the mainline driver are really needed to make it working
with TRULY camera module.

Thanks,
Anatolij

[1] http://git.freescale.com/git/cgit.cgi/imx/linux-2.6-imx.git/plain/drivers/media/video/mxc/capture/ov5642.c?h=imx_3.0.15
