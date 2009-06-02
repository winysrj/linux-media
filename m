Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:44125 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbZFBKj7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Jun 2009 06:39:59 -0400
Received: from ravenclaw.localnet (249.248-240-81.adsl-static.isp.belgacom.be [81.240.248.249])
	by perceval.irobotique.be (Postfix) with ESMTPSA id DF87B35B26
	for <linux-media@vger.kernel.org>; Tue,  2 Jun 2009 10:39:59 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: linux-media@vger.kernel.org
Subject: VIDIOC_[GS]_JPEGCOMP clarifications
Date: Tue, 2 Jun 2009 12:44:43 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906021244.44288.laurent.pinchart@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

the VIDIOC_[GS]_JPEGCOMP documentation in the V4L2 specification is far from 
being clear and complete (which is probably why it's marked as [to do]). I'm 
implementing support for this ioctl in the uvcvideo driver and I'd like to 
request your opinion about the expected ioctl behavior.

- VIDIOC_[GS]_JPEGCOMP only make sense for (M)JPEG compressed formats. Should 
the ioctls return an error (-EINVAL ?) when the currently selected format 
isn't (M)JPEG ?

- VIDIOC_S_JPEGCOMP is a write-only ioctl. As such it can't return the quality 
value really applied to the device when the requested quality can't be 
achieved (either because the value is out of bounds or the quality values 
supported by the device have a higher granularity). Should the ioctl still 
succeed in that case, and apply a closest match quality to the device ?

- Similarly, should VIDIOC_S_JPEGCOMP fail if the requested JPEG markers 
combination is not supported by the device, or should it silently fix the 
value ?

- While JPEG-specific fields (such as markers) don't make sense for frame-
based compressed formats other than (M)JPEG, the quality field does. Would it 
be abusing the ioctl to use the quality field to get/set the compression 
quality for compression formats similar to JPEG ? If it would, what's the 
preferred way to set compression quality in V4L2 ?

Best regards,

Laurent Pinchart

