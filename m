Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:56111 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752575AbZJWXpF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Oct 2009 19:45:05 -0400
Date: Sat, 24 Oct 2009 01:45:06 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Valentin Longchamp <valentin.longchamp@epfl.ch>
cc: Sascha Hauer <s.hauer@pengutronix.de>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 5/6] mx31moboard: camera support
In-Reply-To: <4ADF40BC.4090801@epfl.ch>
Message-ID: <Pine.LNX.4.64.0910240059150.8342@axis700.grange>
References: <1255599780-12948-1-git-send-email-valentin.longchamp@epfl.ch>
 <1255599780-12948-2-git-send-email-valentin.longchamp@epfl.ch>
 <1255599780-12948-3-git-send-email-valentin.longchamp@epfl.ch>
 <1255599780-12948-4-git-send-email-valentin.longchamp@epfl.ch>
 <1255599780-12948-5-git-send-email-valentin.longchamp@epfl.ch>
 <1255599780-12948-6-git-send-email-valentin.longchamp@epfl.ch>
 <Pine.LNX.4.64.0910162307160.26130@axis700.grange> <4ADC96A9.3090403@epfl.ch>
 <20091020080941.GN8818@pengutronix.de> <4ADF40BC.4090801@epfl.ch>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 21 Oct 2009, Valentin Longchamp wrote:

> Sascha Hauer wrote:
> > On Mon, Oct 19, 2009 at 06:41:13PM +0200, Valentin Longchamp wrote:
> > > Hi Guennadi,
> > > 
> > > Guennadi Liakhovetski wrote:
> > > > Hi
> > > > 
> > > > On Thu, 15 Oct 2009, Valentin Longchamp wrote:
> > > > 
> > > > > We have two mt9t031 cameras that have a muxed bus on the robot.
> > > > > We can control which one we are using with gpio outputs. This
> > > > > currently is not optimal
> > > > So, what prevents you from registering two platform devices for your two
> > > > cameras? Is there a problem with that?
> > > The lack of time until now to do it properly. I sent those patches as
> > > initial RFC (and by the way thanks for your comment).
> > > 
> > > I would like to have one video interface only and that I can switch
> > > between the two physical camera using a quite simple system call. Would
> > > that be compatible with registering the two platform devices ?
> > 
> > Wouldn't it be better to have /dev/video[01] for two cameras? How do
> > keep the registers synchron between both cameras otherwise?
> > 
> 
> Well, from my experimentations, most initializations are done when you open
> the device. So if you close the device, switch camera and open it again, the
> registers are initialized with the need values. Of course there is a problem
> is you switch camera while the device is open.
> 
> It could be ok with /dev/video[01], but I would need something that would
> prevent one device to be opened when the other already is open (a mutex, but
> where ?).
> 
> Besides, I have read a slide from Dongsoo Kim
> (http://www.celinuxforum.org/CelfPubWiki/ELC2009Presentations?action=AttachFile&do=get&target=Framework_for_digital_camera_in_linux-in_detail.ppt
> slides 41-47) and the cleanest solution would be to have the two chips
> enumerated with VIDIOC_ENUMINPUT as proposed. What would then be the v4l2 call
> to switch from one device to each other ? How to "link" it with the kernel
> code that make the real hardware switching ?

Ok, I don't have a definite answer to this, so, just my thoughts:

1. soc-camera currently registers one struct v4l2_device device per _host_ 
immediately upon its registration, and one struct video_device per 
_client_ platform device.

2. we currently have 1 or 2 boards in the mainline with two video client 
devices on one interface: arch/sh/boards/mach-migor/ and (unsure about) 
arch/sh/boards/board-ap325rxa.c. At least the first of them exports two 
platform devices and thus gets /dev/video[01]. Accesses are synchronised 
with a mutex (I don't actually like that, I'd prefer to get a -EBUSY back 
instead of hanging in D in open()), and a successful acquisition of the 
mutex switches the respective camera on. See code for details. So, this 
approach is supported and it works. In this case we have one v4l2_device 
and two video_device instances, don't know whether this matches how this 
is supposed to be done, but it works so far:-)

3. to support switching inputs, significant modifications to soc_camera.c 
would be required. I read Nate's argument before, that as long as clients 
can only be accessed one at a time, this should be presented by multiple 
inputs rather than multiple device nodes. Somebody else from the V4L folk 
has also confirmed this opinion. In principle I don't feel strongly either 
way. But currently soc-camera uses a one i2c client to one device node 
model, and I'm somewhat reluctant to change this before we're done with 
the v4l2-subdev conversion.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
