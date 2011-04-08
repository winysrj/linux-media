Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60939 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757204Ab1DHPHQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Apr 2011 11:07:16 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: javier Martin <javier.martin@vista-silicon.com>
Subject: Re: mt9t111 sensor on Beagleboard xM
Date: Fri, 8 Apr 2011 17:07:17 +0200
Cc: linux-media@vger.kernel.org
References: <BANLkTin35p+xPHWkf3WsGNPzL9aeUwsazQ@mail.gmail.com>
In-Reply-To: <BANLkTin35p+xPHWkf3WsGNPzL9aeUwsazQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104081707.17576.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Javier,

On Friday 08 April 2011 17:02:48 javier Martin wrote:
> Hi,
> I've just received a LI-LBCM3M1 camera module from Leopard Imaging and
> I want to test it with my Beagleboard xM. This module has a mt9t111
> sensor.
> 
> At first glance, this driver
> (http://lxr.linux.no/#linux+v2.6.38/drivers/media/video/mt9t112.c)
> supports mt9t111 sensor and uses both soc-camera and v4l2-subdev
> frameworks.
> I am trying to somehow connect this sensor with the omap3isp driver
> recently merged (I'm working with latest mainline kernel), however, I
> found an issue when trying to pass "mt9t112_camera_info" data to the
> sensor driver in my board specific file.
> 
> It seems that this data is passed through soc-camera but omap3isp
> doesn't use soc-camera. Do you know what kind of changes are required
> to adapt this driver so that it can be used with omap3isp?

The OMAP3 ISP driver isn't compatible with the soc-camera framework, as you 
correctly noticed. You will need to port the MT9T111 driver to pad-level 
subdev operations.

You can find a sensor driver (MT9V032) implementing pad-level subdev 
operations at 
http://git.linuxtv.org/pinchartl/media.git?a=commit;h=940b87a5cb7ea3f3cff16454e9085e33ab340064 

-- 
Regards,

Laurent Pinchart
