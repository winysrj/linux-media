Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:61851 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758672Ab1IIRnZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Sep 2011 13:43:25 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 79B3E18B03B
	for <linux-media@vger.kernel.org>; Fri,  9 Sep 2011 19:43:23 +0200 (CEST)
Date: Fri, 9 Sep 2011 19:43:23 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 0/4] release soc-camera client drivers into the wild V4L2
 world;-)
Message-ID: <Pine.LNX.4.64.1109091917260.915@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch set finally makes most (except for two) soc-camera client 
(sensor and 1 tv-decoder) drivers also usable outside of the framework. 
The drivers still include headers and rely on a couple of inline and 
out-of-line library functions, which just means you have to build and load 
the soc_camera.ko module. Otherwise there should be no run-time 
dependencies. Completely untested, of course (without soc-camera);-)

All patches are again available under the well-known location

git://linuxtv.org/gliakhovetski/v4l-dvb.git rc1-for-3.2

Enjoy
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
