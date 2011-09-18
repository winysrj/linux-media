Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59230 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932770Ab1IRXY7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Sep 2011 19:24:59 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: Asking advice for Camera/ISP driver framework design
Date: Mon, 19 Sep 2011 01:25:02 +0200
Cc: Cliff Cai <cliffcai.sh@gmail.com>, linux-media@vger.kernel.org
References: <CAFhB-RACaxtkBuXsch5-giTBqCHR+s5_SP-sGeR=E1HVeGfQLQ@mail.gmail.com> <CAFhB-RB8Pm--H5__kjKN=v=7pF0xtt_VKJw0Dh3YfQ6GE+4KVg@mail.gmail.com> <4E72319C.4030904@iki.fi>
In-Reply-To: <4E72319C.4030904@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109190125.02713.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Cliff,

On Thursday 15 September 2011 19:10:52 Sakari Ailus wrote:
> Cliff Cai wrote:
> > On Thu, Sep 15, 2011 at 6:20 PM, Laurent Pinchart wrote:
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
> >> Your driver should create two video nodes, one for each stream. They
> >> will each have their own buffers queue.
> >> 
> >> The driver should also implement the media controller API to let
> >> applications discover that the video nodes are related and how they
> >> interact with the ISP.
> > 
> > As "Documentation/media-framework" says, one of the goals of media
> > device model is "Discovering a device internal topology,and
> > configuring it at runtime".I'm just a bit confused about how
> > applications can discover the related video notes? Could you explain
> > it a little more?
> 
> The major and minor numbers of video nodes are provided to the user
> space in struct media_entity_desc (defined in include/linux/media.h)
> using MEDIA_IOC_ENUM_ENTITIES IOCTL. The major and minor numbers define
> which device node corresponds to the video device; this isn't trivial
> for an application to do so there's a library which makes it easier:
> 
> <URL:http://git.ideasonboard.org/?p=media-ctl.git;a=summary>
> 
> See src/media.h for the interface. An example how to use this is
> available in src/main.c.
> 
> Entities the type of which is MEDIA_ENT_T_DEVNODE_V4L are V4L2 device
> nodes.

http://www.ideasonboard.org/media/omap3isp.ps shows a device topology example 
generated automatically from the output of the media-ctl tool.

-- 
Regards,

Laurent Pinchart
