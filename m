Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1818 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab1IZKzL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Sep 2011 06:55:11 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: Asking advice for Camera/ISP driver framework design
Date: Mon, 26 Sep 2011 12:55:05 +0200
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Cliff Cai <cliffcai.sh@gmail.com>, linux-media@vger.kernel.org
References: <CAFhB-RACaxtkBuXsch5-giTBqCHR+s5_SP-sGeR=E1HVeGfQLQ@mail.gmail.com> <CAFhB-RB8Pm--H5__kjKN=v=7pF0xtt_VKJw0Dh3YfQ6GE+4KVg@mail.gmail.com> <4E72319C.4030904@iki.fi>
In-Reply-To: <4E72319C.4030904@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109261255.05783.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday, September 15, 2011 19:10:52 Sakari Ailus wrote:
> Cliff Cai wrote:
> > On Thu, Sep 15, 2011 at 6:20 PM, Laurent Pinchart
> > <laurent.pinchart@ideasonboard.com> wrote:
> >> Hi Cliff,
> >>
> >> On Wednesday 14 September 2011 08:13:32 Cliff Cai wrote:
> >>> Dear guys,
> >>>
> >>> I'm currently working on a camera/ISP Linux driver project.Of course,I
> >>> want it to be a V4L2 driver,but I got a problem about how to design
> >>> the driver framework.
> >>> let me introduce the background of this ISP(Image signal processor) a
> >>> little bit.
> >>> 1.The ISP has two output paths,first one called main path which is
> >>> used to transfer image data for taking picture and recording,the other
> >>> one called preview path which is used to transfer image data for
> >>> previewing.
> >>> 2.the two paths have the same image data input from sensor,but their
> >>> outputs are different,the output of main path is high quality and
> >>> larger image,while the output of preview path is smaller image.
> >>> 3.the two output paths have independent DMA engines used to move image
> >>> data to system memory.
> >>>
> >>> The problem is currently, the V4L2 framework seems only support one
> >>> buffer queue,and in my case,obviously,two buffer queues are required.
> >>> Any idea/advice for implementing such kind of V4L2 driver? or any
> >>> other better solutions?
> >>
> >> Your driver should create two video nodes, one for each stream. They will each
> >> have their own buffers queue.
> >>
> >> The driver should also implement the media controller API to let applications
> >> discover that the video nodes are related and how they interact with the ISP.
> > 
> > Hi Laurent,
> > 
> > As "Documentation/media-framework" says, one of the goals of media
> > device model is "Discovering a device internal topology,and
> > configuring it at runtime".I'm just a bit confused about how
> > applications can discover the related video notes? Could you explain
> > it a little more?
> 
> Hi Cliff,
> 
> The major and minor numbers of video nodes are provided to the user
> space in struct media_entity_desc (defined in include/linux/media.h)
> using MEDIA_IOC_ENUM_ENTITIES IOCTL. The major and minor numbers define
> which device node corresponds to the video device; this isn't trivial
> for an application to do so there's a library which makes it easier:
> 
> <URL:http://git.ideasonboard.org/?p=media-ctl.git;a=summary>

That reminds me: Laurent, this should really be moved to v4l-utils.git.
Any progress on that?

Regards,

	Hans

> 
> See src/media.h for the interface. An example how to use this is
> available in src/main.c.
> 
> Entities the type of which is MEDIA_ENT_T_DEVNODE_V4L are V4L2 device nodes.
> 
> Regards,
> 
> 
