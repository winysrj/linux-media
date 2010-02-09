Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4842 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211Ab0BIHuA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Feb 2010 02:50:00 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	"laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>
Subject: Re: Requested feedback on V4L2 driver design
Date: Tue, 9 Feb 2010 08:51:40 +0100
Cc: "Maupin, Chase" <chase.maupin@ti.com>,
	"sakari.ailus@maxwell.research.nokia.com"
	<sakari.ailus@maxwell.research.nokia.com>,
	"vpss_driver_design@list.ti.com - This list is to discuss the VPSS
	driver design (May contain non-TIers)"
	<vpss_driver_design@list.ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <131E5DFBE7373E4C8D813795A6AA7F0802C4E0FF3E@dlee06.ent.ti.com> <4B7072A4.7070708@infradead.org>
In-Reply-To: <4B7072A4.7070708@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002090851.40152.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 08 February 2010 21:23:00 Mauro Carvalho Chehab wrote:
> Maupin, Chase wrote:
> > All,
> > 
> > Texas Instruments (TI) is working on the design for the V4L2 capture and display drivers for our next generation system-on-chip (SoC) processor and would like to solicit your feedback.  Our new SoCs have been improved to allow for higher video resolutions and greater frame rates.  To this end the display hardware has been moved to a separate processing block called the video processing subsystem (VPSS).  The VPSS will be running a firmware image that controls the capture/display hardware and services requests from one or more host processors.
> > 
> > Moving to a remote processor for the processing of video input and output data requires that commands to control the hardware be passed to this processing block using some form of inter-processor communication (IPC).  TI would like to solicit your feedback on proposal for the V4L2 driver design to get a feel for whether or not this design would be accepted into the Linux kernel.  To this end we have put together an overview of the design and usage on our wiki at http://wiki.davincidsp.com/index.php/Video_Processing_Subsystem_Driver_Design.  We would greatly appreciate feedback from community members on the acceptability of our driver design.
> > 
> > If you have additional questions or need more information please feel free to contact us (we have setup a mailing list at vpss_driver_design@list.ti.com) so we can answer them.
> > 
> 
> Hi Chase,
> 
> I'm not sure if I got all the details on your proposal, so let me try to give my
> understanding.
> 
> First of all, for normal usage (e.g. capturing a stream or sending an stream
> to an output device), the driver should work with only the standard V4L2 API.
> I'm assuming that the driver will provide this capability.
> 
> I understand that, being a SoC hardware, there are much more that can be done
> than just doing the normal stream capture/output, already supported by V4L2 API.
> 
> For such advanced usages, we're open to a proposal to enhance the existing API
> to support the needs. There are some important aspects that need to be considered
> when designing any Linux userspace API's:

The full functionality of this device can be handled by the proposals made during
last year's LPC and that are currently being implemented/prototyped for omap3.
That's no coincidence, by the way :-)

> 
> 	1) kernel-userspace API's are forever. So, they need to be designed in
> a way that new technology changes won't break the old API;
> 
> 	2) API's are meant to be generic. So, they needed to be designed in a way
> that, if another hardware with similar features require an API, the planned one
> should fit;
> 
> 	3) The API's should be, as much as possible, independent of the hardware
> architecture. You'll see that even low-level architecture dependent stuff, like
> bus drivers are designed in a way that they are not bound to a particular hardware,
> but instead provide the same common methods to interact with the hardware to other
> device drivers.
> 
> That's said, it would be interesting if you could give us a more deep detail on 
> what kind of functionalities and how do you think you'll be implementing them.

For me the core issue will be the communication between the main ARM and the ARM
controlling the VPSS. Looking at the syslink part of the git tree it all looks
way overengineered to me. In particular the multicore_ipc directory. Is all that
code involved in setting up the communication path between the main and VPSS ARM?
Is there some more detailed document describing how the syslink code works?

What I would expect to see is standard mailbox functionality that is used in other
places as well. I gather that at the bottom there actually seems to be a mailbox
involved with syslink, but there also seems to be a lot of layers on top of that.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
