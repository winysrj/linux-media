Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45505 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858Ab0BHUXK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Feb 2010 15:23:10 -0500
Message-ID: <4B7072A4.7070708@infradead.org>
Date: Mon, 08 Feb 2010 18:23:00 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: "Maupin, Chase" <chase.maupin@ti.com>
CC: Hans Verkuil <hans.verkuil@tandberg.com>,
	"laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>,
	"sakari.ailus@maxwell.research.nokia.com"
	<sakari.ailus@maxwell.research.nokia.com>,
	"vpss_driver_design@list.ti.com - This list is to discuss the VPSS
	driver design (May contain non-TIers)"
	<vpss_driver_design@list.ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Requested feedback on V4L2 driver design
References: <131E5DFBE7373E4C8D813795A6AA7F0802C4E0FF3E@dlee06.ent.ti.com>
In-Reply-To: <131E5DFBE7373E4C8D813795A6AA7F0802C4E0FF3E@dlee06.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Maupin, Chase wrote:
> All,
> 
> Texas Instruments (TI) is working on the design for the V4L2 capture and display drivers for our next generation system-on-chip (SoC) processor and would like to solicit your feedback.  Our new SoCs have been improved to allow for higher video resolutions and greater frame rates.  To this end the display hardware has been moved to a separate processing block called the video processing subsystem (VPSS).  The VPSS will be running a firmware image that controls the capture/display hardware and services requests from one or more host processors.
> 
> Moving to a remote processor for the processing of video input and output data requires that commands to control the hardware be passed to this processing block using some form of inter-processor communication (IPC).  TI would like to solicit your feedback on proposal for the V4L2 driver design to get a feel for whether or not this design would be accepted into the Linux kernel.  To this end we have put together an overview of the design and usage on our wiki at http://wiki.davincidsp.com/index.php/Video_Processing_Subsystem_Driver_Design.  We would greatly appreciate feedback from community members on the acceptability of our driver design.
> 
> If you have additional questions or need more information please feel free to contact us (we have setup a mailing list at vpss_driver_design@list.ti.com) so we can answer them.
> 

Hi Chase,

I'm not sure if I got all the details on your proposal, so let me try to give my
understanding.

First of all, for normal usage (e.g. capturing a stream or sending an stream
to an output device), the driver should work with only the standard V4L2 API.
I'm assuming that the driver will provide this capability.

I understand that, being a SoC hardware, there are much more that can be done
than just doing the normal stream capture/output, already supported by V4L2 API.

For such advanced usages, we're open to a proposal to enhance the existing API
to support the needs. There are some important aspects that need to be considered
when designing any Linux userspace API's:

	1) kernel-userspace API's are forever. So, they need to be designed in
a way that new technology changes won't break the old API;

	2) API's are meant to be generic. So, they needed to be designed in a way
that, if another hardware with similar features require an API, the planned one
should fit;

	3) The API's should be, as much as possible, independent of the hardware
architecture. You'll see that even low-level architecture dependent stuff, like
bus drivers are designed in a way that they are not bound to a particular hardware,
but instead provide the same common methods to interact with the hardware to other
device drivers.

That's said, it would be interesting if you could give us a more deep detail on 
what kind of functionalities and how do you think you'll be implementing them.

-- 

Cheers,
Mauro
