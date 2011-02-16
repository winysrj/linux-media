Return-path: <mchehab@pedra>
Received: from devils.ext.ti.com ([198.47.26.153]:36060 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab1BPPlO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Feb 2011 10:41:14 -0500
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 16 Feb 2011 09:41:09 -0600
Subject: [Query] Soc_camera: Passing MIPI bus physical link details
Message-ID: <A24693684029E5489D1D202277BE894486B1D3BC@dlee02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Guennadi,

I have been working internally in a private 2.6.35.7 kernel with the TI OMAP4
platform, and as I have a very simple camera support driver (It just enables a
CSI2 Rx Interface), i decided to go for a soc-camera host implementation.

Now, I see that there is a set_bus_param callback function for host drivers,
which if i understand correctly, it tries to negotiate the bus parameters
between the host and the client.

But what i notice is that this seems to be mostly oriented towards a parallel
interface, as most of the things won't make much sense in MIPI CSI2 spec
(HSYNC_ACTIVE_HIGH, DATAWIDTH_x, etc.)

I was wondering what's the best way to be able to tell to the host driver
MIPI specific details such as, how many datalanes the interface is using, and
the MIPI Clk speed in which the sensor will be transmitting the data.

Does it make sense to expand this inside the [query/set]_bus_param APIs? or
Will it be better to implement a new v4l2_subdev_sensor_ops entry, something
like g_mipi_params?

Regards,
Sergio
