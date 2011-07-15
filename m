Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:59958 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab1GOPtW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2011 11:49:22 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id D8470189B6D
	for <linux-media@vger.kernel.org>; Fri, 15 Jul 2011 17:49:20 +0200 (CEST)
Date: Fri, 15 Jul 2011 17:49:20 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [RFC] soc-camera: remove device and bus abstractions
Message-ID: <Pine.LNX.4.64.1107151738210.22613@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm currently working on removing "struct device" from "struct 
soc_camera_device" and the "struct bus_type soc_camera_bus_type" bus. 
Reasoning - well, I've just got enough of them;-) Everything, what they 
are currently providing, can also be implemented directly. They served 
their purpose during the active soc-camera API development as a nice 
abstraction to build around, as debugging means, etc. But not, that also 
subdevices have got their own "struct video_device" and with "struct 
device" nodes embedded, I thi, we in v4l2 have (more than) enough devices 
to satisfy all sysfs fans;-)

So, this is just to let everyone know about my plans, don't know whether I 
manage it for 3.1, or will have to postpone to 3.2. In any case if anyone 
has any principle objections against this plan, please shout now!

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
