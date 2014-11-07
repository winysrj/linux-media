Return-path: <linux-media-owner@vger.kernel.org>
Received: from hqemgate16.nvidia.com ([216.228.121.65]:8705 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaKGBOV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Nov 2014 20:14:21 -0500
From: Andrew Chew <AChew@nvidia.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: "Pawel Osciak (posciak@google.com)" <posciak@google.com>,
	Bryan Wu <pengw@nvidia.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: RE: soc-camera and focuser vcm devices
Date: Fri, 7 Nov 2014 01:14:19 +0000
Message-ID: <c0b17f2320f74b0f96b2618a2d9e15d4@HQMAIL103.nvidia.com>
References: <804f809f79cf4e5ca24ec02be61402bd@HQMAIL103.nvidia.com>
 <Pine.LNX.4.64.1411062304450.25946@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1411062304450.25946@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> On Tue, 4 Nov 2014, Andrew Chew wrote:
> 
> > Hello, Guennadi
> >
> > I was wondering if you can provide some advice as to how focuser vcm
> > devices would fit into the soc-camera framework.  We have a raw sensor
> > (an IMX219) with an AD5823 VCM (it's just a simple I2C device) to
> > provide variable focus.
> >
> > I currently have the sensor and camera host driver instantiated via
> > device tree, following the guidelines in
> > Documentation/devicetree/bindings/media/video-interfaces.txt, by using
> > the of_graph stuff, and that all works fine.  However, I'm not sure
> > what the proper way is to associate a focuser with that particular
> > image pipeline, and I couldn't find any examples to draw from.
> 
> As discussed in an earlier thread [1], in principle soc-camera has support for
> attaching multiple subdevices to a camera-host (camera DMA engine) driver.
> In [2] you can see how I initially implemented DT for soc-camera, which also
> supported multiple subdevices. Beware, very old code. Some more
> comments are in [3].
> 
> Thanks
> Guennadi
> 
> [1] http://www.spinics.net/lists/linux-sh/msg31436.html - see comment,
> following "Hm, I think, this isn't quite correct."
> 
> [2] http://marc.info/?l=linux-sh&m=134875489304837&w=1
> 
> [3] https://www.mail-archive.com/linux-
> media@vger.kernel.org/msg70514.html

I think I get it, but just to clarify...currently, I'm going with the patch in [1], and I currently have multiple subdevs (sensors) hooked up and working with my soc-camera host driver.  [2] was an alternate implementation, right? (as in, I don't need it).

So I understand that I can just hook up the focuser and flash subdevs to the camera host via device tree, in the same exact way of using the of_graph stuff to hook up the sensor subdev.  My question is, is it then left up to the camera host driver to make sense of which subdevs do what?  Or should/will there be a common mechanism to bind ports on a camera host to a sensor, focuser, and flash under a common group which makes up an image pipeline?
-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
