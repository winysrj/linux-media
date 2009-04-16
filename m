Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:34528 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754946AbZDPMGG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Apr 2009 08:06:06 -0400
Date: Thu, 16 Apr 2009 14:06:11 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: Re: [PATCH 5/5] soc-camera: Convert to a platform driver
In-Reply-To: <5e9665e10904160409n26ecec11n89569b33d4797c6c@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0904161328420.4947@axis700.grange>
References: <Pine.LNX.4.64.0904151356480.4729@axis700.grange>
 <Pine.LNX.4.64.0904151403500.4729@axis700.grange>
 <5e9665e10904151919p50c695e2s35140402d2c7345c@mail.gmail.com>
 <Pine.LNX.4.64.0904161032050.4947@axis700.grange>
 <5e9665e10904160300k7e581910r73710d8ffe5230a8@mail.gmail.com>
 <Pine.LNX.4.64.0904161214200.4947@axis700.grange>
 <5e9665e10904160409n26ecec11n89569b33d4797c6c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 16 Apr 2009, Dongsoo, Nathaniel Kim wrote:

> My concern is all about the logical thing. "Why can't we open device
> node even if it is not opened from any other process."

The answer is of course "because the other node is currently active," but 
I can understand the sort of "confusion" that the user might have: we have 
two "independent" device nodes, but only one of them can be active at any 
given time. So, in a way you're right, this might not be very intuitive.

> I have been working on dual camera with Linux for few years, and
> everybody who I'm working with wants not to fail opening camera device
> node in the first place. Actually I'm mobile phone developer and I've
> been seeing so many exceptional cases in field with dual camera
> applications. With all my experiences, I got my conclusion which is
> "Don't make user get confused with device opening failure". I want you
> to know that no offence but just want to make it better.

Sure, I appreciate your opinion and respect your experience, but let's 
have a look at the current concept:

1. the platform has N cameras on camera interface X
2. soc_camera.c finds the matching interface X and creates M (<= N) nodes 
for all successfully probed devices.
3. in the beginning, as long as no device is open, all cameras are powered 
down / inactive.
4. you then open() one of them, it gets powered on / activated, the others 
become unaccessible as long as one is used.
5. this way switching is easy - you're sure, that when no device is open, 
all cameras are powered down, so, you can safely select any of them.
6. module reference-counting is easy too - every open() of a device-node 
increments the use-count

With your proposed approach:

1. the platform has N cameras on camera interface X.
2. as long as at least one camera probed successfully for interface X, you 
create a videoX device and count inputs for it - successfully probed 
cameras.
3. you open videoX, one "default" camera gets activated immediately - not 
all applications issue S_INPUT, so, there has to be a default.
4. if an S_INPUT is issued, you have to verify, whether any camera is 
currently active / capturing, if none - switch to the requested one, if 
one is active - return -EBUSY.
5. reference-counting and guaranteeing consistency is more difficult, as 
well as handling camera driver loading / unloading.

So, I would say, your approach adds complexity and asymmetry. Can it be 
that one camera client has several inputs itself? E.g., a decoder? In any 
case, I wouldn't do this now, if we do decide in favour of your approach, 
then only after the v4l2-device transition, please.

> But the mt9v022 case, I should need some research.

Ok.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
