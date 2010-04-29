Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:53949 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932929Ab0D3RlN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Apr 2010 13:41:13 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [ANNOUNCEMENT] Media controller tree updated
Date: Thu, 29 Apr 2010 23:07:03 +0200
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	Vaibhav Hiremath <hvaibhav@ti.com>,
	Pawel Osciak <p.osciak@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"Zhang, Xiaolin" <xiaolin.zhang@intel.com>,
	Guru Raj <gururaj.nagendra@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201004292307.04385.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

The next version of the media controller patches is available in git at

http://git.linuxtv.org/pinchartl/v4l-dvb-media.git

To avoid putting too much pressure on the linuxtv.org git server, please make 
sure you reference an existing mainline Linux git tree when cloning v4l-dvb-
media (see the --reference option to git-clone).

Beside the media controller core, the tree contains a uvcvideo driver ported 
to the media controller. If you want to test the media controller code with 
the OMAP3 ISP driver, you can check out the devel branch in the 
http://gitorious.org/omap3camera/mainline/ tree instead.

WARNING: Don't unplug the device or unload the driver while holding a 
/dev/media or /dev/subdev device open. This problem will be fixed in a future 
release.

-- 
Regards,

Laurent Pinchart
