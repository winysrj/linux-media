Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:37011 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbZJ0Kmf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Oct 2009 06:42:35 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [RFC] Media controller: next round of patches
Date: Tue, 27 Oct 2009 11:43:14 +0100
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200910271143.14182.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

I've committed 26 media controller patches to 
http://linuxtv.org/hg/~pinchartl/v4l-dvb-mc-uvc.

The code is in an early development phase, so I need to rework the patches and 
rebase the tree very often. Hg doesn't provide a rebase operation and 
linuxtv.org can't host git trees yet (AFAIK), so I've settled on quilt+hg. 
Patches are thus provided as a quilt series on top of the v4l-dvb repository 
head (at clone time).

The first 16 patches come directly from Hans' v4l-dvb-mc tree (including 
Devin's patches). The remaining patches are based on the 14 patches I've 
already posted.

Compared to the previous RFC/PATCH, this series adds

- video_device refactoring
- subdev device node support
- better subdev support in the UVC driver

As always feedback will be greatly appreciated, especially if you believe I'm 
headed in the wrong direction. If you don't have much time please comment on 
the video_device refactoring first.

-- 
Regards,

Laurent Pinchart
