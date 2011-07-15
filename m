Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40921 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018Ab1GOQC1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2011 12:02:27 -0400
Message-ID: <4E20648F.6080601@redhat.com>
Date: Fri, 15 Jul 2011 13:02:23 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC] soc-camera: remove device and bus abstractions
References: <Pine.LNX.4.64.1107151738210.22613@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1107151738210.22613@axis700.grange>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 15-07-2011 12:49, Guennadi Liakhovetski escreveu:
> I'm currently working on removing "struct device" from "struct 
> soc_camera_device" and the "struct bus_type soc_camera_bus_type" bus. 
> Reasoning - well, I've just got enough of them;-) Everything, what they 
> are currently providing, can also be implemented directly. They served 
> their purpose during the active soc-camera API development as a nice 
> abstraction to build around, as debugging means, etc. But not, that also 
> subdevices have got their own "struct video_device" and with "struct 
> device" nodes embedded, I thi, we in v4l2 have (more than) enough devices 
> to satisfy all sysfs fans;-)

Very welcome plan.
> 
> So, this is just to let everyone know about my plans, don't know whether I 
> manage it for 3.1, or will have to postpone to 3.2. In any case if anyone 
> has any principle objections against this plan, please shout now!

It is probably too late for 3.1, as the merge window will likely start next
week. So, all patches for 3.1 are likely already submitted.

Cheers,
Mauro.
