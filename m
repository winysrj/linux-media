Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:61620 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab2JMAQr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Oct 2012 20:16:47 -0400
Date: Sat, 13 Oct 2012 02:16:10 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sakari Ailus <sakari.ailus@iki.fi>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 05/14] media: add a V4L2 OF parser
In-Reply-To: <20121011194845.GQ14107@valkosipuli.retiisi.org.uk>
Message-ID: <Pine.LNX.4.64.1210130155490.23713@axis700.grange>
References: <1348754853-28619-1-git-send-email-g.liakhovetski@gmx.de>
 <201210051241.52205.hverkuil@xs4all.nl> <Pine.LNX.4.64.1210051250210.13761@axis700.grange>
 <201210051323.45571.hverkuil@xs4all.nl> <Pine.LNX.4.64.1210081306240.12203@axis700.grange>
 <20121011194845.GQ14107@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

Bearing in mind the local time, I hope my brevity will be excused:-) Just 
wanted to give a sign, that I just finished a first successful run of a 
fully asynchronous and uniform multi-component non-DT video (soc-camera) 
pipeline probing, verified by a sample capture. What this means:

The pipeline consists of 3 components: a sensor, a CSI-2 interface, and a 
bridge. The platform code registers 3 devices: 2 platform devices for the 
bridge and CSI-2 and an I2C device for the sensor. The bridge driver gets 
a list of device descriptors, which it passes to the (soc-camera) generic 
code. That is used to initialise internal data and install bus (platform- 
and i2c-) notifiers. After all components have been collected the normal 
probing continues.

Next week I'll (hopefully) be cleaning all this up and converting from 
soc-camera to V4L2 core... After that I'll start posting, beginning with 
v2 of this DT series, taking into account possibly many comments:-)

I think, it might make sense to first post and have a look at the purely 
asynchronous code, first without DT additions, that we planned to 
implement for bus notifiers and whatever is related to them. If that looks 
reasonable, we can move on with adding DT. (One of) the ugly part(s) is 
going to be, that with this we'll be supporting 3 (!) pipeline 
initialisation modes: current (legacy) mode, generating I2C devices on the 
fly, non-DT asynchronous with all devices probing independently, and DT... 
Let's see if all this actually flies.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
