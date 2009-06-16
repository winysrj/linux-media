Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:58994 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751066AbZFPN7k (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jun 2009 09:59:40 -0400
Date: Tue, 16 Jun 2009 15:59:52 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Jonathan Cameron <jic23@cam.ac.uk>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Darius <augulis.darius@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] soc-camera: ov7670 merged multiple drivers and moved
 over to v4l2-subdev
In-Reply-To: <4A365918.40801@cam.ac.uk>
Message-ID: <Pine.LNX.4.64.0906161552420.4880@axis700.grange>
References: <4A365918.40801@cam.ac.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 15 Jun 2009, Jonathan Cameron wrote:

> From: Jonathan Cameron <jic23@cam.ac.uk>
> 
> OV7670 soc-camera driver. Merge of drivers from Jonathan Corbet,
> Darius Augulis and Jonathan Cameron

Could you please, describe in more detail how you merged them?

However, I am not sure this is the best way to go. I think, a better 
approach would be to take a driver currently in the mainline, perhaps, 
the most feature-complete one if there are several of them there, convert 
it and its user(s) to v4l2-subdev, extend it with any features missing in 
it and present in other drivers, then switch users of all other ov7670 
drivers over to this one, and finally make it work with soc-camera. This 
way you get a series of smaller and reviewable patches, instead of a 
completely new driver, that reproduces a lot of existing code but has to 
be reviewed anew. How does this sound?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
