Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57036 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab1DHRHD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Apr 2011 13:07:03 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: javier Martin <javier.martin@vista-silicon.com>
Subject: Re: mt9t111 sensor on Beagleboard xM
Date: Fri, 8 Apr 2011 19:07:02 +0200
Cc: linux-media@vger.kernel.org
References: <BANLkTin35p+xPHWkf3WsGNPzL9aeUwsazQ@mail.gmail.com> <201104081707.17576.laurent.pinchart@ideasonboard.com> <BANLkTi=NTHHyGRhCff+wvXWL4pD+Dv4b8w@mail.gmail.com>
In-Reply-To: <BANLkTi=NTHHyGRhCff+wvXWL4pD+Dv4b8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104081907.02509.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Javier,

On Friday 08 April 2011 17:30:54 javier Martin wrote:
> On 8 April 2011 17:07, Laurent Pinchart wrote:
> > On Friday 08 April 2011 17:02:48 javier Martin wrote:
> >> Hi,
> >> I've just received a LI-LBCM3M1 camera module from Leopard Imaging and
> >> I want to test it with my Beagleboard xM. This module has a mt9t111
> >> sensor.
> >> 
> >> At first glance, this driver
> >> (http://lxr.linux.no/#linux+v2.6.38/drivers/media/video/mt9t112.c)
> >> supports mt9t111 sensor and uses both soc-camera and v4l2-subdev
> >> frameworks.
> >> I am trying to somehow connect this sensor with the omap3isp driver
> >> recently merged (I'm working with latest mainline kernel), however, I
> >> found an issue when trying to pass "mt9t112_camera_info" data to the
> >> sensor driver in my board specific file.
> >> 
> >> It seems that this data is passed through soc-camera but omap3isp
> >> doesn't use soc-camera. Do you know what kind of changes are required
> >> to adapt this driver so that it can be used with omap3isp?
> > 
> > The OMAP3 ISP driver isn't compatible with the soc-camera framework, as
> > you correctly noticed. You will need to port the MT9T111 driver to
> > pad-level subdev operations.
> > 
> > You can find a sensor driver (MT9V032) implementing pad-level subdev
> > operations at
> > http://git.linuxtv.org/pinchartl/media.git?a=commit;h=940b87a5cb7ea3f3cff
> > 16454e9085e33ab340064
> 
> Hi Laurent,
> thank you for your quick answer.
> 
> Does the fact of adding pad-level subdev operations for the sensor
> break  old way of doing things?

Adding pad-level operations will not break any existing driver, as long as you 
keep the existing operations functional.

> I mean, if I port MT9T111 driver to pad-level subdev operations would
> it be accepted for mainline or would it be rejected since it breaks
> something older?

The patch will be accepted if you don't break anything :-)

We first need to add pad-level operations to subdev drivers. The next step 
will be to convert bridge drivers to pad-level operations, at which point 
legacy operations will be removed from subdevs.

-- 
Regards,

Laurent Pinchart
