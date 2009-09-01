Return-path: <linux-media-owner@vger.kernel.org>
Received: from ppsw-1.csi.cam.ac.uk ([131.111.8.131]:55145 "EHLO
	ppsw-1.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbZIASob (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Sep 2009 14:44:31 -0400
Message-ID: <4A9D6B98.5090003@cam.ac.uk>
Date: Tue, 01 Sep 2009 19:44:40 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: soc-camera: Handling hardware reset?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear all,

With an ov7670 I have been using soc_camera_link.reset to pass in board specific
hardware reset of the sensor. (Is this a correct usage? The reset must occur
before the chip is used.)

Unfortunately this function is called on every initialization of the camera
(so on probe and before taking images). Basically any call to open()

This would be fine if the v4l2_subdev_core_ops.init  was called after every
call of this (ensuring valid state post reset). 

Previously I was using the soc_camera_ops.init to call the core init function
thus putting the register values back before capturing, but now it's gone from
the interface.

What is the right way to do this?

Thanks,

Jonathan
