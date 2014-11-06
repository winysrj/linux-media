Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:62524 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193AbaKFW3N (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 6 Nov 2014 17:29:13 -0500
Date: Thu, 6 Nov 2014 23:29:06 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Andrew Chew <AChew@nvidia.com>
cc: "Pawel Osciak (posciak@google.com)" <posciak@google.com>,
	Bryan Wu <pengw@nvidia.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: soc-camera and focuser vcm devices
In-Reply-To: <804f809f79cf4e5ca24ec02be61402bd@HQMAIL103.nvidia.com>
Message-ID: <Pine.LNX.4.64.1411062304450.25946@axis700.grange>
References: <804f809f79cf4e5ca24ec02be61402bd@HQMAIL103.nvidia.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 4 Nov 2014, Andrew Chew wrote:

> Hello, Guennadi
> 
> I was wondering if you can provide some advice as to how focuser vcm 
> devices would fit into the soc-camera framework.  We have a raw sensor 
> (an IMX219) with an AD5823 VCM (it's just a simple I2C device) to 
> provide variable focus.
> 
> I currently have the sensor and camera host driver instantiated via 
> device tree, following the guidelines in 
> Documentation/devicetree/bindings/media/video-interfaces.txt, by using 
> the of_graph stuff, and that all works fine.  However, I'm not sure what 
> the proper way is to associate a focuser with that particular image 
> pipeline, and I couldn't find any examples to draw from.

As discussed in an earlier thread [1], in principle soc-camera has support 
for attaching multiple subdevices to a camera-host (camera DMA engine) 
driver. In [2] you can see how I initially implemented DT for soc-camera, 
which also supported multiple subdevices. Beware, very old code. Some more 
comments are in [3].

Thanks
Guennadi

[1] http://www.spinics.net/lists/linux-sh/msg31436.html - see comment, 
following "Hm, I think, this isn't quite correct."

[2] http://marc.info/?l=linux-sh&m=134875489304837&w=1

[3] https://www.mail-archive.com/linux-media@vger.kernel.org/msg70514.html

> 
> Any help/guidance would be appreciated!
> -----------------------------------------------------------------------------------
> This email message is for the sole use of the intended recipient(s) and may contain
> confidential information.  Any unauthorized review, use, disclosure or distribution
> is prohibited.  If you are not the intended recipient, please contact the sender by
> reply email and destroy all copies of the original message.
> -----------------------------------------------------------------------------------
> 
