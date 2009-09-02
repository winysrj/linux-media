Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:48342 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752683AbZIBQHi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Sep 2009 12:07:38 -0400
Date: Wed, 2 Sep 2009 18:07:49 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Jonathan Cameron <jic23@cam.ac.uk>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: soc-camera: Handling hardware reset?
In-Reply-To: <4A9D6B98.5090003@cam.ac.uk>
Message-ID: <Pine.LNX.4.64.0909021755391.6326@axis700.grange>
References: <4A9D6B98.5090003@cam.ac.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 1 Sep 2009, Jonathan Cameron wrote:

> Dear all,
> 
> With an ov7670 I have been using soc_camera_link.reset to pass in board specific
> hardware reset of the sensor. (Is this a correct usage? The reset must occur
> before the chip is used.)
> 
> Unfortunately this function is called on every initialization of the camera
> (so on probe and before taking images). Basically any call to open()
> 
> This would be fine if the v4l2_subdev_core_ops.init  was called after every
> call of this (ensuring valid state post reset). 
> 
> Previously I was using the soc_camera_ops.init to call the core init function
> thus putting the register values back before capturing, but now it's gone from
> the interface.
> 
> What is the right way to do this?

The idea is, that we're trying to save power, as long as noone is using 
the camera, i.e., between the last close and the next open. But some 
boards might not implement the power callback, so, to make the situation 
equal for all, we also added a reset call on every first open. So, this is 
exactly your case. Imagine, your camera driver has to work on a platform, 
where power callbacks are implemented. So, in your .s_fmt() (or the new 
.s_imgbus_fmt()) method, which is always called on the first open, you 
have to be able to configure the chip after a fresh power-on.

(isn't this a job for runtime-pm?...)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
