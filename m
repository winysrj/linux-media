Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:38806 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756580AbZDPNT5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Apr 2009 09:19:57 -0400
Date: Thu, 16 Apr 2009 15:20:03 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: Re: [PATCH 5/5] soc-camera: Convert to a platform driver
In-Reply-To: <31771.62.70.2.252.1239885621.squirrel@webmail.xs4all.nl>
Message-ID: <Pine.LNX.4.64.0904161500440.4947@axis700.grange>
References: <31771.62.70.2.252.1239885621.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 16 Apr 2009, Hans Verkuil wrote:

> If you have mutually exclusive sources, then those should be implemented
> as one device with multiple inputs. There is really no difference between
> a TV capture driver that selects between a tuner and S-Video input, and a
> camera driver that selects between multiple cameras.
> 
> A completely different question is whether soc-camera should be used at
> all for this. The RFC Nate posted today said that this implementation was
> based around the S3C64XX SoC. The limitation of allowing only one camera
> at a time is a limitation of the hardware implementation, not of the SoC
> as far as I could tell.

This is the opposite to how I understood it. S3C6400 only has one set of 
camera interface signals, so, it is supposed to only handle one camera (at 
a time). As for mutual exclusivity - this is not enforced by the 
soc-camera framework, rather it is a limitation of the hardware - SoC and 
implementation. The implementor wants to prohibit access to the inactive 
camera, and that's where the conflict arises. The framework would then 
have to treat a solution with one host and multiple cameras differently 
depending on board implementation: if they are not mutually exclusive map 
them to multiple video devices, if they are - map them to multiple inputs 
on one video device...

> Given the fact that the SoC also supports codecs and other fun stuff, I
> really wonder whether there shouldn't be a proper driver for that SoC that
> supports all those features. Similar to what TI is doing for their davinci
> platform. It is my understanding that soc-camera is really meant as a
> simple framework around a sensor device, and not as a full-featured
> implementation for codecs, previews, etc. Please correct me if I'm wrong.

Having briefly looked at s3c6400, its video interface doesn't seem to be 
more advanced than, for instance, that of the PXA270 SoC. Ok, maybe only 
the preview path is missing on PXA.

soc-camera framework has been designed as a standard framework between 
SoCs and video data sources with the primary goal to allow driver reuse. 
The functionality that it implements is what was required at that time, 
plus what has been added since then. Yes, it does impose a couple of 
simplifications on the current V4L2 API. So, of course, a decision has to 
be made either or not to use it in every specific case.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
