Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:44411 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbZIYRwC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Sep 2009 13:52:02 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Subject: Re: V4L-DVB Summit Day 2
Date: Fri, 25 Sep 2009 19:53:35 +0200
Cc: "v4l-dvb" <linux-media@vger.kernel.org>
References: <40e7bbfbf781ac7bdda6757a1292fe45.squirrel@webmail.xs4all.nl>
In-Reply-To: <40e7bbfbf781ac7bdda6757a1292fe45.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909251953.35529.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

Hans asked me to write a quick update on the global video buffers pool 
discussions. so here it is.

We started with a presentation of the global video buffers pool RFC[1], The 
proposal aimed at solving different problems related to video buffers 
allocation and management depending on the target platform. Everybody agreed 
that a video buffers pool was indeed needed.

The original proposal was to create pools at the media controller level for 
implementation ease (or maybe because I'm lazy at times :-)). It soon became 
clear that a truly global pool was desirable, and probably not more complex to 
implement.

Moving one more level upwards, it was proposed to make the buffers pool video-
agnostic so that it could be used for generic buffers, not only v4l2_buffers. 
However, such a global pool might have a hard time entering the mainline 
kernel, and using v4l2_buffers would be easier for V4L2 driver writers as the 
drivers already use those objects. The first implementation will thus likely 
be V4L2-specific.

As video buffers need to be shared with the GPU for some use cases (Xv video 
rendering, OpenGL textures, ...) the video buffers manager might need to 
interact with the GEM GPU memory manager. As no attendee was familiar with GEM 
this topic needs to be researched.

The conclusion was that the video buffers pool needs a lot more research 
followed by another RFC. The implementation will likely first focus on buffers 
allocation and management, and then move on video queuing latency issues 
(cache management).

[1] http://osdir.com/ml/linux-media/2009-09/msg00693.html

-- 
Regards,

Laurent Pinchart
