Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:41675 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934100AbZKXVwP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Nov 2009 16:52:15 -0500
Date: Tue, 24 Nov 2009 22:52:17 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Ryan Raasch <ryan.raasch@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Camera sensor
In-Reply-To: <4B0BE393.2080904@gmail.com>
Message-ID: <Pine.LNX.4.64.0911242244360.4680@axis700.grange>
References: <4B0BE393.2080904@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 24 Nov 2009, Ryan Raasch wrote:

> Hello,
> 
> I have implemented a driver for the LZ0P374 Sharp CCD camera sensor. I have
> been using an old kernel, and now i am updating to the new soc_camera
> framework. My question is, is there anyone using this sensor? We bought the
> sensor with absolutely no documents, support to be found (lucky to get driver
> running).

I've recently implemented a driver for a rj54n1cb0c camera, and I've seen 
it being referred to as lz0p398m... A simplified version of it is 
currently in the linux-next tree, and a more complete version has been 
submitted for review to the list. Would be interesting if you could dig 
out that driver from the mailing list archives and see how similar it is 
to your camera.

You can also see the patch-stack here

http://download.open-technology.de/soc-camera/20091105/

apply it to linux 2.6.32-rc5 and look at the resulting 
drivers/media/video/rj54n1cb0c.c file.

> It was found on the Sandgate 2P Sophia Systems development kit. The sensor is
> mainly (only) sold in Asia. But at the time of our product release (~2006),
> this was the only CCD camera sensor to be found in quantities less than
> millions.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
