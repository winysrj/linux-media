Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:61555 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754532Ab1IMOiT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Sep 2011 10:38:19 -0400
Date: Tue, 13 Sep 2011 16:38:14 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: soc-camera: future directions
Message-ID: <Pine.LNX.4.64.1109131024030.17902@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all

(a slightly more complete version of this post with some background 
information is available at 
http://www.open-technology.de/index.php?/archives/80-soc-camera-3.2-and-beyond-roadmap.html
)

As you all are certainly aware, the soc-camera framework in its present 
state, as published at

http://git.linuxtv.org/gliakhovetski/v4l-dvb.git/shortlog/refs/heads/rc1-for-3.2

has converted almost all its sensor and TV-decoder drivers to be usable 
with generic V4L2 bridge drivers (thanks to Hans Verkuil for V4L2 control 
framework conversion). Next on our roadmap is support for the Media 
Controller and pad-level APIs. Below are a couple of ideas, how this could 
be done, without any supporting code yet. The purpose of this post is to 
formalise my ideas a bit and to give you all a chance to point out any 
flaws in my concept. Since I haven't so far worked too closely with MC, 
such flaws are quite possible.

At the moment the soc-camera framework is mostly designed around a model, 
in which the video subsystem consists of a video capture interface on the 
SoC, handled as a single block, and one external capture device, like a 
camera sensor or a TV-decoder, connected to the above interface and 
additionally controlled over I2C or by some other means.

Extending this model to better support multi-entity configurations is also 
on my TODO list, but is a separate task, therefore in this first step of 
the MC conversion I will initially address this simplistic 2-point scheme, 
but try to make design decisions, that would make supporting more complex 
configurations in the future simple enough.

The actual idea for this first step is to add an ability to support client 
(sensor and decoder) drivers, implementing the pad-level API, to 
soc-camera in a native way. This means, without wrapping subdev pad 
operations in standard video and core subdev operations, but by building a 
minimum MC implementation on top of existing soc-camera SoC (host / 
bridge) drivers, ideally, without having to modify them at all. That way, 
if a standard subdev driver is attached to your SoC, you get a standard 
V4L2 user-space interface, if your subdev driver implements pad-level 
operations, you can get a functional MC interface in user space with the 
same SoC driver.

Such a minimal MC implementation would create two entities: one for the 
actual video device (for the DMA engine), and one for the external video 
interface. In this simple case they shall be connected by an immutable 
link. The external pad will then be linked to the external video device, 
at least in the typical simple case of only one source pad on it.

Additionally, it should be possible for SoC drivers to implement advanced 
MC support, while still using parts of the soc-camera infrastructure.

In the most generic case, when both the SoC and the client drivers 
implement their own MC API support, the soc-camera framework should be 
made aware of the fact, that the configuration of all the entities in the 
system can change at any time, bypassing soc-camera interfaces, which 
means no cached values can be used by the soc-camera core.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
