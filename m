Return-path: <mchehab@localhost>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:17774 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753834Ab0IES54 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Sep 2010 14:57:56 -0400
Subject: Re: [Q] camera test pattern as an alternative input?
From: Andy Walls <awalls@md.metrocast.net>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1009051852250.434@axis700.grange>
References: <Pine.LNX.4.64.1009051852250.434@axis700.grange>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 05 Sep 2010 14:56:24 -0400
Message-ID: <1283712984.2057.85.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@localhost>

On Sun, 2010-09-05 at 19:09 +0200, Guennadi Liakhovetski wrote:
> In a currently running mt9m111 thread we're discussing ways to activate 
> one of camera's (sensor's) test patterns. A module parameter has been 
> proposed, earlier this has been done by just using the infamous 
> VIDIOC_DBG_S_REGISTER. But then it occurred to me, that there has been 
> previously such a discussion and it has been proposed to assign 
> alternative inputs to various test patterns. So, you just issue a 
> VIDIOC_S_INPUT to switch between the actual video input and one of test 
> patterns. Can anyone else remember such a discussion or maybe just knows 
> examples of such drivers?

The SAA7127 Video Encoder has a test pattern generator.  The saa7127.c
file uses a module option to enable it a module probe time.  It also
appears the v4l2_subdev.s_routing method of the saa7127 module can also
be used to switch to the test signal generator as input (So
VIDIOC_S_INPUT looks like it should work, maybe?).

There's your precedent.

Also using VIDIOC_S_INPUT also makes a lot of sense to me.  A test
pattern is an input; just an internal one as opposed to an external one.



>  A couple of grep attempts haven't revealed 
> anything. Is this a good idea?

I don't think it's bad.  Working through implementation details might
show you if anything is really bad (VIDIOC_ENUMINPUT, etc.).

Regards,
Andy

> Thanks
> Guennadi


