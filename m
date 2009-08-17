Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:42974 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757529AbZHQKJD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Aug 2009 06:09:03 -0400
Date: Mon, 17 Aug 2009 12:09:12 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [Q] sensors, corrupting the top line
Message-ID: <Pine.LNX.4.64.0908171040310.4449@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans, all

In soc-camera since its first version we have a parameter "y_skip_top", 
which the sensor uses to tell the host (bridge) driver "I am sending you 
that many lines more than what is requested, and you should drop those 
lines from the top of the image." I never investigated this in detail, 
originally this was a "strong tip" that the top line is always corrupted. 
Now I did investigate it a bit by setting this parameter to 0 and looking 
what the sensors actually produce. I am working with four sensor: mt9m001, 
mt9v022, mt9t031 and ov7725, of which only the first two had that 
parameter set to 1 from the beginning, the others didn't have it and also 
showed no signs of a problem. mt9m001 (monochrome) doesn't have the 
problem either, but mt9v022 does. It does indeed deliver the first line 
with "randomly" coloured pixels. Notice - this is not the top line of the 
sensor, this is the first read-out line, independent of the cropping 
position. So, it seems we do indeed need a way to handle such sensors. Do 
you have a suggestion for a meaningful v4l2-subdev API for this?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
