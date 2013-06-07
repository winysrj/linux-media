Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:57573 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671Ab3FGKuE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Jun 2013 06:50:04 -0400
Date: Fri, 7 Jun 2013 12:49:49 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 05/13] soc_camera: replace vdev->parent by vdev->v4l2_dev.
In-Reply-To: <201306071229.39416.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1306071232490.11277@axis700.grange>
References: <1370252210-4994-1-git-send-email-hverkuil@xs4all.nl>
 <Pine.LNX.4.64.1306071129580.11277@axis700.grange> <201306071141.30383.hverkuil@xs4all.nl>
 <201306071229.39416.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 7 Jun 2013, Hans Verkuil wrote:

> Stupid question perhaps, but why is soc_camera_device a platform_device?

Partially that's historic.

> It's weird. The camera host device is definitely a platform_device, and
> the video nodes are childs of that platform_device, but soc_camera_device
> doesn't map to any hardware.

Using platform devices for camera sensors etc. is a way to inform the 
soc-camera core about them. Soc-camera core registers a platform driver, 
which probes those devices, and then, once soc-camera hosts register with 
the soc-camera core, they are matched against those platform devices. Yes, 
this could also be done differently - hosts could just pass lists of 
respective camera sensor descriptors, but soc-camera is currently using a 
different approach. This anyway is going to disappear once we convert to 
asynchronous probing...

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
