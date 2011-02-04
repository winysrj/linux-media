Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.187]:62675 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351Ab1BDKJr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Feb 2011 05:09:47 -0500
Date: Fri, 4 Feb 2011 11:09:40 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: soc-camera: experimental git trees, please review / test
Message-ID: <Pine.LNX.4.64.1102041051030.14717@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi all

I've pushed 2 branches to my git repository at 
http://linuxtv.org/git/gliakhovetski/v4l-dvb.git - soc_camera-vb2 and 
devel-2.6.39. As is easy to guess from the names, the former one contains 
patches for the videobuf2 support by soc_camera and the latter one 
contains patches queued for 2.6.39.

The videobuf2 branch contains just the 3 patches I posted before: 
http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/28658 
and is meant to encourage users and developers to test the already ported 
to vb2 sh_mobile_ceu_camera driver and to port further camera host 
drivers.

The devel-2.6.39 branch accumulates a few patches, I've collected so far. 
Its purpose is to let submitters verify, whether they agree with how I 
pushes their patches, occasionally slightly modified, and whether I've 
lost any patches without commenting back, why I'm not applying it in its 
latest form. There is also one patch in the set, that can have impact on 
all soc_camera users:

commit 5c39a57a8b50f72e5d2020a0c6b5c3433f2397fc
Author: Anatolij Gustschin <agust@denx.de>

    V4L: soc-camera: start stream after queueing the buffers

I've tested it on i.MX31, SuperH, PXA270, would be nice to also have it 
tested on other soc-camera platforms. My concern is, that with this patch 
we change the order, in which the host and the client(s) drivers start 
streaming. Specifically, before this patch we first started streaming on 
the client, e.g., on an i2c sensor, upon which it would start sending 
frames. After that we start the host driver, so it has valid data 
immediately available and can immediately start capturing it. After this 
patch, we first start the host driver and _trust_ it to sit and wait until 
we also start the client. If, however, for some reason some hosts will 
start capturing immediately, they will capture invalid data. So, unless 
someone can concince me, that no sane video set up will ever do this, I'd 
like this to be explicitly tested on as many platforms as possible.

Enjoy;)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
