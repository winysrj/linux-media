Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44174 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130AbaAVWyn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jan 2014 17:54:43 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Detlev Casanova <detlev.casanova@gmail.com>
Cc: linux-media@vger.kernel.org, hyun.kwon@xilinx.com
Subject: qv4l2 and media controller support
Date: Wed, 22 Jan 2014 23:55:29 +0100
Message-ID: <2270106.dN7Lhra68Q@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans and Detlev,

While reviewed driver code that models the hardware using the media 
controller, I noticed a patch that enabled subdev controls inheritance for the 
video nodes. While this is useful for fixed devices, the complexity, 
genericity and flexibility of the hardware at hand makes this undesirable, 
given that we can't guarantee that a control won't be instantiated more than 
once in the pipeline.

I've thus asked what triggered the need for controls inheritance, and found 
out that the developers wanted to use qv4l2 as a demo application 
(congratulations to Hans for such a useful application :-)). As qv4l2 doesn't 
support subdevices, accessing controls required inheriting them on video 
nodes.

There's an existing GUI test application for media controller-based devices 
called mci (https://gitorious.org/mci) but it hasn't been maintained for quite 
some time, and isn't as feature-complete as qv4l2. I was thus wondering 
whether it would make sense to add explicit media controller support to qv4l2, 
or whether the two applications should remain separate (in the later case some 
code could probably still be shared).

Any opinion and/or desire to work on this ?

-- 
Regards,

Laurent Pinchart

